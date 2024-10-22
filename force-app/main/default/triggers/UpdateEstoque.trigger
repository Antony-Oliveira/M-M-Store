trigger UpdateEstoque on Pedido__c (after update) {
    Set<Id> productIds = new Set<Id>();

    for (Pedido__c pedido : Trigger.new) {
        Pedido__c oldPedido = Trigger.oldMap.get(pedido.Id);

        if (pedido.Status__c == 'Pedido concluido' && oldPedido.Status__c != 'Pedido concluido') {
       
            List<PedidoProduto__c> pedidoProdutos = [
                SELECT Id, Produto__c, Quantidade__c
                FROM PedidoProduto__c
                WHERE Pedido__c = :pedido.Id
            ];
            
            for (PedidoProduto__c pedidoProduto : pedidoProdutos) {
                productIds.add(pedidoProduto.Produto__c);
            }
            
            List<Produto__c> produtos = [
                SELECT Id, Estoque__c
                FROM Produto__c
                WHERE Id IN :productIds
            ];
            
            Map<Id, Produto__c> produtoMap = new Map<Id, Produto__c>(produtos);
            
            for (PedidoProduto__c pedidoProduto : pedidoProdutos) {
                Produto__c produto = produtoMap.get(pedidoProduto.Produto__c);
                if (produto != null) {
                    produto.Estoque__c -= pedidoProduto.Quantidade__c;
                }
            }
            
            update produtos;
        }
    }
}
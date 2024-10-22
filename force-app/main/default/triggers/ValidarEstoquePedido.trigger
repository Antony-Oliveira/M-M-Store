trigger ValidarEstoquePedido on Pedido__c (before update) {
    Set<Id> pedidoIds = new Set<Id>();
    
    for (Pedido__c pedido : Trigger.new) {
        Pedido__c oldPedido = Trigger.oldMap.get(pedido.Id);
        if (pedido.Status__c == 'Pedido concluido' && oldPedido.Status__c != 'Pedido concluido') {
            pedidoIds.add(pedido.Id);
        }
    }
    
    if (pedidoIds.isEmpty()) {
        return;
    }
    
    Map<Id, Decimal> estoquePorProduto = new Map<Id, Decimal>();
    Map<Id, String> nomePorProduto = new Map<Id, String>();
    
    List<Produto__c> produtos = [SELECT Id, Estoque__c, Name FROM Produto__c WHERE Id IN (SELECT Produto__c FROM PedidoProduto__c WHERE Pedido__c IN :pedidoIds)];
    for (Produto__c produto : produtos) {
        estoquePorProduto.put(produto.Id, produto.Estoque__c);
        nomePorProduto.put(produto.Id, produto.Name);
    }
    
    List<PedidoProduto__c> pedidosProdutos = [SELECT Id, Quantidade__c, Produto__c, Pedido__c FROM PedidoProduto__c WHERE Pedido__c IN :pedidoIds];
    
    Map<Id, Set<String>> errosPorPedido = new Map<Id, Set<String>>();
    
    for (PedidoProduto__c pedidoProduto : pedidosProdutos) {
        Decimal estoque = estoquePorProduto.get(pedidoProduto.Produto__c);
        if (estoque == null) {
            estoque = 0;
        }
        if (pedidoProduto.Quantidade__c > estoque) {
            String nomeProduto = nomePorProduto.get(pedidoProduto.Produto__c);
            if (!errosPorPedido.containsKey(pedidoProduto.Pedido__c)) {
                errosPorPedido.put(pedidoProduto.Pedido__c, new Set<String>());
            }
            errosPorPedido.get(pedidoProduto.Pedido__c).add(nomeProduto);
        }
    }

    for (Pedido__c pedido : Trigger.new) {
        if (errosPorPedido.containsKey(pedido.Id)) {
            Set<String> nomesProdutos = errosPorPedido.get(pedido.Id);
            String mensagemErro = 'Os produtos ' + String.join(new List<String>(nomesProdutos), ', ') + ' não possuem estoque suficiente para esta operação.';
            pedido.addError(mensagemErro);
        }
    }
}
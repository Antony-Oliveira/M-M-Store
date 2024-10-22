trigger ChecarSeExisteProdutosNoPedido on Pedido__c (before update) {
    for (Pedido__c pedido : Trigger.new) {
        if (pedido.Status__c == 'Pedido Concluido') {
            Integer count = [SELECT COUNT() 
                             FROM PedidoProduto__c 
                             WHERE Pedido__c = :pedido.Id];
            if (count == 0) {
                pedido.addError('O pedido deve ter pelo menos um item associado para ser concluído.');
            }
        }
    }
}
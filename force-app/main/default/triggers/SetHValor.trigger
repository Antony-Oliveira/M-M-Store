trigger SetHValor on PedidoProduto__c (before insert, before update) {
    for (PedidoProduto__c pp : Trigger.new) {
        pp.HValor__c = pp.Valor__c;
    }
}
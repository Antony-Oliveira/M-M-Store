trigger SetPagamentoDoCliente on Pedido__c (before insert, before update) {
   
    for (Pedido__c pedido : Trigger.new) {
        
        if (pedido.Cliente__c != null && pedido.Forma_de_pagamento__c == null) {
            Cliente__c cliente = [SELECT Forma_de_pagamento_preferencial__c FROM Cliente__c WHERE Id = :pedido.Cliente__c LIMIT 1];
            
            pedido.Forma_de_pagamento__c = cliente.Forma_de_pagamento_preferencial__c;
        }
    }
}
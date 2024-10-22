import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Introducao extends NavigationMixin(LightningElement) {

    navigateToNewCliente() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Cliente__c',
                actionName: 'new'
            }
        });
    }

    navigateToNewProduto() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Produto__c',
                actionName: 'new'
            }
        });
    }

}

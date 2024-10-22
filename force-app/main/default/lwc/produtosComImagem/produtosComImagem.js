import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getProductsWithImage from '@salesforce/apex/ProductController.getProductsWithImage';

export default class ProdutosComImagem extends NavigationMixin(LightningElement) {
    @track products;
    @track error;
    @track isLoading = true;

    @wire(getProductsWithImage)
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
            this.isLoading = false;
        } else if (error) {
            this.error = 'Erro ao carregar produtos';
            this.isLoading = false;
        }
    }

    handleProductClick(event) {
        const productId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: productId,
                objectApiName: 'Produto__c',
                actionName: 'view'
            }
        });
    }
}

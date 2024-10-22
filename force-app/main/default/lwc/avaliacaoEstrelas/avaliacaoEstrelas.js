import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import AVALIACAO_FIELD from '@salesforce/schema/Pedido__c.Avaliacao__c';

export default class AvaliacaoEstrelas extends LightningElement {
    @api recordId;
    @track avaliacao;

    @wire(getRecord, { recordId: '$recordId', fields: [AVALIACAO_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            this.avaliacao = data.fields.Avaliacao__c.value;
        } else if (error) {
            console.error('Erro ao buscar o registro:', error);
        }
    }

    get stars() {
        return [...Array(5)].map((_, i) => ({
            key: i + 1,
            emoji: i < this.avaliacao ? '⭐' : null
        }));
    }

    get hasRating() {
        console.log('Avaliação definida:', this.avaliacao !== null && this.avaliacao !== undefined);
        return this.avaliacao !== null && this.avaliacao !== undefined;
    }
}

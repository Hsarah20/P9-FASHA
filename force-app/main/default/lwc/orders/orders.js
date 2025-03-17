import { LightningElement, api,wire } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/AccountController.getSumOrdersByAccount';

export default class Orders extends LightningElement {

    sumOrdersOfCurrentAccount=0;
    @api recordId;

    connectedCallback() {
        this.fetchSumOrders();
    }

    // fetchSumOrders() {
    //     // TODO - récupérer le montant total des Orders sur le compte avec la méthode apex
    // }

    @wire(getSumOrdersByAccount, { accountId: '$recordId' })
    wiredOrder({ error, data }) {
        if (data) {
            this.sumOrdersOfCurrentAccount = data;
                
        } else if (error) {
            console.error('Erreur lors de la récupération de la somme des commandes', error);
        }
    }

    get isError() {
        return !this.sumOrdersOfCurrentAccount || this.sumOrdersOfCurrentAccount <= 0;
    }

    get isSuccess() {
        return this.sumOrdersOfCurrentAccount > 0;
    }
    
}
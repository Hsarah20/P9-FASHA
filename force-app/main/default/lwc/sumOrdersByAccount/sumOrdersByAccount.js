import { LightningElement, api,wire } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

export default class sumOrdersByAccount extends LightningElement {

    sumOrdersOfCurrentAccount=0;
    @api recordId;

    connectedCallback() {
       //console.log("Record id" +this.recordId);
    }

    @wire(getSumOrdersByAccount, { accountId: '$recordId' })
    wiredOrder({ error, data }) {
        if (data) {
           // console.log('DATA '+ JSON.stringify(data))
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
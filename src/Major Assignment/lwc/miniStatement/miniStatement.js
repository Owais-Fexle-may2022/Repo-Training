/*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This Js File is used for mini statement LWC.
   * @author           Mohd Owais  <mohd.owais@fexle.com>           
   * @created          18/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
//   importing apex class and track,api and Lightning element.
import { LightningElement, track, api } from 'lwc';
import getTransactionEntriesByLimit from '@salesforce/apex/miniStatementHelper.getTransactionEntriesByLimit';
// created an object for dataTable.
const txnColumns = [
    {label : 'Entry Number', fieldName : 'TX_Entry_Name__c'},
    {label : 'Debit/Credit', fieldName : 'Type__c'},
    {label : 'Amount', fieldName : 'Amount__c'},
    {label : 'Transaction Date', fieldName : 'Transaction_Date__c'}
]

export default class miniStatement extends LightningElement {
    // initilizing variable
    @track value = "";
    @track txns;
    @track txnColumns = txnColumns;
    @track cardVisible = false;
    @api recordId;
// creating options for combobox.
    get options() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '15', value: '15' },
            { label: '20', value: '20' },
            { label: '25', value: '25' }
        ];
    }
// on click event to make visibl;ity true of card.
    handleLimit(event) {
        this.cardVisible = true;
        // adding event to variable value
        this.value = event.detail.value;
        // calling apex method add fetching data accordingly and return promise.
        getTransactionEntriesByLimit({lmt :this.value, conId: this.recordId})
        .then((result)=>{
            this.txns = result;
        })
    }
}
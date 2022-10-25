/*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This Js File is used for mini statement LWC.
   * @author           Mohd Owais  <mohd.owais@fexle.com>           
   * @created          18/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
//   importing apex classes,vf page,showToastEvent and closeActionScreenEvent a and track,api and Lightning element.
import { LightningElement, api, track } from 'lwc';
import getData from '@salesforce/apex/RetrieveTransactionEntriesRecords.getEntriesRecordForStatement';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {exportCSVFile} from './utils';
import { CloseActionScreenEvent } from 'lightning/actions';
import sendRecordOnEmail from '@salesforce/apex/StatementPdfEmail.sendEmail';
// object for data table.
const cols = [
    {label: 'Txn Entry Name', fieldName: 'Name', type: 'url', sortable: true, typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'linkName'}, target: '_blank'}},
    { lable: 'Type', fieldName: 'Type__c'},
    { lable: 'Amount', fieldName: 'Amount__c'},
    { lable: 'Status', fieldName: 'Status__c'}
];

export default class statement extends LightningElement {
//  declaring variables.
    @api recordId;
    @api startDate_Value = '';
    @api endDate_Value = '';
    @track result1;
    @track result;
    @track date1;
    @track date2;
    @track startDate1;
    @track endDate1;
    @track columns = cols;
    @track entriesRecord;
    // event for start date
    handle_Start_Date(event){
        this.startDate_Value = event.target.value;
        this.startDate1 = this.startDate_Value;
    }
// event for end date
    handle_End_Date(event){
        this.endDate_Value = event.target.value;
        this.endDate1 = this.endDate_Value;
    }
    // event for show entry 
    handleClick() {
        let downloadCsvButton = '';
        this.date1 = new Date(this.startDate_Value);
        this.date2 = new Date(this.endDate_Value);
        this.result = this.date2 - this.date1;
        /// this.result is in millisceonds you might need to convert it to days using below formula
        this.result = parseInt(this.result/ (1000*60*60*24));


        if(182 > this.result){
            getData({ recordId: this.recordId, start_Date: this.startDate_Value, end_Date: this.endDate_Value })
        .then(result => {

            this.entriesRecord = result;
            downloadCsvButton = this.template.querySelector('.csv');
            downloadCsvButton.classList.add('visibleCsv');
        })
        .catch(error => {
            console.error(error);
        })
        }
        else{
            const event = new ShowToastEvent({
                title: 'Date Limit Hit',
                message: 'you can not view entries of more than six months',
                variant: 'Warning'
            });

            this.dispatchEvent(event);
        }


    }

    // event for Download PDF
    downloadPdfFile() {
        // To calculate the no. of days between two dates
        //let Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
        this.date1 = new Date(this.startDate_Value);
        this.date2 = new Date(this.endDate_Value);
        this.result = this.date2 - this.date1;
        /// this.result is in millisceonds you might need to convert it to days using below formula
        this.result = parseInt(this.result/ (1000*60*60*24));
        if(182 > this.result){
            if(this.entriesRecord.length > 0){
                let urlString = window.location.href;
                let urlWithParameters = urlString.substring(0, urlString.indexOf(".com/"));
                this.date1 = new Date(this.startDate_Value);
                this.date2 = new Date(this.endDate_Value);
                urlWithParameters = urlWithParameters.concat('.com/apex/Download_PDF?id=' + this.recordId + '&startdate=' + this.startDate_Value + '&enddate=' + this.endDate_Value);
                const event = new ShowToastEvent({
                    title: 'PDF Success',
                    message: 'PDF Downloaded Successfully',
                    variant: 'success'
                });

                this.dispatchEvent(event);

                //Opening url
                window.open(urlWithParameters);
            }
            else{
            const event = new ShowToastEvent({
                title: 'Empty Entries',
                message: 'No entry is available at this time in your account',
                variant: 'Warning'
            });
            this.dispatchEvent(event);
        }

        }
        else{
            const event = new ShowToastEvent({
                title: 'Date Limit Hit',
                message: 'you can not view entries of more than six months',
                variant: 'Warning'
            });
            this.dispatchEvent(event);
        }
    }

    entryHeader ={
        Id:"Record Id",
        Name:"Name",
        Amount__c:"Amount",
        Type__c:"Type",
        Transaction_Date__c:"Transaction Date"

    }

    // event for CSV Download
    downloadCsvFile(){
        if(this.entriesRecord.length > 0){
            exportCSVFile(this.entryHeader, this.entriesRecord, "Transaction Entry Records")
        }
        else{
            const event = new ShowToastEvent({
                title: 'Empty Entries',
                message: 'No entry is available at this time in your account',
                variant: 'Warning'
            });
            this.dispatchEvent(event);
        }
    }

    // event for Email Statement
    handleEmail(){
        //Calling Email method from apex
        sendRecordOnEmail({recordIdOfContact : this.recordId, start_Date: this.startDate1, end_Date: this.endDate1 })
                .then(result =>
                {
                    console.log('Result==== > ' + result);
                })
                .catch(error => {
                    console.log(error);
                });

        const event = new ShowToastEvent({
            title: 'Email',
            message: 'PDF  sent to Contact Email address.',
            variant: 'success'
        });
        this.dispatchEvent(event);
    }

    // event For cancel Button to reset all event.
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}
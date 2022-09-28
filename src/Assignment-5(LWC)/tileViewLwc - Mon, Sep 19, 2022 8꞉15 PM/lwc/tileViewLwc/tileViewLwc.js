/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This Js file is used as to fetch all contact details from apex contactController class.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/ 
import { LightningElement, api } from 'lwc';
import getContactTile from '@salesforce/apex/contactController.getContactTile';
export default class tileViewLwc extends LightningElement {
    contacts;
    error;
	@api flexipageRegionWidth;
    columnSize;
    tileSize;
    // it fires after component finished its rendering phase 
    renderedCallback() {
        this.columnSize = this.flexipageRegionWidth;
        if(this.columnSize === 'LARGE') {
            this.tileSize = 3;
        }
        if(this.columnSize === 'MEDIUM') {
            this.tileSize = 4;
        }
        if(this.columnSize === 'SMALL') {
            this.tileSize = 6;
        }
    }
    // this is used to call loadContact method.
    connectedCallback() {
		this.loadContact();
	}
    // this method is used to get promise from getContactTile which is import from apex class method.
	loadContact() {
	    getContactTile()
		.then(result => {
			this.contacts = result;
		});
	}

}
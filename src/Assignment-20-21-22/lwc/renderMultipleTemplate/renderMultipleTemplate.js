/*
    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @Description      This Js file is used as to import string type of data from apex class and show return value to HTML template.
    * @author           Mohd Owais  <mohd.owais@fexle.com>
    * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */  
import { LightningElement } from 'lwc';
// Importing methods of apex class.
import getTextMethod1 from '@salesforce/apex/Controller.getTextMethod1';
import getTextMethod2 from '@salesforce/apex/Controller.getTextMethod2';
import getTextMethod3 from '@salesforce/apex/Controller.getTextMethod3';


export default class RenderMultipleTemplate extends LightningElement {
    // initilizing variables
    message1;
    message2;
    message3;
    // When Hit click me 1  button this methods start executing
    handleClickMe1() {
        // this promise gave two value if result found then gave value else gave error
        getTextMethod1()
            .then(result1 => {
                this.message1 = result1;
            })
            .catch(error => {
                this.error=error;
            });
    }
    // When Hit click me 2  button this methods start executing
    handleClickMe2() {
        getTextMethod1()
            .then(result1 => {
                this.message1 = result1;
            })
        getTextMethod2()
            .then(result2 => {
                this.message2 =result2;
            })
            .catch(error => {
                this.error=error;
            });
    }
    // When Hit click me 3  button this methods start executing
    handleClickMe3() {
        getTextMethod1()
            .then(result1 => {
                this.message1 = result1;
            })
        getTextMethod2()
            .then(result2 => {
                this.message2 =result2;
            })
        getTextMethod3()
            .then(result3 => {
                this.message3 = result3;
            })
            .catch(error => {
                this.error=error;
            });
    }        
}
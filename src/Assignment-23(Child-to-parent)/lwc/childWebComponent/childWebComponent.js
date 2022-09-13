/*
  ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  * @Description      This js File is having a public method which is called by its parent component.
  * @author           Mohd Owais  <mohd.owais@fexle.com>
  * @created  Date    10/9/2022
  * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
  */
import { LightningElement,track,api } from 'lwc';

export default class ChildWebComponent extends LightningElement {
  //it reflect value to template it is reactive in nature. 
  @track value=''; 
  //this is a public method and its parent will call it.when it gets call it change value to 100.
  @api handleValueChange() {
    this.value='Magic';
  }
}
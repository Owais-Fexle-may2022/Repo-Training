/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This js contains a method when some one click on its template button.Method get fires.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @created Date     10/9/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
import { LightningElement } from 'lwc';

export default class ParentWebComponent extends LightningElement {
    // this method gets fire when some one click on button 
    handleClick() {
        // here we use query selector to  select child component and fires child's component  method.
        this.template.querySelector("c-child-web-component").handleValueChange();
      }
}
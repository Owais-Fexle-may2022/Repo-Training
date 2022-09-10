/*
  ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  * @Description      This js file is used when any change is happening in HTML temple Input field.
  * @author           Mohd Owais  <mohd.owais@fexle.com>
  * @created  Date        2022-08-13
  * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */
import { LightningElement,api } from 'lwc';

export default class ChildLwc extends LightningElement {
  // public variable
    @api progressValue;
    // this method get fires when someone change the input field of child component.
    handleChnage(event) {
      // targeting the event's value and assigning that value to process value.
        this.progressValue = event.target.value;
        // Creating event and passing data to progess value.
        const selectedEvent = new CustomEvent("changevalueofprogress", {
        detail: this.progressValue
    });

    // Dispatching  event.
    this.dispatchEvent(selectedEvent);
  }
}
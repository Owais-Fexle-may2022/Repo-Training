/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This js file is used to handle event dispatch from its child and reflect change in process value to make progress bar reactable.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @created Date     10/9/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
import { LightningElement,track } from 'lwc';

export default class ParentLwc extends LightningElement {
    // reactive in nature
    @track progressValue = 0;
    // this get fires when any event is dispatched from child and adding details of event to progress value.
    hanldeProgressValueChange(event) {
        this.progressValue = event.detail;
    }
}
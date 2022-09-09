/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This js file is used as backend file of lightning component calculator. 
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @created          2022-08-31
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
// /import track along with lightnin element
import { LightningElement,track } from 'lwc';

export default class UpdatedCalculator extends LightningElement {
    // initilizing variables
    firstNumber;
    secondNumber;
    @track currentOutput;
    // this event executes when any change is happening in first input. 
    FirstNumber(event){
        this.firstNumber=parseInt(event.target.value);
    }
    // this event executes when any change is happening in second input.
    SecondNumber(event){
        this.secondNumber=parseInt(event.target.value);
    }
    // this  executes when add button hits.
    Addition(){
        this.currentOutput="Output value is :" +(this.firstNumber+this.secondNumber);
    }
    // this  executes when sub button hits.
    Subtraction(){
        this.currentOutput="Output value is :" +(this.firstNumber-this.secondNumber);
    }
    // this  executes when mul button hits.
    Multiplication(){
        this.currentOutput="Output value is :" +(this.firstNumber*this.secondNumber);
    }
    // this  executes when div button hits.
    Division(){
        this.currentOutput="Output value is :" +(this.firstNumber/this.secondNumber);
    }
}
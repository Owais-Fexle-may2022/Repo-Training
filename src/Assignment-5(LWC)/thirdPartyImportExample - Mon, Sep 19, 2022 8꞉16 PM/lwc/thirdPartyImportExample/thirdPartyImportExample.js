import { LightningElement } from 'lwc';
// importing resource from org
import firstResource from '@salesforce/resourceUrl/firstResource';

export default class ThirdPartyImportExample extends LightningElement {
    // creating object and adding image url fetch from resource to src property.
    actor =[
        {
            id:"1",
            header:"Iron Man",
            src: firstResource + '/newResourcefolder/ironman.jpg',
            href:"https://en.wikipedia.org/wiki/Iron_Man",
            description:"Robert Jr"

        },
        { 
            id:"2",
            header:"Messi",
            src: firstResource + '/newResourcefolder/messi.jpg',
            href:"https://en.wikipedia.org/wiki/Lionel_Messi",
            description:"Lionel Messi"

        },
    ]
   
}
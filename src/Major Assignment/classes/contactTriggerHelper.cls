/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used when some user wants to delete contact which have some entries in it.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Method           one
* @created          18/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class contactTriggerHelper {
/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This method is used when some user wants to delete contact which have some entries in it.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Return           void
* @Parameter        old List of Contact
* @created          18/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void contactCanNotBeDelete(List<Contact> oldContactList){
        // set of contact Id.
        Set<Id> setOfContactId = new Set<Id>();
        // iterating old List add adding id of contact to set.
        for(Contact conId : oldContactList){
            setOfContactId.add(conId.Id);
        }
        // query contact based on set of id.
        Map<Id,Contact> mapOfContact = new Map<Id,Contact>([SELECT Id,Name,(SELECT Id,Name FROM Transactions_Entries__r) 
                                                            FROM Contact WHERE Id IN: setOfContactId]);
        // iterating old list of contact.
        for(Contact con : oldContactList){
            // check contact's transaction entry is not null.
            if(!mapOfContact.get(con.Id).Transactions_Entries__r.isEmpty()){
                // add error on contact object.
                con.addError('Firstly delete transaction then only you can delete contact ');
            }
        }
    }
}
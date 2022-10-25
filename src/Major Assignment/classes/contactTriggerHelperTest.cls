/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This is a test class used for contactTriggerHelper file of apex.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @created          18/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest(seeAllData = false)
public class contactTriggerHelperTest {
    @TestSetUp
    static void testContactCantBeDeleted(){
        // List of contact
        List<Contact> conList = new List<Contact>();
        // create new contact and adding details to it.
        Contact con = new Contact();
        con.LastName = 'Owais';
        con.Status__c = 'Active';
        con.Email = 'owaispsit99@gmail.com';
        con.Available_Balance__c = 10000;
        conList.add(con);
        // inserting list
        insert conList;    
    }
    @isTest 
    private static void testRecords(){
        // query data of contact.
        List<Contact> conList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Owais'];
        // creating List of transaction
        List<Transactions_Entry__c> listOfTransaction = new List<Transactions_Entry__c>();
        // creating transaction and adding details to it.
        Transactions_Entry__c txnEntry = new Transactions_Entry__c();
        txnEntry.Amount__c = 1000;
        txnEntry.Type__c = 'Debit';
        txnEntry.Status__c = 'Pending';
        txnEntry.Contact__c = conList[0].id;
        txnEntry.Transaction_Date__c = System.today();
        // add transaction to list
        listOfTransaction.add(txnEntry);
        // insert listof Transaction
        insert listOfTransaction; 
        // querying inserted data and their entries.   
        Contact conDel = [SELECT Id,Name, (SELECT Id, Name FROM Transactions_Entries__r) FROM Contact WHERE Id = :conList[0].id];
        try{
            // delete contact
            delete conDel;
        }catch(exception e){
            System.debug('Error' +e.getMessage());
        }
        // check result
        System.assert(conDel.Transactions_Entries__r != null );
    }    
}
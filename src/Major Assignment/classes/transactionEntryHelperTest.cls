/*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This Class is used to test automation on transaction entry of file transactionEntryHelper.
   * @author           Mohd Owais  <mohd.owais@fexle.com>           
   * @created          17/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
@isTest(seeAllData = false)
public with sharing class transactionEntryHelperTest {
    @TestSetUp
   private static void parentofEntryData(){
    // initilizing transaction List
    List<Transaction_Limit__c> txnLimitList = new List<Transaction_Limit__c>();
     // creating more then one transaction Limit using for loop and adding detail to it .
       for(Integer j=0;j<2;j++){
            Transaction_Limit__c axisLimit = new Transaction_Limit__c();
            axisLimit.name = 'axis' + j;
            axisLimit.Maximum_Debit_Allowed_per_Transaction__c = 10000;
            axisLimit.Maximum_Debit_Allowed_per_Day__c = 40000;
            axisLimit.Maximum_Transactions_Allowed_per_Day__c = 4;
            axisLimit.Maximum_Debit_Allowed_per_Month__c = 1000000; 
            axisLimit.Maximum_Transactions_Allowed_per_Month__c = 25; 
            txnLimitList.add(axisLimit);
       }
       insert txnLimitList;
    //    creating List of contact
        List<Contact> conList=new List<Contact>();
// creating more then one contact using for loop and adding details and making relation between contact and transaction limit.
        for(Integer i=0;i<2;i++){
            Contact conBank = new Contact();
            conBank.LastName = 'Limit' + i;
            conBank.status__c = 'Active';
            conBank.Email = 'test@test.com';
            conBank.Transaction_Limit__c = txnLimitList[i].Id;
            conBank.Available_Balance__c=50000;
            conList.add(conBank);
        }  
        insert conList;
    }
    @isTest
    public static void testForAxis(){
        // querying data of contact
        List<Contact> listOfConId = new List<Contact>([SELECT Id,Name FROM Contact WHERE LastName = 'Limit0']);
        // initilizing  list of transaction entries.
        List<Transactions_Entry__c> creditAndDebitEntry = new List<Transactions_Entry__c>();
        // creating more then one transaction using for loop and adding details.
        for(Integer i=0;i<2;i++){
            Transactions_Entry__c txnEntryCredit=new Transactions_Entry__c();
            txnEntryCredit.Name='Test' +i;
            txnEntryCredit.Amount__c=100;
            txnEntryCredit.Status__c='Completed';
            txnEntryCredit.Type__c='Credit';
            txnEntryCredit.Transaction_Date__c=System.today();
            txnEntryCredit.Contact__c=listOfConId[0].Id;
            creditAndDebitEntry.add(txnEntryCredit);
        }
        // creating more then one transaction using for loop and adding details.
        for(Integer i=0;i<2;i++){
            Transactions_Entry__c txnEntryDebit=new Transactions_Entry__c();
            txnEntryDebit.Name='Test' +i;
            txnEntryDebit.Amount__c=200;
            txnEntryDebit.Status__c='Completed';
            txnEntryDebit.Type__c='Debit';
            txnEntryDebit.Transaction_Date__c=System.today();
            txnEntryDebit.Contact__c=listOfConId[0].Id;
            creditAndDebitEntry.add(txnEntryDebit);
        }
        // insert transaction list
        insert creditAndDebitEntry;
        // querying contact.
        List<Contact> listOfConAfterInsertEntry = [SELECT Id, LastName, Available_Balance__c FROM Contact WHERE id = : listOfConId[0].id];
        // check excepted and actual result.
        System.assertEquals(49800, listOfConAfterInsertEntry[0].Available_Balance__c);
    }
}
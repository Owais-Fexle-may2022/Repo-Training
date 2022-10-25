/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This is a test class used for emailNotificationMonthly file of apex.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @created          18/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest(seeAllData = false)

public with sharing class emailNotificationMonthlyTest {   
    @istest
    public static void  testschedule() {
    Test.StartTest();
    // create contact and adding details to it.
	contact con=new contact();
    con.LastName='Owais';
    con.Status__c='Active';
    con.Email='owaisPsit99@gmail.com';
    // insert contact.
    insert con;
    // creating list of contact
    List<Transactions_Entry__c> txnList = new List<Transactions_Entry__c>();
    // creating entries using for Loop
    for(integer i=0;i<10;i++){
        Transactions_Entry__c txnEntry=new Transactions_Entry__c();
        txnEntry.Name='Test' +i;
        txnEntry.Amount__c=100;
        txnEntry.Status__c='Completed';
        txnEntry.Type__c='Credit';
        txnEntry.Transaction_Date__c=System.today();
        txnEntry.Contact__c=con.Id;
        txnList.add(txnEntry);
    }
    // insert transaction List.
    insert txnList;
    // new object of file emailNotificationMonthly.
    emailNotificationMonthly sh1 = new emailNotificationMonthly(); 
    //  adding virtual value
    String sch = '0 0 23 * * ?';
    // do scheduler operation to check test.
    system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }
}
/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used as helper of  statment lwc.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Method           one
* @created          21/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class PdfController {
    public List<Transactions_Entry__c> transaction_Entry_List {get;set;}
    public String startDateString {set;get;}
    public String endDateString {set;get;}
    public Contact contact_Obj{set;get;} 
    //Constructor
    public PdfController()
    {
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=BankStatement.pdf');    
    }

    public void genratePDF()
    { 
        Id recordIdOfContact = ApexPages.currentPage().getParameters().get('id');
        //SOQL
        Transaction_Entry_List = [SELECT Id, Name, Amount__c, Transaction_Date__c,
                                           Type__c, Status__c FROM Transactions_Entry__c WHERE 
                                           Contact__c =: recordIdOfContact];
        //Contact information for pdf body
        contact_Obj = [SELECT Id, Title, Name, Account_Number__c, Email FROM Contact WHERE Id =: recordIdOfContact];
    }

}
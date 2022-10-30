/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used as helper of  statment lwc.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Method           one
* @created          21/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class Records_PDF_Controller {
    public List<Transactions_Entry__c> transactions_Entry_List{get;set;}
    public String startDateString {set;get;}
    public String endDateString {set;get;}
    public Contact contact_Object{set;get;}

    public Records_PDF_Controller() {
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=BankStatement.pdf');
    }
    public void recordPdf(){
        Id idOfContacts = ApexPages.currentPage().getParameters().get('id');
        String newStartDate = ApexPages.currentPage().getParameters().get('startdate');
        String newEndDate = ApexPages.currentPage().getParameters().get('enddate');
        Date startDate = Date.valueOf(newStartDate);
        Date endDate = Date.valueOf(newEndDate);
        String stringStartDate = String.valueOf(date.newinstance(startDate.year(), startDate.month(), startDate.day()));
        String stringEndDate = String.valueOf(date.newinstance(endDate.year(), endDate.month(), endDate.day()));
        Transactions_Entry_List  = [SELECT Id, Name, Transaction_Date__c, Amount__c,  Type__c, Status__c
                                    	FROM Transactions_Entry__c WHERE Contact__c = :idOfContacts AND
                                    			CreatedDate >= :startDate AND CreatedDate <= :endDate];
        contact_Object = [SELECT Id, Title, Name , Email, Account_Number__c FROM Contact WHERE ID = :idOfContacts];
        startDateString = newStartDate;
        endDateString = newEndDate;
    }
}
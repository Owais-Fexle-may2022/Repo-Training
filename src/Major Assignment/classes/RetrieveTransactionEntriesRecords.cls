/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used as helper of mini statment lwc to fetch data according to input
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Method           one
* @created          21/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class RetrieveTransactionEntriesRecords {
    @AuraEnabled(cacheable=true)
    public static List<Transactions_Entry__c> getEntriesRecord(Id recordId, Integer transLimit){
        return [SELECT Id, Name, Amount__c, Type__c, Transaction_Date__c FROM Transactions_Entry__c WHERE Contact__c =: recordId  Limit: transLimit];
    }
    // Fetch the records for (CSV) file
    @AuraEnabled(cacheable=true)
    public static List<Transactions_Entry__c> getEntriesRecordForStatement(Id recordId, Date start_Date, Date end_Date){
        List<Transactions_Entry__c> listOfEntriesRecord = new List<Transactions_Entry__c>();
        Integer dt1 = (start_Date). daysBetween(end_Date);
        try{
            if(182 >= dt1){
                listOfEntriesRecord = [SELECT Id, Name, Amount__c, Type__c, Transaction_Date__c FROM Transactions_Entry__c WHERE Contact__c =: recordId  AND Transaction_Date__c >= :start_Date AND Transaction_Date__c <=: end_Date];
            }
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return listOfEntriesRecord;
    }
}
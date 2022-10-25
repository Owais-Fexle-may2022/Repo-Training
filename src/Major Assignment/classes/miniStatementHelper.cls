/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used as helper of mini statment lwc to fetch data according to input.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Method           one
* @created          21/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class miniStatementHelper {
    @AuraEnabled
    public static List<Transactions_Entry__c> getTransactionEntriesByLimit(Integer lmt, String conId) {
        // query data based on recieved parameter.
        List<Transactions_Entry__c> txnList = [SELECT Id, TX_Entry_Name__c, Amount__c, Type__c,
                                             Transaction_Date__c, Contact__r.Account_Number__c
                                                 FROM Transactions_Entry__c Where Contact__c =:
                                                     conId ORDER BY CreatedDate Desc Limit :lmt];
        return txnList;
    }
}
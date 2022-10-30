/*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This Class is used to return result based on input on Lightning Web Component.
   * @author           Mohd Owais  <mohd.owais@fexle.com>           
   * @created          17/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
public with sharing class statementHelper {
    @AuraEnabled
/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This Method is used to return result of queried data.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Parameter        Date,Date,Contact Id           
* @created          17/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static List<Transactions_Entry__c> getTransactionEntry(String str1, String str2, String conId) {
        // type caste string to date
        Date StartDate = Date.valueOf(str1);
        Date EndDate = Date.valueOf(str2);
        Integer monthsBetween = StartDate.monthsBetween(EndDate);
        List<Transactions_Entry__c> txnList = new List<Transactions_Entry__c>();
        // check for transaction not more then six months
        if (StartDate.monthsBetween(EndDate) <= 6) {
            // query data based on parameter recieved.
            txnList = [SELECT Id, Name, Amount__c, Type__c, Transaction_Date__c, 
                      Status__c From Transactions_Entry__c Where CreatedDate >=
                      : StartDate AND CreatedDate <= : EndDate AND Contact__c =: conId];
        }
        return txnList;
    }  
}
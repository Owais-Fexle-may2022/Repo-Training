public with sharing class emailNotificationMonthly implements Schedulable {
     /*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This method is used to sent email of monthly transaction based on scheduled date
   * @author           Mohd Owais  <mohd.owais@fexle.com>
   * @Return           void
   * @created          16/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
    public void execute(SchedulableContext sc){
        //query data of contact with transactions
         List<Contact> contactWithTransactionList=[SELECT Id,Name,Available_Balance__c,Account_Number__c,Status__c,Email,
                                                  (SELECT Amount__c,Id,Contact__c,Status__c,Transaction_Date__c,TX_Entry_Name__c,
                                           		  Type__c FROM Transactions_Entries__r WHERE Transaction_Date__c=This_Month)
                                          											  FROM Contact WHERE Status__c='Active'];
         if(!contactWithTransactionList.isEmpty()){
            // created email list.
            List<Messaging.Email> emailList = new List<Messaging.Email>();
            for(Contact con: contactWithTransactionList){
                // check for status
                if(con.Status__c=='Active'){
                    // create single email
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    // sent email address
                    emailMsg.setToAddresses(new String[]{con.Email});
                    // set email subject
                    emailMsg.setSubject(con.Name);
                    // initilizing HTMLBody
                    String htmlBody = '';
                    htmlBody='Greeting From Axis Bank<br><br> <table border="1" style="border-collapse: collapse"><tr><th>  Account Number  </th><th>   Type    </th><th>   Amount  </th><th>   Transaction Date   </th></tr>';
                    for(Transactions_Entry__c txn :con.Transactions_Entries__r){
                        // check transaction parent id and contact id.
                        if(con.Id==txn.Contact__c && txn.Contact__c!=null){
                            // adding transactions details to htmlbody.
                            htmlBody += '<tr><td>' + con.Account_Number__c + '</td><td>' + txn.Type__c + '</td><td>' + txn.Amount__c + '</td><td>' + txn.Transaction_Date__c + '</td></tr>'; 
                        }                  
                    }
                    // closing html body.
                    htmlBody += '</table><br>';
                    // addding html body to single email
                    emailMsg.setHtmlBody(htmlBody);
                    // adding single email to email list
                    emailList.add(emailMsg);
                }       
            }
            // sending email 
             if(!emailList.isEmpty()){
            	Messaging.sendEmail(emailList);
             }
        }
    }
}
/*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This Class is used to automate transaction based on requirements.
   * @author           Mohd Owais  <mohd.owais@fexle.com>
   * @Methods          Three methods are avilable in the class.           
   * @created          09/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
public class transactionEntryHelper {
    /*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This method is used when an amount is debited/credited then it will update available balance.
   * @author           Mohd Owais  <mohd.owais@fexle.com>
   * @Return           void
   * @Parameter        List of Transaction Entries.
   * @created          09/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
    public static void updateAvilableBalance(List<Transactions_Entry__c> newTransactionList,Map<Id,Transactions_Entry__c> oldTransactionMap){
        // set of contact to filter data of transaction entry.
        Set<Id> contactIds = new Set<Id>();
        Integer minimumBalance=3000;
        // iterating new transaction list and adding parent id to set contactIds.
        for(Transactions_Entry__c txn: newTransactionList){     
            if(oldTransactionMap==null || (oldTransactionMap!=null && 
                oldTransactionMap.get(txn.Id).contact__c!=null &&
                (txn.Type__c != oldTransactionMap.get(txn.Id).Type__c
                ||txn.Status__c!=oldTransactionMap.get(txn.Id).Status__c
                ||txn.Amount__c!=oldTransactionMap.get(txn.Id).Amount__c))) {
                contactIds.add(txn.Contact__c);
            }
        }
        if(contactIds.size()>0){
        // qurerying data of parent record of transaction entry.
            Map<Id,Contact> mapOfContact=new  Map<Id,Contact>([SELECT Id,Available_Balance__c,Account_Number__c,Status__c,
                                                            Transaction_Limit__r.Maximum_Debit_Allowed_per_Transaction__c
                                                                                    FROM Contact WHERE Id IN:contactIds]);
            Map<Id,Contact> mapOfContactToBeUpdate = new Map<Id,Contact>();
            // iterating transaction list.
            for(Transactions_Entry__c txn:newTransactionList){
                // check for status and minimun balance.
                if(mapOfContact!=null && (mapOfContact.get(txn.Contact__c).Status__c == 'Active' && 
                   mapOfContact.get(txn.Contact__c).Available_Balance__c >  minimumBalance)){
                    // create object of parent to be update.
                    Contact con = new Contact();
                    //  check for type and status of transaction.
                    if(txn.Type__c == 'Debit' && ( txn.Status__c =='Completed' || txn.Status__c=='Pending')){
                        // adding details to parents object
                        con.Id = txn.Contact__c;
                        con.Available_Balance__c = mapOfContact.get(txn.Contact__c).Available_Balance__c - txn.Amount__c;
                        mapOfContactToBeUpdate.put(con.Id,con);
                    }
                    else if(txn.Type__c == 'Credit' && (txn.Status__c =='Completed' ||txn.Status__c=='Pending')){
                        con.Id = txn.Contact__c;
                        con.Available_Balance__c = mapOfContact.get(txn.Contact__c).Available_Balance__c + txn.Amount__c;
                        mapOfContactToBeUpdate.put(con.Id,con);
                    }
                    else if(oldTransactionMap!=null && oldTransactionMap.get(txn.Id).Status__c=='Pending'
                                                && txn.Status__c=='Cancelled' && txn.Type__c=='Credit' ){
                        con.Id=txn.Contact__c;
                        con.Available_Balance__c = mapOfContact.get(txn.Contact__c).Available_Balance__c - txn.Amount__c;
                        mapOfContactToBeUpdate.put(con.Id,con);
                    }else if(oldTransactionMap!=null && oldTransactionMap.get(txn.Id).Status__c=='Pending'
                                                    && txn.Status__c=='Cancelled' && txn.Type__c=='Debit'){
                        con.Id=txn.Contact__c;
                        con.Available_Balance__c = mapOfContact.get(txn.Contact__c).Available_Balance__c + txn.Amount__c;
                        mapOfContactToBeUpdate.put(con.Id,con);  
                    }
                    else{
                        // if condition not met then the show an error on status.
                        txn.Status__c.addError('you cannot select cancelled at new entry');
                    }
                }
            }
             //  if this mapof Contact is not null then update parent and add or update transaction entry.
            if(!mapOfContactToBeUpdate.isEmpty()){
                update mapOfContactToBeUpdate.values();
            }
        }  
    }
/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This method is used when an transaction is done it sent mail to owner about transaction with detail.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Return           void
* @Parameter        List of Transaction Entries.
* @created          10/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
   public static void sentEmailNotification(List<Transactions_Entry__c> newTransactionList){
       Set<Id> setOfContactIds = new Set<Id>();
       //adding parent id to conId set for transaction list
       for (Transactions_Entry__c txn : newTransactionList) {
           if(txn.Contact__c!=null){
           		setOfContactIds.add(txn.Contact__c);
           }
       }
       if(!setOfContactIds.isEmpty()){
           // query data to which email have to sent.
           List<Contact> conList = [SELECT Id,Available_Balance__c,Account_Number__c,Status__c,Email  FROM Contact WHERE Id IN : setOfContactIds];
           //created email list
           List<Messaging.SingleEmailMessage> emailList =new List<Messaging.SingleEmailMessage>();
           //iterating transaction list
           for(Transactions_Entry__c txn : newTransactionList){
               for(Contact con: conList){
                   //check for contact id and transaction parent id and contact status transaction status
                    if(con.Id==txn.Contact__c && con.Status__c=='Active' && 
                        (txn.Status__c=='Completed' ||txn.Status__c=='Pending')){
                        //creating single email
                        Messaging.SingleEmailMessage emailMsg =  new Messaging.SingleEmailMessage();
                        //adding email address of contact
                        String [] toAddress=new String[]{con.Email};
                        //setting email address
                        emailMsg.setToAddresses(toAddress);
                        //adding subject
                        String emailSub=' Balance alert Notification';
                        emailMsg.setSubject(emailSub);
                        //adding display name
                        String displayName='Axis Bank';
                        emailMsg.setSenderDisplayName(displayName);
                        //creating email content or HTMLBody and adding transactions detail and contact details.
                        String content ='Your '+  con.Account_Number__c +' is ' 
                                                + txn.Type__c +  ' by '  + txn.Amount__c +  ' on '
                                                + txn.Transaction_Date__c +  ' . Available Balance Rs. '
                                                + con.Available_Balance__c;
                        //adding content to email
                        emailMsg.setHtmlBody(content);
                        //adding email to email list.
                        emailList.add(emailMsg);
                    }
               }  
           }
            // sending emails to the contact's email which have done some transaction.
           if(!emailList.isEmpty()){
       			Messaging.sendEmail(emailList);
           }
       }
      
    } 
/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This method is used to check weather the no of transaction per day/Month limit is exceed.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Return           void
* @Parameter        List of Transaction Entries.
* @created          15/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    
    public static void CheckTrasactionlimitOnTransactionEntry(List<Transactions_Entry__c> newTransactionList) {
       
        //set of id to store contact ids with transaction
        Set<Id> setOfContactIds = new set<Id>();
       
        //loop to store the ids
        for(Transactions_Entry__c tran : newTransactionList) {
            if(tran.Contact__c!=null){
            	setOfContactIds.add(tran.Contact__c);
            }
        }
        // map to strore debit details    
        Map<Id, Map<String,Integer>> mapOfConIdWithTxnEntriesForAmountDebitedPerDay = new Map<Id, Map<String,Integer>>();
        //    query data based on data and parent id.
        List<Transactions_Entry__c> transactionEntriesListForDay = [SELECT Id,Name, Contact__c, Amount__c, Type__c, Transaction_Date__c FROM Transactions_Entry__c WHERE Contact__c IN:setOfContactIds AND Transaction_Date__c =: System.Today()];
        //  iterating data of transactionEntriesListForDay List.   
        for(Transactions_Entry__c tran : transactionEntriesListForDay) {
            // check if mapOfConIdWithTxnEntriesForAmountDebitedPerDay not contains parent key.
            if(!mapOfConIdWithTxnEntriesForAmountDebitedPerDay.containsKey(tran.Contact__c)) {
                mapOfConIdWithTxnEntriesForAmountDebitedPerDay.put(tran.Contact__c, new Map<String,Integer>());
                mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).put('transactionEntries',0);
                mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).put('debitAmount',0);
            }
            // adding one in every transaction at value.
            mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).put('transactionEntries',
                                                         	(Integer)mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).get('transactionEntries')+1);
            //    check if type is debit then adding one to value.
            if(tran.Type__c == 'Debit') {
                mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).put('debitAmount',
                                                              (Integer)mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).get('debitAmount')+1);
            }   
        }
        // initilizing map of map for calculating transaction per month
        Map<Id, Map<String,Integer>> mapOfConIdWithTxnEntriesForAmountDebitedPerMonth = new Map<Id, Map<String,Integer>>();
        // querying data based of transaction which is done with in month.
        List<Transactions_Entry__c> transactionEntriesListForMonth = [SELECT Id,Name, Contact__c, Amount__c, Type__c, 
                                                                    Transaction_Date__c FROM Transactions_Entry__c WHERE Contact__c IN:setOfContactIds
                                                                    AND CALENDAR_MONTH(Transaction_Date__c) =:(Integer)System.today().Month()];
        //    iteration query transactionEntriesListForMonth  
        for(Transactions_Entry__c tran : transactionEntriesListForMonth) {
            // check if transactionEntriesListForMonth not contains parent key.
            if(!mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.containsKey(tran.Contact__c)) {
                mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.put(tran.Contact__c, new Map<String,Integer>());
                mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).put('transactionEntries',0);
                mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).put('debitAmount',0);
            }
            mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).put('transactionEntries',(Integer)mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).get('transactionEntries')+1);
           
            //    if transaction type is debit then add one to value
            if(tran.Type__c == 'Debit') {
                mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).put('debitAmount',(Integer)mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).get('debitAmount')+1);
            }  
        }
        //    initilizing map of contact
        Map<Id, Contact> mapOfContactWithIds = new map<Id, Contact>();
        // Querying data of Limit limit oject using child parent query.
        mapOfContactWithIds.putAll([SELECT Id,Status__c, Transaction_Limit__r.Maximum_Debit_Allowed_Per_Day__c,Transaction_Limit__r.Maximum_Debit_Allowed_Per_Month__c,
                               Transaction_Limit__r.Maximum_Debit_Allowed_Per_Transaction__c, Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c,
                               Transaction_Limit__r.Maximum_Transactions_Allowed_Per_Month__c FROM Contact WHERE Id IN:setOfContactIds ]);
        //    iterating value of mapofContactIds.
        for(Contact con : mapOfContactWithIds.values()) {
            // check for contact status
            if(con.Status__c == 'Active') {
                // iterating transaction list comes from trigger.new.
                for(Transactions_Entry__c tran : newTransactionList) {
                    // check for parent is not null.
                    if(mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c) != Null) {
                        // check no of transaction entries is greater then maximum transaction entries
                        if(mapOfConIdWithTxnEntriesForAmountDebitedPerDay.get(tran.Contact__c).get('transactionEntries') 
                            > mapOfContactWithIds.get(tran.Contact__c).Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c) {
                                // show error on transaction entry
                            tran.addError('Per day Transaction Limit exceeded');
                        }
                    }
                    // check for parent id is not null.
                    if(mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c) != Null) {
                        // check no of transaction entries is greater then maximum transaction entries
                        if(mapOfConIdWithTxnEntriesForAmountDebitedPerMonth.get(tran.Contact__c).get('transactionEntries') 
                            > mapOfContactWithIds.get(tran.Contact__c).Transaction_Limit__r.Maximum_Transactions_Allowed_Per_Month__c) {
                                // show error on transaction entry.
                            tran.addError('Per Month Transaction Limit exceeded');
                        }
                    }
                }
            }
        }   
    }
}
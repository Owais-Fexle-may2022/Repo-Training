trigger transactionTrigger on Transactions_Entry__c (After insert,After update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            transactionEntryHelper.updateAvilableBalance(trigger.new,trigger.oldMap);
            transactionEntryHelper.sentEmailNotification(trigger.new);
            transactionEntryHelper.CheckTrasactionlimitOnTransactionEntry(trigger.new);
        }else if(trigger.isUpdate){
            transactionEntryHelper.updateAvilableBalance(trigger.new,trigger.oldMap);
        }
    }
}
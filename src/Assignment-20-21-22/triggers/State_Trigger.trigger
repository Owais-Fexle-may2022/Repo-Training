trigger State_Trigger on State__c (After insert, After Update, After Delete,before Update) {
    if(trigger.isAfter){
        if(trigger.isInsert||trigger.isUpdate||trigger.isDelete){
            stateTriggerHelper.rollUpStateAndDistrictCountOnCountry(trigger.new,trigger.oldMap);
        }
    }
    if(trigger.isBefore){
        if(trigger.isUpdate){
            stateTriggerHelper.stateJSONGenerator(trigger.new,trigger.oldMap);
        }
    }

}
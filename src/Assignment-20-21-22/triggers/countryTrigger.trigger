trigger countryTrigger on Country__c (before Update) {
    if(trigger.isBefore){
        if(trigger.isUpdate){
            countryTriggerHelper.countryJsonDataUpdate(trigger.New, trigger.OldMap);
        }
    }
}
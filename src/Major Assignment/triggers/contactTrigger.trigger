trigger contactTrigger on contact (before delete) {
    if(trigger.isBefore && trigger.isdelete){
        contactTriggerHelper.contactCanNotBeDelete(trigger.old);
    }

}
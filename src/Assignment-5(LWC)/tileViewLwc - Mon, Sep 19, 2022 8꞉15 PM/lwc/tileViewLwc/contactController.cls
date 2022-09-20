public with sharing class contactController {
    @AuraEnabled
    public static List<Contact> getContactTile() {
        List<Contact> conList = [Select Id, Name, Title, Phone, Email From Contact Order By CreatedDate Asc Limit 20]; 
        return conList;
    }
}
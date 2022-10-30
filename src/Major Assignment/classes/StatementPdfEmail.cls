/*
   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
   * @Description      This Class is used to return result based on input on Lightning Web Component.
   * @author           Mohd Owais  <mohd.owais@fexle.com>           
   * @created          17/10/2022
   * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   */
public with sharing class StatementPdfEmail {
    @AuraEnabled(cacheable=true)
    public static void sendEmail(Id recordIdOfContact, String start_Date, String end_Date){
        //Setting page reference
        PageReference statementPDFRef = new PageReference('/apex/Download_PDF');
        //putting value to page
        statementPDFRef.getParameters().put('id', recordIdOfContact);
        statementPDFRef.getParameters().put('startdate', start_Date);
        statementPDFRef.getParameters().put('enddate', end_Date);
        //To hold pdf body
        Blob bodyOfPDF;
        //For testing class
        if(Test.isRunningTest()){
            bodyOfPDF = blob.valueOf('Unit.Test');
        }else{
            //Content of pdf
            bodyOfPDF = statementPDFRef.getContent();
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //File attachment
        Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
        //Calling contact_obj for email body
        Contact contact_obj = [SELECT Id, Name, Email, Account_Number__c FROM Contact WHERE Id =: recordIdOfContact];
        //formating account number
        String accountNumberFormat = 'AccNo-XXX'+ contact_Obj.Account_Number__c.substringAfter('-').right(2);
        //set address
        email.setToAddresses(new String[] {contact_obj.Email});
        //set subject
        email.setSubject('Requested Bank Statement');
        //set HTML body
        email.setHtmlBody('Hello '+ contact_obj.Name + ', <br><br> As you have requested, Account statement for your account is attached below. ');
        //set attachment
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {att});
        //Defination of attachment
        att.setContentType('application/pdf');
        att.setFileName('Bank_Statement.pdf');
        att.setBody(bodyOfPDF);
        //send email
        Messaging.sendEmail(new messaging.SingleEmailMessage[] {email});
    }
}
public with sharing class Controller {
    @AuraEnabled
    public static string getTextMethod1(){
        return 'APEX-METHOD-1';
    }
 
    @AuraEnabled
    public static string getTextMethod2(){
        return 'APEX-METHOD-2';
    }
 
    @AuraEnabled
    public static string getTextMethod3(){
        return 'APEX-METHOD-3';
    }
}
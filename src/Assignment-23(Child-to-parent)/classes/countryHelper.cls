public with sharing class countryHelper {
    public static void countryJsonData(List<Country__c> newCountryList ,Map<Id,Country__c> oldCountryMap){

        Set<Id> CountryId = new Set<Id>();
        for(Country__c count : newCountryList){
            if(oldCountryMap != null){   
                CountryId.add(count.Id);             
            }
            system.debug('idscountry'+CountryId);
        }
        if(!CountryId.isEmpty()){

            Map<Id,State__c> mapOfStatewithCountryId = new Map<Id,State__c>([SELECT Id, Country_Name__c,Country_Name__r.Id,Country_Name__r.Name,
                                                                        Country_Name__r.Country_Code__c,Country_Name__r.Total_Number_Of_States__c,
                                                                         Country_Name__r.Total_Number_Of_Districts__c, Name,Total_Number_Of_Districts__c,
                                                                            (SELECT id, Name FROM Districts__r)
                                                                            FROM State__c WHERE Country_Name__c IN : CountryId]);
            System.debug(mapOfStatewithCountryId.values());

            for(Country__c cou : newCountryList){
                if(CountryId.contains(cou.Id)) {  
                    Country wrapCountry = new Country();
                    wrapCountry.countryName = cou.Name;
                    wrapCountry.countryCode = cou.Country_Code__c;
                    wrapCountry.states = new List<states>();
                    wrapCountry.totalNumberDistrict = (Integer)cou.Total_Number_Of_Districts__c;
                    wrapCountry.totalNumberState = (Integer)cou.Total_Number_Of_States__c;

                    for(State__c std : mapOfStatewithCountryId.values()){    
                        States wrapState = new States();
                        wrapState.stateName = std.Name;
                        wrapState.districts = new List<Districts>();
                        wrapState.totalDistrict = String.valueof(std.Total_Number_Of_Districts__c); 
                        for(District__c dst : std.Districts__r){
                            Districts wrapDistrict = new Districts();
                            wrapDistrict.districtName = dst.Name;
                            wrapState.districts.add(wrapDistrict);
                        }
                        wrapCountry.states.add(wrapState);
                    }
                    String jString = JSON.serialize(wrapCountry);
                    cou.Country_JSON_Data__c = jString;
                }
            }
        }     
    }
    public List<Country> countryList{get; set;}
    public class Country{
        public String countryName{get; set;}
        public String countryCode{get; set;}
        public Integer totalNumberState{get; set;}
        public Integer totalNumberDistrict{get; set;}
        public List<States> states{get; set;}       
    }
    public class States{
        Public string stateName{get; set;}
        Public List<Districts> districts{get; set;}
        public String totalDistrict{get; set;}
    }
    public class Districts{
        Public String districtName{get; set;}
    }
}
public with sharing class countryTriggerHelper {
  /*
    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @Description      This method is used when an district or state is update,insert or delete in updates Json data of country
    * @author           Mohd Owais  <mohd.owais@fexle.com>
    * @Return           void
    * @Parameter        List of Country,map of Country.
    * @created          2022-08-13
    * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void countryJsonDataUpdate(List<Country__c> newCountryList ,Map<Id,Country__c> oldCountryMap){
        // stores country Id
        Set<Id> setOfCountryId = new Set<Id>();
        // iterating new List
        for(Country__c count : newCountryList){
            // check for changes
            if(oldCountryMap != null && ((count.Total_Number_Of_States__c !=oldCountryMap.get(count.Id).Total_Number_Of_States__c )
									 ||(count.Total_Number_Of_Districts__c !=oldCountryMap.get(count.Id).Total_Number_Of_Districts__c))){
                // adding country Id to set   
                setOfCountryId.add(count.Id);             
            }
        }
        // check size of set where country Id stores
        if(!setOfCountryId.isEmpty()){
            // querying data
            Map<Id,State__c> mapOfStatewithCountryId = new Map<Id,State__c>([SELECT Id, Country_Name__c,Country_Name__r.Id,Country_Name__r.Name,
                                                                            Country_Name__r.Country_Code__c,Country_Name__r.Total_Number_Of_States__c,
                                                                            Country_Name__r.Total_Number_Of_Districts__c, Name,Total_Number_Of_Districts__c,
                                                                            (SELECT id, Name FROM Districts__r)
                                                                            FROM State__c WHERE Country_Name__c IN : setOfCountryId]);
            // iterating new List of country
            for(Country__c cou : newCountryList){
                if(setOfCountryId.contains(cou.Id)) {  
                    Country wrapCountry = new Country();
                    wrapCountry.countryName = cou.Name;
                    wrapCountry.countryCode = cou.Country_Code__c;
                    wrapCountry.states = new List<states>();
                    wrapCountry.totalNumberDistrict = (Integer)cou.Total_Number_Of_Districts__c;
                    wrapCountry.totalNumberState = (Integer)cou.Total_Number_Of_States__c;
                    // iterating map values
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
                    // passing seralize method of json to country object.
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
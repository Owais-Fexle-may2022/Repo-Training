public with sharing class stateTriggerHelper {
     /*
    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @Description      This method is used when an district or state is insert,update or delete.
    * @author           Mohd Owais  <mohd.owais@fexle.com>
    * @Return           void
    * @Parameter        List,Map
    * @created          2022-08-13
    * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */  
    public static void rollUpStateAndDistrictCountOnCountry(List<State__c> newState,Map<Id,State__c> oldStateMap) {
        // initilizing map to store state parent and id.
        Map<Id,Country__c> mapOfCountryToBeUpdate=new Map<Id,Country__c>();
         // iterating state list.And putting values in map.
        for(State__c std:newState!=null ? newState:oldStateMap.Values()){
            if(std.Country_Name__c!=null){
                mapOfCountryToBeUpdate.put(std.Country_Name__c,new Country__c(Id=std.Country_Name__c,
										Total_Number_Of_States__c=0,Total_Number_Of_Districts__c=0));
            }
            if(oldStateMap !=null && std.Country_Name__c != oldStateMap.get(std.Id).Country_Name__c){
                mapOfCountryToBeUpdate.put(oldStateMap.get(std.Id).Country_Name__c,new Country__c(Id=oldStateMap.get(std.Id).Country_Name__c,
                                                                                 Total_Number_Of_States__c=0,Total_Number_Of_Districts__c=0));
            }
        }
        if(!mapOfCountryToBeUpdate.isEmpty()){
            // iterating aggregate query and putting new value in total no of state field.
            for(AggregateResult agr:[SELECT Country_Name__c,COUNT(Id)totalNumberOfState,SUM(Total_Number_Of_Districts__c)totalNumberOfDistricts
											 FROM State__c WHERE Country_Name__c IN:mapOfCountryToBeUpdate.keySet() GROUP BY Country_Name__c]){
                mapOfCountryToBeUpdate.put(String.valueOf(agr.get('Country_Name__c')),new Country__c(Id = (Id)agr.get('Country_Name__c'),
																	  Total_Number_Of_States__c = (Decimal)agr.get('totalNumberOfState'),
															 Total_Number_Of_Districts__c = (Decimal)agr.get('totalNumberOfDistricts'))); 
            }
			// updating map values
			update mapOfCountryToBeUpdate.Values();
        }
        
    }
    /*
    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @Description      This Method is used to generate json data on state object.
    * @author           Mohd Owais  <mohd.owais@fexle.com>
    * @Return           void
    * @Parameter        List,Map
    * @created          2022-08-15
    * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void stateJSONGenerator(List<State__c> newStateList ,Map<Id,State__c> oldStateMap){
        Set<Id> stateIds = new Set<Id>();
        for(State__c state: newStateList){
            if(state.Total_Number_Of_Districts__c != oldStateMap.get(state.Id).Total_Number_Of_Districts__c){
                stateIds.add(state.Id);
                //system.debug('ids'+stateIds);
            }
        }
        if(!stateIds.isEmpty()){
            Map<Id, State__c> mapOfState = new Map<Id, State__c>([SELECT Id, Name, Total_Number_Of_Districts__c,
																			(SELECT Id, Name FROM Districts__r)
																								FROM State__c]);
            for(State__c st: newStateList){
                if(mapOfState.containsKey(st.Id)){ 
                    State wrap = new State();
                    wrap.stateName=st.Name;
                    wrap.totalDistrict = st.Total_Number_Of_Districts__c;
                    wrap.districts = new List<Districts>();
                    for(District__c dis: mapOfState.get(st.Id).Districts__r){
                        Districts wrapDist = new Districts();
                        wrapDist.districtName = dis.Name;
                        wrap.districts.add(wrapDist);
                    }
                    String jsonString = JSON.serialize(wrap);
                    st.State_JSON_Data__c = jsonString;
                }
            }
            
         }
    }
    public List<State> states{get; set;}
    public class State{
        Public string stateName{get; set;}
        Public List<Districts> districts{get; set;}
        public Decimal totalDistrict{get; set;}
    }
    public class Districts{
        Public String districtName{get; set;}
    } 
   
}
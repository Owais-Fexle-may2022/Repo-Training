public with sharing class districtTriggerHelper {
    /*
    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    * @Description      This method is used when an district is inserted deleted or updated it updates total no of district on state object.
    * @author           Mohd Owais  <mohd.owais@fexle.com>
    * @Return           void
    * @Parameter        List,Map
    * @created          2022-08-13
    * ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void  rollUpDistrictCountOnState(List<District__c> newDistrict,Map<Id,District__c> oldDistrictMap){
        // initilizing map to store district parent and id.
        Map<Id,State__c> mapOfStateToBeUpdate=new Map<Id,State__c>();
        // iterating district list.And putting values in map.
        for(District__c dist:newDistrict!=null ? newDistrict:oldDistrictMap.Values()){
            if(dist.State_Name__c!=null){
                mapOfStateToBeUpdate.put(dist.State_Name__c,new State__c(Id=dist.State_Name__c,Total_Number_Of_Districts__c=0));
            }
            if(oldDistrictMap !=null && dist.State_Name__c != oldDistrictMap.get(dist.Id).State_Name__c){
                mapOfStateToBeUpdate.put(oldDistrictMap.get(dist.Id).State_Name__c,new State__c(Id=oldDistrictMap.get(dist.Id).State_Name__c,
                                                                                                            Total_Number_Of_Districts__c=0));
            }
        }
        if(!mapOfStateToBeUpdate.isEmpty()){
            // iterating aggregate query and putting new value in total no of district field.
            for(AggregateResult agr:[SELECT COUNT(Id)numberOfDistrict,State_Name__c FROM District__c WHERE State_Name__c 
																IN:mapOfStateToBeUpdate.keySet() GROUP BY State_Name__c]){
                mapOfStateToBeUpdate.get((Id)agr.get('State_Name__c')).Total_Number_Of_Districts__c=(Integer)agr.get('numberOfDistrict');
                                        }
			// updating map values.
			update mapOfStateToBeUpdate.Values();
        }
        
    }
}
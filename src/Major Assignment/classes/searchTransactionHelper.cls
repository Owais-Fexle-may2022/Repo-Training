/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used as an helper of visual force page searchTransaction to query data based on input.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Method           one
* @created          21/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class searchTransactionHelper {
    // initilizing getter and setter for communicate between vf page to this class.
    public Decimal amountFrom { get; set; }
    public Decimal amountUpto { get; set; }
    public Date dateFrom { get; set; }
    public Date dateUpto { get; set; }
    public String selectedStatus { get; set; }
    public String entryName { get; set; }
    public String accountNumber { get; set; }
    public List<Transactions_Entry__c> transactionData { get; set; }
/*
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Description      This class is used as an helper of visual force page searchTransaction to query data based on input.
* @author           Mohd Owais  <mohd.owais@fexle.com>
* @Parameter        None
* @Return           Void
* @created          21/10/2022
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public void searchTransaction(){
        // dynamic query based on inputs.
        String query = 'SELECT Name, Status__c,TX_Entry_Name__c,Transaction_Date__c,Amount__c,Contact__r.Account_Number__c FROM Transactions_Entry__c ';
        // initilizing temp list.
        List<String> tempList=new List<String>();
        // initilizing Map for input values
        Map<String, String> mapValues = new Map<String, String>{
                                    // type caste value and adding it to map 
                                    'accountNumber'=> String.valueOf('\'%'+accountNumber+'%\''),
                                    'entryName'=> String.valueOf('\'%'+entryName+'%\''),
                                    'amountFrom'=> String.valueOf(amountFrom),    // 1000
                                    'amountUpto'=> String.valueOf(amountUpto),    // 20000
                                    'dateFrom'=> String.valueOf(dateFrom),        // 2022/10/10
                                    'dateUpto'=> String.valueOf(dateUpto),        // 2022/10/26
                                    'selectedStatus'=> '\'' + String.valueOf(selectedStatus) + '\''  // Completed
                                    };
            // Initilizing map for operator field. 
            Map<String, String> mapOperators = new Map<String, String>{
                                    // adding operator to map 
                                    'accountNumber'=>'Contact__r.Account_Number__c Like ',
                                    'entryName'=> 'TX_Entry_Name__c Like ',
                                    'amountFrom'=> 'Amount__c >= ',
                                    'amountUpto'=> 'Amount__c <= ',
                                    'dateFrom'=> 'Transaction_Date__c >= ',
                                    'dateUpto'=> 'Transaction_Date__c <= ',
                                    'selectedStatus'=> 'Status__c = '
                                    };                               
            String filter = 'WHERE ';
        // iterating map of operator.
        for(String str: mapOperators.keySet()){
            // check for  map value is not null
            if(mapValues.get(str) != null && mapValues.get(str) != '0'){
                // concatinate map value and map operator and add it to temp list
                tempList.add(mapOperators.get(str) + ' ' + String.valueOf(mapValues.get(str)));
            }
        }
        filter += String.join(tempList, ' AND ');
        query += filter;
        System.debug('Query: ' + query);
        // querying dynamic query using inbuild function databasequery.
        transactionData = Database.query(query);
    }
}
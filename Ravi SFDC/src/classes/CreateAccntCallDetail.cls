public class CreateAccntCallDetail {
   
    @AuraEnabled public list<string> CommunicationMethods {get;set;}
    @AuraEnabled public list<string> Reasons {get;set;}
    @AuraEnabled public Boolean isDisable {get;set;}
    
    @AuraEnabled
    public static CreateAccntCallDetail initClass(string recordId){
 		CreateAccntCallDetail objClass = new CreateAccntCallDetail(); 
        objClass.CommunicationMethods = PicklistValues(Afterhourcall__c.CommunicationMethod__c.getDescribe());
        objClass.Reasons = PicklistValues(Afterhourcall__c.Reason__c.getDescribe());
        
        objClass.isDisable = checkAfterCall(recordId);
        
        return objClass;
    }
    
    public static list<string> PicklistValues(Schema.DescribeFieldResult fieldResult){
        List<String> options = new List<String>();
        options.add('');
        //fieldResult = Contact.get(field).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    
    public static boolean checkAfterCall(string recordId){
        boolean res = false;
        if(recordId != null){
            if(recordId.indexOf('001') == 0){
                for(Account objA : [select Id from Account where Id=:recordId AND Name != 'sForce']){
                    res = true;
                }
            }else if(recordId.indexOf('003') == 0){
                for(Contact objC : [select Id from Contact where Id=:recordId]){
                    res = true;
                }
            }
        }
        return res;
    }
    
    /**
   * Create a new Aftercall Record
   *
   * @param Afterhourcall__c Afterhourcall Afterhourcall record to be inserted
   * 
   */
    @AuraEnabled
    public static string createRecord (Afterhourcall__c Afterhourcall){
        
        try{
            
            if(Afterhourcall != null){
                insert Afterhourcall;
            }
            
        } catch (Exception ex){
            return ex.getMessage();
        }
        return 'Success';
    }    
    
    /*@AuraEnabled
    public static List<String> getCommunicationMethods(){
        List<String> options = new List<String>();
        options.add('');
        Schema.DescribeFieldResult fieldResult = Afterhourcall__c.CommunicationMethod__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }*/
    
    @AuraEnabled
    public static string getContactName(string recordId){
        string AccountName = '';
        for(Account obj : [select Id,Name from account where id=:recordId]){
            AccountName = obj.Name+'##:##'+obj.Id;
        }
        return AccountName;
    }
    /*@AuraEnabled
    public static List<String> getReason(){
        List<String> options = new List<String>();
        options.add('');
        Schema.DescribeFieldResult fieldResult = Afterhourcall__c.Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        
        return options;
    }*/
   }
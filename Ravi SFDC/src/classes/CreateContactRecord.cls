public with sharing class CreateContactRecord {

    /**
   * Create a new candidate Record
   *
   * @param Candidate__c candidate  candidate record to be inserted
   * 
   */
    @AuraEnabled
    public static string createRecord (Contact candidate){
        
        try{
            System.debug('CreateCandidateRecord::createRecord::candidate'+candidate);
            
            if(candidate != null){
                insert candidate;
            }
            
        } catch (Exception ex){
            return ex.getMessage();
        }
        return 'Success';
    }    
    
    @AuraEnabled
    public static Contact getContact() {
        return [select Id, Name from Contact Limit 1];
    }
    
    @AuraEnabled
    public static List<String> getLevelValues(){
        List<String> options = new List<String>();
        options.add('');
        Schema.DescribeFieldResult fieldResult = Contact.Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        
        return options;
    }
    
    @AuraEnabled
    public static string getContactAccountName(string recordId){
        string AccountName = '';
        for(Contact obj : [select Id,AccountId,Account.Name from Contact where id=:recordId]){
            AccountName = obj.Account.Name+'##:##'+obj.AccountId;
        }
        return AccountName;
    }
    
    @AuraEnabled public list<string> ContatLevels {get;set;}
    @AuraEnabled public list<string> LeadSources {get;set;}
    
    @AuraEnabled
    public static CreateContactRecord initClass(){
 		CreateContactRecord objClass = new CreateContactRecord();  
        objClass.ContatLevels = CreateContactRecord.getLevelValues();
        
        objClass.LeadSources = CreateContactRecord.getLevelValues();
        
        system.debug('objClass '+objClass);
        return objClass;
    } 
    
}
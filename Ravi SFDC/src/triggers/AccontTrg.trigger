trigger AccontTrg on Account (after update) {
  
    if(trigger.isUpdate && trigger.isAfter){
        list<Id> lstInactiveAccountIds = new list<Id>();
        list<Id> lstActiveAccountIds = new list<Id>();
        
        for(Account objAcc : trigger.new){
            if( objAcc.Account_Record_Type__c == 'Corporate_Account' || objAcc.Account_Record_Type__c == 'All_CF_Account' ){
                if(objAcc.Account_Status__c == 'Inactive' && trigger.oldMap.get(objAcc.Id).Account_Status__c != objAcc.Account_Status__c){
                	lstInactiveAccountIds.add(objAcc.Id);
                }else if(objAcc.Account_Status__c == 'Active' && trigger.oldMap.get(objAcc.Id).Account_Status__c != objAcc.Account_Status__c){
                	lstActiveAccountIds.add(objAcc.Id);
                } 
            }
        }
        
        if(!lstInactiveAccountIds.isEmpty()){
            list<Contact> lstContacts = new list<Contact>();
            list<AccountContactRelation> lstAccountContactRelationsDelete = new list<AccountContactRelation>();
        	list<Inactive_Account_Contact__c> lstInactiveContactRelations = new list<Inactive_Account_Contact__c>();
            
            for(Contact objCon : [select Id from Contact where AccountId IN : lstInactiveAccountIds ]){
                lstContacts.add( new Contact(Id=objCon.Id,AccountId=null) );
            }
        	
            for(AccountContactRelation obj : [select Id,ContactId,AccountId,Roles,IsDirect,StartDate,EndDate from AccountContactRelation where AccountId IN : lstInactiveAccountIds] ){
				lstInactiveContactRelations.add(
					new Inactive_Account_Contact__c(
                        Contact__c = obj.ContactId,
                        Account__c = obj.AccountId,
                        Roles__c = obj.Roles,
                        Is_Direct__c = obj.IsDirect
					)
              	);
                if(obj.IsDirect == false){
                  lstAccountContactRelationsDelete.add(obj);
                }
            }
            if(!lstAccountContactRelationsDelete.isEmpty())
                delete lstAccountContactRelationsDelete;
            if(!lstContacts.isEmpty())
                update lstContacts;
            if(!lstInactiveContactRelations.isEmpty())
                insert lstInactiveContactRelations;
        }
        
        if(!lstActiveAccountIds.isEmpty()){
            map<Id,Contact> mapContacts = new map<Id,Contact>();
            map<string,AccountContactRelation> mapAccountContactRelations = new map<string,AccountContactRelation>();
        	list<Inactive_Account_Contact__c> lstInactiveContactRelationsDelete = new list<Inactive_Account_Contact__c>();
            
            for(Inactive_Account_Contact__c obj : [select Id,Contact__c,Account__c,Roles__c,Is_Direct__c from Inactive_Account_Contact__c where Account__c IN : lstActiveAccountIds AND Contact__r.Contact_Status__c = 'Active' order by createdDate desc] ){
            	if(obj.Is_Direct__c){
                    mapContacts.put(obj.Contact__c, new Contact(Id=obj.Contact__c,AccountId=obj.Account__c) );
                }else{
                    mapAccountContactRelations.put(
                    	obj.Account__c+'-'+obj.Contact__c,
                        new AccountContactRelation(
                            ContactId = obj.Contact__c,
                            AccountId = obj.Account__c,
                            Roles = obj.Roles__c
                        )
                    );
                }
                
                
                lstInactiveContactRelationsDelete.add(obj);
            }
            
            if(!lstInactiveContactRelationsDelete.isEmpty())
            	delete lstInactiveContactRelationsDelete;
            if(!mapContacts.isEmpty())
                update mapContacts.values();
            if(!mapAccountContactRelations.isEmpty())
                insert mapAccountContactRelations.values();
        }
        
    }
}
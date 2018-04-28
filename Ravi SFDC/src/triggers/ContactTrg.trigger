trigger ContactTrg on Contact (before update, after update) {
  
    if(trigger.isUpdate && trigger.isBefore){
      list<Inactive_Account_Contact__c> lstInactiveContactRelations = new list<Inactive_Account_Contact__c>();
        //list<AccountContactRelation> lstAccountContactRelations = new list<AccountContactRelation>();
        list<AccountContactRelation> lstAccountContactRelationsDelete = new list<AccountContactRelation>();
        
        list<Id> lstConIds = new list<Id>();
        list<Id> lstActiveConIds = new list<Id>();
        
        for(Contact objCon : trigger.new){
            if(objCon.Contact_Status__c == 'Inactive' && ( objCon.Contact_Record_Type__c == 'Corporate_Contacts'
                    || objCon.Contact_Record_Type__c == 'All_CF_Contact' ) && trigger.oldMap.get(objCon.Id).Contact_Status__c != objCon.Contact_Status__c){
                objCon.AccountId = null;
                lstConIds.add(objCon.Id);
            }else if(objCon.Contact_Status__c == 'Active' && ( objCon.Contact_Record_Type__c == 'Corporate_Contacts'
                    || objCon.Contact_Record_Type__c == 'All_CF_Contact' ) && trigger.oldMap.get(objCon.Id).Contact_Status__c != objCon.Contact_Status__c){
                lstActiveConIds.add(objCon.Id);
            }
        }
        
        if(!lstConIds.isEmpty()){
            for(AccountContactRelation obj : [select Id,ContactId,AccountId,Roles,IsDirect,StartDate,EndDate from AccountContactRelation where ContactId IN : lstConIds] ){
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
        }
        
        if(!lstActiveConIds.isEmpty()){
            map<Id,Id> mapContactDirectAccouts = new map<Id,Id>();
            for(Inactive_Account_Contact__c obj : [select Id,Contact__c,Account__c,Roles__c,Is_Direct__c from Inactive_Account_Contact__c where Contact__c IN : lstActiveConIds order by createdDate desc] ){
                
                if(obj.Is_Direct__c && mapContactDirectAccouts.containsKey(obj.Contact__c) == false){
                    if(obj.Account__c != null)
                    mapContactDirectAccouts.put(obj.Contact__c,obj.Account__c);
                }
                
                /*if(obj.Is_Direct__c == false){
                    lstAccountContactRelations.add(
                        new AccountContactRelation(
                            ContactId = obj.Contact__c,
                            AccountId = obj.Account__c,
                            Roles = obj.Roles__c
                        )
                    );
                }*/
            }
            
            if(mapContactDirectAccouts.isEmpty() == false){
                for(Contact objCon : trigger.new){
                  if(objCon.Contact_Status__c == 'Active' && ( objCon.Contact_Record_Type__c == 'Corporate_Contacts'
                    || objCon.Contact_Record_Type__c == 'All_CF_Contact' ) && trigger.oldMap.get(objCon.Id).Contact_Status__c != objCon.Contact_Status__c){
                        if(mapContactDirectAccouts.containsKey(objCon.Id)){
                            objCon.AccountId = mapContactDirectAccouts.get(objCon.Id);
                        }
                    }
                }
            }
            
        }
        if(!lstAccountContactRelationsDelete.isEmpty()){
            delete lstAccountContactRelationsDelete;
        }
        if(!lstInactiveContactRelations.isEmpty()){
            insert lstInactiveContactRelations;
        }
        
    }
   
    if(trigger.isUpdate && trigger.isAfter){
    list<Id> lstActiveConIds = new list<Id>();
        list<AccountContactRelation> lstAccountContactRelations = new list<AccountContactRelation>();
        list<Inactive_Account_Contact__c> lstInactiveContactRelationsDelete = new list<Inactive_Account_Contact__c>();
        
        for(Contact objCon : trigger.new){
            if(objCon.Contact_Status__c == 'Active' && ( objCon.Contact_Record_Type__c == 'Corporate_Contacts'
                    || objCon.Contact_Record_Type__c == 'All_CF_Contact' ) && trigger.oldMap.get(objCon.Id).Contact_Status__c != objCon.Contact_Status__c){
                lstActiveConIds.add(objCon.Id);
            }
        }
        
        if(!lstActiveConIds.isEmpty()){
            for(Inactive_Account_Contact__c obj : [select Id,Contact__c,Account__c,Roles__c,Is_Direct__c from Inactive_Account_Contact__c where Contact__c IN : lstActiveConIds order by createdDate desc] ){
                if(obj.Is_Direct__c == false){
                    lstAccountContactRelations.add(
                        new AccountContactRelation(
                            ContactId = obj.Contact__c,
                            AccountId = obj.Account__c,
                            Roles = obj.Roles__c
                        )
                    );
                }
                lstInactiveContactRelationsDelete.add(obj);
            }
            
            if(!lstAccountContactRelations.isEmpty()){
                insert lstAccountContactRelations;
            }
            if(!lstInactiveContactRelationsDelete.isEmpty()){
                delete lstInactiveContactRelationsDelete;
            }
        }
    }
}
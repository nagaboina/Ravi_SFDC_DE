trigger AddRelatedRecord on Lead (after update) {
    list<Contact> lstContacts = new list<Contact>();
    list<Contact> lstContactsToDelete = new list<Contact>();
    map<Id, Lead> mapLeads = new map<Id,Lead>();
    map<Id,Account> mapAccounts = new map<Id,Account>();//v1.1
    map<Id,Id> mapContactRecordTypes = new map<Id,Id>();
    
    if(trigger.isUpdate && trigger.isAfter){
        for(Lead objLead : trigger.new){
            if(objLead.isConverted && trigger.oldMap.get(objLead.Id).isConverted != objLead.isConverted && objLead.Lead_Record_Type__c == 'All_Qualified_Leads' ){
                mapLeads.put(objLead.Id,objLead);
                if(objLead.ConvertedContactId != null){
                    //lstContactsToDelete.add(new Contact(Id=objLead.ConvertedContactId));
                    mapContactRecordTypes.put(objLead.ConvertedContactId,objLead.Id);
                }
                
                //v1.1
                if(objLead.ConvertedAccountId != null){
                    mapAccounts.put(
                    	objLead.ConvertedAccountId,
                        new Account(
                        	Id = objLead.ConvertedAccountId,
                            Tax_Id__c = objLead.Tax_Id__c
                        )
                    );
                }
            }
        }
        
        if(!mapLeads.isEmpty()){
            for(Contact objCon : [select id,RecordTypeId from Contact where Id IN : mapContactRecordTypes.keySet()]){
                if(mapContactRecordTypes.containsKey(objCon.Id) )
                	mapContactRecordTypes.put( mapContactRecordTypes.get(objCon.Id), objCon.RecordTypeId );
            }
            for(Related_Contact__c objRC : [select Id, Contact_Type__c,  Email__c, Last_Name__c, First_Name__c,  Lead__c, Phone__c, Promise_Notifications__c, Promise_User_Role__c, Title__c,Entered_In_Promise__c,Lead__r.Entered_In_Promise__c from Related_Contact__c where lead__c in :mapLeads.keySet()]){
                if(objRC.Lead__r.Entered_In_Promise__c == true && objRC.Entered_In_Promise__c == false){
                    trigger.newMap.get(objRC.Lead__c).addError('Related Contacts are not in Promise system');
                }
                lstContacts.add(
                	new Contact(
                    	FirstName=objRC.First_Name__c,
                       	LastName=objRC.Last_Name__c,
                       	Contact_Type__c=objRC.Contact_Type__c,
                       	Email=objRC.Email__c,
                       	Phone=objRC.Phone__c,
                       	Promise_Notifications__c=objRC.Promise_Notifications__c,
                       	Promise_User_Role__c=objRC.Promise_User_Role__c,
                       	Title=objRC.Title__c,
                       	AccountId = mapLeads.get(objRC.lead__c).ConvertedAccountId,
                        RecordTypeId = mapContactRecordTypes.get(objRC.lead__c),
                        Contact_Status__c = 'Active'
                    )
                );
            }
        }
        
        //v1.1
        if(!mapAccounts.isEmpty()){
            update mapAccounts.values();
        }
        
        if(!lstContacts.isEmpty()){
            insert lstContacts;
        }
        if(!lstContactsToDelete.isEmpty())
            delete lstContactsToDelete;
    }
}
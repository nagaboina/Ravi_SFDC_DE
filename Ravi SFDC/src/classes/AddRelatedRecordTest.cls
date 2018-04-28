@isTest
public class AddRelatedRecordTest {
	@isTest
    static void positiveTest(){
        
        Product2 objProduct = new Product2();
        objProduct.Name = 'Test Product';
        insert objProduct;
        
        Lead objLead = new Lead();
        objLead.FirstName = 'Test';
        objLead.LastName = 'Lead';
        objLead.Email = 'test@lead.com';
        objLead.Company = 'Test Class';
        insert objLead;
    	
        Related_Product__c objRP = new Related_Product__c();
        objRP.Product__c = objProduct.Id;
        objRP.Lead__c = objLead.Id;
        insert objRP;
        
        Related_Contact__c objRC = new Related_Contact__c();
        objRC.Lead__c = objLead.Id;
        objRC.First_Name__c = 'Test Name';
        objRC.Last_Name__c = 'Last Name';
        objRC.Email__c = 'test@lead.email';
    	insert objRC;
        
        objLead.Status = 'Closed - Converted';
        update objLead;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Closed - Converted');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
    }
}
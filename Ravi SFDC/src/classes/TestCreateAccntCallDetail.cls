@isTest
public class TestCreateAccntCallDetail {

    @isTest
    public static void myTestMethod(){
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Name';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        CreateAccntCallDetail.initClass(objAccount.Id);
        CreateAccntCallDetail.initClass(objContact.Id);
        
        Afterhourcall__c objAfterhourcall = new Afterhourcall__c();
        //objAfterhourcall. = objContact.Id;
        objAfterhourcall.AccountId__c = objAccount.Id;
        
        CreateAccntCallDetail.createRecord(objAfterhourcall);
        CreateAccntCallDetail.getContactName(objAccount.Id);
    }
}
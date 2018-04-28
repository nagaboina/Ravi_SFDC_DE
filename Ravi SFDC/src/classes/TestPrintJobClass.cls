/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 
 		Author		:	Shravan
 		Created On	:	22/03/2011
 		Description	:	Code Coverage for PrintJobClass.
 */
@isTest
private class TestPrintJobClass {

    static testMethod void myUnitTest() {
    	Pagereference ref = new Pagereference('http://www.google.com');
    	Test.setCurrentPage(ref);
    	
    	ApexPages.currentPage().getParameters().put('jobReferenceID','24890779');
    	ApexPages.currentPage().getParameters().put('jobDestinationName','ricoh500607');
    	ApexPages.currentPage().getParameters().put('jobPageCount','2');
    	ApexPages.currentPage().getParameters().put('jobPriceTotal','0.00');
    	ApexPages.currentPage().getParameters().put('jobDestination','300984885667');
    	ApexPages.currentPage().getParameters().put('userEmail','shravan.bowrampet@appshark.com');
    	ApexPages.currentPage().getParameters().put('clientUID','');
    	ApexPages.currentPage().getParameters().put('serviceUID','268483385');
    	ApexPages.currentPage().getParameters().put('apiRespURL','https://www.printeron.net/system/hotspot/interface/hotspot_blank_frame.jsp');
    	
    	
    	
    	Contact objCon = new Contact();
    	objCon.Lastname = 'shravan';
    	objCon.MailingPostalCode = '500009';
    	insert objCon;
    	
    	PrintJobClass objPJC = new PrintJobClass();
    	objPJC.getCost();
    	objPJC.getJobId();
    	objPJC.getPages();
    	objPJC.getPrinterId();
    	objPJC.setRenderAuthorize(true);
    	objPJC.getRenderAuthorize();
    	objPJC.PinCode = objCon.MailingPostalCode; 
    	
    	objPJC.Verify();
    	objPJC.AuthorizeJob();
    	objPJC.Canceljob();
    }
}
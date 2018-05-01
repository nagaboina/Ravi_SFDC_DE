/*
    Author          :   Shravan
    Created Date    :   22/03/2011
    Description     :   Handles the Authorization and generating release code for Print Job submitted in Printer On server
                        1. Authorization
                        2. Authorize Job Request
                        3. Cancel Job Request
                        
                        added the descroption for vikram & my self for testing
*/
public class PrintJobClass {
    /*Start of global declarations*/
    static string strApiFunc = 'AuthorizeJobResponse';//static apiFunc to be passed as parameter to the Authorize Job redirection URL
    //variables used to show on Printer On Page,
    //these vales are retrieved from the Query string 
    string strJobId;
    string strPrinterId;
    string strPages;
    string strCost;
    //variables used to hold the values of Query string passed to the (PrintJob)VF page,
    //these values has to be passed as parameters to the Authorize Job redirection URL
    string strJobDest;
    string strSupressUserEmail;
    string strApproveUse;
    string strUserMail;
    string strClientUID;
    string strServiceUID;
    string strRetURL;
    boolean RenderAuth = true;//a boolean variable used for enabling and disabling the AuthorizeJob button in (PrintJob)VF page
    list<Contact> lstContacts = new list<Contact>();//list to hold the contacts
    /*End Of Global Declarations*/
    public string PinCode {get;set;} //property to hold pincode value entered by the user
    public boolean getRenderAuthorize(){//to get RenderAuth value
        return RenderAuth;
    }
    public void setRenderAuthorize(boolean RenderAuth){//to set the RenderAuth value
        this.RenderAuth = RenderAuth;
    }
    public String getCost(){ return strCost; } //method to get the Cost, retrieved from query string 
    public String getPages(){ return strPages; } //method to get the number of pages, retrieved from query string 
    public String getPrinterId(){ return strPrinterId; } //method to get the Printer Name, retrieved from query string. 
    public String getJobId(){ return strJobId; } //method to get the Print Job Id, retrieved from query string 
    public PrintJobClass(){
        //parameters retrieved from the current page query string
        strJobId = ApexPages.currentPage().getParameters().get('jobReferenceID');
        strPrinterId = ApexPages.currentPage().getParameters().get('jobDestinationName');
        strPages = ApexPages.currentPage().getParameters().get('jobPageCount');
        strCost = ApexPages.currentPage().getParameters().get('jobPriceTotal');
        strJobDest = ApexPages.currentPage().getParameters().get('jobDestination');
        strUserMail = ApexPages.currentPage().getParameters().get('userEmail');
        strClientUID = ApexPages.currentPage().getParameters().get('clientUID');
        strServiceUID = ApexPages.currentPage().getParameters().get('serviceUID');
        strRetURL = ApexPages.currentPage().getParameters().get('apiRespURL');
    }
    //METHOD DEFINITION       :   Verify()
    //verifies the Pincode entered by the user in the Contact object
    //INPUT                   :
    //OUTPUT                  :
    //Key Features            :   Enables or Disables the Authorize Button in the VF page (depends on the verifcation success/failure)
    public void Verify(){
        String Message;// Success or Failure Message.
        ApexPages.Message msg;
        try{
            //checking whether pincode contains some string
            if(PinCode!=null && PinCode!=''){
                //searching in the contacts with the Pincode
                lstContacts = [select Id,Name from Contact where pinCode__c =: PinCode];
            }
            
            //Checking whether contacts exists in the list
            if(lstContacts.size()>0){
                //Contacts exist
                RenderAuth = false;//Enabling the Authorize button, by making RenderAuthorize as false
                Message = label.SuccessMessage;//Message to be printed after authorization Success 
                msg = new ApexPages.Message(ApexPages.Severity.INFO,Message);//creating an object for Apex Page messages and selecting msg type as INFO
            }
            else{
                //Contacts do not exist
                RenderAuth = true;//Disabling the Authorize button, by making RenderAuthorize as true
                Message = label.ErrorMessage;//Message to be printed after authorization Failure
                msg = new ApexPages.Message(ApexPages.Severity.ERROR,Message);//Error message generation
            }
            ApexPages.addMessage(msg);//Addind Custom message to the Apex Page Messages
        }
        catch(Exception e){
            e.getMessage();
        }
    }
    //METHOD DEFINITION       :   AuthorizeJob()
    //Handles the Authorize Job Request and Redirects to the release code generation page
    //INPUT                   :
    //OUTPUT                  :   PageReference(redirection to the release code generation page)
    public PageReference AuthorizeJob(){
        //Need to pass as query string to the strReturn URL
        strSupressUserEmail = 'TRUE';
        strApproveUse = 'TRUE';
        
        //constructing the URL with Query string
        string strEndPointURL = strRetURL+'?'+'jobReferenceID=' + strJobId + '&jobDestination=' + strJobDest + '&approveUse=' + strApproveUse + '&supressUserEmail=' + strSupressUserEmail + '&userEmail=' + strUserMail + '&clientUID=' + strClientUID + '&serviceUID=' + strServiceUID + '&apiFunc=' + strApiFunc;

        //Redirecting to the EndPointURL
        PageReference ref = new PageReference(strEndPointURL);
        ref.setRedirect(true);
        return ref;
    }
    //METHOD DEFINITION       :   AuthorizeJob()
    //Handles the Cancel Job Request
    //INPUT                   :
    //OUTPUT                  :   Redirection to the Cancel Job Page
    public PageReference CancelJob(){
        //Redirecting to the Cancel Job Page
        string pageURL = ApexPages.currentPage().getUrl(); //getting the Current page URL
        string[] splitURL = pageURL.split('\\?'); //splitting with '?' to eliminate query string
        
        PageReference ref = new Pagereference(splitURL[0]+'/CancelJob');
        ref.setRedirect(true);
        return ref;
    }
}
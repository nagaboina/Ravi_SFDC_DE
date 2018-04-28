({
	create : function(component, event, helper) {
		//getting the AfterCallDetail information
        var Afterhourcall = component.get("v.Afterhourcall");
        
        //Validation
        if($A.util.isEmpty(Afterhourcall.Name) || $A.util.isUndefined(Afterhourcall.Name)){
            alert('Name is Required');
            return;
        }
        
        //Calling the Apex Function
        var action = component.get("c.createRecord");
        
        //Setting the Apex Parameter
        action.setParams({
            Afterhourcall : Afterhourcall
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
                var newAfterhourcall = {'sobjectType': 'Afterhourcall__c',
                                    'Name': '',
									'CommunicationMethod__c': '',
									'Call_Start_Date__c': '', 
									'Call_End_Date__c': '',
									'Reason__c': '',
									'Comments__c': '',
									'AccountId__c':Afterhourcall.AccountId__c,
                                    'Account_Store__c':Afterhourcall.Account_Store__c
                                };
                //resetting the Values in the form
                component.set("v.Afterhourcall",newAfterhourcall);
               // alert('Record is Created Successfully');
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
		//adds the server-side action to the queue        
        $A.enqueueAction(action);

	},
	doInit : function(component, event, helper) {
        
        //getting Account Name
      	var action1 = component.get("c.getContactName");
        action1.setParams({
            recordId : component.get("v.recordId")
        });
        action1.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var res = a.getReturnValue();
                if(res != null){
                    component.set("v.Afterhourcall.AccountId__c",res.split('##:##')[1]);
                    component.set("v.Afterhourcall.Account_Store__c",res.split('##:##')[0]);
                }
            }
        });
        $A.enqueueAction(action1);
        
        var acn = component.get('c.initClass');
        acn.setParams({
            recordId : component.get("v.recordId")
        });
        acn.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ClassObj', response.getReturnValue());
            }
   		});
      $A.enqueueAction(acn);
        
    }
})
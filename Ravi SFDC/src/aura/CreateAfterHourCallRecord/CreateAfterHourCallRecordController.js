({
	create : function(component, event, helper) {
		console.log('Create record');
        
        //getting the candidate information
        var candidate = component.get("v.candidate");
        
        //Validation
        if($A.util.isEmpty(candidate.FirstName) || $A.util.isUndefined(candidate.FirstName)){
            alert('First Name is Required');
            return;
        }            
        if($A.util.isEmpty(candidate.LastName) || $A.util.isUndefined(candidate.LastName)){
            alert('Last Name is Rqquired');
            return;
        }
        if($A.util.isEmpty(candidate.Email) || $A.util.isUndefined(candidate.Email)){
            alert('Email is Required');
            return;
        }
        
        //Calling the Apex Function
        var action = component.get("c.createRecord");
        
        //Setting the Apex Parameter
        action.setParams({
            candidate : candidate
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
                var newCandidate = {'sobjectType': 'Contact',
                                    'FirstName': '',
                                    'LastName': '',
                                    'Email': '', 
                                    'MobilePhone': '',
                                    'Level__c':'',
                                    'AccountId':'',
                                    'Languages__c':''
                                   };
                //resetting the Values in the form
                component.set("v.candidate",newCandidate);
                alert('Record is Created Successfully');
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
		//adds the server-side action to the queue        
        $A.enqueueAction(action);

	},
    doInit : function(component, event, helper) {
        /*var action = component.get("c.getLevelValues");
        var inputsel = component.find("InputSelectDynamic");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
    
        });
        $A.enqueueAction(action);*/
        
        //getting Account Name for Contact
        var action1 = component.get("c.getContactAccountName");
        console.log(component.get("v.recordId"));
        action1.setParams({
            recordId : component.get("v.recordId")
        });
        action1.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state '+state);
            if(state == "SUCCESS"){
                var res = a.getReturnValue();
                if(res != null){
                    component.set("v.candidate.AccountId",res.split('##:##')[1]);
                    component.set("v.candidate.Languages__c",res.split('##:##')[0]);
                }
            }
        });
        $A.enqueueAction(action1);
        
        var acn = component.get('c.initClass');
        acn.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.ClassObj', response.getReturnValue());
            }
   		});
      $A.enqueueAction(acn);
        
    }
})
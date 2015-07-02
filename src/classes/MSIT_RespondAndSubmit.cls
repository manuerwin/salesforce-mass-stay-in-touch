//  Type:       Controller Extension
//  Purpose:    Provide functionality for VF Page Mass Stay In Touch - External user responds and submits
//  Copyright (C) 2015  Manu Erwin

//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

//  Used By:    MSIT_RespondAndSubmit.page
//  History:    see https://github.com/manuerwin/salesforce-mass-stay-in-touch

public with sharing class MSIT_RespondAndSubmit {
    /* CONSTANTS */
    public static final String CONFIRMED = 'Confirmed';
    public static final String CHANGE = 'Change';

    /* CONSTRUCTOR */
    public MSIT_RespondAndSubmit() {
        pageParameters = ApexPages.currentPage().getParameters();
        errorExists = false;
    }

    /* PUBLIC VARIABLES AND METHODS */
    public Contact contact {
		get {
			if (contact == null) {
                contact = new Contact();
                if (!errorExists && contactId != null) {
				    contact = [SELECT Id, LastName, Last_MSIT_Response_Datetime__c, Last_MSIT_Request_Result__c FROM Contact WHERE Id = :contactId];
                }
			}
			return contact;
		}
		set;
	}
	public Boolean errorExists {
        get;
        set;
    }
    public String status {
	   	get {
    		if (status == null) {
    			status = pageParameters.get('status');
    		}
    		return status;
    	}
    	set;
    }
    public void processConfirmation() {
		if (status == CONFIRMED) {
        	contact.Last_MSIT_Response_Datetime__c = System.now();
        	contact.Last_MSIT_Request_Result__c = CONFIRMED;
            updateContact();

        }
    }
    public void processChange() {
        contact.Last_MSIT_Response_Datetime__c = System.now();
        contact.Last_MSIT_Request_Result__c = CHANGE;
        updateContact();
    }

    /* PRIVATE VARIABLES AND METHODS */
    private Id contactId {
        get {
            if (contactId == null) {
                contactId = stayInTouchRequest.Contact__c;
            }
            return contactId;
        }
        set;
    }
    private Map<String, String> pageParameters {
        get {
            if (pageParameters == null) {
                pageParameters = new Map<String, String>();
            }
            return pageParameters;
        }
        set;
    }
    private String refParameter {
        get {
            if (refParameter == null) {
                refParameter = pageParameters.get('ref');
            }
            return refParameter;
        }
        private set;
    }
    private Id stayInTouchId {
        get {
            if (stayInTouchId == null && refParameter != null) {
                try {
                    stayInTouchId = Id.valueOf(refParameter);
                } catch (Exception ex) {
                    errorExists = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something is wrong with the link, please try again!'));
                }
            }
            return stayInTouchId;
        }
        set;
    }
    private Stay_In_Touch_Request__c stayInTouchRequest {
        get {
            if (stayInTouchRequest == null) {
                stayInTouchRequest = new Stay_In_Touch_Request__c();
                if (!errorExists && stayInTouchId != null) {
                    stayInTouchRequest = [SELECT Id, Contact__c FROM Stay_In_Touch_Request__c WHERE Id = :stayInTouchId];
                }
            }
            return stayInTouchRequest;
        }
        set;
    }
    private void updateContact(){
    	try {
    		update contact;
    	} catch (Exception ex) {
    		errorExists = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
    	}
    }
}
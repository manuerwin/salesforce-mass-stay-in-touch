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
    public MSIT_RespondAndSubmit(){
        // Put all the URL parameters into a collection to access later
        pageParameters = ApexPages.currentPage().getParameters();
        this.theContact = getContact();
    }

    /* PUBLIC VARIABLES AND METHODS */
    public Contact theContact { get; set; }
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Contact.FieldSets.msit__Mass_Stay_In_Touch.getFields();
    }
    public String status {
        // URL parameter that indicates the contacts response to either confirm all correct, or changes need to be made
        get {
            if (status == null) {
                status = pageParameters.get('status');
            }
            return status;
        }
        set;
    }
    public void processResponse() {
        // Stamp the SIT with contact response - WF will update the contact
        System.debug('## DEBUG: about to update SIT Contact Response with status ' + status);
        stayInTouchRequest.Contact_Response__c = status;
        updateStayInTouchRequest();
    }
    public void processChange() {
        // Update the Contact record with the updated field values
        updateContact();
    }

    /* PRIVATE VARIABLES AND METHODS */
    private Contact getContact() {
        String query = 'SELECT Id, ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Name FROM Contact WHERE Id = :contactId';
        return Database.query(query);
    }
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
        // String representation of the Stay In Touch Id passed to the VF page in the URL
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
                if (stayInTouchId != null) {
                    stayInTouchRequest = [SELECT Id, Contact__c, Contact_Response__c FROM Stay_In_Touch_Request__c WHERE Id = :stayInTouchId];
                }
            }
            return stayInTouchRequest;
        }
        set;
    }
    private void updateStayInTouchRequest(){
        try {
            System.debug('## DEBUG: stayInTouchRequest: ' + stayInTouchRequest);
            update stayInTouchRequest;
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
        }
    }
    private void updateContact(){
        try {
            System.debug('## DEBUG: contact: ' + theContact);
            update theContact;
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
        }
    }
}
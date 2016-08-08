//  Type:       Controller Extension
//  Purpose:    Provide functionality for VF Page Mass Stay In Touch - External user responds and submits
//  Copyright (C) 2016  Manu Erwin

//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

//  Used By:    MSIT_RespondAndSubmit.page
//  History:    see https://github.com/manuerwin/salesforce-mass-stay-in-touch

public without sharing class MSIT_RespondAndSubmit {
    // without sharing is used so the Force.com Site Guest User can see and update all Contact records
    /* CONSTANTS */
    public static final String CONFIRMED = 'Confirmed';
    public static final String CHANGE = 'Change';

    /* CONSTRUCTOR */
    public MSIT_RespondAndSubmit(){
        // Put all the URL parameters into a collection to access later
        pageParameters = ApexPages.currentPage().getParameters();
        getContact();
    }

    /* PUBLIC VARIABLES AND METHODS */
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
    public PageReference processResponse() {
        // Stamp the SIT with contact response - WF will update the contact
        System.debug('## DEBUG: about to update SIT Contact Response with status ' + status);
        stayInTouchRequest.Contact_Response__c = status;
        updateStayInTouchRequest();
        return null;
    }
    public PageReference processChange() {
        // Update the Contact record with the updated field values
        updateContact();
        status = 'Success';
        return null;
    }
    public String contactOwnerName {
        get {
            if (contactOwnerName == null) {
                contactOwnerName = theContact.Owner.FirstName +' '+ theContact.Owner.LastName;
            }
            return contactOwnerName;
        }
        set;
    }
    public String contactOwnerEmail {
        get {
            if (contactOwnerEmail == null) {
                contactOwnerEmail = theContact.Owner.Email;
            }
            return contactOwnerEmail;
        }
        set;
    }
    public String salutation {
        get {
            if (salutation == null) {
                salutation = theContact.Salutation;
            }
            return salutation;
        }
        set;
    }
    public String firstName {
        get {
            if (firstName == null) {
                firstName = theContact.FirstName;
            }
            return firstName;
        }
        set;
    }
    public String lastName {
        get {
            if (lastName == null) {
                lastName = theContact.LastName;
            }
            return lastName;
        }
        set;
    }
    public String email {
        get {
            if (email == null) {
                email = theContact.Email;
            }
            return email;
        }
        set;
    }
    public String company {
        get {
            if (company == null) {
                company = theContact.Account.Name;
            }
            return company;
        }
        set;
    }
    public String title {
        get {
            if (title == null) {
                title = theContact.Title;
            }
            return title;
        }
        set;
    }
    public String department {
        get {
            if (department == null) {
                department = theContact.Department;
            }
            return department;
        }
        set;
    }
    public String phone {
        get {
            if (phone == null) {
                phone = theContact.Phone;
            }
            return phone;
        }
        set;
    }
    public String mobilePhone {
        get {
            if (mobilePhone == null) {
                mobilePhone = theContact.MobilePhone;
            }
            return mobilePhone;
        }
        set;
    }
    public String homePhone {
        get {
            if (homePhone == null) {
                homePhone = theContact.HomePhone;
            }
            return homePhone;
        }
        set;
    }
    public String fax {
        get {
            if (fax == null) {
                fax = theContact.Fax;
            }
            return fax;
        }
        set;
    }
    public String assistantName {
        get {
            if (assistantName == null) {
                assistantName = theContact.AssistantName;
            }
            return assistantName;
        }
        set;
    }
    public String assistantPhone {
        get {
            if (assistantPhone == null) {
                assistantPhone = theContact.AssistantPhone;
            }
            return assistantPhone;
        }
        set;
    }
    public String mailingStreet {
        get {
            if (mailingStreet == null) {
                mailingStreet = theContact.MailingStreet;
            }
            return mailingStreet;
        }
        set;
    }
    public String mailingCity {
        get {
            if (mailingCity == null) {
                mailingCity = theContact.MailingCity;
            }
            return mailingCity;
        }
        set;
    }
    public String mailingState {
        get {
            if (mailingState == null) {
                mailingState = theContact.MailingState;
            }
            return mailingState;
        }
        set;
    }
    public String mailingPostalCode {
        get {
            if (mailingPostalCode == null) {
                mailingPostalCode = theContact.MailingPostalCode;
            }
            return mailingPostalCode;
        }
        set;
    }
    public String mailingCountry {
        get {
            if (mailingCountry == null) {
                mailingCountry = theContact.MailingCountry;
            }
            return mailingCountry;
        }
        set;
    }
    public String messageToOwner {
        get {
            if (messageToOwner == null) {
                messageToOwner = theContact.Last_MSIT_Message__c;
            }
            return messageToOwner;
        }
        set;
    }

    /* PRIVATE VARIABLES AND METHODS */
    private Contact theContact { get; set; }
    private void getContact() {
        // To add custom fields, add a comma after Last_MSIT_Message__c and then the API name of the custom field e.g. Last_MSIT_Message__c, MyCustomField__c
        if (contactId != null) {
            theContact = [SELECT Id, Name, Salutation, FirstName, LastName, Email, Owner.FirstName, Owner.LastName, Owner.Email,
            Account.Name, Title, Department, Phone, MobilePhone, HomePhone, Fax, AssistantName, AssistantPhone,
            MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Last_MSIT_Message__c
            FROM Contact WHERE Id = :contactId];
        }
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
    private void updateStayInTouchRequest() {
        try {
            System.debug('## DEBUG: stayInTouchRequest: ' + stayInTouchRequest);
            update stayInTouchRequest;
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
        }
    }
    private void updateContact() {
        // To add custom fields, add a new line after Last_MSIT_Message__c with the custom field e.g. MyCustomField__c
        try {
            theContact.Salutation = salutation;
            theContact.FirstName = firstName;
            theContact.LastName = lastName;
            theContact.Email = email;
            theContact.Account.Name = company;
            theContact.Title = title;
            theContact.Department = department;
            theContact.Phone = phone;
            theContact.MobilePhone = mobilePhone;
            theContact.HomePhone = homePhone;
            theContact.Fax = fax;
            theContact.AssistantName = assistantName;
            theContact.AssistantPhone = assistantPhone;
            theContact.MailingStreet = mailingStreet;
            theContact.MailingCity = mailingCity;
            theContact.MailingState = mailingState;
            theContact.MailingPostalCode = mailingPostalCode;
            theContact.MailingCountry = mailingCountry;
            theContact.Last_MSIT_Message__c = messageToOwner;

            System.debug('## DEBUG: contact: ' + theContact);
            update theContact;
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
        }
    }
}
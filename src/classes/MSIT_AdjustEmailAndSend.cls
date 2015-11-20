//  Type:       Controller Extension
//  Purpose:    Provide functionality for VF Page Mass Stay In Touch Requests
//  Copyright (C) 2014  Manu Erwin

//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or  (at your option) any later version.

//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

//  Used By:    MSIT_AdjustEmailAndSend.page
//  History:    see https://github.com/manuerwin/salesforce-mass-stay-in-touch

public with sharing class MSIT_AdjustEmailAndSend {

    /* CONSTANTS */

    /* CONSTRUCTOR */
    public MSIT_AdjustEmailAndSend(ApexPages.StandardSetController standardSetController) {
        System.debug(System.LoggingLevel.DEBUG, '##DEBUG: standardSetController.getSelected(): ' + standardSetController.getSelected());
        selectedContacts = (List<Contact>) standardSetController.getSelected();

        // Set booleans as default false
        dailyLimitExceeded = false;

        // ASSUMPTION: Only one entry for this List Custom Setting has been created
        Mass_Stay_In_Touch_Settings__c msitSettings = Mass_Stay_In_Touch_Settings__c.getAll().values();
        emailTemplateId = msitSettings.Email_Template_Id__c;
    }

    /* PUBLIC VARIABLES AND METHODS*/
    public Boolean dailyLimitExceeded {get; set;}
    public Boolean emailSendAttempted {get; set;}
    public Id emailTemplateId {get; set;}
    public Stay_In_Touch_Request__c proxySIT {
        get {
            if (proxySIT == null){
                proxySIT = new Stay_In_Touch_Request__c();
            }
            return proxySIT;
        }
        set;
    }
    public Integer numberOfTargetedContacts {
        get {
            return targetedContactIdToContact.values().size();
        }
        set;
    }
    public Boolean storeActivity {get; set;}

    public PageReference createSITs() {
        emailSendAttempted = true;

        // Loop through selected Contacts and create Stay In Touch records for each one. Workflow will then send the stay in touch request email.
        List<Stay_In_Touch_Request__c> SITs = new List<Stay_In_Touch_Request__c>();
        for (Contact con : selectedContacts) {
            Stay_In_Touch_Request__c SIT = new Stay_In_Touch_Request__c();
            SIT.Contact__c = con.Id;
            SIT.Subject__c = proxySIT.Subject__c;
            SIT.Signature__c = proxySIT.Signature__c;
            SITs.add(SIT);
        }

        if (!SITs.isEmpty()) {
            System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: Proceed as SITs should be created');
            try {
                System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: insert SITs');
                insert SITs;
            } catch (Exception ex) {
                System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: exception');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
            }
        }

        return null;
    }

    /* PRIVATE VARIABLES AND METHODS */
    private ApexPages.StandardSetController standardController;
    private List<Contact> selectedContacts { get; set; }
    private Map<Id, Contact> targetedContactIdToContact {
        get {
            if (targetedContactIdToContact == null) {
                targetedContactIdToContact = new Map<Id, Contact>([SELECT Id, Email, HasOptedOutOfEmail
                                    FROM Contact
                                    WHERE Id IN :selectedContacts
                                    AND HasOptedOutOfEmail = false
                                    AND Email != null]);
            }
            return targetedContactIdToContact;
        }
        set;
    }
}
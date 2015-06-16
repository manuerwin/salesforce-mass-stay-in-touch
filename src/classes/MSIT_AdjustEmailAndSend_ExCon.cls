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

public with sharing class MSIT_AdjustEmailAndSend_ExCon {

    /* CONSTANTS */

    /* CONSTRUCTOR */
    public MSIT_AdjustEmailAndSend_ExCon(ApexPages.StandardSetController standardSetController) {
        System.debug(System.LoggingLevel.DEBUG, '##DEBUG: standardSetController.getSelected(): ' + standardSetController.getSelected());
        selectedContacts = (List<Contact>) standardSetController.getSelected();

        // Set booleans as default false
        bccMe = false;
        storeActivity = false;
        dailyLimitExceeded = false;

        // ASSUMPTION: Only one entry for this List Custom Setting has been created
        Mass_Stay_In_Touch_Settings__c msitSettings = Mass_Stay_In_Touch_Settings__c.getAll().values();
        storeActivity = msitSettings.Create_Activity_Record__c;

/*
        // Attempt to reserve email capacity. By-product of failure will alert user.
        try {
            Messaging.reserveMassEmailCapacity(numberOfTargetedContacts);
        } catch (HandledException handledEx) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, the daily email limit for the org would be exceeded by this request. Try a smaller number of Contacts.'));
            dailyLimitExceeded = true;
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry, something broke: ' + ex.getTypeName() + ' : ' + ex.getMessage()));
        }
*/
    }

    /* PUBLIC VARIABLES AND METHODS*/
    public Boolean bccMe {get; set;}
    public Boolean dailyLimitExceeded {get; set;}
    public Id emailTemplateId {get; set;}
    public Integer numberOfTargetedContacts {
        get {
            return targetedContactIdToContact.values().size();
        }
        set;
    }
    public Boolean emailSendAttempted {get; set;}
    public Boolean storeActivity {get; set;}

    public PageReference createSITs() {
        emailSendAttempted = true;

        // Loop through selected Contacts
        // Create a Stay In Touch

        List<Messaging.Email> emails = new List<Messaging.Email>();
        Messaging.MassEmailMessage massEmailMessage = new Messaging.MassEmailMessage();

        massEmailMessage.Description = 'Staying in Touch';
        massEmailMessage.setTemplateID(emailTemplateId);
        massEmailMessage.setSaveAsActivity(storeActivity);
        massEmailMessage.setReplyTo(UserInfo.getUserEmail());
        massEmailMessage.setSenderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName());
        massEmailMessage.setUseSignature(false);
        List<Id> contactIds = new List<Id>(targetedContactIdToContact.keySet());
        massEmailMessage.setTargetObjectIds(contactIds);
        massEmailMessage.setBccSender(bccMe);
        emails.add(massEmailMessage);

        System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: Number of contactIds: ' + contactIds.size() );
        System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: contactIds: ' + contactIds );
        if (contactIds.size() > 0) {
            System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: Number of contactIds > 0. Proceed');
            try {
                List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emails, false);
                for(Messaging.SendEmailResult sendResult : sendEmailResults) {
                    if(sendResult.isSuccess()) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Emails sent successfully! '));
                    } else if (!sendResult.isSuccess()) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error message: ' + sendResult.getErrors()[0].getMessage()));
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Status Code: ' + sendResult.getErrors()[0].getStatusCode()));
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error fields: ' + sendResult.getErrors()[0].getFields()));
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error record ids: ' + sendResult.getErrors()[0].getTargetObjectId()));
                    }
                }
            } catch (Exception ex) {
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
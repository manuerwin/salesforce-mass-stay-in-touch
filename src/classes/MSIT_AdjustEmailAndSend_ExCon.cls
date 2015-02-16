//	Type:		Controller Extension
//	Purpose:	Provide functionality for VF Page Mass Stay In Touch Requests
//  Copyright (C) 2014  Manu Erwin

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

//	Used By:	MSIT_AdjustEmailAndSend.page

//	History:	17-Apr-2014	Manu Erwin	Created

public with sharing class MSIT_AdjustEmailAndSend_ExCon {

	/* CONSTANTS */

    /* CONSTRUCTOR */
    public MSIT_AdjustEmailAndSend_ExCon(ApexPages.StandardSetController standardController) {
    	System.debug(System.LoggingLevel.DEBUG, '##DEBUG: standardController.getSelected(): ' + standardController.getSelected());
    	selectedContacts = (List<Contact>) standardController.getSelected();
		// TODO: get the email Template Id from a Custom Setting
		//EmailTemplate template = [select Id, Name, Subject,body, HtmlValue FROM EmailTemplate WHERE Name LIKE :templateName+'%'];
		emailTemplateId = '00Xi0000001Elo8';
	}

	/* PUBLIC VARIABLES AND METHODS*/
	public Boolean bccMe {get; set;}
	public Boolean storeActivity {get; set;}
	public Integer numberOfTargetedContacts {
		get {
			return targetedContactIdToContact.values().size();
		}
		set;
	}
	public String emailTemplateId {get; set;}
	public PageReference sendEmail() {

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

		System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: Number of emails: '  + emails.size() );
		if (emails.size() > 0) {
			System.Debug(System.LoggingLevel.DEBUG, '##DEBUG: Number of emails > 0. Proceed');
			try {
				List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emails, false);
				for(Messaging.Sendemailresult sendResult : sendEmailResults) {
					if(!sendResult.isSuccess()) {
						// TODO: add all errors to list and pageMessages for user
						System.Debug(System.LoggingLevel.DEBUG, 'Messaging failed ' + sendResult.getErrors()[0].getMessage());
					}
				}
			} catch (Exception ex) {
				// TODO: catch and display error to user as pageMessage
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
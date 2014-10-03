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
	}

	/* PUBLIC VARIABLES AND METHODS*/
	public Boolean bccMe {get; set;}
	public Boolean storeActivity {get; set;}
	public String emailBody {get; set;}
	public String emailSubject {get; set;}
	public String emailSignature {get; set;}
	public Integer numberOfTargetedContacts {
		get {
			return targetedContactIdToContact.values().size();
		}
		set;
	}
	public PageReference sendEmail() {
		// Build up the core email attributes
		Messaging.MassEmailMessage massEmailMessage;
		// Set the email from details
		massEmailMessage.setReplyTo(UserInfo.getUserEmail());
		massEmailMessage.setSenderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName());
		// Set the email subject
		massEmailMessage.setSubject(emailSubject);
		// Use the entered signature rather than the users standard signature
		massEmailMessage.setUseSignature(false);
		// Set the Contacts receiving the email
		List<Id> contactIds = new List<Id>(targetedContactIdToContact.keySet());
		massEmailMessage.setTargetObjectIds(contactIds);
		// Set the template for this email
		massEmailMessage.setTemplateID('123456789012345678');
		// Set whether an activity is created
		massEmailMessage.setSaveAsActivity(storeActivity);
		// BCC the user on the first email
		massEmailMessage.setBccSender(bccMe);

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
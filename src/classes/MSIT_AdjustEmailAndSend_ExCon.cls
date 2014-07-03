//	Type:		Controller Extension
//	Purpose:	Provide functionality for VF Page Mass Stay In Touch Requests
//				
//	Used By:	MSIT_AdjustEmailAndSend.page
//	History:	17-Apr-2014	Manu Erwin (Salesforce.com)		Created

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
		User currentUser = [SELECT Email FROM User WHERE Username = :UserInfo.getUserName() LIMIT 1];
		massEmailMessage.setReplyTo(currentUser.Email);
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
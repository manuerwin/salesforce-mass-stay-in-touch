public with sharing class MSIT_AdjustEmailAndSend_ExCon {

	/* CONSTANTS */

	/* PUBLIC VARIABLES */
	private Boolean bccMe {get; set;}
	private Boolean storeActivity {get; set;}
	private String emailBody {get; set;}
	private String emailSubject {get; set;}
	private String emailSignature {get; set;}
	private Integer numberOfSelectedContacts {
		get {
			return selectedContacts.size();
		}
		set;
	}
	private Integer numberOfTargetedContacts {
		get {
			return targetedContacts.size();
		}
		set;
	}
	private Set<Id> targetedIds { get; set; }

	/* PRIVATE VARIABLES */
	private ApexPages.StandardSetController standardController;
	private List<Contact> selectedContacts { get; set; }
	private List<Contact> targetedContacts { get; set; }

    /* CONSTRUCTOR */
    public MSIT_AdjustEmailAndSend_ExCon(ApexPages.StandardSetController standardController) {
    	this.standardController = standardController;
    	Set<Id> selectedContactIds = new Set<Id>();
    	for (Contact selectedContact :(List<Contact>) standardController.getSelected()) {
    		selectedContactIds.add(selectedContact.Id);
		}
		for (Contact targetedContact : [SELECT Id, EmailAddress, HasOptedOutOfEmail FROM Contact WHERE Id IN :selectedContactIds]) {
			if (!targetedContact.HasOptedOutOfEmail) {
				System.debug(System.LoggingLevel.DEBUG, '##DEBUG: Contact has NOT OptedOutOfEmail - add to list');
				targetedContacts.add(targetedContact);
			}
		}
	}
}
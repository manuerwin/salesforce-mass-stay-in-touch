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
		return null;
	}

	/* PRIVATE VARIABLES AND METHODS */
	private ApexPages.StandardSetController standardController;
	private List<Contact> selectedContacts { get; set; }
	private Map<Id, Contact> targetedContactIdToContact {
		get {
			if (targetedContactIdToContact == null) {
				targetedContactIdToContact = new Map<Id, Contact>([SELECT Id, Email, HasOptedOutOfEmail
									FROM Contact WHERE Id IN :selectedContacts AND HasOptedOutOfEmail = false]);
			}
			return targetedContactIdToContact;
		}
		set;
	}
}
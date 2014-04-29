public with sharing class MSIT_AdjustEmailAndSend_ExCon {

	/* CONSTANTS */

	/* PUBLIC VARIABLES */
	public Boolean bccMe {get; set;}
	public Boolean storeActivity {get; set;}
	public String emailBody {get; set;}
	public String emailSubject {get; set;}
	public String emailSignature {get; set;}
	public Integer numberOfSelectedContacts {
		get {
			return selectedContacts.size();
		}
		set;
	}

	/* PRIVATE VARIABLES */
	private ApexPages.StandardSetController standardController;
	private List<Contact> selectedContacts {get; set;}

    /* CONSTRUCTOR */
    public MSIT_AdjustEmailAndSend_ExCon(ApexPages.StandardSetController standardController) {
    	this.standardController = standardController;
    	this.selectedContacts = (List<Contact>) standardController.getSelected();
    }
}
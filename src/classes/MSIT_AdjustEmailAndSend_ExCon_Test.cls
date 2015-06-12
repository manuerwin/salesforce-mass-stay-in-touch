@isTest
private class MSIT_AdjustEmailAndSend_ExCon_Test {

	@testSetup static void setupCommonData() {
		Account acc = new Account(Name = 'MSIT Test');
		insert acc;

		List<Contact> defaultContacts = new List<Contact>();
		for (Integer i=0; i<20; i++) {
			Contact con = new Contact();
			con.AccountId = acc.Id;
			con.FirstName = 'MSIT Test';
			con.LastName = 'MSIT Test-' + i;
			con.Email = 'msit_test_' + i + '@msit_test.com';
			defaultContacts.add(con);
		}
		insert defaultContacts;
	}

	// Story: User sends email
	// In order to send mass stay in touch requests
	// As an internal user
	// I want to select contacts who will receive emails

	@isTest static void emailShouldBeSentWhenContactSelected() {
		List<Contact> selectedContacts = [SELECT Id FROM Contact];
		ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(selectedContacts);
PageReference testPage = Page.MSIT_AdjustEmailAndSend;
Test.setCurrentPage(testPage);

		// Given the number of selected Contacts is greater than zero
		setCon.setSelected(selectedContacts);

		// When the Send button is clicked
		msit.MSIT_AdjustEmailAndSend_ExCon conExt = new msit.MSIT_AdjustEmailAndSend_ExCon(setCon);
		Test.startTest();
			PageReference pageRef = conExt.SendEmail();
		Test.stopTest();

		// Then the email should be sent
// assert no errors
//System.assert(conExt);
// assert number of email invocations is one
// assert returned page ref (aka navigation behaviour)
	}
	@isTest static void emailShouldNotBeSentWhenNoContactSelected() {
		// Given the number of selected Contacts is zero
List<Contact> deleteContacts = [SELECT Id FROM Contact];
delete deleteContacts;
ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deleteContacts);
		// When the Send button is clicked
msit.MSIT_AdjustEmailAndSend_ExCon conExt = new msit.MSIT_AdjustEmailAndSend_ExCon(setCon);
		Test.startTest();
			PageReference pageRef = conExt.SendEmail();
		Test.stopTest();
		// Then the email should not be sent
// assert number of email invocations is zero
// assert returned page ref (aka navigation behaviour)
	}
	@isTest static void sendEmailButtonShouldWorkWhenContactsSelected() {
List<Contact> selectedContacts = [SELECT Id FROM Contact];
		ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(selectedContacts);
		// Given there were Contacts selected
setCon.setSelected(selectedContacts);

		// When the page loads
		msit.MSIT_AdjustEmailAndSend_ExCon conExt = new msit.MSIT_AdjustEmailAndSend_ExCon(setCon);
		Test.startTest();
			PageReference pageRef = conExt.SendEmail();
		Test.stopTest();

		// Then the "Send email to all contacts" button should be clickable
	}
	@isTest static void sendEmailButtonShouldNotWorkWhenContactsNotSelected() {
		// Given there were no Contacts selected
		// When the page loads
		// Then the "Send email to all contacts" button should not be clickable
	}

	// Story: User sees sent email
	// In order to verify the content of the mass stay in touch email
	// As an internal user
	// I want to be blind carbon copied on one of the emails

	@isTest static void userShouldBeBCCdOnAnEmail() {
		// Given the "BCC me on one message" checkbox is selected
		// When the Send button is clicked
		// Then the user should be BCC'd on one of the emails
	}
	@isTest static void userShouldNotBeBCCdOnAnEmail() {
		// Given the "BCC me on one message" checkbox is NOT selected
		// When the Send button is clicked
		// Then the user should not be BCC'd on one of the emails
	}

	// Story: Emails saved as activities
	// In order to see that emails were sent to contacts
	// As an internal user
	// I want emails to be saved as activities

	@isTest static void activityShouldBeCreated() {
		// Given the "Store an activity for each message" checkbox is selected
		// When the Send button is clicked
		// Then an activity should be created for each email
	}
	@isTest static void activityShouldNotBeCreated() {
		// Given the "Store an activity for each message" checkbox is NOT selected
		// When the Send button is clicked
		// Then an activity should NOT be created for each email
	}

	// Story: Seeing how many contacts will be sent to
	// In order to confirm the number of contacts the stay in touch email will be sent to
	// As an internal user
	// I want to see the number of contacts displayed

	@isTest static void numberOfContactsShouldBeShown() {
		// Given there are Contacts selected
		// When the VF page is loaded
		// Then the number of Contacts to be sent the email should be shown to the user
	}
	@isTest static void emailOptOutContactsShouldBeExcluded() {
		// Given email out out contacts have been selected
		// When the VF page is loaded
		// Then those contacts should be excluded
	}
	@isTest static void contactsWithoutEmailShouldBeExcluded() {
		// Given Contacts without emails have been selected
		// When the VF page is loaded
		// Then those contacts should be excluded
	}

	// Story: Email template is used for emails
	// In order to send mass stay in touch emails
	// As an internal user
	// I want the email template to be used

	@isTest static void emailTemplateShouldBeUsed() {
		// Given the email template exists
		// When the email is sent
		// Then the email template should be used
	}
	@isTest static void emailTemplateShouldNotBeUsed() {
		// Given the email template does not exist
		// When the email is sent
		// Then the user should be shown an error message
	}

	// Story: Understanding fields for contact update
	// In order to know what fields the Contact will be able to update
	// As an internal user
	// I want to see them on the page

	@isTest static void noErrorShouldShowWhenFieldSetConfigured() {
		// Given the Field Set for MSIT has at least one field configured
		// When the page loads
		// Then the user should see no page errors
	}
	@isTest static void errorShouldShowWhenFieldSetNotConfigured() {
		// Given the Field Set for MSIT has not been configured
		// When the page loads
		// Then the user should see an error message
	}
}
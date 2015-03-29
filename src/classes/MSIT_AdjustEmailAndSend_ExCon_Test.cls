@isTest
private class MSIT_AdjustEmailAndSend_ExCon_Test {

	// Story: User sees sent email
	// In order to verify the content of the mass stay in touch email
	// As an internal user
	// I want to be blind carbon copied on one of the emails

	@isTest	static void userShouldBeBCCdOnAnEmail() {
		// Given the "BCC me on one message" checkbox is selected
		// When the Send button is clicked
		// Then the user should be BCC'd on one of the emails
	}

	@isTest	static void userShouldNotBeBCCdOnAnEmail() {
		// Given the "BCC me on one message" checkbox is NOT selected
		// When the Send button is clicked
		// Then the user should not be BCC'd on one of the emails
	}

	// Story: Emails saved as activities
	// In order to see that emails were sent to contacts
	// As an internal user
	// I want emails to be saved as activities

	@isTest	static void activityShouldBeCreated() {
		// Given the "Store an activity for each message" checkbox is selected
		// When the Send button is clicked
		// Then an activity should be created for each email
	}

	@isTest	static void activityShouldNotBeCreated() {
		// Given the "Store an activity for each message" checkbox is NOT selected
		// When the Send button is clicked
		// Then an activity should NOT be created for each email
	}

	// Story: Seeing how many contacts will be sent to
	// In order to confirm the number of contacts the stay in touch email will be sent to
	// As an internal user
	// I want to see the number of contacts displayed

	@isTest	static void numberOfUsersShouldBeShown() {
		// Given 
		// When the VF page is loaded
		// Then the user should be shown to the user
	}

	// Story: 
	// In order to
	// As a 
	// I want to

	@isTest	static void itShould() {
		// Given
		// When
		// Then
	}

}
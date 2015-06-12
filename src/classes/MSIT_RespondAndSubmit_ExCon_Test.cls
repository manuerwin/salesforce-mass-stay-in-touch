@isTest
private class MSIT_RespondAndSubmit_ExCon_Test {

    // Story: Confirming no change to details
    // In order to confirm my details are correct
    // As a Contact
    // I want to see a page thanking me for confirmation

    @isTest static void pageShouldShowThankYouNoChangeMessage() {
        // Given "no change" was indicated
        // And the Contact Id was provided
        // When the page loads
        // Then a "thank you" page message should show
    }
    @isTest static void pageShouldNotShowThankYouNoChangeMessage() {
        // Given "no change" was indicated
        // And no Contact Id was provided
        // When the page loads
        // Then a warning page message should show
        // And the "thank you" page message should not show
    }
    @isTest static void pageShouldShowWarningMessage() {
        // Given nothing was indicated
        // When the page loads
        // Then a warning page message should show
        // And the "thank you" page message should not show
    }
}
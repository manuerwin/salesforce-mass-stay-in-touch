@isTest
private class MSIT_RespondAndSubmit_Test {

    // Story: Confirming no change to details
    // In order to confirm my details are correct
    // As a Contact
    // I want to see a message thanking me for confirmation

    @isTest static void pageShouldShowThankYouNoChangeMessage() {
        // Given "no change" was indicated
        // When the page loads
        // Then a "thank you" message should show
    }
    @isTest static void contactMsitRequestResultShouldBeUpdatedToNoChange() {
        // Given "no change" was indicated
        // When the page loads
        // Then the Last MSIT Request Result field should be 'No Change'
        // And the Last MSIT Response Datetime should be the current date time
    }

    // Story: Making changes to details
    // In order to change my details
    // As a Contact
    // I want to make changes and be thanked

    @isTest static void changesShouldHaveBeenSavedToContact() {
        // Given changes were made
        // When the page reloads after submit
        // Then the changes should be reflected on the Contact record
    }
    @isTest static void pageShouldShowThankYouForChangeMessage() {
        // Given changes were made
        // When the page reloads after submit
        // Then a "thank you" message should show
    }

    // Story: Error handling
    // Should the SITR record not exist (e.g. hacking attempt or deleted)
    // As a Contact
    // I want to see a warning message

    @isTest static void pageShouldShowWarningMessage() {
        // Given information is missing from the URL
        // When the page loads
        // Then a warning message should show
    }
}
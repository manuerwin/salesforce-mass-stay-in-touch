@isTest
private class MSIT_RespondAndSubmit_Test {

    @testSetup static void setupCommonData() {
        Account defaultAcc = new Account(Name = 'MSIT Test');
        insert defaultAcc;

        List<Contact> defaultContacts = new List<Contact>();
        for (Integer i=0; i<10; i++) {
            Contact con = new Contact();
            con.AccountId = defaultAcc.Id;
            con.FirstName = 'MSIT Test';
            con.LastName = 'MSIT Test-' + i;
            con.Email = 'msitTest' + i + '@msitTest.com';
            defaultContacts.add(con);
        }
        insert defaultContacts;

        // Create Stay In Touch Request records for each Contact
        List<Stay_In_Touch_Request__c> defaultStayInTouchRequests = new List<Stay_In_Touch_Request__c>();
        for (Contact contact : defaultContacts) {
            Stay_In_Touch_Request__c stayInTouchRequest = new Stay_In_Touch_Request__c();
            stayInTouchRequest.Contact__c = contact.Id;
            stayInTouchRequest.Subject__c = 'MSIT Test';
            stayInTouchRequest.Signature__c = 'thanks a bunch, talk soon!!';
            defaultStayInTouchRequests.add(stayInTouchRequest);
        }
        insert defaultStayInTouchRequests;
    }

    // Story: Confirming details are correct
    // In order to confirm my details are correct
    // As a Contact
    // I want to see a message thanking me for confirmation

    @isTest static void pageShouldShowThankYouConfirmMessage() {
        PageReference testPage = Page.MSIT_RespondAndSubmit;
        Test.setCurrentPageReference(testPage);

        // Given "confirm" was indicated
        Stay_In_Touch_Request__c stayInTouch = [SELECT Id, Contact__c FROM Stay_In_Touch_Request__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ref', stayInTouch.Id);
        ApexPages.currentPage().getParameters().put('status', 'confirm');

        // When the page loads
        msit.MSIT_RespondAndSubmit rAs = new msit.MSIT_RespondAndSubmit();
        rAs.processConfirmation();
        Datetime nowPageLoaded = System.now();

        // Then a "thank you" message should show
        System.assertEquals(rAs.status, 'confirm', 'The status should be confirm');
        // And the Contact.Last MSIT Request Result field should be 'Confirmed'
        Contact contact = [SELECT Id, Last_MSIT_Request_Result__c, Last_MSIT_Response_Datetime__c FROM Contact WHERE Id = :stayInTouch.Contact__c];
        System.assertEquals(contact.Last_MSIT_Request_Result__c, 'Confirmed', 'The last request result should be Confirmed');
        // And the Contact.Last MSIT Response Datetime should be the date time when the page executed
        System.assertEquals(contact.Last_MSIT_Response_Datetime__c, nowPageLoaded, 'The last request datetime should be equal to the time of page load/execution');
    }
/*
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
*/
}
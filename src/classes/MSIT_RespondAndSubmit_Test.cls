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
    // As a Customer
    // I want to see a message thanking me for confirmation

    @isTest static void pageShouldShowThankYouConfirmMessage() {
        PageReference testPage = Page.MSIT_RespondAndSubmit;
        Test.setCurrentPageReference(testPage);

        // Given "confirm" was indicated
        Stay_In_Touch_Request__c stayInTouch = [SELECT Id, Contact__c FROM Stay_In_Touch_Request__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ref', stayInTouch.Id);
        ApexPages.currentPage().getParameters().put('status', MSIT_RespondAndSubmit.CONFIRMED);

        // When the page loads
        MSIT_RespondAndSubmit rAs = new MSIT_RespondAndSubmit();
        rAs.processResponse();
        stayInTouch = [SELECT Id, Contact__c, Name, Contact_Response__c FROM Stay_In_Touch_Request__c WHERE Id = :stayInTouch.Id];

        // Then a "thank you" message should show (just testing the status value not the UI)
        System.assertEquals(MSIT_RespondAndSubmit.CONFIRMED, rAs.status, 'The status should be ' + MSIT_RespondAndSubmit.CONFIRMED);
        // And the SIT Contact Response should be 'Confirmed'
        System.assertEquals(MSIT_RespondAndSubmit.CONFIRMED, stayInTouch.Contact_Response__c, 'The SIT contact response should be ' + MSIT_RespondAndSubmit.CONFIRMED);
    }

    // Story: Making changes to details
    // In order to change my details
    // As a Customer
    // I want to make changes and be thanked

    @isTest static void changesShouldHaveBeenSavedToContact() {
        PageReference testPage = Page.MSIT_RespondAndSubmit;
        Test.setCurrentPageReference(testPage);

        // Given changes were made
        Stay_In_Touch_Request__c stayInTouch = [SELECT Id, Contact__c FROM Stay_In_Touch_Request__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ref', stayInTouch.Id);
        ApexPages.currentPage().getParameters().put('status', MSIT_RespondAndSubmit.CHANGE);
        MSIT_RespondAndSubmit rAs = new MSIT_RespondAndSubmit();
        rAs.processResponse();
        rAs.theContact.LastName = 'Test Change';
        rAs.processChange();

        // When the page reloads after submit
        stayInTouch = [SELECT Id, Contact__c, Name, Contact_Response__c FROM Stay_In_Touch_Request__c WHERE Id = :stayInTouch.Id];
        Contact contact = [SELECT Id, LastName FROM Contact WHERE Id = :stayInTouch.Contact__c];

        // Then a "thank you" message should show (just testing the status value not the UI)
        System.assertEquals(MSIT_RespondAndSubmit.CHANGE, rAs.status, 'The status should be ' + MSIT_RespondAndSubmit.CHANGE);
        // And the SIT Contact Response should be 'Change'
        System.assertEquals(MSIT_RespondAndSubmit.CHANGE, stayInTouch.Contact_Response__c, 'The SIT contact response should be ' + MSIT_RespondAndSubmit.CHANGE);
        // And the changes should be reflected on the Contact record
        System.assertEquals('Test Change', contact.LastName, 'The last name should be Test Change');
    }

    // Story: Error handling
    // Should the SITR record not exist (e.g. hacking attempt or deleted)
    // As a Customer
    // I want to see a warning message

    @isTest static void pageShouldShowWarningMessage() {
        PageReference testPage = Page.MSIT_RespondAndSubmit;
        Test.setCurrentPageReference(testPage);

        // Given information is missing from or incorrect in the URL
        ApexPages.currentPage().getParameters().put('ref', 'invalid id');
        ApexPages.currentPage().getParameters().put('status', MSIT_RespondAndSubmit.CONFIRMED);

        // When the page loads
        MSIT_RespondAndSubmit rAs = new MSIT_RespondAndSubmit();
        rAs.processResponse();
    }
}
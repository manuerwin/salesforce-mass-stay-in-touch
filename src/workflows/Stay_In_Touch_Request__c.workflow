<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Mass_Stay_In_Touch_Send_Stay_In_Touch_Request_to_Contact</fullName>
        <description>Mass Stay In Touch - Send Stay In Touch Request to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Mass_Stay_In_Touch_Emails/Mass_Stay_In_Touch_Contact_Template_NO_NOT_DELETE</template>
    </alerts>
</Workflow>

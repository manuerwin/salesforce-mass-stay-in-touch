<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Mass_Stay_In_Touch_notify_Contact_Owner_no_changes_made</fullName>
        <description>Mass Stay In Touch - notify Contact Owner no changes made</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Mass_Stay_In_Touch_Emails/Stay_In_Touch_notify_no_change</template>
    </alerts>
    <alerts>
        <fullName>Stay_In_Touch_changed</fullName>
        <description>Stay In Touch - changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Mass_Stay_In_Touch_Emails/Stay_In_Touch_notify_changes</template>
    </alerts>
    <rules>
        <fullName>Stay In Touch %E2%80%93 changes made</fullName>
        <actions>
            <name>Stay_In_Touch_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Last_MSIT_Request_Result__c</field>
            <operation>equals</operation>
            <value>Changed</value>
        </criteriaItems>
        <description>If changes occurred as a result of a MSIT request, the internal user should be notified by email.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Stay In Touch %E2%80%93 no changes</fullName>
        <actions>
            <name>Mass_Stay_In_Touch_notify_Contact_Owner_no_changes_made</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Last_MSIT_Request_Result__c</field>
            <operation>equals</operation>
            <value>No Change</value>
        </criteriaItems>
        <description>If the MSIT recipient advises no change, the internal user should be notified by email that no changes were made.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

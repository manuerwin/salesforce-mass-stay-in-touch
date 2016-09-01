# Purpose
Provide steps to implement this functionality into a testing environment while development is still occurring.

# 1) Manually create Site
You need to create the Site first so the Site Guest profile (Mass Stay In Touch Profile) will be created and to enable the subsequent metadata deploy to match.
Navigate to Setup, enter Sites in "Quick Find" and click through.
Create a New Site with the following details (make sure they are exactly the same otherwise the subsequent metadata won't match):
1 Site Label: Mass Stay In Touch
2 Site Name: Mass_Stay_In_Touch
3 Default Web Address: stayingintouch
4 Active Site Home Page: InMaintenance
5 Leave all other default values and click Save

# 2) Migrate metadata into target environment
Manually remove the MSIT-Creation flow from the src/flow directory as error occurs when migration is attempted.
Run the ant deploy script 'deployCodeNoTests' to get around test method failure in sandbox.
Confirm all metadata items present.
Manually provision Read permissions for Contact MSIT fields to appropriate profiles.
Manually add the MSIT custom fields to the Contact page layout and set to Read Only.
Manually add the Stay In Touch related list to the Contact page layout, with Stay In Touch Ref, Subject, Signature, Contact Response, and Last Modified By as columns. Set Sort By to Last Modified By Descending. Remove the New button.

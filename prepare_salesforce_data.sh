#!/bin/bash

#from command-line, export MYSQL_PWD=yourpasswordhere
ORG_ALIAS=hunter-fulluat

echo ""
echo "*** Setup ****"
mysql -u root hunter_sfdc < setup.sql

echo "Salesforce reference data exports..."
echo "*** Export record types... ****"
./export_record_types.sh $ORG_ALIAS

# May have to do this command in mysql if this creates an error:
# SHOW VARIABLES LIKE 'local_infile';
# SET GLOBAL local_infile = 1;

# mysql --local-infile -u root hunter_sfdc < setup.sql

# echo ""
# echo "*** Program ****"
# mysql -u root hunter_sfdc < programs.sql

echo ""
echo "*** Account (ERP) ****"
echo "Parents..."
mysql -u root hunter_sfdc < accounts_parents.sql
echo "Children..."
mysql -u root hunter_sfdc < accounts_children.sql

echo ""
echo "*** Contact ****"
mysql -u root hunter_sfdc < contacts.sql

echo ""
echo "*** Lead ****"
mysql -u root hunter_sfdc < leads.sql

echo ""
echo "*** Opportunity ****"
mysql -u root hunter_sfdc < opportunities.sql

echo ""
echo "*** Case ****"
mysql -u root hunter_sfdc < cases.sql

echo ""
echo "*** Number Lookup Contacts ****"
mysql -u root hunter_sfdc < number_lookup_contacts.sql

# echo ""
# echo "*** Sales Summary Data ****"
# mysql -u root hunter_sfdc < sales_summary_data.sql
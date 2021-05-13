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
echo "*** Account ****"
./export_migrated_accounts.sh $ORG_ALIAS
mysql -u root hunter_sfdc < load_migrated_accounts.sql

echo "Parents..."
mysql -u root hunter_sfdc < accounts_parents.sql
echo "Children..."
mysql -u root hunter_sfdc < accounts_children.sql

mysql -u root hunter_sfdc -e "delete from mig_account where External_ID__c in (select external_id from migrated_accounts)"
mysql -u root hunter_sfdc -e "select count(*) from mig_account"

mysql -u root hunter_sfdc < export_accounts_to_file.sql

# echo ""
# echo "*** Contact ****"
# mysql -u root hunter_sfdc < contacts.sql

# echo ""
# echo "*** Opportunity ****"
# mysql -u root hunter_sfdc < opportunities.sql

# echo ""
# echo "*** Sales Summary Data ****"
# mysql -u root hunter_sfdc < sales_summary_data.sql
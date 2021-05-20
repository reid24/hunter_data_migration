#!/bin/bash

#from command-line, export MYSQL_PWD=yourpasswordhere
ORG_ALIAS=hunter-fulluat

echo "Salesforce reference data exports..."
echo "*** Export record types... ****"
./export_record_types.sh $ORG_ALIAS
./export_users.sh $ORG_ALIAS

echo ""
echo "*** Setup ****"
mysql -u root hunter_sfdc < setup.sql

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

echo ""
echo "*** Distributor Health Checks ****"
mysql -u root hunter_sfdc < distributor_health_checks.sql

echo ""
echo "*** Sales Summary Data ****"
mysql -u root hunter_sfdc < sales_summary_data.sql

echo ""
echo "*** FSM Sites ***"
mysql -u root hunter_sfdc < fsm_sites.sql

echo ""
echo "*** Meetings ***"
mysql -u root hunter_sfdc < meetings.sql

echo ""
echo "*** Calls ***"
mysql -u root hunter_sfdc < calls.sql

echo ""
echo "*** Tasks ***"
mysql -u root hunter_sfdc < tasks.sql
#!/bin/bash

#from command-line, export MYSQL_PWD=yourpasswordhere

echo ""
echo "*** Setup ****"
mysql -u root hunter_sfdc < setup.sql

echo ""
echo "*** Program ****"
mysql -u root hunter_sfdc < programs.sql

echo ""
echo "*** Account ****"
mysql -u root hunter_sfdc < accounts.sql

echo ""
echo "*** Contact ****"
mysql -u root hunter_sfdc < contacts.sql

echo ""
echo "*** Opportunity ****"
mysql -u root hunter_sfdc < opportunities.sql

echo ""
echo "*** Sales Summary Data ****"
mysql -u root hunter_sfdc < sales_summary_data.sql
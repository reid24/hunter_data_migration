#!/bin/bash

#from command-line, export MYSQL_PWD=yourpasswordhere

mysql -u root hunter_sfdc < setup.sql
mysql -u root hunter_sfdc < programs.sql
mysql -u root hunter_sfdc < accounts.sql
mysql -u root hunter_sfdc < contacts.sql
mysql -u root hunter_sfdc < opportunities.sql
# hunter_data_migration
Hunter Data Migration

# Setup
## export MYSQL_PWD=yourpassword
## Create mysql database "hunter"
## Create mysql database "hunter_sfdc"
## Import hunter data into "hunter"

# Execution
## Run prepare_salesforce_data.sh - this will generate mig_ tables in "hunter_sfdc" database


# OTHER STUFF
## To turn on MySQL load from file permission:
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
## To generate a list of possible sugar values:
select 'AccountType', a.account_type, a.account_type from 
hunter.accounts a group by 'AccountType', a.account_type, a.account_type order by count(*) desc;

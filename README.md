# hunter_data_migration
Hunter Data Migration

## Setup
# Create mysql database "hunter"
# Create mysql database "hunter_sfdc"
# Import hunter data into "hunter"

## Execution
# Edit prepare_salesforce_data.sh, set your mysql password in the PWD variable
# Run prepare_salesforce_data.sh - this will generate mig_ tables in "hunter_sfdc" database
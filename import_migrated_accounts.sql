DROP TABLE IF EXISTS ref_migrated_accounts;
CREATE TABLE ref_migrated_accounts (
	Id varchar(18) NOT NULL,
	External_ID__c varchar(255) NOT NULL,
	Name varchar(255) DEFAULT NULL
);

LOAD DATA LOCAL INFILE 'data/ref_migrated_accounts.csv' INTO TABLE ref_migrated_accounts FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

DELETE FROM mig_account WHERE External_ID__c IN (SELECT External_ID__c FROM ref_migrated_accounts);
DROP TABLE IF EXISTS mig_account;
CREATE TABLE mig_account (
  External_ID__c varchar(255) NOT NULL,
  Name varchar(255) DEFAULT NULL,
  Type varchar(255) DEFAULT NULL,
  BillingCity varchar(255) DEFAULT NULL,
  BillingCountry varchar(255) DEFAULT NULL,
  BillingPostalCode varchar(255) DEFAULT NULL,
  BillingState varchar(255) DEFAULT NULL,
  BillingStreet varchar(255) DEFAULT NULL,
  Description text,
  PRIMARY KEY (External_ID__c)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS create_accounts;

DELIMITER &&
CREATE PROCEDURE create_accounts()
BEGIN    
  INSERT INTO mig_account(External_ID__c, Name, Type, 
    BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet,
    Description) (
    SELECT a.id, a.name, vlookup('AccountType',a.account_type), a.billing_address_city, 
    a.billing_address_country, a.billing_address_postalcode, a.billing_address_state, a.billing_address_street,
    a.description
    FROM hunter.accounts a
    INNER JOIN hunter.accounts_cstm ac ON ac.id_c = a.id
    WHERE a.deleted = 0
  );
END &&
DELIMITER ;

call create_accounts();

select count(*) from mig_account;
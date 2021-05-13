DROP TABLE IF EXISTS mig_number_lookup_contacts;
CREATE TABLE mig_number_lookup_contacts (
    External_ID__c varchar(36) NOT NULL PRIMARY KEY,
    AccountId varchar(36),
    CreatedDate varchar(255),
    Description text,
    Email varchar(255),
    FirstName varchar(255),
    LastName varchar(255)
);

INSERT INTO mig_number_lookup_contacts (
    External_ID__c,
    CreatedDate,
    Description,
    Email,
    FirstName,
    LastName) (
    SELECT 
    id,
    date_entered,
    description,
    email_address,
    first_name,
    last_name
    FROM 
    hunter.nl_number_lookup nl
    WHERE nl.deleted = 0
);

select '';
select count(*) NumberOfRecords from mig_number_lookup_contacts;

DROP TABLE IF EXISTS mig_number_lookup_contacts;
CREATE TABLE mig_number_lookup_contacts (
    External_ID__c varchar(36) NOT NULL PRIMARY KEY,
    AccountId varchar(36),
    Description text,
    Email varchar(255),
    FirstName varchar(255),
    LastName varchar(255),
	OwnerId char(36) DEFAULT NULL,
	CreatedById char(36) DEFAULT NULL,
	CreatedDate datetime DEFAULT NULL
);

INSERT INTO mig_number_lookup_contacts (
    External_ID__c,
    Description,
    Email,
    FirstName,
    LastName,
    OwnerId, 
    CreatedById, 
    CreatedDate) (
    SELECT 
    nl.id,
    nl.description,
    nl.email_address,
    nl.first_name,
    nl.last_name,
    owner_user.id,
    creator.id,
    nl.date_entered
    FROM 
    hunter.nl_number_lookup nl
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = nl.assigned_user_id AND nl.assigned_user_id <> ''
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = nl.created_by AND nl.created_by <> ''
    WHERE nl.deleted = 0
);

select '';
select count(*) NumberOfRecords from mig_number_lookup_contacts;

DROP TABLE IF EXISTS mig_contact;
CREATE TABLE mig_contact (
  External_ID__c varchar(255) NOT NULL,
  FirstName varchar(255) DEFAULT NULL,
  LastName varchar(255) DEFAULT NULL,
  AccountId varchar(255) DEFAULT NULL,
  Description text DEFAULT NULL,
  Type__c varchar(255),
  PRIMARY KEY (External_ID__c)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS create_contacts;

DELIMITER &&
CREATE PROCEDURE create_contacts()
BEGIN    
  INSERT INTO mig_contact(External_ID__c, FirstName, LastName, AccountId, Description, Type__c) (
    SELECT c.id, c.first_name, c.last_name, ac.account_id, c.description, c_cstm.customer_type_c
    FROM hunter.contacts c
    INNER JOIN hunter.contacts_cstm c_cstm ON c_cstm.id_c = c.id
    LEFT OUTER JOIN hunter.accounts_contacts ac ON ac.contact_id = c.id AND ac.deleted = 0 AND ac.primary_account = 1
    WHERE c.deleted = 0
  );
END &&
DELIMITER ;

call create_contacts();

select count(*) from mig_contact;
select count(*) from mig_contact where AccountId is null;
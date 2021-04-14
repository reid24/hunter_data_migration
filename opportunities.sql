DROP TABLE IF EXISTS mig_opportunity;
CREATE TABLE mig_opportunity (
  External_ID__c varchar(255) NOT NULL,
  Name varchar(255) DEFAULT NULL,
  PRIMARY KEY (External_ID__c)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS create_opportunities;

DELIMITER &&
CREATE PROCEDURE create_opportunities()
BEGIN    
  INSERT INTO mig_opportunity(External_ID__c, Name) (
    SELECT o.id, o.name
    FROM hunter.opportunities o
    INNER JOIN hunter.opportunities_cstm oc ON oc.id_c = o.id
    WHERE o.deleted = 0
  );
END &&
DELIMITER ;

call create_opportunities();

select count(*) from mig_opportunity;
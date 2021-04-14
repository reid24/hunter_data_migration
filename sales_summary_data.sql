DROP TABLE IF EXISTS mig_sales_summary_data;
CREATE TABLE mig_sales_summary_data (
  External_ID__c varchar(255) NOT NULL,
  Account__c varchar(255) DEFAULT NULL,
  PRIMARY KEY (External_ID__c)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS create_sales_summary_data;

DELIMITER &&
CREATE PROCEDURE create_sales_summary_data()
BEGIN    
  INSERT INTO mig_sales_summary_data(External_ID__c, Account__c) (
    SELECT ac.id_c, ac.id_c
    FROM hunter.accounts a
    INNER JOIN hunter.accounts_cstm ac ON ac.id_c = a.id
    WHERE a.deleted = 0
  );
END &&
DELIMITER ;

call create_sales_summary_data();

select count(*) from mig_sales_summary_data;
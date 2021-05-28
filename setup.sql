DROP TABLE IF EXISTS ref_vlookup;
CREATE TABLE ref_vlookup (
	vlookup_type varchar(30) NOT NULL,
	sugar_type varchar(255) DEFAULT NULL,
	sfdc_type varchar(255)  DEFAULT NULL
);

DROP FUNCTION IF EXISTS vlookup;

DELIMITER $$
CREATE FUNCTION vlookup(in_vtype varchar(255), in_sugar_type varchar(255)) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN    
	DECLARE out_sfdc_type VARCHAR(255);
	SET @out_sfdc_type := in_sugar_type;
	
	SELECT sfdc_type INTO @out_sfdc_type FROM ref_vlookup WHERE sugar_type = in_sugar_type and vlookup_type = in_vtype LIMIT 1;
	
	RETURN @out_sfdc_type;
END$$
DELIMITER ;

LOAD DATA LOCAL INFILE 'data/vlookup_country.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
LOAD DATA LOCAL INFILE 'data/vlookup_accounttype.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
LOAD DATA LOCAL INFILE 'data/vlookup_sugar_customer_segment.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
LOAD DATA LOCAL INFILE 'data/vlookup_sugar_specialty_list.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
LOAD DATA LOCAL INFILE 'data/vlookup_preferred_language.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS ref_record_type;
CREATE TABLE ref_record_type (
	id char(18) PRIMARY KEY NOT NULL,
	sobject_type varchar(100) NOT NULL,
	name varchar(255) NOT NULL
);

LOAD DATA LOCAL INFILE 'data/ref_record_types.csv' INTO TABLE ref_record_type FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

SELECT vlookup('Country','United States of America');
SELECT vlookup('Country','United States OF America');
SELECT vlookup('Country','australia');

SELECT * FROM ref_record_type;

DROP TABLE IF EXISTS ref_customer_segmentation;

CREATE TABLE ref_customer_segmentation (
	sugar_customer_segment varchar(100) NOT NULL,
	sugar_customer_type varchar(100) NOT NULL,
	sfdc_record_type_name varchar(100) NOT NULL,
	sfdc_account_type varchar(100) NOT NULL,
	sfdc_business_unit varchar(100) NOT NULL,
	sfdc_market varchar(100) NOT NULL
);

LOAD DATA LOCAL INFILE 'data/ref_customer_segmentation_rules.csv' INTO TABLE ref_customer_segmentation FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';

DROP TABLE IF EXISTS ref_users;
CREATE TABLE ref_users (
	id char(18) PRIMARY KEY NOT NULL,
	username varchar(255) NOT NULL,
	sugar_id char(36)
);
LOAD DATA LOCAL INFILE 'data/ref_users.csv' INTO TABLE ref_users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

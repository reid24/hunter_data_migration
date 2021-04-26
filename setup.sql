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

LOAD DATA LOCAL INFILE 'data/vlookup_country.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"';
LOAD DATA LOCAL INFILE 'data/vlookup_accounttype.csv' INTO TABLE ref_vlookup FIELDS TERMINATED BY ',' ENCLOSED BY '"';

DROP TABLE IF EXISTS ref_record_type;
CREATE TABLE ref_record_type (
	id char(18) PRIMARY KEY NOT NULL,
	sobject_type varchar(100) NOT NULL,
	name varchar(255) NOT NULL
);

LOAD DATA LOCAL INFILE 'data/ref_record_types.csv' INTO TABLE ref_record_type FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 LINES;

SELECT vlookup('Country','United States of America');
SELECT vlookup('Country','United States OF America');
SELECT vlookup('Country','australia');

SELECT * FROM ref_record_type;

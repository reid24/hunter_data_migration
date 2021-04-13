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
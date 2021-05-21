DROP TABLE IF EXISTS mig_fsm_site;
CREATE TABLE mig_fsm_site (
  External_ID__c varchar(255) NOT NULL,
  CreatedDate datetime not null,
  Name varchar(255),
  BillingStreet varchar(255),
  BillingCity varchar(255),
  BillingState varchar(255),
  BillingStateCode varchar(255),
  BillingPostalCode varchar(255),
  BillingCountryCode varchar(255),
  OwnerId varchar(255),
  CreatedById varchar(255),
  RecordTypeId varchar(255)
);

INSERT INTO mig_fsm_site (
    External_ID__c, CreatedDate, Name, BillingStreet, BillingCity, BillingState, BillingStateCode, 
	 BillingPostalCode, BillingCountryCode, 
	 OwnerId, CreatedById, RecordTypeId
	  
) (
    SELECT 
	 fsm.id, 
	 fsm.date_entered, 
	 fsm.name, 
	 fsmc.site_street_c, 
	 fsmc.city_c, 
	 -- fsmc.state_c, 
		case 
			when LENGTH(fsmc.state_c) = 3 AND fsmc.country_c IN ('AU','Australia') then null
			when LENGTH(fsmc.state_c) > 2 then fsmc.state_c 
		END AS state_c,
		case
			when LENGTH(fsmc.state_c) = 3 AND fsmc.country_c IN ('AU','Australia') then fsmc.state_c
			when LENGTH(fsmc.state_c) = 2 then fsmc.state_c 
		END AS state_code_c,	
	 fsmc.postal_code_c,
	 -- fsmc.country_c, 
	 vlookup('Country', fsmc.country_c) AS country_c,
	 owner_user.id,
	 creator.id,
	 rt.id
    FROM jr_fsm_sites fsm
    INNER JOIN jr_fsm_sites_cstm fsmc ON fsmc.id_c = fsm.id
    LEFT OUTER JOIN ref_record_type rt ON rt.name = 'Indirect Purchaser' AND rt.sobject_type = 'Account'
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = fsm.assigned_user_id
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = fsm.created_by
    WHERE fsm.deleted = 0
    -- AND fsmc.country_c LIKE 'Au%'
);
DROP TABLE IF EXISTS mig_opportunity;
CREATE TABLE mig_opportunity (
  External_ID__c varchar(255) NOT NULL,
  Name varchar(255) DEFAULT NULL,
  AccountId varchar(36) DEFAULT NULL,
  estimated_lighting__c varchar(255) DEFAULT NULL,
  forecasted_amount__c varchar(255) DEFAULT NULL,
  CloseDate varchar(255) DEFAULT NULL,
  Description text,
  Type varchar(255) DEFAULT NULL,
  StageName varchar(255) DEFAULT NULL,
  Expected_Order_Date__c varchar(255) DEFAULT NULL,
  course_grade__c varchar(255) DEFAULT NULL,
  Amount varchar(255) DEFAULT NULL,
  estimated_irrigation__c varchar(255) DEFAULT NULL,
  Facility_ID__c varchar(255) DEFAULT NULL,
  location_address_city__c varchar(255) DEFAULT NULL,
  location_address_country__c varchar(255) DEFAULT NULL,
  PostalCode__c varchar(255) DEFAULT NULL,
  location_address_state__c varchar(255) DEFAULT NULL,
  location_address_state_code__c varchar(255) DEFAULT NULL,
  location_address_street__c varchar(255) DEFAULT NULL,
  won_loss_notes__c varchar(255) DEFAULT NULL,
  won_loss_reason__c varchar(255) DEFAULT NULL,
  ForecastCategory varchar(255) DEFAULT NULL,
  PRIMARY KEY (External_ID__c)
);

INSERT INTO mig_opportunity(
  External_ID__c, 
  Name, 
  AccountId,
  estimated_lighting__c,
  forecasted_amount__c,
  CloseDate,
  Description,
  Type,
  StageName,
  Expected_Order_Date__c,
  course_grade__c,
  Amount,
  estimated_irrigation__c,
  Facility_ID__c,
  location_address_city__c,
  location_address_country__c,
  PostalCode__c,
  location_address_state__c,
  location_address_state_code__c,
  location_address_street__c,
  won_loss_notes__c,
  won_loss_reason__c,
  ForecastCategory
  ) (
  SELECT DISTINCT 
  o.id, 
  o.name, 
  NULL,
  o.amount,
  o.amount_usdollar,
  o.date_closed,
  o.description,
  o.opportunity_type,
  o.sales_stage,
  oc.bid_date_c,
  oc.course_grade_c,
  oc.dollars_won_c,
  oc.estimated_irrigation_c,
  oc.facility_id_c,
  oc.location_address_city_c,
  -- oc.location_address_country_c,
  vlookup('Country', oc.location_address_country_c) AS location_address_country_c,
  oc.location_address_postalcode_c,
  -- oc.location_address_state_c,
	case 
		when LENGTH(oc.location_address_state_c) > 2 AND oc.location_address_country_c != 'AU'
			then oc.location_address_state_c
	END AS location_address_state_c,
	case 
		when LENGTH(oc.location_address_state_c) = 2 OR (LENGTH(oc.location_address_state_c) = 3 AND oc.location_address_country_c = 'AU')
			then oc.location_address_state_c
	END AS location_address_state_c_code,	
  oc.location_address_street_c,
  oc.loss_notes_c,
  oc.loss_reason_c,
  oc.probability_category_c  
  FROM opportunities o
  INNER JOIN opportunities_cstm oc ON oc.id_c = o.id
  WHERE o.deleted = 0 AND o.sales_stage IN ('Prospecting','Active_Project_Lead','Perception Analysis')
);

update mig_opportunity set AccountId = (select account_id from accounts_opportunities where opportunity_id = mig_opportunity.External_ID__c and deleted = 0 limit 1) where AccountId is null;

select count(*) from mig_opportunity;
select count(*) from mig_opportunity where AccountId is null;
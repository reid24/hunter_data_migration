DROP PROCEDURE IF EXISTS create_erp_child_accounts;

DELIMITER &&
CREATE PROCEDURE create_erp_child_accounts()
BEGIN    
	INSERT INTO mig_account(
		`External_ID__c`,
		`customer_type_category__c`,
		`Account_Type__c`,
		`Business_Unit__c`,
		`Markets__c`,
		`RecordTypeId`,
		`annual_revenue__c`,
		`BillingCity`,
		`BillingCountryCode`,
		`BillingPostalCode`,
		`BillingState`,
		`BillingStateCode`,
		`BillingStreet`,
		`Description`,
		`NumberOfEmployees`,
		`Name`,
		`next_renewal_date__c`,
		`phone_alternate__c`,
		`Fax`,
		`Phone`,
		`ShippingCity`,
		`ShippingCountryCode`,
		`ShippingPostalCode`,
		`ShippingState`,
		`ShippingStateCode`,
		`ShippingStreet`,
		`Website`,
		`architect__c`,
		`back_orders__c`,
		`central_control_brand__c`,
		-- `Commercial Irrigation Referral Request`,
		-- `Commercial Lighting Referral Request`,
		-- `Contact Frequency`,
		-- `Contact Overdue`,
		`control_system_age__c`,
		`control_system__c`,
		`controller_brand_type__c`,
		`county__c`,
		`course_category__c`,
		`course_opening_year__c`,
		`course_type__c`,
		`customer_marketing_priority__c`,
		`days_since_last_contact__c`,
		`days_until_hsn_expiration__c`,
		-- `dealer_number__c`,
		`dist_irrigation_2018__c`,
		`dist_irrigation_2019__c`,
		`dist_lighting_2018__c`,
		`dist_lighting_2019__c`,
		`distibutor_salesman_name__c`,
		`distributor_rep__c`,
		`distributor_salesman_email__c`,
		`dm__c`,
		`expired__c`,
		`facility_id__c`,
		`golf_distributor_billing__c`,
		`golf_holes_type__c`,
		`golf_irrigation_installation__c`,
		`hmds_id__c`,
		`hpp_primary_contact__c`,
		`hpp_primary_contact_email__c`,
		`hpp_secondary_contact__c`,
		`hpp_secondary_contact_email__c`,
		`hsn_expiration_date__c`,
		`hsn_start_date__c`,
		`hunter_golf_customer__c`,
		`hunter_golf_reference__c`,
		`hunter_pilot_course__c`,
		`hunter_preferred_balance__c`,
		`hunter_product__c`,
		`hunter_product_samples__c`,
		`hunter_service_network__c`,
		`hydrawise_customers__c`,
		`hydrawise_id__c`,
		`irrigation_2016__c`,
		`irrigation_2017__c`,
		`irrigation_2018__c`,
		`irrigation_2019__c`,
		`irrigation_design_projects__c`,
		`irrigation_install_projects__c`,
		`last_contact__c`,
		`last_visit_date__c`,
		`level__c`,
		`lighting_2016__c`,
		`lighting_2017__c`,
		`lighting_2018__c`,
		`lighting_2019__c`,
		`mailing_preference__c`,
		`management_company__c`,
		`next_contact_due_date__c`,
		`number_of_holes__c`,
		`number_of_installation_crews__c`,
		`oem__c`,
		`pcp_points_on_hold__c`,
		`pilot_version__c`,
		-- `PO Box City`,
		-- `PO Box Country`,
		-- `PO Box PostalCode`,
		-- `PO Box State`,
		-- `PO Box Address`,
		`points_about_to_expire__c`,
		`preferred_language_list__c`,
		`referral_program__c`,
		`res_irr_ref_req__c`,
		`res_light_ref_req__c`,
		`returned_mail_bad_address__c`,
		`rewards_id__c`,
		`rewards_point_balance__c`,
		`rewards_points_at_risk__c`,
		`rewards_points_earned_monthl__c`,
		`rewards_points_redeemed_mont__c`,
		`rewards_primary_contact__c`,
		`rewards_primary_contact_emai__c`,
		`rotor_age__c`,
		`rotor_brand__c`,
		`rotor_count__c`,
		`rotor_type__c`,
		`Ship_To_Number__c`,
		`services__c`,
		`specialty_list__c`,
		`sso_account_name__c`,
		`year_established__c`,
		`ParentId`,
		`sales_reporting_number__c`,
		OwnerId, 
		CreatedById, 
		CreatedDate,
		Account_Status__c
		)
		(
		SELECT 
		DISTINCT
		a.id,
		-- a.account_type,
		segment_rule.sfdc_record_type_name,
		segment_rule.sfdc_account_type,
		segment_rule.sfdc_business_unit,
		replace(segment_rule.sfdc_market,', ',';') AS sfdc_market,
		-- rt.id AS rectypeid, -- record type id
		case when rt.id IS NULL then (SELECT id FROM ref_record_type WHERE NAME = 'Indirect Purchaser') ELSE rt.id END AS rectypeid,
		a.annual_revenue,
		a.billing_address_city,
		vlookup('Country', a.billing_address_country),
		-- a.billing_address_country,
		a.billing_address_postalcode,
		-- a.billing_address_state,		
		case 
			when LENGTH(a.billing_address_state) = 3 AND a.billing_address_country IN ('AU','Australia') then null
			when LENGTH(a.billing_address_state) > 2 then a.billing_address_state
		END AS billing_address_state,
		case
			when LENGTH(a.billing_address_state) = 3 AND a.billing_address_country IN ('AU','Australia') then a.billing_address_state
			when LENGTH(a.billing_address_state) = 2 then a.billing_address_state
		END AS billing_address_state_code,
		a.billing_address_street,
		a.description,
		a.employees,
		a.name,
		a.next_renewal_date,
		a.phone_alternate,
		a.phone_fax,
		a.phone_office,
		a.shipping_address_city,
		vlookup('Country', a.shipping_address_country),
		-- a.shipping_address_country,
		a.shipping_address_postalcode,
		-- a.shipping_address_state,
		case 
			when LENGTH(a.shipping_address_state) = 3 AND a.shipping_address_country IN ('AU','Australia') then null
			when LENGTH(a.shipping_address_state) > 2 then a.shipping_address_state
		END AS shipping_address_state,
		case
			when LENGTH(a.shipping_address_state) = 3 AND a.shipping_address_country IN ('AU','Australia') then a.shipping_address_state
			when LENGTH(a.shipping_address_state) = 2 then a.shipping_address_state
		END AS shipping_address_state_code_c,	
		a.shipping_address_street,
		a.website,
		ac.architect_c,
		ac.back_orders_c,
		ac.central_control_brand_c,
		-- ac.com_irr_ref_req_c,
		-- ac.com_light_ref_req_c,
		-- ac.contact_frequency_c,
		-- ac.contact_overdue_c,
		ac.control_system_age_c,
		ac.control_system_c,
		ac.controller_brand_type_c,
		ac.county_c,
		ac.course_category_c,
		ac.course_opening_year_c,
		ac.course_type_c,
		ac.customer_marketing_priority_c,
		ac.days_since_last_contact_c,
		ac.days_until_hsn_expiration_c,
		-- ac.dealer_number_c,
		ac.dist_irrigation_2018_c,
		ac.dist_irrigation_2019_c,
		ac.dist_lighting_2018_c,
		ac.dist_lighting_2019_c,
		ac.distibutor_salesman_name_c,
		ac.distributor_rep_c,
		ac.distributor_salesman_email_c,
		ac.dm_c,
		ac.expired_c,
		ac.facility_id_c,
		ac.golf_distributor_billing_c,
		ac.golf_holes_type_c,
		ac.golf_irrigation_installation_c,
		ac.hmds_id_c,
		ac.hpp_primary_contact_c,
		ac.hpp_primary_contact_email_c,
		ac.hpp_secondary_contact_c,
		ac.hpp_secondary_contact_email_c,
		ac.hsn_expiration_date_c,
		ac.hsn_start_date_c,
		ac.hunter_golf_customer_c,
		ac.hunter_golf_reference_c,
		ac.hunter_pilot_course_c,
		ac.hunter_preferred_balance_c,
		ac.hunter_product_c,
		ac.hunter_product_samples_c,
		ac.hunter_service_network_c,
		ac.hydrawise_customers_c,
		ac.hydrawise_id_c,
		ac.irrigation_2016_c,
		ac.irrigation_2017_c,
		ac.irrigation_2018_c,
		ac.irrigation_2019_c,
		ac.irrigation_design_projects_c,
		ac.irrigation_install_projects_c,
		ac.last_contact_c,
		ac.last_visit_date_c,
		ac.level_c,
		ac.lighting_2016_c,
		ac.lighting_2017_c,
		ac.lighting_2018_c,
		ac.lighting_2019_c,
		ac.mailing_preference_c,
		ac.management_company_c,
		case 
		when ac.next_contact_due_date_c = '0000-00-00' then NULL
		else ac.next_contact_due_date_c
		end as next_contact_due_date_c,
		ac.number_of_holes_c,
		ac.number_of_installation_crews_c,
		ac.oem_c,
		ac.pcp_points_on_hold_c,
		ac.pilot_version_c,
		-- ac.po_box_address_city_c,
		-- ac.po_box_address_country_c,
		-- ac.po_box_address_postalcode_c,
		-- ac.po_box_address_state_c,
		-- ac.po_box_address_street_c,
		ac.points_about_to_expire_c,
		ac.preferred_language_list_c,
		ac.referral_program_c,
		replace(REPLACE(replace(ac.res_irr_ref_req_c,' ^','^'),',',';'),'^','') AS res_irr_ref_req_c,
		replace(REPLACE(replace(ac.res_light_ref_req_c,' ^','^'),',',';'),'^','') AS res_light_ref_req_c,
		ac.returned_mail_bad_address_c,
		ac.rewards_id_c,
		ac.rewards_point_balance_c,
		ac.rewards_points_at_risk_c,
		ac.rewards_points_earned_monthl_c,
		ac.rewards_points_redeemed_mont_c,
		ac.rewards_primary_contact_c,
		ac.rewards_primary_contact_emai_c,
		ac.rotor_age_c,
		-- ac.rotor_brand_c,
		REPLACE(ac.rotor_brand_c,'Rainbird','Rain_Bird') AS rotor_brand_c,
		ac.rotor_count_c,
		ac.rotor_type_c,
		ac.sales_reporting_number_c,
		replace(REPLACE(replace(ac.services_c,' ^','^'),',',';'),'^','') AS services_c,
		REPLACE(REPLACE(replace(REPLACE(replace(ac.specialty_list_c,' ^','^'),',',';'),'^',''),
			'Res_Com Irrigation','Hunter_Res_Com Irrigation'),'Res-Com Irrigation','Hunter_Res_Com Irrigation') AS specialty_list_c,
		ac.sso_account_name_c,
		ac.year_established_c,
		case when a.parent_id = a.id and length(a.parent_id) > 10 then NULL ELSE a.parent_id END AS parent_id,
		pac.sales_reporting_number_c AS pac_sales_reporting_number_c,
		owner_user.id AS owner_user_id,
		creator.id as creator_id,
		case when a.date_entered = '0000-00-00 00:00:00' then NULL else a.date_entered END AS date_entered,
		'Customer' AS account_status
		FROM hunter.accounts a
		INNER JOIN hunter.accounts_cstm ac ON ac.id_c = a.id
		LEFT OUTER JOIN hunter.accounts pa ON pa.id = a.parent_id
		LEFT OUTER JOIN hunter.accounts_cstm pac ON pac.id_c = pa.id
		LEFT OUTER JOIN ref_vlookup sugar_segment ON sugar_segment.vlookup_type = 'SugarCustomerSegment' AND sugar_segment.sugar_type = ac.customer_type_category_c
		LEFT OUTER JOIN ref_customer_segmentation segment_rule ON (segment_rule.sugar_customer_segment = sugar_segment.sfdc_type and (if(a.account_type is null or a.account_type = '','empty',a.account_type) = if(segment_rule.sugar_customer_type is null or segment_rule.sugar_customer_type = '', 'empty', segment_rule.sugar_customer_type)))
		OR (if(segment_rule.sugar_customer_segment is null or segment_rule.sugar_customer_segment = '', 'empty', segment_rule.sugar_customer_segment) = if(ac.customer_type_category_c is null or ac.customer_type_category_c = '', 'empty', ac.customer_type_category_c) and (if(a.account_type is null or a.account_type = '','empty',a.account_type) = if(segment_rule.sugar_customer_type is null or segment_rule.sugar_customer_type = '', 'empty', segment_rule.sugar_customer_type)))
		LEFT OUTER JOIN ref_record_type rt ON rt.Name = segment_rule.sfdc_record_type_name
		LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = a.assigned_user_id AND a.assigned_user_id <> ''
		LEFT OUTER JOIN ref_users creator ON creator.sugar_id = a.created_by AND a.created_by <> ''
		WHERE 
		a.deleted = 0
		AND (a.parent_id IS NOT NULL AND a.parent_id != a.id)
  );
  update mig_account set specialty_list__c = null where recordtypeid is null;
  select count(*) ChildrenWithMissingParentBefore from mig_account where ParentId is not null and ParentId not in (select External_ID__c from mig_account);
  update mig_account set ParentId = NULL where ParentId is not null and ParentId not in (select id from hunter.accounts where deleted = 0);
  -- emails
	UPDATE mig_account a SET email_address__c = (
	SELECT e.email_address FROM 
	hunter.email_addr_bean_rel beanrel 
	INNER JOIN hunter.email_addresses e on e.id = beanrel.email_address_id and beanrel.primary_address = 1 and e.deleted = 0 and e.invalid_email = 0
	WHERE beanrel.bean_module = 'Accounts' and beanrel.bean_id = a.External_ID__c and beanrel.deleted = 0
	LIMIT 1
	);
END &&
DELIMITER ;

call create_erp_child_accounts();

select count(*) Children from mig_account where `ParentId` is not null;
select count(*) ChildrenWithMissingParentAfter from mig_account where ParentId is not null and ParentId not in (select External_ID__c from mig_account);

-- manual fixes

update mig_account set billingstatecode = NULL, billingstate = NULL, shippingstatecode = NULL, shippingstate = NULL 
where external_id__c IN 
(
'62705468-5584-11ea-ad5a-06156affe90a',
'bfae09b6-ff08-49a0-3e62-4fa15a079fa9',
'6b588490-744c-2b90-cbec-509c3af62ea6',
'ef88d215-94ca-71ce-bd80-507a9696d86f',
'501fa31a-4025-5c6e-2694-4fe33cf74f9b',
'd5827194-65ab-4d2f-e8e5-4f0dc2b25226',
'95d91474-cdac-11eb-9d0d-069eed229002',
'32e02af4-b4dc-dfc7-e9a7-509e72168dcf',
'933815a2-d5f9-11e7-b8ca-060c6f621ec1' -- child
);
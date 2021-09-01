DROP TABLE IF EXISTS mig_contact;
CREATE TABLE mig_contact (
  External_ID__c varchar(255) NOT NULL,
  FirstName varchar(255) DEFAULT NULL,
  LastName varchar(255) DEFAULT NULL,
  AccountId varchar(255) DEFAULT NULL,
  Description text DEFAULT NULL,
  Type__c VARCHAR(255) DEFAULT NULL,
  Salutation VARCHAR(255) DEFAULT NULL,
  Title VARCHAR(255) DEFAULT NULL,
  Department VARCHAR(255) DEFAULT NULL,
  DoNotCall TINYINT(1),
  HomePhone VARCHAR(255) DEFAULT NULL,
  MobilePhone VARCHAR(255) DEFAULT NULL,
  phone_work__c VARCHAR(255) DEFAULT NULL,
  OtherPhone VARCHAR(255) DEFAULT NULL,
  Fax VARCHAR(255) DEFAULT NULL,
  MailingStreet text DEFAULT NULL,
  MailingCity VARCHAR(255) DEFAULT NULL,
  MailingState VARCHAR(255) DEFAULT NULL,
  MailingStateCode VARCHAR(255) DEFAULT NULL,
  MailingPostalCode VARCHAR(255) DEFAULT NULL,
  MailingCountry VARCHAR(255) DEFAULT NULL,
  OtherStreet text DEFAULT NULL,
  OtherCity VARCHAR(255) DEFAULT NULL,
  OtherState VARCHAR(255) DEFAULT NULL,
  OtherStateCode VARCHAR(255) DEFAULT NULL,
  OtherPostalCode VARCHAR(255) DEFAULT NULL,
  OtherCountry VARCHAR(255) DEFAULT NULL,
  AssistantName VARCHAR(255) DEFAULT NULL,
  AssistantPhone VARCHAR(255) DEFAULT NULL,
  LeadSource VARCHAR(255) DEFAULT NULL,
  Birthdate VARCHAR(255) DEFAULT NULL,
  preferred_language_list__c VARCHAR(255) DEFAULT NULL,
  hmds_id__c VARCHAR(10) DEFAULT NULL,
  customer_marketing_priority__c VARCHAR(255) DEFAULT NULL,
  distributor_rep__c VARCHAR(255) DEFAULT NULL,
  last_name_phonetically__c VARCHAR(255) DEFAULT NULL,
  first_name_phonetically__c VARCHAR(255) DEFAULT NULL,
  Phone VARCHAR(255) DEFAULT NULL,
  specialty_list__c VARCHAR(255) DEFAULT NULL,
  mailing_preference__c VARCHAR(255) DEFAULT NULL,
  contact_type__c VARCHAR(255) DEFAULT NULL,
  interest__c VARCHAR(255) DEFAULT NULL,
  return_mail_bad_address__c VARCHAR(255) DEFAULT NULL,
  program_member__c VARCHAR(255) DEFAULT NULL,
  fx_update_mail__c VARCHAR(255) DEFAULT NULL,
  fx_update_email__c VARCHAR(255) DEFAULT NULL,
  pp_info_request__c VARCHAR(255) DEFAULT NULL,
  pp_member__c VARCHAR(255) DEFAULT NULL,
  pp_residential_rotor__c VARCHAR(255) DEFAULT NULL,
  ppommercial_rotor__c VARCHAR(255) DEFAULT NULL,
  pp_spray_head__c VARCHAR(255) DEFAULT NULL,
  pp_spray_nozzle__c VARCHAR(255) DEFAULT NULL,
  pp_hi_efficency_nozzle__c VARCHAR(255) DEFAULT NULL,
  pp_residential_valve__c VARCHAR(255) DEFAULT NULL,
  ppommercial_valve__c VARCHAR(255) DEFAULT NULL,
  pp_residentialcontroller__c VARCHAR(255) DEFAULT NULL,
  ppommercialontroller__c VARCHAR(255) DEFAULT NULL,
  pp_sensor__c VARCHAR(255) DEFAULT NULL,
  pp_micro_irrigation__c VARCHAR(255) DEFAULT NULL,
  pp_lighting__c VARCHAR(255) DEFAULT NULL,
  pp_golf_rotor__c VARCHAR(255) DEFAULT NULL,
  pp_golfontroller__c VARCHAR(255) DEFAULT NULL,
  preferred_design_software__c VARCHAR(255) DEFAULT NULL,
  customer_bio__c TEXT DEFAULT NULL,
  report_id__c VARCHAR(255) DEFAULT NULL,
  price_product_recall__c TINYINT(1) DEFAULT 0,
  referral_programcontact__c TEXT DEFAULT NULL,
  customer_type_category__c VARCHAR(255) DEFAULT NULL,
  Family__c TEXT DEFAULT NULL,
  HasOptedOutOfEmail TINYINT(1) DEFAULT 0,
  expert_referrals__c TINYINT(1) DEFAULT 0,
  sso_uuid__c VARCHAR(255) DEFAULT NULL,
  sso_log__c TEXT DEFAULT NULL,
  sso_account_name__c TEXT DEFAULT NULL,
  sso_branch_number__c TEXT DEFAULT NULL,
  oem__c TEXT DEFAULT NULL,
  maincontact__c TINYINT(1) DEFAULT 0,
  hydrawiseustomer__c TINYINT(1) DEFAULT 0,
  lastcontact__c DATETIME DEFAULT NULL,
  authorized_resource__c TINYINT(1) DEFAULT 0,
  centralus_user__c TINYINT(1) DEFAULT 0,
  fbsg_sme_initialcheck__c TINYINT(1) DEFAULT 0,
  county__c TEXT DEFAULT NULL,
  gdprompliant__c TINYINT(1) DEFAULT 0,
  siterec_user__c TINYINT(1) DEFAULT 0,
  number_of_recommendations__c INTEGER DEFAULT NULL,
  last_recommendation_sent_dat__c DATE,
  email_group__c VARCHAR(255) DEFAULT NULL,
  price_product_recall_fx__c TINYINT(1) DEFAULT 0,
  holm_price_product_recall__c TINYINT(1) DEFAULT 0,
  golf_price_product_recall__c TINYINT(1) DEFAULT 0,
  sf_lastactivity_default__c DATETIME DEFAULT NULL,
  hunterompany_news__c TINYINT(1) DEFAULT 0,
  hunter_irrigation_emails__c TINYINT(1) DEFAULT 0,
  hunter_golf_irrigation_email__c TINYINT(1) DEFAULT 0,
  fx_luminaire_lighting_emails__c TINYINT(1) DEFAULT 0,
  senninger_agriculture_irriga__c TEXT DEFAULT NULL,
  hpp_primarycontact__c TINYINT(1) DEFAULT 0,
  hpp_secondarycontact__c TINYINT(1) DEFAULT 0,
  rev_it_up_coins__c INTEGER DEFAULT NULL,
  hunterompany_news_subscrib__c TINYINT(1) DEFAULT 0,
  hunter_irrigation_subscribe__c TINYINT(1) DEFAULT 0,
  hunter_golf_irrigation_sub__c TINYINT(1) DEFAULT 0,
  fx_luminaire_lighting_sub__c TINYINT(1) DEFAULT 0,
  senninger_ag_irr_sub__c TINYINT(1) DEFAULT 0,
	OwnerId char(36) DEFAULT NULL,
	CreatedById char(36) DEFAULT NULL,
	CreatedDate datetime DEFAULT NULL,
  Email varchar(255),
  PRIMARY KEY (External_ID__c)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO mig_contact(External_ID__c, FirstName, LastName, AccountId, Description, Type__c,
  Salutation,
  Title,
  Department,
  DoNotCall,
  HomePhone,
  MobilePhone,
  phone_work__c,
  OtherPhone,
  Fax,
  MailingStreet,
  MailingCity,
  MailingState,
  MailingStateCode,
  MailingPostalCode,
  MailingCountry,
  OtherStreet,
  OtherCity,
  OtherState,
  OtherStateCode,
  OtherPostalCode,
  OtherCountry,
  AssistantName,
  AssistantPhone,
  LeadSource,
  Birthdate,
  preferred_language_list__c,
  hmds_id__c,
  customer_marketing_priority__c,
  distributor_rep__c,
  last_name_phonetically__c,
  first_name_phonetically__c,
  Phone,
  specialty_list__c,
  mailing_preference__c,
  contact_type__c,
  interest__c,
  return_mail_bad_address__c,
  program_member__c,
  fx_update_mail__c,
  fx_update_email__c,
  pp_info_request__c,
  pp_member__c,
  pp_residential_rotor__c,
  ppommercial_rotor__c,
  pp_spray_head__c,
  pp_spray_nozzle__c,
  pp_hi_efficency_nozzle__c,
  pp_residential_valve__c,
  ppommercial_valve__c,
  pp_residentialcontroller__c,
  ppommercialontroller__c,
  pp_sensor__c,
  pp_micro_irrigation__c,
  pp_lighting__c,
  pp_golf_rotor__c,
  pp_golfontroller__c,
  preferred_design_software__c,
  customer_bio__c,
  report_id__c,
  price_product_recall__c,
  referral_programcontact__c,
  customer_type_category__c,
  Family__c,
  HasOptedOutOfEmail,
  expert_referrals__c,
  sso_uuid__c,
  sso_log__c,
  sso_account_name__c,
  sso_branch_number__c,
  oem__c,
  maincontact__c,
  hydrawiseustomer__c,
  lastcontact__c,
  authorized_resource__c,
  centralus_user__c,
  fbsg_sme_initialcheck__c,
  county__c,
  gdprompliant__c,
  siterec_user__c,
  number_of_recommendations__c,
  last_recommendation_sent_dat__c,
  email_group__c,
  price_product_recall_fx__c,
  holm_price_product_recall__c,
  golf_price_product_recall__c,
  sf_lastactivity_default__c,
  hunterompany_news__c,
  hunter_irrigation_emails__c,
  hunter_golf_irrigation_email__c,
  fx_luminaire_lighting_emails__c,
  senninger_agriculture_irriga__c,
  hpp_primarycontact__c,
  hpp_secondarycontact__c,
  rev_it_up_coins__c,
  hunterompany_news_subscrib__c,
  hunter_irrigation_subscribe__c,
  hunter_golf_irrigation_sub__c,
  fx_luminaire_lighting_sub__c,
  senninger_ag_irr_sub__c,
  OwnerId, 
  CreatedById, 
  CreatedDate
    ) (
SELECT c.id, c.first_name, c.last_name, ac.account_id, c.description, c_cstm.customer_type_c,
  c.salutation, 
  c.title,
  c.department,
  c.do_not_call,
  c.phone_home,
  c.phone_mobile,
  c.phone_work,
  c.phone_other,
  c.phone_fax,
  c.primary_address_street,
  c.primary_address_city,
  -- c.primary_address_state,
		case 
			when LENGTH(c.primary_address_state) = 3 AND c.primary_address_country IN ('AU','Australia') then null
			when LENGTH(c.primary_address_state) > 2 then c.primary_address_state
		END AS primary_address_state,
		case
			when LENGTH(c.primary_address_state) = 3 AND c.primary_address_country IN ('AU','Australia') then c.primary_address_state
			when LENGTH(c.primary_address_state) = 2 then c.primary_address_state
		END AS primary_address_state_code,
  c.primary_address_postalcode,
  -- c.primary_address_country,
  vlookup('Country', c.primary_address_country) AS primary_address_country,
  c.alt_address_street,
  c.alt_address_city,
  -- c.alt_address_state,
		case 
			when LENGTH(c.alt_address_state) = 3 AND c.alt_address_country IN ('AU','Australia') then null
			when LENGTH(c.alt_address_state) > 2 then c.alt_address_state
		END AS alt_address_state,
		case
			when LENGTH(c.alt_address_state) = 3 AND c.alt_address_country IN ('AU','Australia') then c.alt_address_state
			when LENGTH(c.alt_address_state) = 2 then c.alt_address_state
		END AS alt_address_state_code,
  c.alt_address_postalcode,
  -- c.alt_address_country,
  vlookup('Country', c.alt_address_country) AS alt_address_country,
  c.assistant,
  c.assistant_phone,
  c.lead_source,
  c.birthdate,
  -- c.preferred_language,
  vlookup('PreferredLanguage', c.preferred_language) AS preferred_language,
  c_cstm.hmds_id_c,
  c_cstm.customer_marketing_priority_c,
  c_cstm.distributor_rep_c,
  c_cstm.last_name_phonetically_c,
  c_cstm.first_name_phonetically_c,
  c_cstm.free_phone_c,
  -- c_cstm.specialty_list_c,
  REPLACE(
  		REPLACE(
		  	REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(c_cstm.specialty_list_c,' ^','^'),
					',',';'),
				'^',''),
			'Res_Com Irrigation','Hunter_Res_Com Irrigation'),
		'Res-Com Irrigation','Hunter_Res_Com Irrigation'),
	'Sports Fields1','Sports_Fields') AS specialty_list_c,
  c_cstm.mailing_preference_c,
  -- c_cstm.contact_type_c,
  replace(REPLACE(replace(c_cstm.contact_type_c,' ^','^'),',',';'),'^','') AS contact_type_c,
  c_cstm.interest_c,
  c_cstm.return_mail_bad_address_c,
  c_cstm.program_member_c,
  c_cstm.fx_update_mail_c,
  c_cstm.fx_update_email_c,
  c_cstm.pp_info_request_c,
  c_cstm.pp_member_c,
  c_cstm.pp_residential_rotor_c,
  c_cstm.pp_commercial_rotor_c,
  c_cstm.pp_spray_head_c,
  c_cstm.pp_spray_nozzle_c,
  c_cstm.pp_hi_efficency_nozzle_c,
  c_cstm.pp_residential_valve_c,
  c_cstm.pp_commercial_valve_c,
  c_cstm.pp_residential_controller_c,
  c_cstm.pp_commercial_controller_c,
  c_cstm.pp_sensor_c,
  c_cstm.pp_micro_irrigation_c,
  c_cstm.pp_lighting_c,
  c_cstm.pp_golf_rotor_c,
  c_cstm.pp_golf_controller_c,
  c_cstm.preferred_design_software_c,
  c_cstm.customer_bio_c,
  c_cstm.report_id_c,
  c_cstm.price_product_recall_c,
  c_cstm.referral_program_contact_c,
  c_cstm.customer_type_category_c,
  c_cstm.family_c,
  c_cstm.do_not_mail_c,
  c_cstm.expert_referrals_c,
  c_cstm.sso_uuid_c,
  c_cstm.sso_log_c,
  c_cstm.sso_account_name_c,
  c_cstm.sso_branch_number_c,   
  c_cstm.oem_c,
  c_cstm.main_contact_c,
  c_cstm.hydrawise_customer_c,
  c_cstm.last_contact_c,
  c_cstm.authorized_resource_c,
  c_cstm.centralus_user_c,
  c_cstm.fbsg_sme_initial_check_c,
  c_cstm.county_c,
  c_cstm.gdpr_compliant_c,
  c_cstm.siterec_user_c,
  c_cstm.number_of_recommendations_c,
  c_cstm.last_recommendation_sent_dat_c,
  c_cstm.email_group_c,
  c_cstm.price_product_recall_fx_c,
  c_cstm.holm_price_product_recall_c,
  c_cstm.golf_price_product_recall_c,
  c_cstm.sf_lastactivity_default_c,
  c_cstm.hunter_company_news_c,
  c_cstm.hunter_irrigation_emails_c,
  c_cstm.hunter_golf_irrigation_email_c,
  c_cstm.fx_luminaire_lighting_emails_c,
  c_cstm.senninger_agriculture_irriga_c,
  c_cstm.hpp_primary_contact_c,
  c_cstm.hpp_secondary_contact_c,
  c_cstm.rev_it_up_coins_c,
  c_cstm.hunter_company_news_subscrib_c,
  c_cstm.hunter_irrigation_subscribe_c,
  c_cstm.hunter_golf_irrigation_sub_c,
  c_cstm.fx_luminaire_lighting_sub_c,
  c_cstm.senninger_ag_irr_sub_c,
  owner_user.id,
  creator.id,
  case when c.date_entered = '0000-00-00 00:00:00' then NULL else c.date_entered END AS date_entered
  FROM hunter.contacts c
  INNER JOIN hunter.contacts_cstm c_cstm ON c_cstm.id_c = c.id
  LEFT OUTER JOIN hunter.accounts_contacts ac ON ac.contact_id = c.id AND ac.deleted = 0 AND ac.primary_account = 1
  LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = c.assigned_user_id AND c.assigned_user_id <> ''
  LEFT OUTER JOIN ref_users creator ON creator.sugar_id = c.created_by AND c.created_by <> ''
  WHERE c.deleted = 0
);

-- checkboxes
UPDATE mig_contact SET hpp_primarycontact__c = 0 WHERE hpp_primarycontact__c IS NULL;
UPDATE mig_contact SET hpp_secondarycontact__c = 0 WHERE hpp_secondarycontact__c IS NULL;
UPDATE mig_contact SET hunter_golf_irrigation_sub__c = 0 WHERE hunter_golf_irrigation_sub__c IS NULL;
UPDATE mig_contact SET golf_price_product_recall__c = 0 WHERE golf_price_product_recall__c IS NULL;
UPDATE mig_contact SET fx_luminaire_lighting_sub__c = 0 WHERE fx_luminaire_lighting_sub__c IS NULL;
UPDATE mig_contact SET holm_price_product_recall__c = 0 WHERE holm_price_product_recall__c IS NULL;
UPDATE mig_contact SET price_product_recall_fx__c = 0 WHERE price_product_recall_fx__c IS NULL;
UPDATE mig_contact SET hunter_irrigation_subscribe__c = 0 WHERE hunter_irrigation_subscribe__c IS NULL;
UPDATE mig_contact SET fx_luminaire_lighting_emails__c = 0 WHERE fx_luminaire_lighting_emails__c IS NULL;
UPDATE mig_contact SET hydrawiseustomer__c = 0 WHERE hydrawiseustomer__c IS NULL;
UPDATE mig_contact SET siterec_user__c = 0 WHERE siterec_user__c IS NULL;
UPDATE mig_contact SET hunterompany_news_subscrib__c = 0 WHERE hunterompany_news_subscrib__c IS NULL;
UPDATE mig_contact SET hunter_golf_irrigation_email__c = 0 WHERE hunter_golf_irrigation_email__c IS NULL;
UPDATE mig_contact SET senninger_agriculture_irriga__c = 0 WHERE senninger_agriculture_irriga__c IS NULL;
UPDATE mig_contact SET hunter_irrigation_emails__c = 0 WHERE hunter_irrigation_emails__c IS NULL;
UPDATE mig_contact SET authorized_resource__c = 0 WHERE authorized_resource__c IS NULL;
UPDATE mig_contact SET gdprompliant__c = 0 WHERE gdprompliant__c IS NULL;
UPDATE mig_contact SET fbsg_sme_initialcheck__c = 0 WHERE fbsg_sme_initialcheck__c IS NULL;
UPDATE mig_contact SET senninger_ag_irr_sub__c = 0 WHERE senninger_ag_irr_sub__c IS NULL;
UPDATE mig_contact SET hunterompany_news__c = 0 WHERE hunterompany_news__c IS NULL;
UPDATE mig_contact SET centralus_user__c = 0 WHERE centralus_user__c IS NULL;

-- back up to the non-primary
update mig_contact set AccountId = (select account_id from hunter.accounts_contacts where contact_id = mig_contact.External_ID__c and deleted = 0 limit 1) where AccountId is null;

select count(*) TotalContacts from mig_contact;
select count(*) NoAccount from mig_contact where AccountId is null;
-- integrity check on contacts
select count(*) BadAccountLinks from mig_contact where AccountId is not null and AccountId not in (select External_ID__c from mig_account);

update mig_contact set AccountId = null where AccountId is not null and AccountId not in (select External_ID__c from mig_account);
select count(*) NoAccount from mig_contact where AccountId is null;

-- update mig_contact set MailingStateCode = NULL, MailingState = NULL, otherstatecode = NULL, otherstate = NULL 
-- where external_id__c IN 
-- (
-- '16906de0-cbd4-11eb-9774-06156affe90a',
-- '2720d366-ce68-11eb-850f-069eed229002',
-- '32834228-cdcf-11eb-999e-02d962f59f52',
-- '499b0899-eba7-abea-3ffc-4cdd82b874ba',
-- '91d78822-285b-a014-cf7e-4cdd82fa70b1',
-- '94f7ece5-bde5-0266-f5d4-4cdd8273b189',
-- '950bc7c6-cdac-11eb-a575-069eed229002',
-- 'a7525971-6ab0-1547-c3a1-4cdd823c057f',
-- 'a79a52ea-2058-11e8-bfc4-02ef9e9f3eb9',
-- 'b40d10e8-cb73-11eb-9b47-02d962f59f52',
-- 'bc2d150a-f29a-f95c-5138-4cdd8346886e',
-- 'c287504b-d384-2353-6b98-4e39c05ae28f',
-- 'c77bb4d0-cddb-11eb-9c82-02d06230d2dc'
-- );

-- emails
UPDATE mig_contact c SET Email = (
  SELECT e.email_address FROM 
  hunter.email_addr_bean_rel beanrel 
  INNER JOIN hunter.email_addresses e on e.id = beanrel.email_address_id and beanrel.primary_address = 1 and e.deleted = 0 and e.invalid_email = 0
  WHERE beanrel.bean_module = 'Contacts' and beanrel.bean_id = c.External_ID__c and beanrel.deleted = 0
);

-- do_not_mail_c vs HasOpted
select count(*) HasEmail from mig_contact where Email IS NOT NULL;
select count(*) OptedOutBefore from mig_contact where HasOptedOutOfEmail = TRUE;
UPDATE mig_contact c SET HasOptedOutOfEmail = TRUE WHERE External_ID__c IN (
  SELECT beanrel.bean_id FROM 
  hunter.email_addr_bean_rel beanrel 
  INNER JOIN hunter.email_addresses e on e.id = beanrel.email_address_id and beanrel.primary_address = 1 and e.deleted = 0 and e.invalid_email = 0 and e.opt_out = 1
  WHERE beanrel.bean_module = 'Contacts' and beanrel.deleted = 0
);
select count(*) OptedOutAfter from mig_contact where HasOptedOutOfEmail = TRUE;
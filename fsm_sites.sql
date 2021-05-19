DROP TABLE IF EXISTS mig_fsm_site;
CREATE TABLE mig_fsm_site (
  External_ID__c varchar(255) NOT NULL,
  CreatedDate datetime not null,
  Name varchar(255),
  BillingStreet varchar(255),
  BillingCity varchar(255),
  BillingStateCode varchar(255),
  BillingPostalCode varchar(255),
  BillingCountryCode varchar(255),
  OwnerId varchar(255),
  CreatedById varchar(255)
);

INSERT INTO mig_fsm_site (
    External_ID__c, CreatedDate, Name, BillingStreet, BillingCity, BillingStateCode, BillingPostalCode, BillingCountryCode, OwnerId, CreatedById 
) (
    SELECT fsm.id, fsm.date_entered, fsm.name, fsmc.site_street_c, fsmc.city_c, fsmc.state_c, fsmc.postal_code_c, fsmc.country_c, owner_user.id, creator.id
    FROM hunter.jr_fsm_sites fsm
    INNER JOIN hunter.jr_fsm_sites_cstm fsmc ON fsmc.id_c = fsm.id
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = fsm.assigned_user_id
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = fsm.created_by
    WHERE fsm.deleted = 0
);

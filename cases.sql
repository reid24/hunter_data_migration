DROP TABLE IF EXISTS mig_case;
CREATE TABLE mig_case (
    External_ID__c varchar(36) NOT NULL PRIMARY KEY,
    ContactId varchar(36),
    AccountId varchar(36),
    ContactPhone varchar(255),
    Resolution_Notes__c text,
    Emergency_Visit_Required__c varchar(255),
    Reason varchar(255),
    Date_of_Visit__c varchar(255),
    Desired_Visit_By__c varchar(255),
    Duration_Hours__c varchar(255),
    Description text,
    Status varchar(255),
	OwnerId char(36) DEFAULT NULL,
	CreatedById char(36) DEFAULT NULL,
	CreatedDate datetime DEFAULT NULL
);

INSERT INTO mig_case (
    External_ID__c,
    ContactPhone,
    Resolution_Notes__c,
    Emergency_Visit_Required__c,
    Reason,
    Date_of_Visit__c,
    Desired_Visit_By__c,
    Duration_Hours__c,
    Description,
    Status,
    OwnerId, 
    CreatedById, 
    CreatedDate
) (
    SELECT 
    fst.id,
    fst.contact_number,
    fst.description,
    fst.emergency_visit_required,
    fst.reason_for_request,
    fstc.date_of_visit_c,
    fstc.desired_time_frame_for_visit_c,
    fstc.duration_in_hours_c,
    fstc.problem_description_c,
    fstc.request_status_c,
    owner_user.id,
    creator.id,
    fst.date_entered
    FROM 
    hunter.fst_field_service_tickets fst
    INNER JOIN hunter.fst_field_service_tickets_cstm fstc ON fstc.id_c = fst.id
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = fst.assigned_user_id AND fst.assigned_user_id <> ''
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = fst.created_by AND fst.created_by <> ''
    WHERE fst.deleted = 0
);

select count(*) NumberOfCases from mig_case;

update mig_case set ContactId = (select contacts_fst_field_service_tickets_1contacts_ida from hunter.contacts_fst_field_service_tickets_1_c where contacts_f061etickets_idb = mig_case.External_ID__c and deleted = 0 limit 1) where ContactId is null;
update mig_case set AccountId = (select fst_field_service_tickets_accountsaccounts_ida from hunter.fst_field_service_tickets_accounts_c where fst_field_service_tickets_accountsfst_field_service_tickets_idb = mig_case.External_ID__c and deleted = 0 limit 1) where AccountId is null;

select count(*) CasesWithContactId from mig_case where ContactId is not null;
select count(*) CasesWithAccountId from mig_case where AccountId is not null;
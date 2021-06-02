DROP TABLE IF EXISTS mig_call;
CREATE TABLE mig_call (
    External_ID__c varchar(36) NOT NULL PRIMARY KEY,
    WhoId varchar(36),
    StartDateTime datetime,
    EndDateTime datetime,
    DurationInMinutes integer,
    Subject varchar(255),
    Description text,
    CreatedDate datetime,
    OwnerId varchar(255),
    CreatedById varchar(255)
);

INSERT INTO mig_call (
    External_ID__c,
    WhoId,
    StartDateTime,
    EndDateTime,
    DurationInMinutes,
    Subject,
    Description,
    CreatedDate,
    OwnerId,
    CreatedById
) (
    SELECT 
    m.id,
    NULL,
    m.date_start,
    m.date_end,
    m.duration_minutes,
    m.name,
    m.description,
    m.date_entered,
    owner_user.id, 
    creator.id
    FROM 
    calls m
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = m.assigned_user_id AND m.assigned_user_id <> ''
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = m.created_by AND m.created_by <> ''
    WHERE deleted = 0 AND m.date_modified > DATE_SUB(NOW(), INTERVAL 3 YEAR)
);

select count(*) NumberOfCalls from mig_call;
select '';
update mig_call set WhoId = (select contact_id from calls_contacts where call_id = mig_call.External_ID__c and deleted = 0 limit 1) where WhoId is null;
update mig_call set WhoId = (select lead_id from calls_leads where call_id = mig_call.External_ID__c and deleted = 0 limit 1) where WhoId is null;
select '';
select count(*) CallsWithWhoId from mig_call where WhoId is not null;
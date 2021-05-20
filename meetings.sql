DROP TABLE IF EXISTS mig_meeting;
CREATE TABLE mig_meeting (
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

INSERT INTO mig_meeting (
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
    hunter.meetings m
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = m.assigned_user_id
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = m.created_by
    WHERE deleted = 0
);

select count(*) NumberOfMeetings from mig_meeting;
select '';
update mig_meeting set WhoId = (select id from hunter.meetings_contacts where meeting_id = mig_meeting.External_ID__c and deleted = 0 limit 1) where WhoId is null;
update mig_meeting set WhoId = (select id from hunter.meetings_leads where meeting_id = mig_meeting.External_ID__c and deleted = 0 limit 1) where WhoId is null;
select '';
select count(*) MeetingsWithWhoId from mig_meeting where WhoId is not null;
DROP TABLE IF EXISTS mig_task;
CREATE TABLE mig_task (
    External_ID__c varchar(36) NOT NULL PRIMARY KEY,
    WhoId varchar(36),
    Subject varchar(255),
    ActivityDate date,
    Description text,
    Status varchar(255),
    CreatedDate datetime,
    OwnerId varchar(255),
    CreatedById varchar(255)
);

INSERT INTO mig_task (
    External_ID__c,
    WhoId,
    Subject,
    ActivityDate,
    Description,
    Status,
    CreatedDate,
    OwnerId,
    CreatedById
) (
    SELECT 
    t.id,
    IFNULL(c.id, l.id),
    t.name,
    t.date_due,
    t.description,
    t.status,
    t.date_entered,
    owner_user.id, 
    creator.id
    FROM 
    hunter.tasks t
    LEFT OUTER JOIN hunter.contacts c ON c.id = t.parent_id AND c.deleted = 0
    LEFT OUTER JOIN hunter.leads l ON l.id = t.parent_id AND l.deleted = 0
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = t.assigned_user_id
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = t.created_by
    WHERE t.deleted = 0
);

select count(*) NumberOfTasks from mig_task;
select count(*) TasksWithWhoId from mig_call where WhoId is not null;
DROP TABLE IF EXISTS migrated_accounts;
CREATE TABLE migrated_accounts (
    id char(18) not null primary key,
    external_id char(36) not null,
    created_date datetime not null,
    created_by varchar(255) not null,
    INDEX(external_id)
);
LOAD DATA LOCAL INFILE 'data/migrated_accounts.csv' INTO TABLE migrated_accounts FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 LINES;

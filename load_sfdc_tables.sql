-- ACCOUNT
DROP TABLE IF EXISTS ref_account;

CREATE TABLE `hunter`.`ref_account` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_account.csv' INTO TABLE ref_account FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


-- CONTACT
DROP TABLE IF EXISTS ref_contact;

CREATE TABLE `hunter`.`ref_contact` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_contact.csv' INTO TABLE ref_contact FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


-- OPPORTUNITY
DROP TABLE IF EXISTS ref_opportunity;

CREATE TABLE `hunter`.`ref_opportunity` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_opportunity.csv' INTO TABLE ref_opportunity FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


-- CASE
DROP TABLE IF EXISTS ref_case;

CREATE TABLE `hunter`.`ref_case` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_case.csv' INTO TABLE ref_case FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

-- DHC
DROP TABLE IF EXISTS ref_dhc;

CREATE TABLE `hunter`.`ref_dhc` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_dhc.csv' INTO TABLE ref_dhc FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


-- EVENT
DROP TABLE IF EXISTS ref_event;

CREATE TABLE `hunter`.`ref_event` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_event.csv' INTO TABLE ref_event FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


-- TASK
DROP TABLE IF EXISTS ref_task;

CREATE TABLE `hunter`.`ref_task` (
	`ID` VARCHAR(20) NOT NULL,
	`EXTERNAL_ID__C` VARCHAR(40) NOT NULL
);

LOAD DATA LOCAL INFILE 'sfdc_extracts/ref_task.csv' INTO TABLE ref_task FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

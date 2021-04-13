#!/bin/bash

PWD=yourmysqlpasswordhere

rm *.sql
rm sugar_data.zip

mysqldump -u root -p$PWD hunter accounts > accounts.sql
mysqldump -u root -p$PWD hunter accounts_cstm > accounts_cstm.sql
mysqldump -u root -p$PWD hunter contacts > contacts.sql
mysqldump -u root -p$PWD hunter contacts_cstm > contacts_cstm.sql
mysqldump -u root -p$PWD hunter accounts_contacts > accounts_contacts.sql
mysqldump -u root -p$PWD hunter campaigns > campaigns.sql
mysqldump -u root -p$PWD hunter campaigns_cstm > campaigns_cstm.sql
mysqldump -u root -p$PWD hunter cases > cases.sql
mysqldump -u root -p$PWD hunter cases_cstm > cases_cstm.sql
mysqldump -u root -p$PWD hunter leads > leads.sql
mysqldump -u root -p$PWD hunter leads_cstm > leads_cstm.sql
mysqldump -u root -p$PWD hunter opportunities > opportunities.sql
mysqldump -u root -p$PWD hunter opportunities_cstm > opportunities_cstm.sql
mysqldump -u root -p$PWD hunter bhc_brachhealthchecks > bhc_brachhealthchecks.sql
mysqldump -u root -p$PWD hunter bhc_brachhealthchecks_cstm > bhc_brachhealthchecks_cstm.sql
mysqldump -u root -p$PWD hunter fst_field_service_tickets > fst_field_service_tickets.sql
mysqldump -u root -p$PWD hunter fst_field_service_tickets_cstm > fst_field_service_tickets_cstm.sql
mysqldump -u root -p$PWD hunter nl_number_lookup > nl_number_lookup.sql
mysqldump -u root -p$PWD hunter jr_fsm_sites > jr_fsm_sites.sql
mysqldump -u root -p$PWD hunter hml_hunter_my_list > hml_hunter_my_list.sql
mysqldump -u root -p$PWD hunter js_fxl_my_list > js_fxl_my_list.sql
mysqldump -u root -p$PWD hunter meetings > meetings.sql
mysqldump -u root -p$PWD hunter meetings_cstm > meetings_cstm.sql
mysqldump -u root -p$PWD hunter notes > notes.sql
mysqldump -u root -p$PWD hunter notes_cstm > notes_cstm.sql
mysqldump -u root -p$PWD hunter campaigns > campaigns.sql
mysqldump -u root -p$PWD hunter campaigns_cstm > campaigns_cstm.sql
mysqldump -u root -p$PWD hunter gm_courses > gm_courses.sql
mysqldump -u root -p$PWD hunter levjl_grades > levjl_grades.sql
mysqldump -u root -p$PWD hunter tasks > tasks.sql
mysqldump -u root -p$PWD hunter tasks_cstm > tasks_cstm.sql
mysqldump -u root -p$PWD hunter hi_homeowners > hi_homeowners.sql

zip sugar_data.zip *.sql
rm *.sql
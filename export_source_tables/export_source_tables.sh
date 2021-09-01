#!/bin/bash

#from command-line, export MYSQL_PWD=yourpasswordhere

rm *.sql
rm sugar_data.zip

mysqldump -u root hunter accounts > accounts.sql
mysqldump -u root hunter accounts_cstm > accounts_cstm.sql
mysqldump -u root hunter contacts > contacts.sql
mysqldump -u root hunter contacts_cstm > contacts_cstm.sql
mysqldump -u root hunter accounts_contacts > accounts_contacts.sql
mysqldump -u root hunter accounts_opportunities > accounts_opportunities.sql
mysqldump -u root hunter accounts_bhc_branchhealthchecks_1_c > accounts_bhc_branchhealthchecks_1_c.sql
mysqldump -u root hunter campaigns > campaigns.sql
mysqldump -u root hunter campaigns_cstm > campaigns_cstm.sql
mysqldump -u root hunter cases > cases.sql
mysqldump -u root hunter cases_cstm > cases_cstm.sql
mysqldump -u root hunter leads > leads.sql
mysqldump -u root hunter leads_cstm > leads_cstm.sql
mysqldump -u root hunter opportunities > opportunities.sql
mysqldump -u root hunter opportunities_cstm > opportunities_cstm.sql
mysqldump -u root hunter bhc_branchhealthchecks > bhc_branchhealthchecks.sql
mysqldump -u root hunter bhc_branchhealthchecks_cstm > bhc_branchhealthchecks_cstm.sql
mysqldump -u root hunter fst_field_service_tickets > fst_field_service_tickets.sql
mysqldump -u root hunter fst_field_service_tickets_cstm > fst_field_service_tickets_cstm.sql
mysqldump -u root hunter nl_number_lookup > nl_number_lookup.sql
mysqldump -u root hunter jr_fsm_sites > jr_fsm_sites.sql
mysqldump -u root hunter jr_fsm_sites_cstm > jr_fsm_sites_cstm.sql
mysqldump -u root hunter hml_hunter_my_list > hml_hunter_my_list.sql
mysqldump -u root hunter js_fxl_my_list > js_fxl_my_list.sql
mysqldump -u root hunter meetings > meetings.sql
mysqldump -u root hunter meetings_cstm > meetings_cstm.sql
mysqldump -u root hunter notes > notes.sql
mysqldump -u root hunter notes_cstm > notes_cstm.sql
mysqldump -u root hunter campaigns > campaigns.sql
mysqldump -u root hunter campaigns_cstm > campaigns_cstm.sql
mysqldump -u root hunter gm_courses > gm_courses.sql
mysqldump -u root hunter levjl_grades > levjl_grades.sql
mysqldump -u root hunter tasks > tasks.sql
mysqldump -u root hunter tasks_cstm > tasks_cstm.sql
mysqldump -u root hunter hi_homeowners > hi_homeowners.sql
mysqldump -u root hunter contacts_fst_field_service_tickets_1_c > contacts_fst_field_service_tickets_1_c.sql
mysqldump -u root hunter fst_field_service_tickets_accounts_c > fst_field_service_tickets_accounts_c.sql
mysqldump -u root hunter calls > calls.sql
mysqldump -u root hunter calls_contacts > calls_contacts.sql
mysqldump -u root hunter calls_leads > calls_leads.sql
mysqldump -u root hunter meetings_contacts > meetings_contacts.sql
mysqldump -u root hunter meetings_leads > meetings_leads.sql
mysqldump -u root hunter jr_fsm_sites_fst_field_service_tickets_c > jr_fsm_sites_fst_field_service_tickets_c.sql
mysqldump -u root hunter email_addr_bean_rel > email_addr_bean_rel.sql
mysqldump -u root hunter email_addresses > email_addresses.sql

zip sugar_data.zip *.sql
rm *.sql

DROP TABLE IF EXISTS mig_distributor_health_check;
CREATE TABLE mig_distributor_health_check (
    External_ID__c varchar(36) NOT NULL PRIMARY KEY,
    Name varchar(255) NULL,
    q_br_01__c varchar(255) NULL,
    q_br_03__c varchar(255) NULL,
    q_br_04__c varchar(255) NULL,
    q_br_05__c varchar(255) NULL,
    q_br_06__c varchar(255) NULL,
    q_hu_04__c varchar(255) NULL,
    q_hu_05__c varchar(255) NULL,
    q_hu_06__c varchar(255) NULL,
    q_hu_07__c varchar(255) NULL,
    q_hu_08__c varchar(255) NULL,
    q_hu_09__c varchar(255) NULL,
    q_fxl_04__c varchar(255) NULL,
    q_fxl_05__c varchar(255) NULL,
    q_fxl_06__c varchar(255) NULL,
    q_fxl_07__c varchar(255) NULL,
    q_fxl_08__c varchar(255) NULL,
    q_fxl_09__c varchar(255) NULL,
    grade_branch__c varchar(255) NULL,
    grade_hunter__c varchar(255) NULL,
    grade_fxl__c varchar(255) NULL,
    grade_overall__c varchar(255) NULL,
    rating_date__c varchar(255) NULL,
    score_branch1__c varchar(255) NULL,
    score_fxl1__c varchar(255) NULL,
    score_hunter1__c varchar(255) NULL,
    score_overall1__c varchar(255) NULL,
    fxl_only_c__c varchar(255) NULL,
    fxl_share_landscape_light__c varchar(255) NULL,
    fxl_share_light_rpt__c varchar(255) NULL,
    hunter_share_irri_pct_rpt__c varchar(255) NULL,
    hunter_share_irri_sales__c varchar(255) NULL,
    notes_distr_exp__c TEXT,
    notes_fxl__c TEXT,
    notes_hunter_rescom__c TEXT,
    store_sales_pct_irri__c varchar(255) NULL,
    store_sales_pct_irri_prt__c varchar(255) NULL,
    store_sales_pct_lighting__c varchar(255) NULL,
    store_sales_pct_lighting_rpt__c varchar(255) NULL,
    store_sales_pct_other__c varchar(255) NULL,
    store_sales_pct_other_rpt__c varchar(255) NULL,
    store_sales_pct_total_forui__c varchar(255) NULL,
    dhc_scope_c__c varchar(255) NULL,
    Distributor_Account__c varchar(255) NULL,
	OwnerId char(36) DEFAULT NULL,
	CreatedById char(36) DEFAULT NULL,
	CreatedDate datetime DEFAULT NULL
);

INSERT INTO mig_distributor_health_check (
    External_ID__c,
    Name,
    q_br_01__c,
    q_br_03__c,
    q_br_04__c,
    q_br_05__c,
    q_br_06__c,
    q_hu_04__c,
    q_hu_05__c,
    q_hu_06__c,
    q_hu_07__c,
    q_hu_08__c,
    q_hu_09__c,
    q_fxl_04__c,
    q_fxl_05__c,
    q_fxl_06__c,
    q_fxl_07__c,
    q_fxl_08__c,
    q_fxl_09__c,
    grade_branch__c,
    grade_hunter__c,
    grade_fxl__c,
    grade_overall__c,
    rating_date__c,
    score_branch1__c,
    score_fxl1__c,
    score_hunter1__c,
    score_overall1__c,
    fxl_only_c__c,
    fxl_share_landscape_light__c,
    fxl_share_light_rpt__c,
    hunter_share_irri_pct_rpt__c,
    hunter_share_irri_sales__c,
    notes_distr_exp__c,
    notes_fxl__c,
    notes_hunter_rescom__c,
    store_sales_pct_irri__c,
    store_sales_pct_irri_prt__c,
    store_sales_pct_lighting__c,
    store_sales_pct_lighting_rpt__c,
    store_sales_pct_other__c,
    store_sales_pct_other_rpt__c,
    store_sales_pct_total_forui__c,
    dhc_scope_c__c,
    Distributor_Account__c,
    OwnerId, 
    CreatedById, 
    CreatedDate
)(
    SELECT
        bhc.id,
        bhc.name,
        bhc.q_br_01,
        bhc.q_br_03,
        bhc.q_br_04,
        bhc.q_br_05,
        bhc.q_br_06,
        bhc.q_hu_04,
        bhc.q_hu_05,
        bhc.q_hu_06,
        bhc.q_hu_07,
        bhc.q_hu_08,
        bhc.q_hu_09,
        bhc.q_fxl_04,
        bhc.q_fxl_05,
        bhc.q_fxl_06,
        bhc.q_fxl_07,
        bhc.q_fxl_08,
        bhc.q_fxl_09,
        bhc.grade_branch,
        bhc.grade_hunter,
        bhc.grade_fxl,
        bhc.grade_overall,
        bhc.rating_date,
        bhcc.score_branch1_c,
        bhcc.score_fxl1_c,
        bhcc.score_hunter1_c,
        bhcc.score_overall1_c,
        bhcc.fxl_only_c,
        bhcc.fxl_share_landscape_light_c,
        bhcc.fxl_share_light_rpt_c,
        bhcc.hunter_share_irri_pct_rpt_c,
        bhcc.hunter_share_irri_sales_c,
        bhcc.notes_distr_exp_c,
        bhcc.notes_fxl_c,
        bhcc.notes_hunter_rescom_c,
        bhcc.store_sales_pct_irri_c,
        bhcc.store_sales_pct_irri_prt_c,
        bhcc.store_sales_pct_lighting_c,
        bhcc.store_sales_pct_lighting_rpt_c,
        bhcc.store_sales_pct_other_c,
        bhcc.store_sales_pct_other_rpt_c,
        bhcc.store_sales_pct_total_forui_c,
        bhcc.dhc_scope_c,
        abhc.accounts_bhc_branchhealthchecks_1accounts_ida,
        owner_user.id,
        creator.id,
        bhc.date_entered
    FROM 
    hunter.bhc_branchhealthchecks bhc
    INNER JOIN hunter.bhc_branchhealthchecks_cstm bhcc ON bhcc.id_c = bhc.id 
    INNER JOIN hunter.accounts_bhc_branchhealthchecks_1_c abhc ON abhc.accounts_bhc_branchhealthchecks_1bhc_branchhealthchecks_idb = bhc.id
    LEFT OUTER JOIN ref_users owner_user ON owner_user.sugar_id = bhc.assigned_user_id AND bhc.assigned_user_id <> ''
    LEFT OUTER JOIN ref_users creator ON creator.sugar_id = bhc.created_by AND bhc.created_by <> ''
    WHERE bhc.deleted = 0
);

select '';
select count(*) NumberOfRecords from mig_distributor_health_check;

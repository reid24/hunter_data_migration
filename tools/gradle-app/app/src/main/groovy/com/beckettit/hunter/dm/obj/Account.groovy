/*
 * This Groovy source file was generated by the Gradle 'init' task.
 */
package com.beckettit.hunter.dm.obj

import com.beckettit.Env
import com.beckettit.transform.*
import com.beckettit.process.Util
import com.beckettit.salesforce.*
import com.beckettit.salesforce.soap.*
import com.beckettit.jdbc.*

class Account {

    public static ObjectDef getExtractObjectDef(){
        ObjectDef objDef = new ObjectDef(
            [
                [name:"id", type:"varchar(20)", sfdcField: "Id"],
                [name:"external_id", type:"varchar(255) primary key", sfdcField: "External_ID__c"]
            ]
        )
        objDef.table = "ref_account"
        objDef.sobjType = "Account"
        objDef.soql = Util.getSOQL(objDef, "WHERE External_ID__c != NULL")
        return objDef
    }

    public static ObjectDef getInsertParentsObjectDef(){
        ObjectDef objDef = new ObjectDef(
            [
                [name:"rewards_points_earned_monthl__c", type:"varchar(255)", sfdcField: "rewards_points_earned_monthl__c"],
                [name:"number_of_installation_crews__c", type:"varchar(255)", sfdcField: "number_of_installation_crews__c"],
                [name:"management_company__c", type:"varchar(255)", sfdcField: "Management_Company__c"],
                [name:"annual_revenue__c", type:"varchar(255)", sfdcField: "AnnualRevenue"],
                [name:"services__c", type:"varchar(255)", sfdcField: "services__c"],
                [name:"sso_account_name__c", type:"varchar(255)", sfdcField: "sso_account_name__c"],
                [name:"hsn_expiration_date__c", type:"varchar(255)", sfdcField: "hsn_expiration_date__c"],
                [name:"dm__c", type:"varchar(255)", sfdcField: "dm__c"],
                [name:"Website", type:"varchar(255)", sfdcField: "Website"],
                [name:"rotor_age__c", type:"varchar(255)", sfdcField: "rotor_age__c"],
                [name:"control_system__c", type:"varchar(255)", sfdcField: "control_system__c"],
                [name:"CreatedById", type:"varchar(255)", sfdcField: "CreatedById"],
                [name:"phone_alternate__c", type:"varchar(255)", sfdcField: "phone_alternate__c"],
                [name:"control_system_age__c", type:"varchar(255)", sfdcField: "control_system_age__c"],
                [name:"rotor_count__c", type:"varchar(255)", sfdcField: "rotor_count__c"],
                [name:"ShippingStateCode", type:"varchar(255)", sfdcField: "ShippingStateCode"],
                [name:"year_established__c", type:"varchar(255)", sfdcField: "year_established__c"],
                [name:"hydrawise_id__c", type:"varchar(255)", sfdcField: "hydrawise_id__c"],
                [name:"dist_lighting_2018__c", type:"varchar(255)", sfdcField: "dist_lighting_2018__c"],
                [name:"customer_type_category__c", type:"varchar(255)", sfdcField: "customer_type_category__c"],
                [name:"email_address__c", type:"varchar(255)", sfdcField: "email_address__c"],
                [name:"dist_lighting_2019__c", type:"varchar(255)", sfdcField: "dist_lighting_2019__c"],
                [name:"hpp_secondary_contact__c", type:"varchar(255)", sfdcField: "hpp_secondary_contact__c"],
                [name:"rewards_points_redeemed_mont__c", type:"varchar(255)", sfdcField: "rewards_points_redeemed_mont__c"],
                [name:"oem__c", type:"varchar(255)", sfdcField: "oem__c"],
                [name:"hunter_preferred_balance__c", type:"varchar(255)", sfdcField: "hunter_preferred_balance__c"],
                [name:"ShippingCity", type:"varchar(255)", sfdcField: "ShippingCity"],
                [name:"central_control_brand__c", type:"varchar(255)", sfdcField: "central_control_brand__c"],
                [name:"referral_program__c", type:"varchar(255)", sfdcField: "referral_program__c"],
                [name:"BillingStreet", type:"varchar(255)", sfdcField: "BillingStreet"],
                [name:"lighting_2016__c", type:"varchar(255)", sfdcField: "lighting_2016__c"],
                [name:"Markets__c", type:"varchar(255)", sfdcField: "Markets__c"],
                [name:"res_light_ref_req__c", type:"varchar(255)", sfdcField: "res_light_ref_req__c"],
                [name:"hpp_secondary_contact_email__c", type:"varchar(255)", sfdcField: "hpp_secondary_contact_email__c"],
                [name:"lighting_2017__c", type:"varchar(255)", sfdcField: "lighting_2017__c"],
                [name:"sales_reporting_number__c", type:"varchar(255)", sfdcField: "sales_reporting_number__c"],
                [name:"course_category__c", type:"varchar(255)", sfdcField: "course_category__c"],
                [name:"irrigation_install_projects__c", type:"varchar(255)", sfdcField: "irrigation_install_projects__c"],
                [name:"ShippingCountryCode", type:"varchar(255)", sfdcField: "ShippingCountryCode"],
                [name:"next_contact_due_date__c", type:"varchar(255)", sfdcField: "next_contact_due_date__c"],
                [name:"customer_marketing_priority__c", type:"varchar(255)", sfdcField: "customer_marketing_priority__c"],
                [name:"distributor_rep__c", type:"varchar(255)", sfdcField: "distributor_rep__c"],
                [name:"BillingPostalCode", type:"varchar(255)", sfdcField: "BillingPostalCode"],
                [name:"ShippingPostalCode", type:"varchar(255)", sfdcField: "ShippingPostalCode"],
                [name:"lighting_2018__c", type:"varchar(255)", sfdcField: "lighting_2018__c"],
                [name:"last_visit_date__c", type:"varchar(255)", sfdcField: "last_visit_date__c"],
                [name:"golf_holes_type__c", type:"varchar(255)", sfdcField: "golf_holes_type__c"],
                [name:"lighting_2019__c", type:"varchar(255)", sfdcField: "lighting_2019__c"],
                [name:"number_of_holes__c", type:"varchar(255)", sfdcField: "number_of_holes__c"],
                [name:"hunter_pilot_course__c", type:"varchar(255)", sfdcField: "hunter_pilot_course__c"],
                [name:"days_since_last_contact__c", type:"varchar(255)", sfdcField: "days_since_last_contact__c"],
                [name:"OwnerId", type:"varchar(255)", sfdcField: "OwnerId"],
                [name:"BillingState", type:"varchar(255)", sfdcField: "BillingState"],
                [name:"res_irr_ref_req__c", type:"varchar(255)", sfdcField: "res_irr_ref_req__c"],
                [name:"Business_Unit__c", type:"varchar(255)", sfdcField: "Business_Unit__c"],
                [name:"Fax", type:"varchar(255)", sfdcField: "Fax"],
                [name:"last_contact__c", type:"varchar(255)", sfdcField: "last_contact__c"],
                [name:"rewards_points_at_risk__c", type:"varchar(255)", sfdcField: "rewards_points_at_risk__c"],
                [name:"course_opening_year__c", type:"varchar(255)", sfdcField: "course_opening_year__c"],
                [name:"BillingCountryCode", type:"varchar(255)", sfdcField: "BillingCountryCode"],
                [name:"Description", type:"varchar(255)", sfdcField: "Description"],
                [name:"irrigation_2016__c", type:"varchar(255)", sfdcField: "irrigation_2016__c"],
                [name:"irrigation_2017__c", type:"varchar(255)", sfdcField: "irrigation_2017__c"],
                [name:"BillingStateCode", type:"varchar(255)", sfdcField: "BillingStateCode"],
                [name:"golf_irrigation_installation__c", type:"varchar(255)", sfdcField: "golf_irrigation_installation__c"],
                [name:"rewards_point_balance__c", type:"varchar(255)", sfdcField: "rewards_point_balance__c"],
                [name:"irrigation_2018__c", type:"varchar(255)", sfdcField: "irrigation_2018__c"],
                [name:"preferred_language_list__c", type:"varchar(255)", sfdcField: "preferred_language_list__c"],
                [name:"irrigation_2019__c", type:"varchar(255)", sfdcField: "irrigation_2019__c"],
                [name:"pcp_points_on_hold__c", type:"varchar(255)", sfdcField: "pcp_points_on_hold__c"],
                [name:"level__c", type:"varchar(255)", sfdcField: "level__c"],
                [name:"mailing_preference__c", type:"varchar(255)", sfdcField: "mailing_preference__c"],
                [name:"rotor_brand__c", type:"varchar(255)", sfdcField: "rotor_brand__c"],
                [name:"controller_brand_type__c", type:"varchar(255)", sfdcField: "controller_brand_type__c"],
                [name:"hunter_golf_customer__c", type:"varchar(255)", sfdcField: "hunter_golf_customer__c"],
                [name:"course_type__c", type:"varchar(255)", sfdcField: "course_type__c"],
                [name:"specialty_list__c", type:"varchar(255)", sfdcField: "specialty_list__c"],
                [name:"ParentId", type:"varchar(255)", sfdcField: "ParentId"],
                [name:"expired__c", type:"varchar(255)", sfdcField: "expired__c"],
                [name:"BillingCity", type:"varchar(255)", sfdcField: "BillingCity"],
                [name:"hunter_golf_reference__c", type:"varchar(255)", sfdcField: "hunter_golf_reference__c"],
                [name:"hydrawise_customers__c", type:"varchar(255)", sfdcField: "hydrawise_customers__c"],
                [name:"next_renewal_date__c", type:"varchar(255)", sfdcField: "next_renewal_date__c"],
                [name:"days_until_hsn_expiration__c", type:"varchar(255)", sfdcField: "days_until_hsn_expiration__c"],
                [name:"Account_Type__c", type:"varchar(255)", sfdcField: "Account_Type__c"],
                [name:"points_about_to_expire__c", type:"varchar(255)", sfdcField: "points_about_to_expire__c"],
                [name:"facility_id__c", type:"varchar(255)", sfdcField: "facility_id__c"],
                [name:"rotor_type__c", type:"varchar(255)", sfdcField: "rotor_type__c"],
                [name:"hsn_start_date__c", type:"varchar(255)", sfdcField: "hsn_start_date__c"],
                [name:"Phone", type:"varchar(255)", sfdcField: "Phone"],
                [name:"hpp_primary_contact_email__c", type:"varchar(255)", sfdcField: "hpp_primary_contact_email__c"],
                [name:"Name", type:"varchar(255)", sfdcField: "Name"],
                [name:"irrigation_design_projects__c", type:"varchar(255)", sfdcField: "irrigation_design_projects__c"],
                [name:"dist_irrigation_2018__c", type:"varchar(255)", sfdcField: "dist_irrigation_2018__c"],
                [name:"returned_mail_bad_address__c", type:"varchar(255)", sfdcField: "returned_mail_bad_address__c"],
                [name:"External_ID__c", type:"varchar(255)", sfdcField: "External_ID__c"],
                [name:"architect__c", type:"varchar(255)", sfdcField: "architect__c"],
                [name:"dist_irrigation_2019__c", type:"varchar(255)", sfdcField: "dist_irrigation_2019__c"],
                [name:"ShippingState", type:"varchar(255)", sfdcField: "ShippingState"],
                [name:"rewards_id__c", type:"varchar(255)", sfdcField: "rewards_id__c"],
                [name:"rewards_primary_contact__c", type:"varchar(255)", sfdcField: "rewards_primary_contact__c"],
                [name:"county__c", type:"varchar(255)", sfdcField: "county__c"],
                [name:"Account_Status__c", type:"varchar(255)", sfdcField: "Account_Status__c"],
                [name:"pilot_version__c", type:"varchar(255)", sfdcField: "pilot_version__c"],
                [name:"ShippingStreet", type:"varchar(255)", sfdcField: "ShippingStreet"],
                [name:"CreatedDate", type:"varchar(255)", sfdcField: "CreatedDate"],
                [name:"rewards_primary_contact_emai__c", type:"varchar(255)", sfdcField: "rewards_primary_contact_emai__c"],
                [name:"Ship_To_Number__c", type:"varchar(255)", sfdcField: "Ship_To_Number__c"],
                [name:"hpp_primary_contact__c", type:"varchar(255)", sfdcField: "hpp_primary_contact__c"],
                [name:"RecordTypeId", type:"varchar(255)", sfdcField: "RecordTypeId"],
                [name:"golf_distributor_billing__c", type:"varchar(255)", sfdcField: "golf_distributor_billing__c"],
                [name:"NumberOfEmployees", type:"varchar(255)", sfdcField: "NumberOfEmployees"],
                [name:"hmds_id__c", type:"varchar(255)", sfdcField: "hmds_id__c"],
                [name:"hunter_service_network__c", type:"varchar(255)", sfdcField: "hunter_service_network__c"]
            ]
        )
        objDef.table = "mig_account"
        objDef.sobjType = "Account"
        objDef.externalIdField= "External_ID__c"
        return objDef
    }

    public static ObjectDef getUpdateParentsObjectDef() {
        ObjectDef objDef = getInsertParentsObjectDef()
        objDef.mapping.remove("CreatedById")
        objDef.mapping.remove("CreatedDate")
        return objDef
    }

    public static ObjectDef getInsertChildrenObjectDef() {
        ObjectDef objDef = getInsertParentsObjectDef()
        objDef.mapping.put("ParentId", [name:"ParentId", type:"varchar(255)", sfdcField: "ParentId", refExternalIdField: "External_ID__c"])
        return objDef
    }

    public static ObjectDef getUpdateChildrenObjectDef() {
        ObjectDef objDef = getInsertChildrenObjectDef()
        objDef.mapping.remove("CreatedById")
        objDef.mapping.remove("CreatedDate")
        return objDef
    }
}
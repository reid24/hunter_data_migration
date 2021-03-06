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

class Case {

    public static ObjectDef getExtractObjectDef(){
        ObjectDef objDef = new ObjectDef(
            [
                [name:"id", type:"varchar(20)", sfdcField: "Id"],
                [name:"external_id", type:"varchar(255) primary key", sfdcField: "External_ID__c"]
            ]
        )
        objDef.table = "ref_case"
        objDef.sobjType = "Case"
        objDef.soql = Util.getSOQL(objDef, "WHERE External_ID__c != NULL")
        return objDef
    }

    public static ObjectDef getInsertObjectDef(){
        ObjectDef objDef = new ObjectDef(
            [
                [name:"Description", type:"varchar(255)", sfdcField: "Description"],
                [name:"External_ID__c", type:"varchar(255)", sfdcField: "External_ID__c"],
                [name:"CreatedById", type:"varchar(255)", sfdcField: "CreatedById"],
                [name:"CreatedDate", type:"varchar(255)", sfdcField: "CreatedDate"],
                [name:"Resolution_Notes__c", type:"varchar(255)", sfdcField: "Resolution_Notes__c"],
                [name:"ContactId", type:"varchar(255)", sfdcField: "ContactId", refExternalIdField: "External_ID__c"],
                [name:"Date_of_Visit__c", type:"varchar(255)", sfdcField: "Date_of_Visit__c"],
                [name:"OwnerId", type:"varchar(255)", sfdcField: "OwnerId"],
                [name:"Emergency_Visit_Required__c", type:"varchar(255)", sfdcField: "Emergency_Visit_Required__c"],
                [name:"Status", type:"varchar(255)", sfdcField: "Status"],
                [name:"Reason", type:"varchar(255)", sfdcField: "Reason"],
                [name:"AccountId", type:"varchar(255)", sfdcField: "AccountId", refExternalIdField: "External_ID__c"],
                [name:"ContactPhone", type:"varchar(255)", sfdcField: "SuppliedPhone"],
                [name:"Duration_Hours__c", type:"varchar(255)", sfdcField: "Duration_Hours__c"],
                [name:"Desired_Visit_By__c", type:"varchar(255)", sfdcField: "Desired_Visit_By__c"],
            ]
        )
        objDef.table = "mig_case"
        objDef.sobjType = "Case"
        objDef.externalIdField= "External_ID__c"
        return objDef
    }

    public static ObjectDef getUpdateObjectDef() {
        ObjectDef objDef = getInsertObjectDef()
        objDef.mapping.remove("CreatedById")
        objDef.mapping.remove("CreatedDate")
        return objDef
    }

}
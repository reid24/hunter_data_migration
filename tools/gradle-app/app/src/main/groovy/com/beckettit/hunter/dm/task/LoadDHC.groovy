/*
 * This Groovy source file was generated by the Gradle 'init' task.
 */
package com.beckettit.hunter.dm.task

import com.beckettit.Env
import com.beckettit.transform.*
import com.beckettit.process.Util
import com.beckettit.salesforce.*
import com.beckettit.salesforce.soap.*
import com.beckettit.jdbc.*
import com.beckettit.hunter.dm.obj.*
import org.apache.log4j.Logger

class LoadDHC extends BaseTask {
    Boolean insert = false
    Boolean update = false

    public LoadDHC(String[] args){
        super(args)
        insert = args?.findAll {
            it == '--insert'
        }.size() > 0

        update = args?.findAll {
            it == '--update'
        }.size() > 0
    }

    public void run() {
        if(insert){
            ObjectDef objDef = DHC.getInsertObjectDef()
            String query = """
            select * from (
                select ${objDef.getMappedColumnsForQuery('mig')} from ${objDef.table} mig
                left outer join ref_dhc ref on ref.external_id = mig.External_ID__c 
                where ref.id is null and mig.OwnerId is not null
            ) m
            """
            println query
            soap.upsertAll("insert-dhc-owner", objDef, query, [batchSize:200])
            
            query = """
            select * from (
                select ${objDef.getMappedColumnsForQuery('mig')} from ${objDef.table} mig
                left outer join ref_dhc ref on ref.external_id = mig.External_ID__c 
                where ref.id is null and mig.OwnerId is null
            ) m
            """
            println query
            objDef.mapping.remove("OwnerId")
            soap.upsertAll("insert-dhc-noowner", objDef, query, [batchSize:200])
            Util.backupSaveResults(jdbc, "dhc")
        }

        if(update){
            ObjectDef objDef = DHC.getUpdateObjectDef()
            String query = """
            select * from (
                select ${objDef.getMappedColumnsForQuery('mig')} from ${objDef.table} mig
                inner join ref_dhc ref on ref.external_id = mig.External_ID__c 
                where mig.OwnerId is not null
            ) m
            """
            println query
            soap.upsertAll("insert-dhc-owner", objDef, query, [batchSize:200])
            
            query = """
            select * from (
                select ${objDef.getMappedColumnsForQuery('mig')} from ${objDef.table} mig
                inner join ref_dhc ref on ref.external_id = mig.External_ID__c 
                where mig.OwnerId is null
            ) m
            """
            println query
            objDef.mapping.remove("OwnerId")
            soap.upsertAll("insert-dhc-noowner", objDef, query, [batchSize:200])
            Util.backupSaveResults(jdbc, "dhc")
        }


    }

    //main task
    static void main(String[] args) {
        LoadDHC proc = new LoadDHC(args)
        proc.run()
    }
}

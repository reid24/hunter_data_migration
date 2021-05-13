package com.beckettit.process;

import com.beckettit.salesforce.soap.*;
import com.beckettit.transform.*;
import com.beckettit.jdbc.*;
import org.apache.log4j.Logger

public abstract class Util {
  private static final Logger log = Logger.getLogger(Util.class)

  public static void extract(SOAPClient soap, JdbcClient jdbc, ObjectDef objDef) {
    log.debug "extract:start"
    dropAndCreateTable(objDef, jdbc)
    soap.query(objDef, jdbc)
    log.debug "extract:end"
  }

  public static void upsert(SOAPClient soap, JdbcClient jdbc, ObjectDef objDef, String requestId, String upsertCriteria, Integer batchSize=200) {
    log.debug "upsert:start"
    jdbc.execute "delete from save_results where request_id = '"+requestId+"'"
    soap.upsertAll(requestId, objDef, getUpsertSql(objDef, upsertCriteria), [batchSize:batchSize])
    log.debug "upsert:end"
  }

  public static String getUpsertSql(ObjectDef objDef, String criteria=null){
    String s = "select * from ${objDef.table}"
    if(criteria != null) s += " " + criteria
    return s
  }


  public static String getSOQL(ObjectDef objDef, String criteria=null){
    String soql = "SELECT "
    soql += objDef.mapping.values().findAll{ it.sfdcField != null }.collect{ it.sfdcField }.join(",")
    soql += " FROM ${objDef.sobjType}"
    if(criteria != null) {
      soql += " "
      soql += criteria
    }
    return soql
  }

  public static Map<String,String> getMapping(ObjectDef src, ObjectDef dest, Map<String,String> transformMapping){
    Map<String,String> mapping = [:]
    src.mapping.values().findAll {
      !transformMapping.containsKey(it.name) && !transformMapping.values().contains(it.name) && dest.mapping.containsKey(it.name)
    }.each {
      mapping.put(it.name, it.name)
    }
    mapping.putAll(transformMapping)
    return mapping
  }

  public static void dropAndCreateTable(ObjectDef objDef, JdbcClient jdbc){
    jdbc.execute "DROP TABLE IF EXISTS ${objDef.table}"
    String createTable = "CREATE TABLE ${objDef.table} (" +
      objDef.mapping.values().collect{ "\"" + it.name + "\" " + it.type }.join(",\n") +
    ")"
    jdbc.execute createTable
  }

  public static void doMappedFieldsInsert(ObjectDef extractObjDef, ObjectDef objDef, JdbcClient jdbc, Map<String,String> transformMapping){
    def mapping = getMapping(extractObjDef, objDef, transformMapping)

    String insertStmt = "INSERT INTO ${objDef.table} ("+
      mapping.values().collect{"\"${it}\""}.join(",") +
      ") (SELECT " +
      mapping.keySet().collect{"\"${it}\""}.join(",") +
      " FROM ${extractObjDef.table})"
    jdbc.execute insertStmt
  }

  //options:
  //requestId
  //soap: SoapClient
  //jdbc: JdbcClient
  //objDef: ObjectDef
  //proceed : Closure(jdbc) - to know whether to proceed or not
  //transform : Closure(jdbc)
  //sqlQuery : String (query that will select the records to upsert)
  //batchSize : Batch size to use in the call
  //sleep : Time in msec to sleep
  public static void delayedUpdate(options){
    Util.extract(options.soap, options.jdbc, options.objDef)
    if(options.proceed == null) {
      options.proceed = { jdbc ->
        def sqlInstance = jdbc.getSqlInstance()
        Boolean proceed = false
        String countSql = "select count(*) c from ${options.objDef.table}"
        sqlInstance.eachRow(countSql) {
          proceed = (it.c > 0)
        }
        return proceed
      }
    }
    if(options.batchSize == null) options.batchSize = 1
    if(options.limit == null) options.limit = 1
    if(options.sqlQuery == null) options.sqlQuery = "select * from ${options.objDef.table} limit ${options.limit}".toString()
    if(options.sleep == null) options.sleep = 0

    Boolean proceed = options.proceed.call(options.jdbc)
    int iteration = 1

    while(proceed) {
      log.debug "Iteration ${iteration}"
      options.transform.call(options.jdbc)
      options.soap.updateAll(options.requestId, options.objDef, options.sqlQuery, [batchSize:options.batchSize])
      if(iteration > 1) Thread.sleep(options.sleep)
      Util.extract(options.soap, options.jdbc, options.objDef)
      proceed = options.proceed.call(options.jdbc)
      iteration++
    }
  }

  public static ObjectDef getObjectDefFromDescribe(SOAPClient soap, String sobjType, criteria=null, includeFieldClosure={
    it.createable || it.name == "Id"
  }) {
      def desc = soap.getDescribeSObject(sobjType)
      //println desc

      ObjectDef objDef = new ObjectDef()
      objDef.table = "extract_${sobjType.toLowerCase()}"
      objDef.sobjType = sobjType
      
      desc.fields.each { f ->
          if(includeFieldClosure(f)) {
              def mapping = [
                  name: f.name,
                  type: sfdc2postgresType(""+f.type),
                  sfdcField: f.name
              ]
              objDef.mapping.put(mapping.name, mapping)
          }
      }
      
      objDef.soql = Util.getSOQL(objDef, criteria)
      return objDef
  }

  public static void extractAll(SOAPClient soap, JdbcClient jdbc, String sobjType, String tableName=null, String criteria=null, includeFieldClosure = null) {
      ObjectDef objDef = null
      if(includeFieldClosure == null)
        objDef = getObjectDefFromDescribe(soap, sobjType, criteria)
      else
        objDef = getObjectDefFromDescribe(soap, sobjType, criteria, includeFieldClosure)
      //println objDef.soql
      if(tableName != null) objDef.table = tableName
      Util.extract(soap, jdbc, objDef)
  }

  private static String sfdc2postgresType(String sfdcType) {
      def map = [
          "id":"character varying",
          "string":"character varying",
          "textarea":"character varying",
          "picklist":"character varying",
          "url":"character varying",
          "reference":"character varying",
          "multipicklist":"character varying",
          "boolean":"bool",
          "double":"float8",
          "percent":"float8",
          "currency":"float8",
          "datetime":"timestamp"
      ]
      return map[sfdcType] ? map[sfdcType] : sfdcType
  }

}

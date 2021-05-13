package com.beckettit.jdbc;

import groovy.sql.Sql
import org.apache.log4j.Logger
import com.beckettit.Env

class JdbcClient {
  private static final Logger log = Logger.getLogger(JdbcClient.class)
  def url
  def username
  def password
  def driver

  def initProfile(String profile) {
    Properties p = new Properties()
    //p.load(new File(getClass().getClassLoader().getResource("jdbc.properties").getFile()).newDataInputStream())
    p.load(Env.getResourceFile("jdbc.properties").newDataInputStream())
    url = p.getProperty("${profile}.url")
    username = p.getProperty("${profile}.username")
    password = p.getProperty("${profile}.password")
    driver = p.getProperty("${profile}.driver")
    log.debug "driver=${driver}"
  }

  def getSqlInstance() {
    return Sql.newInstance(url, username, password, driver)
  }

  def execute(String stmt){
    def sql = null
    try{
      sql = Sql.newInstance(url, username, password, driver)
      log.debug stmt
      sql.execute(stmt)
    }finally{
      if(sql != null) sql.close()
    }
  }

  def execute(String stmt, params){
    
    def sql = Sql.newInstance(url, username, password, driver)
    log.debug stmt
    sql.execute(stmt, params)
    sql.close()
  }

  def executeBatch(stmt, listOfValues){
    log.debug stmt + ":" + listOfValues?.size()
    def sql = Sql.newInstance(url, username, password, driver)
    sql.connection.setAutoCommit(false)
    int i = 0
    sql.withBatch(stmt) { ps ->
      listOfValues.each { values ->
          ps.addBatch(values)
          if(i%1000 ==0) log.debug "batch: ${i}"
          i++
      }
      ps.executeBatch()
    }
    sql.connection.setAutoCommit(true)
    sql.close()
  }

  def executeBatch(stmt, listOfValues, setClosure){
    def sql = Sql.newInstance(url, username, password, driver)
    def ps = sql.connection.prepareStatement(stmt)
    listOfValues.each { row ->
        ps.clearParameters()
        setClosure.call(ps, row)
        ps.addBatch()
    }
    ps.executeBatch()
    sql.close()
  }

//   def getSaveResultsSummary(request_id){
//     def result = [
//       success: 0,
//       failure: 0,
//       errors: []
//     ]
//     def sql = getSqlInstance()
//     sql.eachRow("select success, count(*) c from save_results where request_id = ? group by success", [request_id]) {
//       if(it.success) result.success = it.c
//       else result.failure = it.c
//     }
//
//     sql.eachRow("select id, error_message from save_results where request_id = ? and success = false", [request_id]) {
//       result.errors << "Id: ${it.id}: error: ${it.error_message}"
//     }
//
//     String summary = """${request_id}
// Success: ${result.success}
// Failure: ${result.failure}"""
//
//     if(result.errors.size() > 0) {
//       summary += "\nErrors:"
//       result.errors.each {
//         summary += "\n" + it
//       }
//     }
//
//     return summary
//
//   }

  def getSaveResultsSummary(request_id){
    def result = [
      count: 0,
      success: 0,
      errors: []
    ]
    def sql = getSqlInstance()
    sql.eachRow("select count(distinct(external_id)) c from save_results where request_id = ?", [request_id]) {
      result.count = it.c
    }

    sql.eachRow("select count(distinct(external_id)) c from save_results where request_id = ? and success = true", [request_id]) {
      result.success = it.c
    }

    sql.eachRow("select id, external_id, error_message, error_status, ts from save_results where request_id = ? and success = false and external_id not in (select distinct(external_id) from save_results where request_id = ? and success = true) order by ts asc", [request_id, request_id]) {
      result.errors << "External ID: ${it.external_id}\n${it.error_status} : ${it.error_message}\n${it.ts}"
    }

    String summary = """${request_id}
Attempts: ${result.count}
Success: ${result.success}"""

    if(result.errors.size() > 0) {
      summary += "\nErrors:"
      result.errors.each {
        summary += "\n---\n" + it
      }
    }

    return summary

  }

  def eachRow(String query, Closure clos) {
    log.debug query
    def sql = getSqlInstance()
    sql.eachRow(query) { row ->
      clos.call(row)
    }
    sql.close()
  }
}

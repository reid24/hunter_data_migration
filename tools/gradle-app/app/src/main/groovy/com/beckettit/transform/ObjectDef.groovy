package com.beckettit.transform;

import com.beckettit.salesforce.model.SObjectDescribe
import com.beckettit.Env

class ObjectDef {
  //jdbc
  def table
  def dbPK

  //SFDC
  def sobjType
  //to build soql query
  def soqlCriteria
  def soqlOrder
  def soqlLimit

  //or set explicit query
  def soql

  //SFDC->JDBC for query or JDBC->SFDC for CUD
  //also includes the jdbc field
  def mapping = [:]
  def externalIdField

  SObjectDescribe desc

  public ObjectDef(mappings = []) {
    addMappings(mappings)
  }

  ObjectDef addMappings(arrayOfStrings) {
    arrayOfStrings.each {
      if(it instanceof Map) {
        this.mapping.put(it.name, it)
      }else {
        this.mapping.put(it,[
          name: it,
          type: "character varying"
        ])
      }
    }
    this
  }

  // String getSoql(){
  //   String s = ""
  //   if(this.soql == null) s = "select " + mapping.values().findAll { it.sfdcField != null }.collect{ it.sfdcField }.unique().join(",") + " from ${sobjType}"
  //   else s = this.soql
  //   if(soqlCriteria != null) s += " where ${soqlCriteria}"
  //   if(soqlOrder != null) s += " order by ${soqlOrder}"
  //   if(soqlLimit != null) s += " limit ${soqlLimit}"
  // }

  String getSoqlMappedInsertStatement(){
    Properties p = new Properties()
    p.load(Env.getResourceFile("jdbc.properties").newDataInputStream())
    String driver = p.getProperty("${Env.getJdbcProfile()}.driver")

    println driver
    String enquoteChar = driver.indexOf("mysql") > 0 ? "`" : "\""

    def columns = mapping.values().findAll { it.sfdcField != null }.collect {
      "${enquoteChar}${it.name}${enquoteChar}"
    }.join(",")
    def values = mapping.values().findAll { it.sfdcField != null }.collect { "?" }.join(",")
    def stmt = "INSERT INTO ${table} (${columns}) VALUES(${values})"
    return stmt
  }

  String getInsertStatement(){
    def columns = mapping.values().collect {
      "\"${it.name}\""
    }.join(",")
    def values = mapping.values().collect { "?" }.join(",")
    def stmt = "INSERT INTO ${table} (${columns}) VALUES(${values})"
    return stmt
  }

  String getCreateTableStatement(){
    def columns = mapping.values().collect {
      "\"${it.name}\" ${it.type != null ? it.type : 'varchar'}"
    }.join(",\n")
    def stmt = "CREATE TABLE ${table}(\n${columns}\n)"
    return stmt
  }

  String getDropTableStatement(){
    return "DROP TABLE IF EXISTS ${table}"
  }

  String getMappedColumnsForQuery(String prefix=""){
    Properties p = new Properties()
    p.load(Env.getResourceFile("jdbc.properties").newDataInputStream())
    String driver = p.getProperty("${Env.getJdbcProfile()}.driver")

    String enquoteChar = driver.indexOf("mysql") > 0 ? "`" : "\""

    def columns = mapping.values().findAll { it.sfdcField != null }.collect {
      (prefix!="") ? "${prefix}.${enquoteChar}${it.name}${enquoteChar}" : "${enquoteChar}${it.name}${enquoteChar}"
    }.join(",")
    return columns
  }
}

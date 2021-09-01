package com.beckettit.salesforce.soap;

import com.sforce.ws.ConnectorConfig
import com.sforce.soap.partner.StatusCode
import com.sforce.soap.partner.PartnerConnection
import com.sforce.soap.partner.sobject.SObject
import java.text.SimpleDateFormat
import groovy.sql.Sql
import com.beckettit.transform.ObjectDef
import com.beckettit.Env
import com.beckettit.jdbc.JdbcClient
import org.apache.commons.beanutils.ConvertUtils
import org.apache.commons.beanutils.converters.DateTimeConverter
import org.apache.commons.beanutils.converters.DateConverter
import org.apache.log4j.Logger

class SOAPClient {
  private static final Logger log = Logger.getLogger(SOAPClient.class)
  def username
  def password
  def authEndpoint
  PartnerConnection connection
  JdbcClient jdbc

  public SOAPClient(){
    jdbc = new JdbcClient()
    jdbc.initProfile(Env.jdbcProfile)
  }

  public SOAPClient(JdbcClient jdbc){
    this.jdbc = jdbc
  }

  def initProfile(profile) {
    Properties p = new Properties()
    // p.load(new File(getClass().getClassLoader().getResource("soapClient.properties").getFile()).newDataInputStream())
    p.load(Env.getResourceFile("soapClient.properties").newDataInputStream())
    username = p.getProperty("${profile}.username")
    password = p.getProperty("${profile}.password")
    authEndpoint = p.getProperty("${profile}.authEndpoint")
  }

  def authenticate() {
    ConnectorConfig config = new ConnectorConfig()
    config.setUsername(username)
    config.setPassword(password)
    config.setAuthEndpoint(authEndpoint)

    try {
      connection = new PartnerConnection(config)
    }catch(Throwable e){
      log.debug("connection exception", e)
      log.debug "attempting reconnect"
      connection = new PartnerConnection(config)
    }
    log.debug "Authentication successful"
    log.debug "Username: ${username}"
    log.debug("SessionID: " + config.getSessionId())
    log.debug("Auth End Point: " + config.getAuthEndpoint())
    log.debug("Service End Point: " + config.getServiceEndpoint())
  }

  //query and return ALL results
  def query(String soql){
    def queryResult = null
    try {
      queryResult = connection.query(soql)
    }catch(Exception e){
      log.debug("caught connection exception", e)
      authenticate()
      queryResult = connection.query(soql)
    }
    Boolean done = false

    def i = 0
    def j = 0
    def recs = []

    while(!done) {
      queryResult.records.each { rec ->
        recs << rec
        i++
        // println i
      }
      j++
      //println j+":"+i
      //if(j > 10) System.exit(0)
      if(queryResult.isDone()) done = true
      else {
        log.debug "queryMore: ${recs.size()}"
        try {
          queryResult = connection.queryMore(queryResult.getQueryLocator())
        }catch(Exception e){
          log.debug("caught connection exception", e)
          authenticate()
          queryResult = connection.queryMore(queryResult.getQueryLocator())
        }
      }
    }

    recs
  }

  //query with closure, process each batch of results
  def query2(String soql, Closure clos=null){
    def queryResult = null
    try {
      queryResult = connection.query(soql)
    }catch(Exception e){
      log.debug("Caught connection exception:",e)
      authenticate()
      queryResult = connection.query(soql)
    }
    Boolean done = false

    def i = 0
    def j = 0
    def recs = []

    while(!done) {
      queryResult.records.each { rec ->
        recs << rec
        i++
      }
      j++
      if(queryResult.isDone()) {
        clos?.call(recs)
        done = true
      }else {
        clos?.call(recs)
        recs = []
        try {
          queryResult = connection.queryMore(queryResult.getQueryLocator())
        }catch(Exception e){
          log.debug("caught connection exception:",e)
          authenticate()
          queryResult = connection.queryMore(queryResult.getQueryLocator())
        }
      }
    }
  }

  def queryAll2(String soql, Closure clos=null){
    def queryResult = null
    try {
      queryResult = connection.queryAll(soql)
    }catch(Exception e){
      log.debug("Caught connection exception:",e)
      authenticate()
      queryResult = connection.queryAll(soql)
    }
    Boolean done = false

    def i = 0
    def j = 0
    def recs = []

    while(!done) {
      queryResult.records.each { rec ->
        recs << rec
        i++
      }
      j++
      if(queryResult.isDone()) {
        clos?.call(recs)
        done = true
      }else {
        clos?.call(recs)
        recs = []
        try {
          queryResult = connection.queryMore(queryResult.getQueryLocator())
        }catch(Exception e){
          log.debug("caught connection exception:",e)
          authenticate()
          queryResult = connection.queryMore(queryResult.getQueryLocator())
        }
      }
    }
  }  

  def query(ObjectDef objDef, JdbcClient jdbc) {
      log.debug "query: " + objDef.soql
      //def results = query(objDef.soql)
      def sql = Sql.newInstance(jdbc.url, jdbc.username, jdbc.password, jdbc.driver)
      log.debug "sql statement: " + objDef.getSoqlMappedInsertStatement()
      def preparedStatement = sql.connection.prepareStatement(objDef.getSoqlMappedInsertStatement())
      def desc = null
      try {
        desc = connection.describeSObject(objDef.sobjType)
      }catch(Exception e){
        log.debug("caught connection exception: ", e)
        authenticate()
        desc = connection.describeSObject(objDef.sobjType)
      }
      int count = 0

      query2(objDef.soql, { records ->
        count += records.size()
        log.debug "query: processing ${records.size()} of ${count}"
        records.each { result ->
          int i = 1
          preparedStatement.clearParameters()
          objDef.mapping.values().findAll{ it.sfdcField != null }.collect { column ->
            def sfdcFieldName = column.sfdcField
            //println sfdcFieldName
            def fieldDescribe = null
            // if(objDef.desc != null){
            //   fieldDescribe = objDef.desc?.fields[sfdcFieldName]
            // }else{
            desc.fields.each { f ->
              if(f.name == sfdcFieldName) fieldDescribe = f
            }
            String fieldType = fieldDescribe?.type?.toString()
            //log.debug "${sfdcFieldName} : ${fieldType}"
            // }
            //def fieldDescribe = objDef.desc?.fields[sfdcFieldName]
            def toks = sfdcFieldName.split("\\.")
            if(toks.length > 1) {
              def toksArr = toks as List
              def sobj = result.getField(toksArr.get(0))
              toksArr.remove(0)
              int len = toksArr.size()
              while(len > 0 && sobj != null) {
                sobj = sobj.getField(toksArr.get(0))
                //TODO: get field describe for nested type when field is not a string
                toksArr.remove(0)
                len = toksArr.size()
              }
              def value = column.transform ? column.transform.call(convert(sobj,fieldDescribe)) : convert(sobj,fieldDescribe)
              if(value != null && fieldType == 'date') preparedStatement.setDate(i, new java.sql.Date(value.time))
              else if(value != null && fieldType == 'datetime') preparedStatement.setTimestamp(i, new java.sql.Timestamp(value.time))
              else preparedStatement.setObject(i, value)
            } else {
              def value = column.transform ? column.transform.call(convert(result.getField(sfdcFieldName),fieldDescribe)) : convert(result.getField(sfdcFieldName),fieldDescribe)
              if(value != null && fieldType == 'date') preparedStatement.setDate(i, new java.sql.Date(value.time))
              else if(value != null && fieldType == 'datetime') preparedStatement.setTimestamp(i, new java.sql.Timestamp(value.time))
              else preparedStatement.setObject(i, value)
            }
            i++
          }
          preparedStatement.addBatch()
        }
        preparedStatement.executeBatch()
    })

      // System.exit(0)
      // log.debug "retrieved " + results.size() + " records"
      // log.debug objDef.getSoqlMappedInsertStatement()

      // results.each { result ->
      //   int i = 1
      //   preparedStatement.clearParameters()
      //   objDef.mapping.values().findAll{ it.sfdcField != null }.collect { column ->
      //     def sfdcFieldName = column.sfdcField
      //     //println sfdcFieldName
      //     def fieldDescribe = null
      //     // if(objDef.desc != null){
      //     //   fieldDescribe = objDef.desc?.fields[sfdcFieldName]
      //     // }else{
      //     desc.fields.each { f ->
      //       if(f.name == sfdcFieldName) fieldDescribe = f
      //     }
      //     // }
      //     //def fieldDescribe = objDef.desc?.fields[sfdcFieldName]
      //     def toks = sfdcFieldName.split("\\.")
      //     if(toks.length > 1) {
      //       def toksArr = toks as List
      //       def sobj = result.getField(toksArr.get(0))
      //       toksArr.remove(0)
      //       int len = toksArr.size()
      //       while(len > 0 && sobj != null) {
      //         sobj = sobj.getField(toksArr.get(0))
      //         toksArr.remove(0)
      //         len = toksArr.size()
      //       }
      //       def value = column.transform ? column.transform.call(convert(sobj,fieldDescribe)) : convert(sobj,fieldDescribe)
      //       if(value != null && fieldDescribe?.type == 'date') preparedStatement.setDate(i, new java.sql.Date(value.time))
      //       else if(value != null && fieldDescribe?.type == 'datetime') preparedStatement.setTimestamp(i, new java.sql.Timestamp(value.time))
      //       else preparedStatement.setObject(i, value)
      //     } else {
      //       def value = column.transform ? column.transform.call(convert(result.getField(sfdcFieldName),fieldDescribe)) : convert(result.getField(sfdcFieldName),fieldDescribe)
      //       if(value != null && fieldDescribe?.type == 'date') preparedStatement.setDate(i, new java.sql.Date(value.time))
      //       else if(value != null && fieldDescribe?.type == 'datetime') preparedStatement.setTimestamp(i, new java.sql.Timestamp(value.time))
      //       else preparedStatement.setObject(i, value)
      //     }
      //     i++
      //   }
      //   preparedStatement.addBatch()
      // }

      preparedStatement.executeBatch()

      sql.close()

  }

  def queryAll(ObjectDef objDef, JdbcClient jdbc) {
      log.debug "query: " + objDef.soql
      //def results = query(objDef.soql)
      def sql = Sql.newInstance(jdbc.url, jdbc.username, jdbc.password, jdbc.driver)
      log.debug "sql statement: " + objDef.getSoqlMappedInsertStatement()
      def preparedStatement = sql.connection.prepareStatement(objDef.getSoqlMappedInsertStatement())
      def desc = null
      try {
        desc = connection.describeSObject(objDef.sobjType)
      }catch(Exception e){
        log.debug("caught connection exception: ", e)
        authenticate()
        desc = connection.describeSObject(objDef.sobjType)
      }
      int count = 0

      queryAll2(objDef.soql, { records ->
        count += records.size()
        log.debug "queryAll: processing ${records.size()} of ${count}"
        records.each { result ->
          int i = 1
          preparedStatement.clearParameters()
          objDef.mapping.values().findAll{ it.sfdcField != null }.collect { column ->
            def sfdcFieldName = column.sfdcField
            //println sfdcFieldName
            def fieldDescribe = null
            // if(objDef.desc != null){
            //   fieldDescribe = objDef.desc?.fields[sfdcFieldName]
            // }else{
            desc.fields.each { f ->
              if(f.name == sfdcFieldName) fieldDescribe = f
            }
            String fieldType = fieldDescribe?.type?.toString()
            //log.debug "${sfdcFieldName} : ${fieldType}"
            // }
            //def fieldDescribe = objDef.desc?.fields[sfdcFieldName]
            def toks = sfdcFieldName.split("\\.")
            if(toks.length > 1) {
              def toksArr = toks as List
              def sobj = result.getField(toksArr.get(0))
              toksArr.remove(0)
              int len = toksArr.size()
              while(len > 0 && sobj != null) {
                sobj = sobj.getField(toksArr.get(0))
                //TODO: get field describe for nested type when field is not a string
                toksArr.remove(0)
                len = toksArr.size()
              }
              def value = column.transform ? column.transform.call(convert(sobj,fieldDescribe)) : convert(sobj,fieldDescribe)
              if(value != null && fieldType == 'date') preparedStatement.setDate(i, new java.sql.Date(value.time))
              else if(value != null && fieldType == 'datetime') preparedStatement.setTimestamp(i, new java.sql.Timestamp(value.time))
              else preparedStatement.setObject(i, value)
            } else {
              def value = column.transform ? column.transform.call(convert(result.getField(sfdcFieldName),fieldDescribe)) : convert(result.getField(sfdcFieldName),fieldDescribe)
              if(value != null && fieldType == 'date') preparedStatement.setDate(i, new java.sql.Date(value.time))
              else if(value != null && fieldType == 'datetime') preparedStatement.setTimestamp(i, new java.sql.Timestamp(value.time))
              else preparedStatement.setObject(i, value)
            }
            i++
          }
          preparedStatement.addBatch()
        }
        preparedStatement.executeBatch()
    })


    preparedStatement.executeBatch()

    sql.close()

  }

  def updateAll(String requestId, ObjectDef objDef, String sqlQuery, opts = [batchSize:200]){
    def sobjs = queryJdbcForSObjects(objDef, jdbc, sqlQuery)
    if(opts?.batchSize == null) opts.batchSize = 200
    update(sobjs, opts.batchSize, requestId)
  }

  def update(sobjs, batchSize=200, requestId="NotSpecified") {
    println "Update:${sobjs.size()}:${batchSize}"

    def totalCount = sobjs.size()
    def attemptsCount = 0
    def successCount = 0
    def failureCount = 0
    def batchesCount = 0
    def updateList = []
    def updateResults = []

    sobjs.each { rec ->
      if(updateList.size() < batchSize) updateList << rec
      else {
        println "updating ${updateList.size()}..."
        def upsertOneResult = updateOneBatch(updateList, requestId)
        batchesCount++
        attemptsCount += upsertOneResult.attempts
        successCount += upsertOneResult.success
        failureCount += upsertOneResult.failure

        updateList = [rec]
        log.debug "==============================="
        log.debug "Attempts: ${attemptsCount}"
        log.debug "Success: ${successCount}"
        log.debug "Errors: ${failureCount}"
        log.debug "Total: ${totalCount}"
        log.debug "Batches Processed: ${batchesCount}"
      }
    }

    if (updateList.size() > 0) {
      println "updating ${updateList.size()}..."
      def upsertOneResult = updateOneBatch(updateList, requestId)
      batchesCount++
      attemptsCount += upsertOneResult.attempts
      successCount += upsertOneResult.success
      failureCount += upsertOneResult.failure

      log.debug "==============================="
      log.debug "Attempts: ${attemptsCount}"
      log.debug "Success: ${successCount}"
      log.debug "Errors: ${failureCount}"
      log.debug "Total: ${totalCount}"
      log.debug "Batches Processed: ${batchesCount}"
    }
    
    log.debug "update complete"
  }

  def update_deprecated(sobjs, batchSize=200) {
    println "updating " + sobjs.size() + " records"
    def updateCount = 0
    def updateList = []

    // def totalCount = sobjs.size()
    // def attemptsCount = 0
    // def successCount = 0
    // def failureCount = 0
    // def batchesCount = 0
    // def updateList = []
    // def updateResults = []

    sobjs.each { rec ->
      if(updateList.size() < batchSize) updateList << rec
      else {
        println "updating ${updateList.size()}"
        def updateResult = null
        try {
          updateResult = connection.update(updateList as SObject[])
        }catch(Exception e){
          log.debug("caught connection exception:", e)
          authenticate()
          updateResult = connection.update(updateList as SObject[])
        }
        //deleteCount += ids.size()
        updateCount += updateResult.findAll { it.success == true }.size()
        updateResult.findAll { it.success == false }.each {
          println it.errors
        }
        println "updated ${updateCount} of ${sobjs.size()}"
        updateList = [rec]
      }
    }

    if (updateList.size() > 0) {
      println "updating ${updateList.size()}"
      def updateResult = null
      try {
        updateResult = connection.update(updateList as SObject[])
      }catch(Exception e){
        log.debug("caught connection exception:", e)
        authenticate()
        updateResult = connection.update(updateList as SObject[])
      }
      updateCount += updateResult.findAll { it.success == true }.size()
      //deleteCount += ids.size()
      updateResult.findAll { it.success == false }.each {
        println it.errors
      }
      println "updated ${updateCount} of ${sobjs.size()}"
      return updateResult
    }else {
      return updateResult
    }
  }

  def delete(ids,batchSize=200) {
    def deleteCount = 0
    def currentBatch = []

    ids.each {
      if(currentBatch.size() < batchSize) currentBatch << it
      else {
        def deleteResult = null
        try {
          deleteResult = connection.delete(currentBatch as String[])
        }catch(Exception e){
          log.debug("caught connection exception:",e)
          authenticate()
          deleteResult = connection.delete(currentBatch as String[])
        }
        deleteCount += deleteResult.findAll { it.success == true }.size()
        deleteResult.findAll { it.success == false }.each {
          println it.errors
        }
        println "deleted ${deleteCount} of ${ids.size()}"
        currentBatch = [it]
      }
    }

    if(currentBatch.size() > 0) {
      println "deleting ${currentBatch.size()}"
      def deleteResult = null
      try {
        deleteResult = connection.delete(currentBatch as String[])
      }catch(Exception e){
        log.debug("caught connection exception:",e)
        authenticate()
        deleteResult = connection.delete(currentBatch as String[])
      }
      deleteCount += deleteResult.findAll { it.success == true }.size()
      deleteResult.findAll { it.success == false }.each {
        println it.errors
      }
      println "deleted ${deleteCount} of ${ids.size()}"
    }

  }

  def deleteAll(soql, deleteBatchSize=200) {
    log.debug "deleteAll: ${soql}"
    def ids = []
    def deleteCount = 0
    def results = query(soql)
    log.debug "found ${results.size()}"
    results.each { rec ->
      if(ids.size() < deleteBatchSize) ids << rec.getId()
      else {
        log.debug "deleting ${ids.size()}"
        //println ids
        def deleteResult = null
        try {
          deleteResult = connection.delete(ids as String[])
        }catch(Exception e){
          log.debug("caught connection exception", e)
          authenticate()
          deleteResult = connection.delete(ids as String[])
        }
        //deleteCount += ids.size()
        deleteCount += deleteResult.findAll { it.success == true }.size()
        deleteResult.findAll { it.success == false }.each {
          log.debug it.getId() + ":" + it.errors
        }
        log.debug "deleted ${deleteCount} of ${results.size()}"
        ids = [rec.getId()]
      }
    }

    if (ids.size() > 0) {
      log.debug "deleting ${ids.size()}"
      //println ids
      def deleteResult = null
      try {
        deleteResult = connection.delete(ids as String[])
      }catch(Exception e){
        log.debug("caught connection exception", e)
        authenticate()
        deleteResult = connection.delete(ids as String[])
      }
      deleteCount += deleteResult.findAll { it.success == true }.size()
      //deleteCount += ids.size()
      deleteResult.findAll { it.success == false }.each {
        log.debug it.getId() + ":" + it.errors
      }
      log.debug "deleted ${deleteCount} of ${results.size()}"
    }

    return deleteCount
  }

  def upsertOneBatch(lstOfSObjects, externalIdField, requestId, retryAttemptNum=0) {
    def updateResult = null
    def attemptsCount = 0
    def successCount = 0
    def failureCount = 0
    def maxRetryAttempts = Integer.valueOf(Env.getProperty("max.retries","3"))
    def retryCount = 0
    def retryList = []

    def returnResult = [
      attempts: attemptsCount,
      success: successCount,
      failure: failureCount
    ]

    try {
      updateResult = connection.upsert(externalIdField, lstOfSObjects as SObject[])
    }catch(Exception e){
      log.debug("re-establishing connection")
      log.debug("caught connection exception: ", e)
      authenticate()
      updateResult = connection.upsert(externalIdField, lstOfSObjects as SObject[])
    }
    
    // enable this when table is created
    saveUpsertResult(requestId, externalIdField, this.jdbc, lstOfSObjects as SObject[], updateResult)

    returnResult.attempts = lstOfSObjects.size()
    returnResult.success += updateResult.findAll { it.success == true }.size()
    updateResult.eachWithIndex { r, index ->
      if(r.success == false) {
        println r.errors
        returnResult.failure++
        r.errors.each { e ->
          if(e.statusCode == StatusCode.UNABLE_TO_LOCK_ROW) {
            retryCount++
            retryList << lstOfSObjects[index]
          }
        }
      }
    }

    boolean retryRequired = !retryList.isEmpty()
    while(retryRequired && retryAttemptNum < maxRetryAttempts) {
      int retryBatchSize = Integer.valueOf(Env.getProperty("batchSize.retry", "1"))
      retryAttemptNum++
      log.debug("retrying attempt ${retryAttemptNum} - " + retryList.size())

      int counter = 0
      def retryBatch = []
      retryRequired = false
      while (counter < retryList.size()) {
        if(retryBatch.size() < retryBatchSize) {
          retryBatch << retryList[counter]
        }else{
          def upsertOneResult = upsertOneBatch(retryBatch as SObject[], externalIdField, requestId, retryAttemptNum)
          if(retryAttemptNum == 1){
            returnResult.failure -= upsertOneResult.success
            returnResult.success += upsertOneResult.success
          }
          retryBatch = [retryList[counter]]
          if(upsertOneResult.failure > 0) retryRequired = true
        }
        counter++
      }

      if(retryBatch.size() > 0) {
        def upsertOneResult = upsertOneBatch(retryBatch as SObject[], externalIdField, requestId, retryAttemptNum)
        if(retryAttemptNum == 1){
          returnResult.failure -= upsertOneResult.success
          returnResult.success += upsertOneResult.success
        }
        retryBatch = []
        if(upsertOneResult.failure > 0) retryRequired = true
      }
    }

    return returnResult
  }

  def updateOneBatch(lstOfSObjects, requestId, retryAttemptNum=0) {
    def updateResult = null
    def attemptsCount = 0
    def successCount = 0
    def failureCount = 0
    def maxRetryAttempts = Integer.valueOf(Env.getProperty("max.retries","3"))
    def retryCount = 0
    def retryList = []

    def returnResult = [
      attempts: attemptsCount,
      success: successCount,
      failure: failureCount
    ]

    try {
      // lstOfSObjects.each {
      //   log.debug it.getId()
      // }
      updateResult = connection.update(lstOfSObjects as SObject[])
    }catch(Exception e){
      log.debug("re-establishing connection")
      log.debug("caught connection exception: ", e)
      authenticate()
      updateResult = connection.update(lstOfSObjects as SObject[])
    }
    
    // enable this when table is created
    saveUpsertResult(requestId, "Id", this.jdbc, lstOfSObjects as SObject[], updateResult)

    returnResult.attempts = lstOfSObjects.size()
    returnResult.success += updateResult.findAll { it.success == true }.size()
    updateResult.eachWithIndex { r, index ->
      if(r.success == false) {
        println r.errors
        returnResult.failure++
        r.errors.each { e ->
          if(e.statusCode == StatusCode.UNABLE_TO_LOCK_ROW) {
            retryCount++
            retryList << lstOfSObjects[index]
          }
        }
      }
    }

    boolean retryRequired = !retryList.isEmpty()
    while(retryRequired && retryAttemptNum < maxRetryAttempts) {
      int retryBatchSize = Integer.valueOf(Env.getProperty("batchSize.retry", "1"))
      retryAttemptNum++
      log.debug("retrying attempt ${retryAttemptNum} - " + retryList.size())

      int counter = 0
      def retryBatch = []
      retryRequired = false
      while (counter < retryList.size()) {
        if(retryBatch.size() < retryBatchSize) {
          retryBatch << retryList[counter]
        }else{
          def upsertOneResult = updateOneBatch(retryBatch as SObject[], requestId, retryAttemptNum)
          if(retryAttemptNum == 1){
            returnResult.failure -= upsertOneResult.success
            returnResult.success += upsertOneResult.success
          }
          retryBatch = [retryList[counter]]
          if(upsertOneResult.failure > 0) retryRequired = true
        }
        counter++
      }

      if(retryBatch.size() > 0) {
        def upsertOneResult = updateOneBatch(retryBatch as SObject[], requestId, retryAttemptNum)
        if(retryAttemptNum == 1){
          returnResult.failure -= upsertOneResult.success
          returnResult.success += upsertOneResult.success
        }
        retryBatch = []
        if(upsertOneResult.failure > 0) retryRequired = true
      }
    }

    return returnResult
  }

  def upsert(externalIdField, sobjs, batchSize=200, requestId="NotSpecified") {
    log.debug "Upsert:${externalIdField}:${sobjs.size()}:${batchSize}"

    def totalCount = sobjs.size()
    def attemptsCount = 0
    def successCount = 0
    def failureCount = 0
    def batchesCount = 0
    def updateList = []
    def updateResults = []
    def retryList = []

    sobjs.each { rec ->
      if(updateList.size() < batchSize) updateList << rec
      else {
        log.debug "upserting ${updateList.size()}..."
        def upsertOneResult = upsertOneBatch(updateList, externalIdField, requestId)
        // def updateResult = null
        // try {
        //   updateResult = connection.upsert(externalIdField, updateList as SObject[])
        // }catch(Exception e){
        //   log.debug("re-establishing connection")
        //   log.debug("caught connection exception: ", e)
        //   authenticate()
        //   updateResult = connection.upsert(externalIdField, updateList as SObject[])
        // }
        //updateResults << updateResult
        batchesCount++
        //attemptsCount += updateList.size()
        attemptsCount += upsertOneResult.attempts
        //successCount += updateResult.findAll { it.success == true }.size()
        successCount += upsertOneResult.success
        failureCount += upsertOneResult.failure
        // upsertOneResult.results.each {
        //   updateResults << it
        // }
        // updateResult.findAll { it.success == false }.each {
        //   println it.errors
        //   failureCount++
        //   it.errors.each { e ->
        //     if(e.statusCode == StatusCode.UNABLE_TO_LOCK_ROW) {
        //       retryList << rec
        //     }
        //   }
        // }
        updateList = [rec]
        log.debug "==============================="
        log.debug "Attempts: ${attemptsCount}"
        log.debug "Success: ${successCount}"
        log.debug "Errors: ${failureCount}"
        log.debug "Total: ${totalCount}"
        log.debug "Batches Processed: ${batchesCount}"
        // if(retryList.size() > 0) {
        //   log.debug "Retrying: ${retryList.size()}"
        //   failureCount -= retryList.size()
        //   try {
        //     updateResult = connection.upsert(externalIdField, retryList as SObject[])
        //   }catch(Exception e){
        //     log.debug("re-establishing connection")
        //     log.debug("caught connection exception: ", e)
        //     authenticate()
        //     updateResult = connection.upsert(externalIdField, retryList as SObject[])
        //   }
        //   successCount += updateResult.findAll { it.success == true }.size()
        //   log.debug "Success: ${successCount}"
        //   log.debug "Errors: ${failureCount}"
        //   retryList = []
        // }
      }
    }

    if(updateList.size() > 0){
      // def updateResult = null
      // try {
      //   updateResult = connection.upsert(externalIdField, updateList as SObject[])
      // }catch(Exception e){
      //   log.debug("re-establishing connection")
      //   log.debug("caught connection exception: ", e)
      //   authenticate()
      //   updateResult = connection.upsert(externalIdField, updateList as SObject[])
      // }
      // updateResults << updateResult
      def upsertOneResult = upsertOneBatch(updateList, externalIdField, requestId)
      batchesCount++
      attemptsCount += upsertOneResult.attempts
      successCount += upsertOneResult.success
      failureCount += upsertOneResult.failure
      // upsertOneResult.results.each {
      //   updateResults << it
      // }
      // attemptsCount += updateList.size()
      // successCount += updateResult.findAll { it.success == true }.size()
      // updateResult.findAll { it.success == false }.each {
      //   log.debug it.errors
      //   it.errors.each { e ->
      //     if(e.statusCode == StatusCode.UNABLE_TO_LOCK_ROW) {
      //       retryList << rec
      //     }
      //   }
      //   failureCount++
      // }
      log.debug "==============================="
      log.debug "Attempts: ${attemptsCount}"
      log.debug "Success: ${successCount}"
      log.debug "Errors: ${failureCount}"
      // if(retryList.size() > 0) {
      //   log.debug "Retrying: ${retryList.size()}"
      //   failureCount -= retryList.size()
      //   try {
      //     updateResult = connection.upsert(externalIdField, retryList as SObject[])
      //   }catch(Exception e){
      //     log.debug("re-establishing connection")
      //     log.debug("caught connection exception: ", e)
      //     authenticate()
      //     updateResult = connection.upsert(externalIdField, retryList as SObject[])
      //   }
      //   successCount += updateResult.findAll { it.success == true }.size()
      //   log.debug "Success: ${successCount}"
      //   log.debug "Errors: ${failureCount}"
      //   retryList = []
      // }
      log.debug "Total: ${totalCount}"
      log.debug "Batches Processed: ${batchesCount}"
    }


    //log.debug "Returning "+updateResults.size()+" sets of results"
    //return updateResults
    log.debug "upsert complete"
  }

  def upsertAll(String requestId, ObjectDef objDef, String sqlQuery, opts = [batchSize:200]) {

    if(opts?.batchSize == null) opts.batchSize = 200
    def batchSize = opts.batchSize
    def sobjs = queryJdbcForSObjects(objDef, jdbc, sqlQuery)
    upsert(objDef.externalIdField, sobjs as SObject[], batchSize, requestId)

    // def upsertResults = upsert(objDef.externalIdField, sobjs as SObject[], batchSize)
    // upsertResults.each {
    //   saveUpsertResult(requestId, objDef.externalIdField, jdbc, sobjs, it)
    // }
    // return upsertResults
  }

  def insertAll(String requestId, ObjectDef objDef, JdbcClient jdbc, String sqlQuery, opts = [batchSize:200]) {

    if(opts?.batchSize == null) opts.batchSize = 200
    def batchSize = opts.batchSize
    def sobjs = queryJdbcForSObjects(objDef, jdbc, sqlQuery)

    def upsertResults = insert(sobjs as SObject[], batchSize)
    upsertResults.each {
      saveCreateResult(requestId, jdbc, sobjs, it)
    }
    return upsertResults
  }

  def insert(sobjs, batchSize=200) {
    log.debug "insert:${sobjs.size()}:${batchSize}"

    def totalCount = sobjs.size()
    def attemptsCount = 0
    def successCount = 0
    def failureCount = 0
    def batchesCount = 0
    def updateList = []
    def updateResults = []

    sobjs.each { rec ->
      if(updateList.size() < batchSize) updateList << rec
      else {
        log.debug "inserting ${updateList.size()}..."
        def updateResult = null
        try {
          updateResult = connection.create(updateList as SObject[])
        }catch(Exception e){
          log.debug("caught connection exception", e)
          authenticate()
          updateResult = connection.create(updateList as SObject[])
        }
        updateResults << updateResult
        batchesCount++
        attemptsCount += updateList.size()
        successCount += updateResult.findAll { it.success == true }.size()
        updateResult.findAll { it.success == false }.each {
          log.debug it.errors
          failureCount++
        }
        updateList = [rec]
        log.debug "==============================="
        log.debug "Attempts: ${attemptsCount}"
        log.debug "Success: ${successCount}"
        log.debug "Errors: ${failureCount}"
        log.debug "Total: ${totalCount}"
        log.debug "Batches Processed: ${batchesCount}"
      }
    }

    if(updateList.size() > 0){
      def updateResult = null
      try {
        updateResult = connection.create(updateList as SObject[])
      }catch(Exception e){
        log.debug("caught connection exception", e)
        authenticate()
        updateResult = connection.create(updateList as SObject[])
      }
      updateResults << updateResult
      batchesCount++
      attemptsCount += updateList.size()
      successCount += updateResult.findAll { it.success == true }.size()
      updateResult.findAll { it.success == false }.each {
        log.debug it.errors
        failureCount++
      }
      log.debug "==============================="
      log.debug "Attempts: ${attemptsCount}"
      log.debug "Success: ${successCount}"
      log.debug "Errors: ${failureCount}"
      log.debug "Total: ${totalCount}"
      log.debug "Batches Processed: ${batchesCount}"
    }

    log.debug "Returning "+updateResults.size()+" sets of results"
    return updateResults
  }

  def queryJdbcForSObjects(ObjectDef objDef, JdbcClient jdbc, String sqlQuery) {
    def sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
    sdf.setTimeZone(TimeZone.getTimeZone("GMT"))

    def dateSdf = new SimpleDateFormat("yyyy-MM-dd")
    dateSdf.setTimeZone(TimeZone.getTimeZone("GMT"))

    def dateFields = []
    def dateTimeFields = []
    def booleanFields = []
    def referenceFields = [:]
    def intFields = []

    if(objDef.sobjType) {
      def desc = null
      try {
        desc = connection.describeSObject(objDef.sobjType)
      }catch(Throwable e){
        log.debug("connection exception thrown", e)
        authenticate()
        desc = connection.describeSObject(objDef.sobjType)
      }

      desc.fields.each { f ->
        //println "${f.name}:${f.type}"
        //if(String.valueOf(f.type).toLowerCase().equals("reference")) println f
        if(String.valueOf(f.type).toLowerCase().equals("date")) dateFields << f.name
        else if(String.valueOf(f.type).toLowerCase().equals("datetime")) dateTimeFields << f.name
        else if(String.valueOf(f.type).toLowerCase().equals("boolean")) booleanFields << f.name
        else if(String.valueOf(f.type).toLowerCase().equals("reference")) referenceFields[f.name] = f
        else if(String.valueOf(f.type).toLowerCase().equals("int")) intFields << f.name
      }
    }

    log.debug sqlQuery
    def sobjs = []

    def sql = Sql.newInstance(jdbc.url, jdbc.username, jdbc.password, jdbc.driver)
    sql.eachRow(sqlQuery) { row ->

      def m = row.toRowResult()

      SObject c = new SObject()
      c.setType(objDef.sobjType)
      def fieldsToNull = []

      m.keySet().each { k ->
        String sfdcField = objDef.mapping[k]?.sfdcField
        String refExternalIdField = objDef.mapping[k]?.refExternalIdField
        // println "refExternalIdField=${refExternalIdField}"
        if(m[k] == null) fieldsToNull << sfdcField

        //println "sfdcField=${sfdcField}"
        if(sfdcField != null){
          if(dateTimeFields.contains(sfdcField)) {
            def val = m[k]
            if(val != null){
              if(val instanceof java.sql.Date) c.setField(sfdcField, val)
              else if(val instanceof java.sql.Timestamp) c.setField(sfdcField, val)
              else{
                def cal = Calendar.getInstance()
                cal.setTime(sdf.parse(val))
                c.setField(sfdcField, cal)
              }
            }
          }else if(dateFields.contains(sfdcField)) {
            def val = m[k]
            if(val != null) {
              if(val instanceof java.sql.Date) c.setField(sfdcField, val)
              else {
                def cal = Calendar.getInstance()
                cal.setTime(dateSdf.parse(val))
                c.setField(sfdcField, cal)
              }
            }
          }else if(booleanFields.contains(sfdcField)) {
            def val = m[k]
            if(val != null) c.setField(sfdcField, Boolean.valueOf(val))
          }else if(referenceFields.containsKey(sfdcField)) {
            def val = m[k]
            if (val) {
              if(refExternalIdField == null || refExternalIdField == ""){
                c.setField(sfdcField, val)
              }else{
                //support related External ID
                // println "supporting refExternalIdField=${refExternalIdField} on ${sfdcField}"
                // println "supporting type=${referenceFields[sfdcField].referenceTo[0]}"
                // println "val=${val}"
                // println "val.class=${val?.class}"
                //if(val?.class == java.lang.Float.class) val = ((Float)val).toInteger()
                // println "val2=${val}"
                // println "val2.class=${val?.class}"
                // println "field=${referenceFields[sfdcField].relationshipName}"
                SObject a = new SObject()
                a.setType(referenceFields[sfdcField].referenceTo[0])
                a.setField(refExternalIdField, val)
                c.setField(referenceFields[sfdcField].relationshipName, a)
              }
            }
          } else if(intFields.contains(sfdcField))  {
            def val = m[k]
            if(val?.class == java.math.BigDecimal.class) val = val.intValue()
            //println val?.class
            c.setField(sfdcField, val)
          } else {
            c.setField(sfdcField, m[k])
          }
        }

      }

      c.setFieldsToNull(fieldsToNull as String[])
      sobjs << c
    }

    return sobjs
  }

  def saveCreateResult(request_id, JdbcClient jdbc, sobjects, saveResult){
    def sql = Sql.newInstance(jdbc.url, jdbc.username, jdbc.password, jdbc.driver)
    def stmt = "INSERT INTO save_results (request_id, operation, id, success, error_fields, error_message, error_status, ts) VALUES(?,?,?,?,?,?,?,NOW())"
    sql.withBatch(10, stmt) { ps ->
      def i = 0
      saveResult.each { result ->
        ps.addBatch(request_id, 'insert', result.getId(), result.success, String.valueOf(result.errors.collect{it.fields.join(",")}.join("")), String.valueOf(result.errors.collect{it.message}.join("")), String.valueOf(result.errors.collect{it.statusCode}.join("")))
        i++
      }
    }
    sql.close()
  }

  def saveUpsertResult(request_id, externalIdField, JdbcClient jdbc, sobjects, saveResult){
    def sql = Sql.newInstance(jdbc.url, jdbc.username, jdbc.password, jdbc.driver)
    def stmt = "INSERT INTO save_results (request_id, operation, external_id, id, success, error_fields, error_message, error_status, ts) VALUES(?,?,?,?,?,?,?,?,NOW())"
    sql.withBatch(10, stmt) { ps ->
      def i = 0
      saveResult.each { result ->
        ps.addBatch(request_id, 'upsert', sobjects[i].getField(externalIdField), result.getId(), result.success, String.valueOf(result.errors.collect{it.fields.join(",")}.join("")), String.valueOf(result.errors.collect{it.message}.join("")), String.valueOf(result.errors.collect{it.statusCode}.join("")))
        i++
      }
    }
    sql.close()
  }

  // def saveUpsertResult(load_id, sobjects, externalIdField, upsertResult){
  //
  //   def sql = Sql.newInstance(Config.dbUrl, Config.dbUser, Config.dbPassword, Config.dbDriver)
  //   def stmt = "INSERT INTO soap_upsert_results (load_id, external_id, id, success, error_fields, error_message, error_status) VALUES(?,?,?,?,?,?,?)"
  //   sql.withBatch(2, stmt) { ps ->
  //     def i = 0
  //     upsertResult.each { result ->
  //       ps.addBatch(load_id, sobjects[i].getField(externalIdField), result.getId(), result.success, String.valueOf(result.errors.collect{it.fields.join(",")}.join("")), String.valueOf(result.errors.collect{it.message}.join("")), String.valueOf(result.errors.collect{it.statusCode}.join("")))
  //       i++
  //     }
  //   }
  //   sql.close()
  // }

  def convert(val, sobjFieldDescribe) {
    //log.debug "convert ${val} with ${sobjFieldDescribe}"
    DateConverter dateConverter = new DateConverter(null);
    dateConverter.setPatterns(["yyyy-MM-dd"] as String[]);
    ConvertUtils.register(dateConverter, Date.class);

    DateTimeConverter dateTimeConverter = new DateConverter();
    dateTimeConverter.setTimeZone(TimeZone.getTimeZone("GMT"))
    dateTimeConverter.setPatterns(["yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"] as String[]);

    //log.debug "${sobjFieldDescribe?.name}: convert: ${val} of type ${val?.class} with ${sobjFieldDescribe?.type}"
    if(sobjFieldDescribe == null || val == null) return val
    else {
      // log.debug sobjFieldDescribe.type
      // log.debug sobjFieldDescribe.type == 'boolean'
      // log.debug sobjFieldDescribe.type.toString() == 'boolean'
      if(sobjFieldDescribe.type.toString() == 'boolean'){
        // def tmp = ConvertUtils.convert(val, Boolean.class)
        // log.debug "tmp=${tmp} ${tmp.class}"
        return ConvertUtils.convert(val, Boolean.class)
      }else if(sobjFieldDescribe.type.toString() == 'currency' || sobjFieldDescribe.type.toString() == 'percent')
        return ConvertUtils.convert(val, Double.class)
      else if(sobjFieldDescribe.type.toString() == 'double')
        return ConvertUtils.convert(val, Double.class)
      else if(sobjFieldDescribe.type.toString() == 'date'){
        //println "result (D): "+ConvertUtils.convert(val, Date.class)
        return ConvertUtils.convert(val, Date.class)
      }else if(sobjFieldDescribe.type.toString() == 'datetime'){
        //println "result (DT): "+dateTimeConverter.convert(Date.class, val)
        return dateTimeConverter.convert(Date.class, val)
      }else return val
    }
  }

  def getDescribeSObject(String sobjType){
      return connection.describeSObject(sobjType)
  }
}

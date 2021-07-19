package com.beckettit.salesforce.rest;

import groovy.json.*
import org.apache.http.client.methods.HttpPost
import org.apache.http.client.HttpClient
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.http.HttpResponse
import org.apache.http.HttpStatus
import org.apache.http.util.EntityUtils
import com.beckettit.Env
import org.apache.log4j.Logger

class RestClient {
  private static final Logger log = Logger.getLogger(RestClient.class)
  def clientId
  def clientSecret
  def username
  def password
  def loginUrl
  def GRANT_SERVICE = "/services/oauth2/token?grant_type=password"
  def accessToken
  def instanceUrl

  def initProfile(profile) {
    Properties p = new Properties()
    // p.load(new File(getClass().getClassLoader().getResource("restClient.properties").getFile()).newDataInputStream())
    p.load(Env.getResourceFile("restClient.properties").newDataInputStream())
    clientId = p.getProperty("${profile}.clientId")
    clientSecret = p.getProperty("${profile}.clientSecret")
    username = p.getProperty("${profile}.username")
    password = p.getProperty("${profile}.password")
    loginUrl = p.getProperty("${profile}.loginUrl")
  }

  def authenticate() {
    //https://github.com/asagarwal/salesforce-rest-api-with-java/blob/master/salesforce_rest_api_1.java
    HttpClient httpClient = HttpClientBuilder.create().build()

    String loginFullUrl = loginUrl + GRANT_SERVICE + "&client_id=" + clientId + "&client_secret=" + clientSecret + "&username=" + username + "&password=" + URLEncoder.encode(password, "UTF-8")
    log.debug loginFullUrl

    HttpPost httpPost = new HttpPost(loginFullUrl)
    HttpResponse response = null

    response = httpClient.execute(httpPost)

    int statusCode = response.getStatusLine().getStatusCode()
    log.debug statusCode

    if(statusCode != HttpStatus.SC_OK) {
      log.debug "Error authenticating to Force.com: " + statusCode
      log.debug response
      return
    }


    String getResult = EntityUtils.toString(response.getEntity())
    //println getResult

    JsonSlurper jsonSlurper = new JsonSlurper()
    def json = jsonSlurper.parseText(getResult)

    //println json.access_token
    accessToken = json.access_token
    instanceUrl = json.instance_url

    log.debug "accessToken=${accessToken}"
    log.debug "instanceUrl=${instanceUrl}"

    httpPost.releaseConnection()
  }

}

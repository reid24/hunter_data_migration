package com.beckettit.salesforce.rest;

import groovy.json.*
import org.apache.http.client.methods.HttpPost
import org.apache.http.client.methods.HttpGet
import org.apache.http.client.HttpClient
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.http.HttpHeaders
import org.apache.http.HttpResponse
import org.apache.http.HttpStatus
import org.apache.http.util.EntityUtils
import com.beckettit.salesforce.model.*

public class RestUtil {
  public RestClient restClient

  public RestUtil(RestClient restClient) {
    this.restClient = restClient
  }

  public SObjectDescribe getMetadata(String sobjType) {
    HttpClient httpClient = HttpClientBuilder.create().build()

    String url = restClient.instanceUrl + "/services/data/v47.0/sobjects/${sobjType}/describe/"
    //println url

    HttpGet httpGet = new HttpGet(url)
    httpGet.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");
    httpGet.setHeader(HttpHeaders.AUTHORIZATION, "Bearer "+restClient.accessToken);
    HttpResponse response = null

    response = httpClient.execute(httpGet)

    int statusCode = response.getStatusLine().getStatusCode()
    //println statusCode

    if(statusCode != HttpStatus.SC_OK) {
      println "Error retrieving metadata from Force.com: " + statusCode
      return
    }


    String getResult = EntityUtils.toString(response.getEntity())
    //println getResult

    JsonSlurper jsonSlurper = new JsonSlurper()
    def json = jsonSlurper.parseText(getResult)

    SObjectDescribe desc = new SObjectDescribe(json.name)

    json.fields.each {
      desc.fields.put(it.name, it)
    }

    httpGet.releaseConnection()

    return desc
  }
}

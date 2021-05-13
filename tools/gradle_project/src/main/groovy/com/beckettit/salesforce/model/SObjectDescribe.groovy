package com.beckettit.salesforce.model;

import groovy.json.*
import org.apache.http.client.methods.HttpPost
import org.apache.http.client.methods.HttpGet
import org.apache.http.client.HttpClient
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.http.HttpHeaders
import org.apache.http.HttpResponse
import org.apache.http.HttpStatus
import org.apache.http.util.EntityUtils

public class SObjectDescribe {
  public String name
  public Map<String, Object> fields

  public SObjectDescribe(String name) {
    this.name = name
    this.fields = [:]
  }
}

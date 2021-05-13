package com.beckettit.transform;

import com.beckettit.jdbc.JdbcClient

class Transformation {
  public JdbcClient jdbc
  public Map<String, ObjectDef> objectDefs

  public Transformation(JdbcClient jdbc) {
    this.jdbc = jdbc
    this.objectDefs = [:]
  }

  public void addObjectDef(String key, ObjectDef objDef) {
    this.objectDefs.put(key, objDef)
  }

  public ObjectDef getObjectDef(String key) {
    return this.objectDefs.get(key)
  }
}

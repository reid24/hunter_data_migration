package com.beckettit;

import org.apache.log4j.Logger

public class Env {
  private static final Logger log = Logger.getLogger(Env.class)
  private static Properties p

  public static void init(){
    log.debug("Env.init")
    p = new Properties()
    p.load(getResourceFile("env.properties").newDataInputStream())
    log.debug("jdbcProfile="+p.getProperty("jdbc.profile"))
    log.debug("soapProfile="+p.getProperty("soap.profile"))
    log.debug("restProfile="+p.getProperty("rest.profile"))
    log.debug("filesDirectory="+p.getProperty("files.dir"))
  }

  public static File getResourceFile(String fileName) {
    String resourcesDir = System.getProperty("resources.dir")
    log.debug "resourcesDir=${resourcesDir}"
    if(resourcesDir == null){
      return new File(Env.class.getClassLoader().getResource(fileName).getFile())
    }else{
      return new File(resourcesDir, fileName)
    }
  }

  public static String getProperty(String propertyName, String defaultValue){
    if(p == null) {
      init()
    }
    return p.getProperty(propertyName, defaultValue)
  }

  public static String getJdbcProfile(){
    if(p == null) {
      init()
    }
    return p.getProperty("jdbc.profile")
  }

  public static String getSoapProfile(){
    if(p == null) {
      init()
    }
    return p.getProperty("soap.profile")
  }

  public static String getRestProfile(){
    if(p == null) {
      init()
    }
    return p.getProperty("rest.profile")
  }

  public static String getFilesDirectory(){
    if(p == null) {
      init()
    }
    return p.getProperty("files.dir")
  }
}

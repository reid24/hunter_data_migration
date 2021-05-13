package com.beckettit.salesforce.bulk;

import com.sforce.async.*
import com.sforce.ws.ConnectorConfig
import com.sforce.soap.partner.PartnerConnection
import com.sforce.async.JobInfo
import com.beckettit.Env

/**
 ** see https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_code_walkthrough.htm
 **
**/
class BulkClient {
  def username
  def password
  def authEndpoint
  BulkConnection connection

  def initProfile(profile) {
    Properties p = new Properties()
    // p.load(new File(getClass().getClassLoader().getResource("soapClient.properties").getFile()).newDataInputStream())
    p.load(Env.getResourceFile("soapClient.properties").newDataInputStream())
    username = p.getProperty("${profile}.username")
    password = p.getProperty("${profile}.password")
    authEndpoint = p.getProperty("${profile}.authEndpoint")
  }

  def authenticate() {
    ConnectorConfig partnerConfig = new ConnectorConfig()
    partnerConfig.setUsername(username)
    partnerConfig.setPassword(password)
    partnerConfig.setAuthEndpoint(authEndpoint)
    PartnerConnection partnerConnection = new PartnerConnection(partnerConfig)

    ConnectorConfig config = new ConnectorConfig()
    config.setSessionId(partnerConfig.getSessionId())
    String soapEndpoint = partnerConfig.getServiceEndpoint()
    String apiVersion = "47.0"
    String restEndpoint = soapEndpoint.substring(0, soapEndpoint.indexOf("Soap/")) + "async/" + apiVersion
    config.setRestEndpoint(restEndpoint)
    // This should only be false when doing debugging.
    config.setCompression(true)
    // Set this to true to see HTTP requests and responses on stdout
    config.setTraceMessage(false)
    this.connection = new BulkConnection(config)
  }

  public JobInfo createInsertJob(String sobjectType) throws AsyncApiException {
    JobInfo job = new JobInfo();
    job.setObject(sobjectType);
    job.setOperation(OperationEnum.insert);
    job.setContentType(ContentType.CSV);
    job = this.connection.createJob(job);
    System.out.println(job);
    return job;
  }

  public JobInfo createUpsertJob(String sobjectType) throws AsyncApiException {
    JobInfo job = new JobInfo();
    job.setObject(sobjectType);
    job.setOperation(OperationEnum.upsert);
    job.setContentType(ContentType.CSV);
    job = this.connection.createJob(job);
    System.out.println(job);
    return job;
  }

  private List<BatchInfo> createBatches(JobInfo jobInfo, String csvFileName) throws IOException, AsyncApiException {
    List<BatchInfo> batchInfos = new ArrayList<BatchInfo>();
    BufferedReader rdr = new BufferedReader(
        new InputStreamReader(new FileInputStream(csvFileName))
    );
    // read the CSV header row
    byte[] headerBytes = (rdr.readLine() + "\n").getBytes("UTF-8");
    int headerBytesLength = headerBytes.length;
    File tmpFile = File.createTempFile("bulkAPIInsert", ".csv");

    // Split the CSV file into multiple batches
    try {
        FileOutputStream tmpOut = new FileOutputStream(tmpFile);
        int maxBytesPerBatch = 10000000; // 10 million bytes per batch
        int maxRowsPerBatch = 10000; // 10 thousand rows per batch
        int currentBytes = 0;
        int currentLines = 0;
        String nextLine;
        while ((nextLine = rdr.readLine()) != null) {
            byte[] bytes = (nextLine + "\n").getBytes("UTF-8");
            // Create a new batch when our batch size limit is reached
            if (currentBytes + bytes.length > maxBytesPerBatch
              || currentLines > maxRowsPerBatch) {
                createBatch(tmpOut, tmpFile, batchInfos, connection, jobInfo);
                currentBytes = 0;
                currentLines = 0;
            }
            if (currentBytes == 0) {
                tmpOut = new FileOutputStream(tmpFile);
                tmpOut.write(headerBytes);
                currentBytes = headerBytesLength;
                currentLines = 1;
            }
            tmpOut.write(bytes);
            currentBytes += bytes.length;
            currentLines++;
        }
        // Finished processing all rows
        // Create a final batch for any remaining data
        if (currentLines > 1) {
            createBatch(tmpOut, tmpFile, batchInfos, connection, jobInfo);
        }
    } finally {
        tmpFile.delete();
    }
    return batchInfos;
  }
}

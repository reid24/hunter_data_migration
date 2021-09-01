/*
 * This Groovy source file was generated by the Gradle 'init' task.
 */
package com.beckettit.hunter.dm.task

import com.beckettit.Env
import com.beckettit.transform.*
import com.beckettit.process.Util
import com.beckettit.salesforce.*
import com.beckettit.salesforce.soap.*
import com.beckettit.jdbc.*
import com.beckettit.hunter.dm.obj.*
import org.apache.log4j.Logger

class ExtractDHC extends BaseTask {

    public ExtractDHC(String[] args){
        super(args)
    }

    public void run() {
        ObjectDef objDef = DHC.getExtractObjectDef()
        Util.extract(soap, jdbc, objDef)
    }

    //main task
    static void main(String[] args) {
        ExtractDHC proc = new ExtractDHC(args)
        proc.run()
    }
}
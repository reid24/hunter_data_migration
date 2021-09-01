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

class ExtractTasks extends BaseTask {

    public ExtractTasks(String[] args){
        super(args)
    }

    public void run() {
        ObjectDef objDef = Task.getExtractObjectDef()
        Util.extractAll(soap, jdbc, objDef)
    }

    //main task
    static void main(String[] args) {
        ExtractTasks proc = new ExtractTasks(args)
        proc.run()
    }
}

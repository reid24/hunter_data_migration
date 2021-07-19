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

class ExtractContacts extends BaseTask {

    public ExtractContacts(String[] args){
        super(args)
    }

    public void run() {
        ObjectDef objDef = Contact.getExtractObjectDef()
        Util.extract(soap, jdbc, objDef)
        jdbc.execute """
        CREATE INDEX `${objDef.table}_id_idx` ON `${objDef.table}` (`id`) USING BTREE
        """
    }

    //main task
    static void main(String[] args) {
        ExtractContacts proc = new ExtractContacts(args)
        proc.run()
    }
}
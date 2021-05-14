#!/bin/bash

BACKUP_NAME=hunter_bak_051021

mysqldump -u root -R hunter > $BACKUP_NAME.sql
mysqladmin -u root create $BACKUP_NAME
mysql -u root $BACKUP_NAME < $BACKUP_NAME.sql
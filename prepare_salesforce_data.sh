#!/bin/bash

PWD=yourmysqlpasswordhere

mysql -u root -p$PWD hunter_sfdc < setup.sql
mysql -u root -p$PWD hunter_sfdc < programs.sql
mysql -u root -p$PWD hunter_sfdc < accounts.sql
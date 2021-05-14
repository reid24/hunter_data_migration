#!/bin/bash

SOURCE_DB=hunter
DEST_DB=hunter_bak_051221

mysqladmin -u root create $DEST_DB
mysql -u root $SOURCE_DB -sNe 'show tables' | while read table; do mysql -u root -sNe "RENAME TABLE $SOURCE_DB.$table TO $DEST_DB.$table"; done

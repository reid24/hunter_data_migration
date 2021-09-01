#!/bin/bash

SOURCE_DB=hunter
DEST_DB=hunter_bak_083121

mysqladmin -u hunter create $DEST_DB
mysql -u hunter $SOURCE_DB -sNe 'show tables' | while read table; do mysql -u hunter -sNe "RENAME TABLE $SOURCE_DB.$table TO $DEST_DB.$table"; done

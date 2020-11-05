#!/bin/bash

formattedDate=$(date +"%F_%T"_backup)
mysqldump --user=root --password=mariadbpassword --add-drop-database -c -i --dump-date --databases sistema_telediagnostico > /root/Server-Management/backups/"$formattedDate".sql
scp backups/"$formattedDate".sql root@192.168.0.3:/root/master_backups/

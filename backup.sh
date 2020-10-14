#!/bin/bash

formattedDate=$(date +"%Y.%m.%d"_backup)
mysqldump --user=root --password=mariadbpassword --add-drop-database -c -i --dump-date sistema_telediagnostico > /root/Server-Management/backups/"$formattedDate".sql

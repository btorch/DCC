#!/bin/bash

#----------------------------------------------------------
# a simple mysql database backup script.
# version 2, updated March 26, 2011.
# copyright 2011 alvin alexander, http://alvinalexander.com
#----------------------------------------------------------
# This work is licensed under a Creative Commons 
# Attribution-ShareAlike 3.0 Unported License;
# see http://creativecommons.org/licenses/by-sa/3.0/ 
# for more information.
#----------------------------------------------------------

# (1) set up all the mysqldump variables
DBSERVER=192.168.1.204
USER=backup
PASS=dicocel2019

# List all databases;
dbnames=`mysql --user=${USER} --password=${PASS} --host=${DBSERVER} -sN -e 'show databases' 2>/dev/null`
    
for name in ${dbnames}
do
    case $name in
        fornecedor_in)
            FILE="/root/mysql_backups/mariadb/"${name}.`date +"%d-%m-%Y"`."dump.sql"
    		/usr/bin/mysqldump --skip-add-drop-table -c --user=${USER} --password=${PASS} --host=${DBSERVER} ${name} > ${FILE} 2>/dev/null
    		gzip -f $FILE
            ;;
        sistema_in)
            FILE="/root/mysql_backups/mariadb/"${name}.`date +"%d-%m-%Y"`."dump.sql"
    		/usr/bin/mysqldump --skip-add-drop-table -c --user=${USER} --password=${PASS} --host=${DBSERVER} ${name} > ${FILE} 2>/dev/null
    		gzip -f $FILE
            ;;
        mysql)
            FILE="/root/mysql_backups/mariadb/"${name}.`date +"%d-%m-%Y"`."dump.sql"
    		/usr/bin/mysqldump --skip-add-drop-table -c --user=${USER} --password=${PASS} --host=${DBSERVER} ${name} > ${FILE} 2>/dev/null
    		gzip -f $FILE
            ;;
	esac
done

# Sync to AWS
/usr/local/bin/aws s3 sync /root/mysql_backups/mariadb s3://dicocel/mariadb/ --only-show-errors --delete	2>/dev/null

exit 0 


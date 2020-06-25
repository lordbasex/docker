#!/bin/bash
cd /tmp

if [ "$1" != "" ]; then
    echo "Restore backup $1"
    aws s3 cp s3://${AWS_S3_SQL}/${1} .
    if [ "$?" -ne 0  ]; then
	echo "ERROR 404 FILE NO EXISTE"
    	exit 1
    else
	echo 'DOWNLOAD OK `date +"%m-%d-%Y %H_%M_%S"` '
    	echo "mysql -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_HOST $MYSQL_DATABASE < $1"
    	echo "rm -fr $1"
    	mysql -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_HOST $MYSQL_DATABASE < $1
    	rm -fr $1
    fi
else
    echo "Restore backup file is empty"
    exit 1
fi

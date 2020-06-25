#!/bin/bash
cd /tmp
FILE_DB=db_`date +"%m-%d-%Y_%H_%M_%S"`.sql
/usr/bin/mysqldump -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_HOST $MYSQL_DATABASE > $FILE_DB
echo "aws s3api put-object --bucket ${AWS_S3_SQL} --key ${FILE_DB} --tagging 's3=sql' --body ${FILE_DB}"
aws s3api put-object --bucket ${AWS_S3_SQL} --key ${FILE_DB} --tagging 's3=sql' --body ${FILE_DB}
rm -fr $FILE_DB

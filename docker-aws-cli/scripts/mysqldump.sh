#!/bin/bash
> /var/log/mysqldump.log
cd /tmp
FILE_DB=db_`date +"%m-%d-%Y_%H_%M_%S"`.sql
/usr/bin/mysqldump -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_HOST $MYSQL_DATABASE > $FILE_DB
echo "aws s3api put-object --bucket ${AWS_S3_SQL} --key ${FILE_DB} --tagging 's3=sql' --body ${FILE_DB}" >> /var/log/mysqldump.log
aws s3api put-object --bucket ${AWS_S3_SQL} --key ${FILE_DB} --tagging 's3=sql' --body ${FILE_DB} >> /var/log/mysqldump.log
if [ $MSMTP = "true" ]; then
  COUNT=`cat /tmp/notification_count`
  if [ "$COUNT" = 24 ]; then
	echo "SEND MAIL COUNT ->$COUNT<-"
  	echo -e "Subject: Auto Backup Crontab mysqldump `date +'%m-%d-%Y %H:%M:%S'`\n`cat /var/log/mysqldump.log `" | msmtp -a default ${MAIL_NOTIFICATION}
	echo 1 > /tmp/notification_count
  else
	echo $COUNT
	((COUNT++))
	echo $COUNT > /tmp/notification_count
  fi
fi
rm -fr $FILE_DB

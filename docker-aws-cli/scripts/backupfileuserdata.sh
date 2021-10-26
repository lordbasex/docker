#!/bin/bash
> /var/log/backupfileuserdata.log
FILE_USER_DATA=user-data_`date +"%m-%d-%Y_%H_%M_%S"`.tar.gz
cd /tmp && tar -czf ${FILE_USER_DATA} /user-data >> /var/log/backupfileuserdata.log

cd /tmp
for f in *.tar.gz; do
	echo "7za -v2g -mx0 $f.7z $f" >> /var/log/backupfileuserdata.log
        7za -v2g -mx0 $f.7z $f >> /var/log/backupfileuserdata.log
done

for z in *.7z.*; do
	echo "aws s3api put-object --bucket ${AWS_S3_FILE} --key ${z} --tagging 's3=fileall' --body ${z}" >> /var/log/backupfileuserdata.log
	aws s3api put-object --bucket ${AWS_S3_FILE} --key ${z} --tagging 's3=fileall' --body ${z} >> /var/log/backupfileuserdata.log
done

if [ $MSMTP = "true" ]; then
	echo -e "Subject: Auto Backup Crontab backupfileuserdata `date +'%m-%d-%Y %H:%M:%S'`\n`cat /var/log/backupfileuserdata.log `" | msmtp -a default ${MAIL_NOTIFICATION}
fi

rm -fr *.tar.gz.7z.*
rm -fr ${FILE_USER_DATA}

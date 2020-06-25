#!/bin/bash
FILE_USER_DATA=user-data_`date +"%m-%d-%Y_%H_%M_%S"`.tar.gz
cd /tmp && tar -czf ${FILE_USER_DATA} /user-data

cd /tmp
for f in *.tar.gz; do
	echo "7z a -v2g -mx0 $f.7z $f"
        7z a -v2g -mx0 $f.7z $f
done

for z in *.7z.*; do
	echo "aws s3api put-object --bucket ${AWS_S3_FILE} --key ${z} --tagging 's3=fileall' --body ${z}"
	aws s3api put-object --bucket ${AWS_S3_FILE} --key ${z} --tagging 's3=fileall' --body ${z}
done

rm -fr *.tar.gz.7z.*
rm -fr ${FILE_USER_DATA}

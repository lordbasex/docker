#!/bin/sh
#
# check if docker is running
if ! (docker ps >/dev/null 2>&1)
then
	echo "docker daemon not running, will exit here!"
	exit
fi
echo "Preparing folder init and creating ./init/initdb.sql"
mkdir ./init >/dev/null 2>&1
mkdir -p ./nginx/ssl >/dev/null 2>&1
chmod -R +x ./init
# latest
#docker run --rm 'guacamole/guacamole' /opt/guacamole/bin/initdb.sh --postgresql > ./init/initdb.sql
# pinned version
docker run --rm 'guacamole/guacamole:1.6.0' /opt/guacamole/bin/initdb.sh --postgresql > ./init/initdb.sql
echo "done"
echo "Preparing folder record and set permissions"
mkdir ./record >/dev/null 2>&1
chmod -R 777 ./record
echo "done"

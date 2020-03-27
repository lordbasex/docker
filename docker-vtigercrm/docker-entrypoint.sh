#!/bin/bash
set -e


DIR='/var/www/html/vtigercrm/'
if [ "$(ls -A $DIR)" ]; then
        echo "$DIR is not empty"
else
        echo "$DIR is empty"
	yes|cp -fra /usr/src/vtigercrm/vtigercrm /var/www/html/
	chmod -R 775 /var/www/html/vtigercrm
	chown -R apache:apache /var/www/html/vtigercrm
fi


if [ -z "$DB_HOSTNAME" ]; then
        echo >&2 'error: missing DB_HOSTNAME environment variable'
        exit 1
fi

if [ -z "$DB_USERNAME" ]; then
        echo >&2 'error: missing DB_USERNAME environment variable'
        exit 1
fi

if [ -z "$DB_PASSWORD" ]; then
        echo >&2 'error: missing DB_PASSWORD environment variable'
        exit 1
fi

if [ -z "$DB_NAME" ]; then
        echo >&2 'error: missing DB_NAME environment variable'
        exit 1
fi

sed -i "s/\$defaultParameters\['db_hostname'\]/'"${DB_HOSTNAME}"'/" vtigercrm/modules/Install/views/Index.php
sed -i "s/\$defaultParameters\['db_username'\]/'"${DB_USERNAME}"'/" vtigercrm/modules/Install/views/Index.php
sed -i "s/\$defaultParameters\['db_password'\]/'"${DB_PASSWORD}"'/" vtigercrm/modules/Install/views/Index.php
sed -i "s/\$defaultParameters\['db_name'\]/'"${DB_NAME}"'/" vtigercrm/modules/Install/views/Index.php

#optional
if [ -n "$ADMIN_NAME" ]; then
sed -i "s/\$defaultParameters\['admin_name'\]/'"${ADMIN_NAME}"'/" vtigercrm/modules/Install/views/Index.php
fi

if [ -n "$ADMIN_LASTNAME" ]; then
sed -i "s/\$defaultParameters\['admin_lastname'\]/'"${ADMIN_LASTNAME}"'/" vtigercrm/modules/Install/views/Index.php
fi

if [ -n "$ADMIN_PASSWORD" ]; then
sed -i "s/\$defaultParameters\['admin_password'\]/'"${ADMIN_PASSWORD}"'/" vtigercrm/modules/Install/views/Index.php
fi

if [ -n "$ADMIN_EMAIL" ]; then
sed -i "s/\$defaultParameters\['admin_email'\]/'"${ADMIN_EMAIL}"'/" vtigercrm/modules/Install/views/Index.php
fi

exec "$@"

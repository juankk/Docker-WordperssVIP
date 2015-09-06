#!/bin/bash
set -e

DIR="/srv"
if [ "$(ls -A $DIR)" ];
then
	#seems that we have alredy installed wp core, just update it
	cd "${DIR}/www/wp"
	#svn up
	#cd "${DIR}/www/wp-content/themes/vip/plugins"
	#svn up
	#cd "${DIR}/www/wp-content/themes/twentyfifteen"
	#svn up
	#cd "${DIR}/www/wp-tests"
	#svn up
else

	#setting database user names and tables
	mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /init-tables.sql
	rm /init-tables.sql

    mkdir "${DIR}/www/"
	mkdir "${DIR}/www/wp"
	cd "${DIR}/www/wp"
	svn checkout --non-interactive --trust-server-cert http://core.svn.wordpress.org/trunk/ ./

	mkdir "${DIR}/www/wp-content/themes/vip/plugins"
	cd "${DIR}/www/wp-content/themes/vip/plugins"
	svn checkout --non-interactive --trust-server-cert https://vip-svn.wordpress.com/plugins/ ./

	mkdir "${DIR}/www/wp-content/themes/twentyfifteen"
	cd "${DIR}/www/wp-content/themes/twentyfifteen"
	svn checkout --non-interactive --trust-server-cert https://wpcom-themes.svn.automattic.com/twentyfifteen/ ./

	mkdir "${DIR}/www/wp-tests"
	cd "${DIR}/www/wp-tests"
	svn checkout --non-interactive --trust-server-cert http://develop.svn.wordpress.org/trunk/ ./

	#TODO Configure apache to run the code from the correct location

	#installing site
	cd "${DIR}/www/wp"
	/usr/bin/wp core multisite-install --url='vip.local' --title='Wordpress site' --admin_email='admin@example.com' --admin_name='wordpress' --admin_password='wordpress'
fi
exec "$@"

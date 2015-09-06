#!/bin/bash
set -e

DIR="/srv"

#configuring wp cli
cd /tmp
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --info --allow-root

if [ "$(ls -A $DIR)" ];
then
	#seems that we have alredy installed wp core, just update it
	cd "${DIR}/www/wp"
	svn up
	cd "${DIR}/www/wp-content/themes/vip/plugins"
	svn up
	cd "${DIR}/www/wp-content/themes/twentyfifteen"
	svn up
	cd "${DIR}/www/wp-tests"
	svn up
else

	#setting database user names and tables
	mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /init-tables.sql
	rm /init-tables.sql

    mkdir "${DIR}/www/"
	mkdir "${DIR}/www/wp"
	cd "${DIR}/www/wp"
	svn checkout --non-interactive --trust-server-cert http://core.svn.wordpress.org/trunk/ ./

	#making sure some necessary folders exist
	mkdir "${DIR}/www/wp-content"
	mkdir "${DIR}/www/wp-content/themes"
	mkdir "${DIR}/www/wp-content/themes/vip"
	mkdir "${DIR}/www/wp-content/plugins"
	mkdir "${DIR}/www/wp-content/upgrade"
	mkdir "${DIR}/www/wp-content/uploads"

	mkdir "${DIR}/www/wp-content/themes/vip/plugins"
	cd "${DIR}/www/wp-content/themes/vip/plugins"
	svn checkout --non-interactive --trust-server-cert https://vip-svn.wordpress.com/plugins/ ./

	mkdir "${DIR}/www/wp-content/themes/twentyfifteen"
	cd "${DIR}/www/wp-content/themes/twentyfifteen"
	svn checkout --non-interactive --trust-server-cert https://wpcom-themes.svn.automattic.com/twentyfifteen/ ./

	mkdir "${DIR}/www/wp-tests"
	cd "${DIR}/www/wp-tests"
	svn checkout --non-interactive --trust-server-cert http://develop.svn.wordpress.org/trunk/ ./

	#setting up configuration files
	cp /files/* "${DIR}/www/"
	rm -r files


	#configure wordpress plugins
	plugins=(
	  'log-deprecated-notices'
	  'monster-widget'
	  'query-monitor'
	  'user-switching'
	  'wordpress-importer'
	  'keyring'
	  'mrss'
	  'polldaddy'
	  'rewrite-rules-inspector'
	)
	declare -A github_plugins=(
		[vip-scanner]='https://github.com/Automattic/vip-scanner'
		[jetpack]='https://github.com/Automattic/jetpack'
		[media-explorer]='https://github.com/Automattic/media-explorer'
		[writing-helper]='https://github.com/automattic/writing-helper'
	)

	#TODO Configure apache to run the code from the correct location

	#installing site
	cd "${DIR}/www/wp"
	wp core multisite-install --url='vip.local' --title='Wordpress site' --admin_email='admin@example.com' --admin_name='wordpress' --admin_password='wordpress' --allow-root

	#installing plugins
	cd "${DIR}/www/wp-content/plugins"
	for i in "${plugins[@]}"
	do
   		wp plugin install ${i} --allow-root
		wp plugin activate ${i} --network --allow-root
	done

	#installing plugins
	for K in "${!github_plugins[@]}";
	do
	    echo $K --- ${github_plugins[$K]};
		mkdir $K
		cd $K
		git checkout ${github_plugins[$K]} ./
		cd ..
		wp plugin activate ${K} --network --allow-root
	done

	cd "${DIR}/www/wp"
	wp plugin update --all --allow-root

	# Symlink db.php for Query Monitor
	ln -s ${DIR}/www/wp-content/db.php  ${DIR}/www/wp-content/plugins/query-monitor/wp-content/db.php

fi
exec "$@"

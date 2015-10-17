#!/bin/bash
set -e

DIR="/var/www/html"
WP_DIR="/var/www/html/wp"

#configuring wp cli
cd /tmp
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --info --allow-root
echo "INFO: wp-cli installed"

if [ "$(ls -A $WP_DIR)" ];
then
	#seems that we have alredy installed wp core, just update it
	cd "${WP_DIR}"
	svn up
	cd "${DIR}/wp-content/themes/vip/plugins"
	svn up
	cd "${DIR}/wp-content/themes/twentyfifteen"
	svn up
	cd "${DIR}/wp-tests"
	svn up
else
	echo "INFO: setting the database"
	#setting database user names and tables
	mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /init-tables.sql
	rm /init-tables.sql

	echo "INFO: Creating WP DIR"
	echo "INFO: ${WP_DIR}"
	mkdir "${WP_DIR}"
	cd "${WP_DIR}"
	svn checkout --non-interactive --trust-server-cert http://core.svn.wordpress.org/trunk/ ./

	#making sure some necessary folders exist
	mkdir "${DIR}/wp-content"
	mkdir "${DIR}/wp-content/themes"
	mkdir "${DIR}/wp-content/themes/vip"
	mkdir "${DIR}/wp-content/plugins"
	mkdir "${DIR}/wp-content/upgrade"
	mkdir "${DIR}/wp-content/uploads"

	mkdir "${DIR}/wp-content/themes/vip/plugins"
	cd "${DIR}/wp-content/themes/vip/plugins"
	svn checkout --non-interactive --trust-server-cert https://vip-svn.wordpress.com/plugins/ ./

	mkdir "${DIR}/wp-content/themes/twentyfifteen"
	cd "${DIR}/wp-content/themes/twentyfifteen"
	svn checkout --non-interactive --trust-server-cert https://wpcom-themes.svn.automattic.com/twentyfifteen/ ./

	mkdir "${DIR}/wp-tests"
	cd "${DIR}/wp-tests"
	svn checkout --non-interactive --trust-server-cert http://develop.svn.wordpress.org/trunk/ ./

	#setting up configuration files
	cp -r /files/* "${DIR}/"
	rm -r /files


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
		[vip-scanner]='https://github.com/Automattic/vip-scanner.git'
		[jetpack]='https://github.com/Automattic/jetpack.git'
		[media-explorer]='https://github.com/Automattic/media-explorer.git'
		[writing-helper]='https://github.com/automattic/writing-helper.git'
	)

	#installing site
	echo "INFO: Installing the site using wp-cli"
	cd $WP_DIR
	pwd
	wp core multisite-install --path=$WP_DIR --url='vip.local' --title='Wordpress site' --admin_email='admin@example.com' --admin_name='wordpress' --admin_password='wordpress' --allow-root
	echo "INFO: Site installed"

	#installing plugins
	cd "${DIR}/wp-content/plugins"
	for i in "${plugins[@]}"
	do
   		wp plugin install ${i} --allow-root --path=$WP_DIR
		wp plugin activate ${i} --network --allow-root --path=$WP_DIR
	done

	#installing plugins
	for K in "${!github_plugins[@]}";
	do
	    echo $K --- ${github_plugins[$K]};
		mkdir $K
		cd $K
		git clone ${github_plugins[$K]} ./
		git submodule update --init --recursive
		cd ..
		wp plugin activate ${K} --network --allow-root --path=$WP_DIR
	done

	cd "${WP_DIR}"
	wp plugin update --all --allow-root --path=$WP_DIR

	# Symlink db.php for Query Monitor
	ln -s ${DIR}/wp-content/plugins/query-monitor/wp-content/db.php ${DIR}/wp-content/db.php

fi
exec "$@"

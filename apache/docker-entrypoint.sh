#!/bin/bash
set -e

DIR=/srv
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

exec "$@"

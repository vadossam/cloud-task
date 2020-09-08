#!/usr/bin/env bash
source /.env

VH_DOC_ROOT='/var/www/vhosts/localhost/html'
DB_HOST='mysql'
THEME='twentytwenty'


cd ${VH_DOC_ROOT} || exit 1
wp core download --allow-root

if [ ! -f ${VH_DOC_ROOT}/wp-config.php ] && [ -f ${VH_DOC_ROOT}/wp-config-sample.php ]; then
    cp ${VH_DOC_ROOT}/wp-config-sample.php ${VH_DOC_ROOT}/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" ${VH_DOC_ROOT}/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" ${VH_DOC_ROOT}/wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" ${VH_DOC_ROOT}/wp-config.php
    sed -i "s/localhost/${DB_HOST}/" ${VH_DOC_ROOT}/wp-config.php
    echo "DB details are set"
elif [ -f ${VH_DOC_ROOT}/wp-config.php ]; then
    echo "${VH_DOC_ROOT}/wp-config.php already exist, exit !"
    exit 1
else
    echo 'No wp-config file!'
    exit 2
fi

wget -q -P ${VH_DOC_ROOT}/wp-content/plugins/ https://downloads.wordpress.org/plugin/litespeed-cache.zip
if [ ${?} = 0 ]; then
    unzip -qq -o ${VH_DOC_ROOT}/wp-content/plugins/litespeed-cache -d ${VH_DOC_ROOT}/wp-content/plugins/
    echo "Litespeed cache plugin is installed"
else
    echo "FAILED to download Litespeed cache plugin"
fi
rm -f ${VH_DOC_ROOT}/wp-content/plugins/*.zip


cat << EOM > ${VH_DOC_ROOT}/.htaccess
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOM


# Enabling litespeed plugin
if [ ! -f ${VH_DOC_ROOT}/wp-content/themes/${THEME}/functions.php.bk ]; then
        cp ${VH_DOC_ROOT}/wp-content/themes/${THEME}/functions.php ${VH_DOC_ROOT}/wp-content/themes/${THEME}/functions.php.bk
        ed ${VH_DOC_ROOT}/wp-content/themes/${THEME}/functions.php << END >>/dev/null 2>&1
2i
require_once( WP_CONTENT_DIR.'/../wp-admin/includes/plugin.php' );
\$path = 'litespeed-cache/litespeed-cache.php' ;
if (!is_plugin_active( \$path )) {
    activate_plugin( \$path ) ;
    rename( __FILE__ . '.bk', __FILE__ );
}
.
w
q
END
fi

chown -R 1000:1000 ${VH_DOC_ROOT}
exit 0

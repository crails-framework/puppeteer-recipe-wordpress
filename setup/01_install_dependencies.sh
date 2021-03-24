#!/bin/bash -ex

source ./variables 2> /dev/null

apt-get update

apt-get install -y software-properties-common

#add-apt-repository universe
#apt-get update

apt-get install -y \
  php-fpm \
  php-mysql

php_fpm_version=`find /etc/php -name www.conf | head -n 1 | cut -d '/' -f 4`
php_fpm_service="php$php_fpm_version-fpm"

if [[ `which php-fpm` ]] ; then
  systemctl enable php-fpm
elif [[ `which php-fpm$php_fpm_version` ]] ; then
  systemctl enable php$php_fpm_version-fpm
else
  echo "/!\\ WARNING: could not enable php-fpm service"
fi

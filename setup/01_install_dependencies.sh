#!/bin/bash -ex

source ./variables 2> /dev/null

apt-get update

apt-get install -y software-properties-common

add-apt-repository universe
apt-get update

apt-get install -y \
  php-fpm \
  php-mysql

if [[ `which php-fpm` ]] ; then
  systemctl enable php-fpm
elif [[ `which php-fpm7.0` ]] ; then
  systemctl enable php7.0-fpm
else
  echo "/!\\ WARNING: could not enable php-fpm service"
fi

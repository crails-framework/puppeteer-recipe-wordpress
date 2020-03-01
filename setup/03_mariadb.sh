#!/bin/bash -ex

source ./variables 2> /dev/null

apt-get install -y mariadb-server

systemctl enable mariadb.service

if [[ -z "$APP_SQL_DATABASE" ]] ; then
  export APP_SQL_DATABASE="$INSTANCE_NAME"
fi

user_exists=`mysql -e "SELECT COUNT(User) FROM mysql.user WHERE User='$APP_USER'" | grep 1 || echo "0"`

if [[ $user_exists == 1 ]] ; then
  mysql -e "SET PASSWORD FOR '$APP_USER'@'localhost' = PASSWORD('$APP_SQL_PASSWORD');"
else
  mysql -e "CREATE USER '$APP_USER'@'localhost' IDENTIFIED BY '$APP_SQL_PASSWORD';"
fi

mysql -e "CREATE DATABASE IF NOT EXISTS \`$APP_SQL_DATABASE\`"
mysql -e "GRANT ALL PRIVILEGES ON \`$APP_SQL_DATABASE\`.* TO '$APP_USER'@'localhost';"

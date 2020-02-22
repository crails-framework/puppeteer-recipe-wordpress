#!/bin/bash -ex

source ./variables 2> /dev/null

apt-get install -y mariadb-server

systemctl enable mysql

user_exists=`mysql -e "SELECT COUNT(User) FROM mysql.user WHERE User='$APP_USER'" | grep 1 || echo "0"`

if [[ $user_exists == 1 ]] ; then
  mysql -e "SET PASSWORD FOR '$APP_USER'@'localhost' = PASSWORD('$APP_SQL_PASSWORD');"
else
  mysql -e "CREATE USER '$APP_USER'@'localhost' IDENTIFIED BY '$APP_SQL_PASSWORD';"
fi

mysql -e "CREATE DATABASE IF NOT EXISTS \`$INSTANCE_NAME\`"
mysql -e "GRANT ALL PRIVILEGES ON \`$INSTANCE_NAME\`.* TO '$APP_USER'@'localhost';"

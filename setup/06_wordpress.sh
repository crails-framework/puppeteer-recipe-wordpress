#!/bin/bash -ex

source ./variables 2> /dev/null

function get_http_group_name() {
  user_line=`cat /etc/nginx/nginx.conf | grep -e "^user"` | cut -d ';' -f 1
  http_group_name=`echo $user_line | cut -d ' ' -f 3`
  http_user_name=`echo $user_line | cut -d ' ' -f 2`

  if [[ "$http_user_name" == "" ]] ; then
    http_user_name="http"
  fi

  if [[ "$http_group_name" == "" ]] ; then
    http_group_name=$http_user_name
  fi

  echo $http_group_name
}

app_dir="/home/$APP_USER/app"

cd /tmp
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

rsync -av wordpress/* "$app_dir"
chown -R $APP_USER:`get_http_group_name` "$app_dir"
chmod -R 775 "$app_dir"

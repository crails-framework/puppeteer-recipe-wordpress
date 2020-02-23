#!/bin/bash -ex

source ./variables 2> /dev/null

available_path="/etc/nginx/sites-available/$INSTANCE_NAME"
enabled_path="/etc/nginx/sites-enabled/$INSTANCE_NAME"

if [[ -e "$available_path" ]] ; then
  mv "$available_path" "$enabled_path"
  systemctl reload nginx
elif [[ -e "$enabled_path" ]] ; then
  echo "site is already enabled"
else
  echo "cannot enable site: missing nginx configuration file"
  exit -1
fi

#!/bin/bash -ex

source ./variables 2> /dev/null

available_path="/etc/nginx/sites-available/$INSTANCE_NAME"
enabled_path="/etc/nginx/sites-enabled/$INSTANCE_NAME"

if [[ -e "$enabled_path" ]] ; then
  mkdir -p /etc/nginx/sites-available
  mv "$enabled_path" "$available_path"
  systemctl reload nginx
else
  echo "cannot disable site: missing nginx configuration file"
  exit -1
fi

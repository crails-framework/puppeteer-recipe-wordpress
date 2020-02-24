#!/bin/bash -ex

source ./variables 2> /dev/null

available_path="/etc/nginx/sites-available/$INSTANCE_NAME"
enabled_path="/etc/nginx/sites-enabled/$INSTANCE_NAME"

if [[ -e "$enabled_path" ]] ; then
  if systemctl status nginx ; then
    exit 0
  else
    exit 1
  fi
fi

if [[ -e "$available_path" ]] ; then
  exit 1
fi

exit -1

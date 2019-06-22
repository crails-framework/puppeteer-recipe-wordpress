#!/bin/bash -ex

source ./variables 2> /dev/null

apt-get install -y nginx

systemctl enable nginx

bash nginx.config > /etc/nginx/sites-enabled/$INSTANCE_NAME;

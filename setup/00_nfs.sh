#!/bin/bash -ex

source ./variables 2> /dev/null

build_path=/opt/puppeteer/builds

if [[ $NFS_BUILD_IP ]] ; then
  if [[ -z `grep /opt/puppeteer/builds /etc/fstab` ]] ; then
    mount $NFS_BUILD_IP:$build_path $build_path
    echo "$NFS_BUILD_IP:$build_path $build_path nfs defaults,user,auto,noatime,ro 0 0" > /etc/fstab
  fi
else
  echo "(!) Variable NFS_BUILD_IP unset. Puppeteer's build directory won't be mounted"
fi

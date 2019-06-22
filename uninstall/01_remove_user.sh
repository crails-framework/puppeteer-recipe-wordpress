#!/bin/bash -ex

source ./variables 2> /dev/null

userdel -rf $APP_USER

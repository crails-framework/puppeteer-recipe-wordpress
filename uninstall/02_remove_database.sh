#!/bin/bash -ex

source ./variables 2> /dev/null

mysql -e "DROP DATABASE $INSTANCE_NAME;"

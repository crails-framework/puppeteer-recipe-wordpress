#!/bin/bash -ex

source ./variables 2> /dev/null

cd "$APP_PATH"
tar -xf "$BUILD_TARBALL"

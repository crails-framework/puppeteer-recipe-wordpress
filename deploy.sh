#!/bin/bash -ex

source ./variables 2> /dev/null

wp_content_path="$APP_PATH/app/wp-content"

mkdir -p "$wp_content_path"
cd "$wp_content_path"

tar -xf "$BUILD_TARBALL"

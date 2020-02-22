#!/bin/bash -ex

source ./variables 2> /dev/null

function get_http_group_name() {
  user_line=`cat /etc/nginx/nginx.conf | grep -e "^user" | cut -d ';' -f 1`
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

#
# Install Wordpress
#
cd /tmp
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

rsync -av wordpress/* "$app_dir"
mkdir -p "$app_dir/uploads"

cd -
bash wp.config > "$app_dir/wp-config.php"

chown -R $APP_USER:`get_http_group_name` "$app_dir"
chmod -R 775 "$app_dir"

#
# Link wp-content to Build path
#
wp_content_path="$app_dir/wp-content"

if [[ -L "$wp_content_path" && -d "$wp_content_path" ]] ; then
  unlink "$wp_content_path"
else
  rm -Rf "$wp_content_path"
fi

ln -s "$BUILD_PATH" "$wp_content_path"

#
# Create admin user, if no user exists (auth data: root;password)
#
user_count=`mysql -sN -e "SELECT COUNT(ID) FROM \`$INSTANCE_NAME\`.wp_users"`

if [[ $user_count == "0" ]] ; then
  encrypted_admin_password='$P$B4sJvG64B5N6Tz81DglGUySJRIc/mf.'
  mysql -e "INSERT INTO \`$INSTANCE_NAME\`.wp_users VALUES ('', 'root', '$encrypted_admin_password', 'root', 'contact@company.com', '', '', '', 0, 'root')"
  admin_user_id=`mysql -sN -e "SELECT ID FROM \`$INSTANCE_NAME\`.wp_users ORDER BY ID DESC LIMIT 1"`
  mysql -e "INSERT INTO \`$INSTANCE_NAME\`.wp_usermeta VALUES(NULL, $admin_user_id, 'wp_capabilities', 'a:1:{s:13:\"administrator\";b:1;}')"
  mysql -e "INSERT INTO \`$INSTANCE_NAME\`.wp_usermeta VALUES(NULL, $admin_user_id, 'wp_user_level', '10')"
fi

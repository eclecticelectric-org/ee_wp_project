#!/usr/bin/env bash
#
# WordPress project setup using Eclectic Electric's
# WordPress Project Template using Git and Composer
#
# Copyright 2019 Eclectic Electric, Inc.
# https://www.eclecticelectric.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# -------------
# Requirements:
# -------------
# + Ubuntu 18.04 LTS+ compatible Linux
# + LAMP/LEMP stack with PHP 7.2+, Apache 2.4+/nginx 1.14+, MySQL 5.7+
# + git 2.17+
# + composer 1.9+ accessible using the 'composer' command
#
# How to use this script:
# 1. Clone the project repository to access this setup file
#       git clone https://github.com/eclecticelectric-org/ee_wp_project PROJECT
# 2. Run the script PROJECT/setup/ee-wp-project.sh for additional instructions
#

#---
# useful script related variables
#---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SCRIPT_NAME=$(basename "$0")

#---
# process args
#---
source $SCRIPT_DIR/parse_args.sh

if [ -n "$SHOW_HELP" ]; then
    usage "$SCRIPT_NAME"; exit $ARG_ERROR
fi

# project domain name must be provided
if [ -z "$PROJECT_DOMAIN" ]; then
    ARG_ERROR=1
fi

if [ "$ARG_ERROR" -gt "0" ]; then
    echo "Error: invalid input"
    usage "$SCRIPT_NAME"; exit $ARG_ERROR
fi

# full filesystem path to the project directory
WS_BASEDIR=$WS_ROOT/$PROJECT
# location of configuration files used by this script
CONFIG_DIR=$WS_BASEDIR/config

# ensure project directory exists
if [ ! -d "$WS_BASEDIR" ]; then
    echo "Error: project $WS_BASEDIR does not exist"
    exit 1
fi

#---
# ensure specified users exist
#---
source $SCRIPT_DIR/user_group_check.sh

# check file system user.group
user_group_check "$FS_USER" "$FS_GROUP"
if [ ! $? -eq 0 ]; then
    echo "File system user/group does not exist - user:$FS_USER group:$FS_GROUP"
    exit 1
fi

# check web server user.group
user_group_check "$WS_USER" "$WS_GROUP"
if [ ! $? -eq 0 ]; then
    echo "Web server user/group does not exist - user:$WS_USER group:$WS_GROUP"
    exit 1
fi

# exit if this script already ran
if [ -d "$WS_BASEDIR/public/wp-content" ]; then
    echo "Error: Project already initialized"
    exit 1
fi

# =====  let's go! =====

echo "Initializng WordPress project $WS_BASEDIR for domain $PROJECT_DOMAIN"

cd $WS_BASEDIR

# install all packages, including WordPress core
composer install

# create the WordPress salts
./setup/wp_local_config.sh

#---
# create the local configuration file for WordPress if none exists
#---
if [ ! -e local-config.php ]; then
    # establish the default local-config.php file for local configuration
    cp setup/default-local-config.php local-config.php
    # add WordPress 'siteurl' and 'home' to the local configuration
    printf "\ndefine('WP_SITEURL', \$http_request_scheme . '://%s');\ndefine('WP_HOME', \$http_request_scheme . '://%s');\n" "$PROJECT_DOMAIN" "$PROJECT_DOMAIN" >> local-config.php
fi

# move the default WordPress wp-content directory outside the web docroot
mv public/wp/wp-content public/

# create uploads directory
mkdir public/wp-content/uploads

# create logs directory
mkdir logs

#---
# set directory and file permissions
# ---
echo "Using sudo to make ownership and permission changes required by web server..."
sudo $SCRIPT_DIR/set_wp_file_perms.sh "$WS_BASEDIR" "$FS_USER" "$FS_GROUP" "$WS_USER" "$WS_GROUP"

#---
# configure the web server virtual host
#---
source ./setup/config-virtual-host.sh
setup_virtual_host

#---
# remove the .git directory from the project clone unless keep option provided
#---
if [ -z "$KEEP_GIT" ]; then
    rm -fr $WS_BASEDIR/.git
else
    # keep the git working space but remove the project remote so git push won't
    # send changes back to the remote repo. User must config a remote.
    git remote rm origin
fi

echo "Done."
# ----- end of ee-wordpress-setup.sh -----

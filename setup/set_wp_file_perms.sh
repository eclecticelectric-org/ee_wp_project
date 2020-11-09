#!/usr/bin/env bash
#
# Copyright 2020,2019 Eclectic Electric, Inc.
# https://www.eclecticelectric.com
#
# set_wp_file_perms.sh
#
# set WordPress file & directory permissions

# Set permissions on WordPress directories and files
#
# set_wp_project_perms PROJECT_ROOT WEB_USER WEB_GROUP WEB_SERVER_USER WEB_SERVER_GROUP
# Parameters:
# $1 = PROJECT_ROOT (web server docroot)
# $2 = WEB_USER (user to own files)
# $3 = WEB_GROUP (group to own directories)
# $4 = WEB_SERVER_USER (web server process user)
# $5 = WEB_SERVER_GROUP (web server process group)
#

scriptname="$0"

if (( $# != 5 ))
then
    echo "$scriptname: Missing arguments"
    exit 1
fi

set_wp_project_perms () {

    #---
    # lockdown all directory and file permissions
    # execute removed from all scripts, including the project setup scripts
    # ---
    # set permissions across project
    find $1 -type d -exec chmod 750 {} \;
    find $1 -type f -exec chmod 640 {} \;

    # chown across project
    chown -R $2.$3 $1
    # fixup project root directory so web server can read as 'other'
    chmod 775 $1

    # set group access to web server across project
    chgrp -R $3 $1

    #---
    # take care of web root in /public
    # Allow sftp users to write through group membership in WEB_GROUP
    # Allow web server to read through 'other' permissions
    #---
    find $1/public -type d -exec chmod 775 {} \;
    find $1/public -type f -exec chmod 664 {} \;

    # allow web server to read/write/create in uploads
    chown -R $4 $1/public/wp-content/uploads
    # provide web server access to salts file
    chgrp $5 $1/salts.inc
    # let web server write to logs directory
    chgrp $5 $1/logs
    chmod 770 $1/logs

    # some plugins require read access to vendor directory
    chgrp -R $5 $1/vendor

    # allow web server to create directories in wp-content
    chown $4 $1/public/wp-content

    # allow web server group read access to config
    if [ -e $1/local-config.php ]; then
        chgrp $5 $1/local-config.php
        chmod 640 $1/local-config.php
    fi
    if [ -e $1/production-config.php ]; then
        chgrp $5 $1/production-config.php
        chmod 640 $1/production-config.php
    fi
   
    # maintain exec permissions for user in setup directory
    chmod u+x $1/setup/*sh 
}

set_wp_project_perms "$1" "$2" "$3" "$4" "$5"

# ----- end of set_wp_file_parms.sh -----

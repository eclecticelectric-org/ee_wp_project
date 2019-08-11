#!/usr/bin/env bash
#
# Copyright 2019 Eclectic Electric, Inc.
# https://www.eclecticelectric.com
#
# Parse command line arguments
#

usage () {
    echo "Usage: $1 --project-domain DOMAIN [OPTION]..."
    echo "Initialize a WordPress project using Eclectic Electric's WordPress project template"
    echo ""
    echo "Required:"
    echo "  -d, --project-domain DOMAIN   domain name (example.com)"
    echo ""
    echo "Options:"
    echo "  -h, --help                    display this usage information and exit"
    echo "  -p, --project PROJECT         project name (match cloned repository directory name)"
    echo "                                  (if not provided, default to DOMAIN)"
    echo "  -w, --web-user USER           web server process user (www-data)"
    echo "  -b, --web-group GROUP         web server process user group (www-data)"
    echo "  -r, --web-root DIRECTORY      parent filesystem directory for project"
    echo "  -s, --web-server              config virtual host: [apache|nginx] (apache)"
    echo "  -u, --user USER               user owner of project files"
    echo "  -g, --group GROUP             group owner of project files"
    echo "  -c, --host-config DIRECTORY   host config directory (/etc/apache2/sites-available)"
    echo "  -k, --keep-git                keep cloned project's .git directory"
    echo ""
    echo "Example:"
    echo "    $1 --project-domain spacelaunch.com"
    echo "    $1 --project spacelaunch --project-domain spacelaunch.com"
    echo "    $1 --project spacelaunch --project-domain spacelaunch.com --user webdev --group webdev"
    echo "    $1 --project spacelaunch --project-domain spacelaunch.com --web-server nginx"
    exit 1
}

## setup default variables

# current user primary group
USER_GROUP=$(id -gn)

#---
# web server process user/group
#
# The web server requires write permissions to the
# wp-content/uploads directory. Specify the user and group
# under which the web server runs. If this script is not run as 'root'
# and the current user/group differs from the web server process user
# then 'sudo' will run so the correct permissions can be set on the
# uploads directory
#
# defaults: www-data
#---
WS_USER=www-data
WS_GROUP=www-data

# web server basedir - default to the current directory
WS_ROOT=$(pwd)

# file system user/group - default to current user
FS_USER=$USER
FS_GROUP=$USER_GROUP

##
# process arguments
##

# argument array
args=( )

# replace long arguments
for arg; do
    case "$arg" in
        --web-user)       args+=( -w ) ;;
        --web-group)      args+=( -b ) ;;
        --web-root)       args+=( -r ) ;;
        --web-server)     args+=( -s ) ;;
        --user)           args+=( -u ) ;;
        --group)          args+=( -g ) ;;
        --project)        args+=( -p ) ;;
        --project-domain) args+=( -d ) ;;
        --host-config)    args+=( -c ) ;;
        --help)           args+=( -h ) ;;
        --keep-git)       args+=( -k ) ;;
        *)                args+=( "$arg" ) ;;
    esac
done

#printf 'args before update : '; printf '%q ' "$@"; echo
set -- "${args[@]}"
#printf 'args after update  : '; printf '%q ' "$@"; echo

ARG_ERROR=0

while getopts "w:b:r:s:u:g:p:d:c:hk" OPTION; do
    : "$OPTION" "$OPTARG"
#    echo "optarg : $OPTARG"
    case $OPTION in
    c)   WS_VIRTUALHOST_DIR="$OPTARG";;
    w)   WS_USER="$OPTARG";;
    b)   WS_GROUP="$OPTARG";;
    r)   WS_ROOT="$OPTARG";;
    s)   WS_SOFTWARE="$OPTARG";;
    u)   FS_USER="$OPTARG";;
    g)   FS_GROUP="$OPTARG";;
    p)   PROJECT="$OPTARG";;
    d)   PROJECT_DOMAIN="$OPTARG";;
    h)   SHOW_HELP=1;;
    k)   KEEP_GIT=1;;
    ?)   ARG_ERROR=1;;
    esac
done


# force web server software config to 'apache' if no valid spec provided
ws_software=("apache" "nginx")
if [[ ! " ${ws_software[@]} " =~ " ${WS_SOFTWARE} " ]]; then
    WS_SOFTWARE=apache
fi

if [ -z "$PROJECT" ]; then
    PROJECT=$PROJECT_DOMAIN
fi

# echo "PROJECT=$PROJECT"
# echo "PROJECT_DOMAIN=$PROJECT_DOMAIN"
# echo "FS_USER=$FS_USER"
# echo "FS_GROUP=$FS_GROUP"
# echo "WS_USER=$WS_USER"
# echo "WS_GROUP=$WS_GROUP"
# echo "WS_ROOT=$WS_ROOT"
# echo "WS_SOFTWARE=$WS_SOFTWARE"
# echo "HELP=$SHOW_HELP"
# echo "ERROR=$ARG_ERROR"

# ----- end of parse_args.sh -----

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
    echo "  -u, --user USER               user owner of project files"
    echo "  -g, --group GROUP             group owner of project files"
    echo "  -c, --host-config DIRECTORY   host config directory (/etc/apache2/sites-available)"
    echo "  -k, --keep-git                keep cloned project's .git directory"
    echo ""
    echo "Example:"
    echo "    $1 --project-domain spacelaunch.com"
    echo "    $1 --project spacelaunch --project-domain spacelaunch.com"
    echo "    $1 --project spacelaunch --project-domain spacelaunch.com --user webdev --group webdev"
    exit 1
}

# argument array
args=( )

# replace long arguments
for arg; do
    case "$arg" in
        --web-user)       args+=( -w ) ;;
        --web-group)      args+=( -b ) ;;
        --web-root)       args+=( -r ) ;;
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

while getopts "w:b:r:u:g:p:d:c:hk" OPTION; do
    : "$OPTION" "$OPTARG"
#    echo "optarg : $OPTARG"
    case $OPTION in
    c)   WS_VIRTUALHOST_DIR="$OPTARG";;
    w)   WS_USER="$OPTARG";;
    b)   WS_GROUP="$OPTARG";;
    r)   WS_ROOT="$OPTARG";;
    u)   FS_USER="$OPTARG";;
    g)   FS_GROUP="$OPTARG";;
    p)   PROJECT="$OPTARG";;
    d)   PROJECT_DOMAIN="$OPTARG";;
    h)   SHOW_HELP=1;;
    k)   KEEP_GIT=1;;
    ?)   ARG_ERROR=1;;
    esac
done

# echo "WEB_USER=$WEB_USER"
# echo "WEB_GROUP=$WEB_GROUP"
# echo "WEB_ROOT=$WEB_ROOT"
# echo "FS_USER=$FS_USER"
# echo "FS_GROUP=$FS_GROUP"
# echo "PROJECT=$PROJECT"
# echo "PROJECT_DOMAIN=$PROJECT_DOMAIN"
# echo "HELP=$SHOW_HELP"
# echo "ERROR=$ARG_ERROR"
# echo "WS_VIRTUALHOST_DIR=$WS_VIRTUALHOST_DIR"

# ----- end of parse_args.sh -----

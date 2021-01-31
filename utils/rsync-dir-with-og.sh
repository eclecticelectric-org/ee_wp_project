#! /usr/bin/env bash
#
# may require sudo
# requires src and dest spec
#
# specify src without a trailing slash... that dir synced to .
#

scriptname="$0"

if (( $# != 1 ))
then
    echo "$scriptname: Must specify source directory without a trailing '/'"
    exit 1
fi

rsync -r -og --chown=www-data:www-data $1 .

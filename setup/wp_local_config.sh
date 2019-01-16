#!/bin/bash
#
# Copyright 2019 Eclectic Electric, Inc.
# https://www.eclecticelectric.com
#
# Output new WordPress salts to a standalone include file
#
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUTPUT_FILE=salts.inc
SALTS=`$SCRIPTDIR/wp_salts.sh`
printf "<?php\n" $SALTS >$OUTPUT_FILE
echo "$SALTS" >>$OUTPUT_FILE


#!/bin/bash
#
# Copyright 2019,2021 Eclectic Electric, Inc.
# https://www.eclecticelectric.com
#
#----------------------------
# generate wordpress salts
#----------------------------

echo '<?php'

# use chars per wp_salt() in wp-includes/pluggable.php
ALPHANUM_CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
SPECIALS_CHARS='!@#$%^&*()'
EXTRA_SPECIAL_CHARS='-_ []{}<>~`+=,.;:/?|'
CHARS=${ALPHANUM_CHARS}${SPECIAL_CHARS}${EXTRA_SPECIAL_CHARS}

for key in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT
do
#    echo Processing key: $i
    SALT=`</dev/urandom tr -dc "$CHARS" | tr '\\\' '+' | head -c 64  ; echo`
    KEY=\'$key\',
    printf "define(%-19s '%s');\n" "$KEY" "$SALT"
done

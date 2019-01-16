#!/usr/bin/env bash
#
# Copyright 2019 Eclectic Electric, Inc.
# https://www.eclecticelectric.com
#

#--
# test if a user and optionally a group exist
# Parameters: user [group]
# Return:
#   0 - user and group valid
#   1 - user invalid
#   2 - group invalid
#   3 - user and group invalid
#   4 - invalid call, no parameters
#--
user_group_check () {
    if [ ! -z "$1" ]; then
        # test if user exists
        id -u "$1" &>/dev/null
        USER_CHECK=$?
        GROUP_CHECK=0
        if [ ! -z "$2" ]; then
            getent group "$2" &>/dev/null
            GROUP_CHECK=$?
            if [ $GROUP_CHECK -ne 0 ]; then
                GROUP_CHECK=2;
            fi
        fi
        return $((USER_CHECK+GROUP_CHECK))
    fi
    return 4;
}

# ----- end of user_group_check.sh -----

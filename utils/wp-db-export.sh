#!/usr/bin/env bash
#
wp db export --add-drop-table --set-gtid-purged=OFF --no-tablespaces=true $1

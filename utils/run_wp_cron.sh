#!/bin/sh
#
# Use wp-cli to run WordPress cron events
#
# Define DISABLE_WP_CRON in WordPress config so cron is not run
# on each request but left to an external process
#
# path to the wp-cli executable
WP_CLI=/usr/local/bin/wp
# set WP_PUBLIC_DIR to the project .../public directory
WP_PUBLIC_DIR=SET_THIS

cd "$WP_PUBLIC_DIR"
#/usr/local/bin/wp cron event run --due-now
for hook in $($WP_CLI cron event list --next_run_relative=now --fields=hook --format=ids)
  do $WP_CLI cron event run "$hook"
done

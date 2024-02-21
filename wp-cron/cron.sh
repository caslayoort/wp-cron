#!/bin/bash

WpSite=$1

/bin/wp cron event run --due-now --user='USERNAME' --context=admin --path="/var/www/html" --url="$WpSite" --allow-root

#!/bin/bash

## Keeps wp-cron running

bash="/bin/bash"

while true; do
  $bash -c "/opt/wp-cron/run.sh" &
  wait
done

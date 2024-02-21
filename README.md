# wp-cron
Custom service replacing the cronjobs in a multisite wordpress in case the scheduler is broken

Warning: the service has been designed as a 'quick fix' for a broken wordpress scheduler. I am not responsible for any side effects, especially since the service is designed to run as root.

Installing:
- Make sure the wordpress cli is installed on your system (https://make.wordpress.org/cli/handbook/guides/installing/)
- Afterwards make sure you move the wp-cron folder to /opt and replace the username in the cron.sh file
- chmod +x /opt/wp-cron/*.sh
- add the service file to systemd (by moving the wp-cron.service file to /etc/systemd/system/wp-cron.service and executing systemctl daemon-reload)
- start the service.


The way the application works is it pulls all the sites from the wordpress cli and loops over each site and starts a subprocess which executes all jobs due at that moment. It has a threading system so it wont execute all sites at once so you do not have to worry about your system breaking from a spike in memory / cpu usage when you have a lot of sites running on your multisite wp.

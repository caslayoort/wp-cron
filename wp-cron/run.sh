#!/bin/bash

##################################################################################
#                                    Settings                                    #
##################################################################################
pid_file="/opt/wp-cron/pid.file"                                                 #
max_amount_of_subprocesses="4"                                                   #
cron="/opt/wp-cron/cron.sh"                                                      #
##################################################################################
#                                    Commands                                    #
##################################################################################
expr="/usr/bin/expr"                                                             #
echo="/bin/echo"                                                                 #
jq="/usr/bin/jq"                                                                 #
curl="/usr/bin/curl"                                                             #
seq="/usr/bin/seq"                                                               #
node="/usr/bin/node"                                                             #
awk="/usr/bin/awk"                                                               #
sed="/bin/sed"                                                                   #
cut="/usr/bin/cut"                                                               #
DATE="/bin/date"                                                                 #
printf="/usr/bin/printf"                                                         #
bash="/bin/bash"                                                                 #
wc="/usr/bin/wc"                                                                 #
cat="/bin/cat"                                                                   #
head="/usr/bin/head"                                                             #
touch="/usr/bin/touch"                                                           #
rm="/bin/rm"                                                                     #
##################################################################################
#                                   Functions                                    #
##################################################################################
                                                                                 #
getWpUrls(){                                                                     #
 wp site list --path="/var/www/html" --fields=url --format=csv --allow-root      #
}                                                                                #
                                                                                 #
runCron(){                                                                       #
  echo "run ${1}"                                                                #
}                                                                                #
                                                                                 #
##################################################################################
#                                Run the program                                 #
##################################################################################
                                                                                 #
URLS=$(getWpUrls)                                                                #
$touch $pid_file                                                                 #
for wpurl in $URLS; do                                                           #
    pids=$( $cat $pid_file | $wc -l)                                             #
    # Creating the possibility of threading                                      # 
    while [ $pids -gt $max_amount_of_subprocesses ]; do                          #
      WAITING_PID=$( $cat $pid_file | $head -n 1 )                               #
      wait $WAITING_PID                                                          #
      $sed -i "/$WAITING_PID/d" $pid_file                                        #
      pids=$( $cat $pid_file | $wc -l)                                           #
    done                                                                         #
  ##Run                                                                          #
    $bash -c "$cron \"$wpurl\""   &                                              #
    $echo $! >> $pid_file                                                        #
done                                                                             #
                                                                                 #
for i in $( $cat $pid_file ); do                                                 #
  wait $i                                                                        #
done                                                                             #
$rm $pid_file                                                                    #
##################################################################################


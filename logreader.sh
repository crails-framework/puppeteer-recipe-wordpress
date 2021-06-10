#!/bin/bash -x

source ./variables 2> /dev/null

logfile="/var/log/nginx/access.log"
logs=`cat "$logfile" | grep "$HOSTNAME"`
total_lines=`echo "$logs" | wc -l | cut -d' ' -f1`
extract_lines=500

if [[ "$LAST_LOG_LINE" > "$total_lines" ]] ; then
  extract_lines=`$total_lines`
elif [[ "$LAST_LOG_LINE" > 0 ]] ; then
  extract_lines=`expr $total_lines - $LAST_LOG_LINE`
fi

echo $total_lines
echo "$logs" | tail -n $extract_lines

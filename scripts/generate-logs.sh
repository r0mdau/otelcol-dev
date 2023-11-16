#!/bin/bash

# Ask for the number of log lines
if [ -z "$1" ]
  then echo "You need to specify the number of log lines to generate"
  exit 1
fi

levels[0]="INFO"
levels[1]="ERROR"
levels[2]="WARNING"
size=${#levels[@]}


# Current timestamp in milliseconds
timestamp=$(date +%s%3N)

fixed_log=' This is a message from the server'

for (( i=0; i<$1; i++ ))
do
    # Get a random log level
    index=$(($RANDOM % $size))
    level=${levels[$index]}

    # Increment timestamp by a random value between 5 and 200 ms
    timestamp=$(($timestamp + RANDOM % 500 + 5))

    # Convert timestamp to date
    date=$(date -d @$(($timestamp / 1000)) +'%Y-%m-%d %H:%M:%S')

    # Generate log line
    log_line="$date $level $fixed_log"

    # Print log line
    echo $log_line
done
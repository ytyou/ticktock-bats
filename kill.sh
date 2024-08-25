#!/bin/bash

PID=`pgrep -u $USER tt`

if [ ! -z "$PID" ]; then
    kill -9 $PID
    echo "$PID killed"
fi

exit 0

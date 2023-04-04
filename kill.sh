#!/bin/bash

PID=`pgrep -u $USER tt`

if [ ! -z "$PID" ]; then
    kill -9 $PID
fi

exit 0

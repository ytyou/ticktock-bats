#!/bin/bash

TGT=rc

# process command line arguments
while [[ $# -gt 0 ]]
do
    key=$1

    case $key in
        -b)
        shift
        TGT=$1
        ;;

        *)
        break
        ;;
    esac
    shift
done

if [ -z "$TT_SRC" ]; then
    export TT_SRC=../$TGT
fi

PID=`pgrep -f -u $USER bin/tt`

if [ ! -z "$PID" ]; then
    echo "TickTockDB process ($PID) is running. Abort!"
    exit 1
fi

echo "Testing against TickTockDB at $TT_SRC"

if ! command -v $TT_SRC/bin/tt &> /dev/null; then
    echo "[ERROR] $TT_SRC/bin/tt does not exist!"
    exit 1
fi

./bats/bin/bats tests/$@

exit 0

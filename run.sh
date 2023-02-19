#!/bin/bash

if [ -z "$TT_SRC" ]; then
    export TT_SRC=../ticktock
fi

echo "Testing against TickTockDB at $TT_SRC"

if ! command -v $TT_SRC/bin/tt &> /dev/null; then
    echo "[ERROR] $TT_SRC/bin/tt does not exist!"
    exit 1
fi

./bats/bin/bats tests/$@

exit 0

#!/usr/bin/env bash

cleanup_home() {
    rm -rf $TT_HOME
    mkdir -p $TT_HOME/data
    mkdir -p $TT_HOME/log
}

initialize() {
    load '../test_helper/bats-support/load'
    load '../test_helper/bats-assert/load'

    PROJ_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$PROJ_ROOT:$PATH"
    echo "PATH=$PATH"
    export TT_HOME=/tmp/tt_bats

    if [ "$1" = "cleanup_home" ]; then
        cleanup_home
    fi
}

check_output() {
    if [ "$1" != "$2" ]; then
        exit 1
    fi
}

check_status() {
    if [ $1 -ne 0 ]; then
        exit $1
    fi
}

check_not_status() {
    if [ $1 -eq 0 ]; then
        exit $1
    fi
}

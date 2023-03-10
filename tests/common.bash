#!/usr/bin/env bash

CURL='curl -s'
HOST=localhost
PORT=6182

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
        exit 1
    fi
}

start_tt() {
    ${TT_SRC}/bin/tt -r -d -c ${TT_SRC}/conf/tt.conf --ticktock.home=$TT_HOME $@ 3>/dev/null
    check_status "$?"
}

ping_tt() {
    RESP=`$CURL -XPOST "http://$HOST:$PORT/api/admin?cmd=ping"`
    check_output "pong" "$RESP"
}

stop_tt() {
    $CURL -XPOST "http://$HOST:$PORT/api/admin?cmd=stop"
    check_status "$?"
}

check_tt_running() {
    pgrep -u $USER -x tt >/dev/null 2>&1
    check_status "$?"
}

check_tt_not_running() {
    pgrep -u $USER -x tt >/dev/null 2>&1
    check_not_status "$?"
}

wait_for_tt_to_stop() {
    for ((i=0; i<30; i++)); do
        pgrep -u $USER -x tt >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            return
        fi
        sleep 1
    done
    exit 3
}

api_put() {
    $CURL -XPOST "http://$HOST:$PORT/api/put" -d "$1"
    check_status "$?"
}

api_write() {
    $CURL -XPOST "http://$HOST:$PORT/api/write" -d "$1"
    check_status "$?"
}

query_tt_get() {
    RESP=`$CURL 'http://'$HOST':'$PORT'/api/query?'"$@"`
    check_status "$?"
    echo "$RESP"
}

query_tt_post() {
    RESP=`$CURL -XPOST "http://$HOST:$PORT/api/query" -d "$1"`
    check_status "$?"
    echo "$RESP"
}

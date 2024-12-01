#!/usr/bin/env bash

CURL='/usr/bin/curl -s'
ECHO='/usr/bin/echo'
GZIP='/usr/bin/gzip'
NC='/usr/bin/nc'
NCOPT="-q 0"
HOST=localhost
TCP_PORT=6181
TCP2_PORT=6180
HTTP_PORT=6182
HTTP2_PORT=6183

# does nc support '-q'?
$NC -h 2>&1 | grep '\-q'
if [ "$?" -ne 0 ]; then
    NCOPT=""
fi

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

check_output2() {
    if [ "$1" != "$2" ] && [ "$1" != "$3" ]; then
        exit 1
    fi
}

check_output3() {
    if [ "$1" != "$2" ] && [ "$1" != "$3" ] && [ "$1" != "$4" ]; then
        exit 1
    fi
}

check_output4() {
    if [ "$1" != "$2" ] && [ "$1" != "$3" ] && [ "$1" != "$4" ] && [ "$1" != "$5" ]; then
        exit 1
    fi
}

check_output_contains() {
    if [[ "$2" != *"$1"* ]]; then
        exit 1
    fi
}

check_output_not_contains() {
    if [[ "$2" == *"$1"* ]]; then
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
    ${TT_SRC}/bin/tt -r -q -d -c ${TT_SRC}/conf/tt.conf --ticktock.home=$TT_HOME $@ 3>/dev/null
    check_status "$?"
    sleep 1
}

ping_tt() {
    RESP=`$CURL -XPOST "http://$HOST:$HTTP_PORT/api/admin?cmd=ping"`
    check_output "pong" "$RESP"
}

stop_tt() {
    $CURL -XPOST "http://$HOST:$HTTP_PORT/api/admin?cmd=stop"
    check_status "$?"
}

kill_tt() {
    PID=`pgrep -u $USER -x tt`
    if [ ! -z "$PID" ]; then
        kill -9 $PID
    fi
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

restart_tt() {
    stop_tt
    wait_for_tt_to_stop
    check_tt_not_running
    sleep 1
    start_tt $@
    check_tt_running
    ping_tt
}

step_down() {
    echo $(($1 - ($1 % $2)))
}

api_put_tcp() {
    $ECHO "$1" | $NC $NCOPT $HOST $TCP_PORT
    check_status "$?"
}

api_put_http() {
    $CURL -XPOST "http://$HOST:$HTTP_PORT/api/put" -d "$1"
    check_status "$?"
}

api_put_http_gzip() {
    $ECHO "$1" | $GZIP | $CURL -XPOST "http://$HOST:$HTTP_PORT/api/put" -H "Content-Encoding: gzip" --data-binary @-
    check_status "$?"
}

api_put_http_json() {
    $CURL -XPOST "http://$HOST:$HTTP_PORT/api/put" -H "Content-Type: application/json" -d "$1"
    check_status "$?"
}

api_write_tcp() {
    $ECHO "$1" | $NC $NCOPT $HOST $TCP2_PORT
    check_status "$?"
}

api_write_http() {
    $CURL -XPOST "http://$HOST:$HTTP_PORT/api/write" -d "$1"
    check_status "$?"
}

api_write_http_gzip() {
    $ECHO "$1" | $GZIP | $CURL -XPOST "http://$HOST:$HTTP_PORT/api/write" -H "Content-Encoding: gzip" --data-binary @-
    check_status "$?"
}

query_tt_get() {
    RESP=`$CURL 'http://'$HOST':'$HTTP_PORT'/api/query?'"$@"`
    check_status "$?"
    echo "$RESP"
}

query_tt_post() {
    RESP=`$CURL -XPOST "http://$HOST:$HTTP_PORT/api/query" -d "$1"`
    check_status "$?"
    echo "$RESP"
}

query_tt_get2() {
    RESP=`$CURL 'http://'$HOST':'$HTTP2_PORT'/api/query?'"$@"`
    check_status "$?"
    echo "$RESP"
}

query_tt_post2() {
    RESP=`$CURL -XPOST "http://$HOST:$HTTP2_PORT/api/query" -d "$1"`
    check_status "$?"
    echo "$RESP"
}

lookup_tt_get() {
    RESP=`$CURL 'http://'$HOST':'$HTTP_PORT'/api/search/lookup?'"$@"`
    check_status "$?"
    echo "$RESP"
}

cmd() {
    RESP=`$CURL -XPOST "http://$HOST:$HTTP_PORT/api/admin?cmd=$1"`
    check_status "$?"
}

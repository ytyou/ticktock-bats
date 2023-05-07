#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

TS=`date +%s`
TS1=$(( ($TS / 100) * 100 - 100 ))

api_put_http_gzip "put downsample.metric $TS1 1 host=web01"
check_status "$?"
TS2=$(( $TS1 + 2 ))
api_put_http_gzip "put downsample.metric $TS2 2 host=web01"
check_status "$?"
TS3=$(( $TS2 + 2 ))
api_put_http_gzip "put downsample.metric $TS3 3 host=web01"
check_status "$?"
TS4=$(( $TS3 + 2 ))
api_put_http_gzip "put downsample.metric $TS4 4 host=web01"
check_status "$?"
TS5=$(( $TS4 + 2 ))
api_put_http_gzip "put downsample.metric $TS5 5 host=web01"
check_status "$?"
TS6=$(( $TS5 + 2 ))
api_put_http_gzip "put downsample.metric $TS6 6 host=web01"
check_status "$?"
TS7=$(( $TS6 + 2 ))
api_put_http_gzip "put downsample.metric $TS7 7 host=web01"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:500ms-sum:downsample.metric%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS1'":1.0,"'$TS2'":2.0,"'$TS3'":3.0,"'$TS4'":4.0,"'$TS5'":5.0,"'$TS6'":6.0,"'$TS7'":7.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:10s-sum:downsample.metric%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS1'":15.0,"'$TS6'":13.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:10000ms-sum:downsample.metric%7Bhost=web01%7D"`
check_status "$?"
echo "RESP=$RESP"
check_output '[{"metric":"downsample.metric","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS1'":15.0,"'$TS6'":13.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

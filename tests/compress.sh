#!/bin/bash

. common.bash

TS=`date +%s`
TS1=$(( $TS - 100 ))
TS2=$(( $TS1 + 11 ))
TS3=$(( $TS2 + 8 ))
TS4=$(( $TS3 + 16 ))
TS5=$(( $TS4 + 1 ))

for i in {0..4}
do

check_tt_not_running
cleanup_home
start_tt "--tsdb.compressor.version=$i"
check_tt_running
ping_tt

api_put_tcp "put compression.metric $TS1 0.001 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS2 1.234 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS3 12345 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS4 12345 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS5 99999 t1=v1"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=none:compression.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP=$RESP"
check_output '[{"metric":"compression.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":0.001,"'$TS2'":1.234,"'$TS3'":12345.0,"'$TS4'":12345.0,"'$TS5'":99999.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running
sleep 1

done

exit 0

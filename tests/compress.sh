#!/bin/bash

. common.bash

TS=`date +%s`
TS1=$(( $TS - 1000 ))
TS2=$(( $TS1 + 11 ))
TS3=$(( $TS2 + 8 ))
TS4=$(( $TS3 + 16 ))
TS5=$(( $TS4 + 1 ))
TS6=$(( $TS5 + 31 ))
TS7=$(( $TS6 + 3 ))
TS8=$(( $TS7 + 44 ))

for i in {0..4}
do

check_tt_not_running
cleanup_home
start_tt "--tsdb.compressor.version=$i"
check_tt_running
ping_tt

api_put_tcp "put compression.metric $TS1 nan t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS2 0.001 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS3 NaN t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS4 0.002 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS5 0.003 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS6 NaN t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS7 0.004 t1=v1"
check_status "$?"
api_put_tcp "put compression.metric $TS8 Inf t1=v1"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=none:compression.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP=$RESP"
check_output '[{"metric":"compression.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":nan,"'$TS2'":0.001,"'$TS3'":nan,"'$TS4'":0.002,"'$TS5'":0.003,"'$TS6'":nan,"'$TS7'":0.004,"'$TS8'":inf}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running
sleep 1

done

exit 0

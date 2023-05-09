#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

TS=`date +%s`
TS1=$(( $TS - 1000 ))
api_write_http "api.write.metric,t1=v1,t2=v2 f1=1,f2=2,f3=3,f4=4,f5=5 $TS1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f1%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f2%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f3%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f4%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f4"},"aggregateTags":[],"dps":{"'$TS1'":4.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f5%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f5"},"aggregateTags":[],"dps":{"'$TS1'":5.0}}]' "$RESP"

TS2=$(( $TS1 + 10 ))
api_write_http "api.write.metric,t1=v1,t2=v2 f5=1,f4=2,f3=3,f2=4,f1=5 $TS2"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f1%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":1.0,"'$TS2'":5.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f2%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f2"},"aggregateTags":[],"dps":{"'$TS1'":2.0,"'$TS2'":4.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f3%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f3"},"aggregateTags":[],"dps":{"'$TS1'":3.0,"'$TS2'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f4%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f4"},"aggregateTags":[],"dps":{"'$TS1'":4.0,"'$TS2'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f5%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f5"},"aggregateTags":[],"dps":{"'$TS1'":5.0,"'$TS2'":1.0}}]' "$RESP"

TS3=$(( $TS2 + 10 ))
api_write_http "api.write.metric,t1=v1,t2=v2 f2=20,f5=50,f1=10,f4=40,f3=30 $TS3"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f1%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":1.0,"'$TS2'":5.0,"'$TS3'":10.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f2%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f2"},"aggregateTags":[],"dps":{"'$TS1'":2.0,"'$TS2'":4.0,"'$TS3'":20.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f3%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f3"},"aggregateTags":[],"dps":{"'$TS1'":3.0,"'$TS2'":3.0,"'$TS3'":30.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f4%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f4"},"aggregateTags":[],"dps":{"'$TS1'":4.0,"'$TS2'":2.0,"'$TS3'":40.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:api.write.metric%7Bt1=v1,t2=v2,_field=f5%7D"`
check_status "$?"
check_output '[{"metric":"api.write.metric","tags":{"t1":"v1","t2":"v2","_field":"f5"},"aggregateTags":[],"dps":{"'$TS1'":5.0,"'$TS2'":1.0,"'$TS3'":50.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

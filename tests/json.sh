#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

INC=10
TS=`date +%s`
TS1=$(( $TS - 6000 ))


# single data point
api_put_http '{"metric":"json.metric1","timestamp":'$TS1',"value":1,"tags":{"t1":"v1"}}'
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:json.metric1%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"json.metric1","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"


# multiple data points
TS2=$(( $TS1 + $INC ))
api_put_http '[{"metric":"json.metric2","timestamp":'$TS2',"value":2,"tags":{"t1":"v1"}},{"metric":"json.metric2","timestamp":'$TS2',"value":3,"tags":{"t1":"v2"}}]'
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:json.metric2"`
check_status "$?"
check_output '[{"metric":"json.metric2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS2'":2.0}},{"metric":"json.metric2","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS2'":3.0}}]' "$RESP"


# telnet format should also work
TS3=$(( $TS2 + $INC ))
api_put_http "put json.metric3 $TS3 5 t1=v1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:json.metric3%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"json.metric3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS3'":5.0}}]' "$RESP"


stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

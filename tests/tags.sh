#!/bin/bash

. common.bash

start_tt
check_tt_running
ping_tt

TS=`date +%s`
api_put "put tags.metric $TS 123 0=1 1=0"
check_status "$?"
api_put "put tags.metric $TS 234 0=1 1=1"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=avg:tags.metric%7B0=1,1=0%7D"`
check_status "$?"
check_output '[{"metric":"tags.metric","tags":{"0":"1","1":"0"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"
echo "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric","tags":{"0":"1"}}]}'`
check_status "$?"
check_output '[{"metric":"tags.metric","tags":{"0":"1","1":"0"},"aggregateTags":[],"dps":{"'$TS'":123.0}},{"metric":"tags.metric","tags":{"0":"1","1":"1"},"aggregateTags":[],"dps":{"'$TS'":234.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

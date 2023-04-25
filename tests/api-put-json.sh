#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

TS=`date +%s`
api_put_http_gzip '[{"metric":"api.put.json.metric","timestamp":'$TS',"value":123,"tags":{"host":"host456"}},{"metric":"api.put.json.metric","timestamp":'$TS',"value":345,"tags":{"host":"host789"}}]'
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=avg:api.put.json.metric%7Bhost=host456%7D"`
check_status "$?"
check_output '[{"metric":"api.put.json.metric","tags":{"host":"host456"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"api.put.json.metric","tags":{"host":"host456"}}]}'`
check_status "$?"
check_output '[{"metric":"api.put.json.metric","tags":{"host":"host456"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

# restart TT
start_tt "--log.level=HTTP"
check_tt_running
ping_tt

RESP=`query_tt_get "start=1d-ago&m=avg:api.put.json.metric%7Bhost=host789%7D"`
check_status "$?"
check_output '[{"metric":"api.put.json.metric","tags":{"host":"host789"},"aggregateTags":[],"dps":{"'$TS'":345.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"api.put.json.metric","tags":{"host":"host789"}}]}'`
check_status "$?"
check_output '[{"metric":"api.put.json.metric","tags":{"host":"host789"},"aggregateTags":[],"dps":{"'$TS'":345.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

#!/bin/bash

. common.bash

check_tt_not_running
start_tt "--log.level=HTTP"
check_tt_running
ping_tt

TS=`date +%s`
api_put "put api.put.plain.metric $TS 123 host=host456"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=avg:api.put.plain.metric%7Bhost=host456%7D"`
check_status "$?"
check_output '[{"metric":"api.put.plain.metric","tags":{"host":"host456"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"api.put.plain.metric","tags":{"host":"host456"}}]}'`
check_status "$?"
check_output '[{"metric":"api.put.plain.metric","tags":{"host":"host456"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

# restart TT
start_tt "--log.level=HTTP"
check_tt_running
ping_tt

RESP=`query_tt_get "start=1d-ago&m=avg:api.put.plain.metric%7Bhost=host456%7D"`
check_status "$?"
check_output '[{"metric":"api.put.plain.metric","tags":{"host":"host456"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"api.put.plain.metric","tags":{"host":"host456"}}]}'`
check_status "$?"
check_output '[{"metric":"api.put.plain.metric","tags":{"host":"host456"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

#!/bin/bash

. common.bash

TS1=1725396552
TS2=1725396553

insert_data_sec() {
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS1 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS2 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 $TS2 123 t1=v1"
    check_status "$?"
}

insert_data_ms() {
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS1}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS2}000 123 t1=v1"
    check_status "$?"
    api_put_tcp "put resolution.metric.$1 ${TS2}000 123 t1=v1"
    check_status "$?"
}

# TT: sec, DATA: sec
check_tt_not_running
start_tt "--tsdb.timestamp.resolution=sec"
check_tt_running
ping_tt

insert_data_sec "1"

RESP=`query_tt_get "start=1600&m=avg:resolution.metric.1"`
check_status "$?"
check_output '[{"metric":"resolution.metric.1","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000&m=avg:resolution.metric.1"`
check_status "$?"
check_output '[{"metric":"resolution.metric.1","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000000&m=avg:resolution.metric.1"`
check_status "$?"
check_output '[{"metric":"resolution.metric.1","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396500&m=avg:resolution.metric.1"`
check_status "$?"
check_output '[{"metric":"resolution.metric.1","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396000000&m=avg:resolution.metric.1"`
check_status "$?"
check_output '[{"metric":"resolution.metric.1","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
cleanup_home

# TT: sec, DATA: ms
check_tt_not_running
start_tt "--tsdb.timestamp.resolution=sec"
check_tt_running
ping_tt

insert_data_ms "2"

RESP=`query_tt_get "start=1600&m=avg:resolution.metric.2"`
check_status "$?"
check_output '[{"metric":"resolution.metric.2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000&m=avg:resolution.metric.2"`
check_status "$?"
check_output '[{"metric":"resolution.metric.2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000000&m=avg:resolution.metric.2"`
check_status "$?"
check_output '[{"metric":"resolution.metric.2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396500&m=avg:resolution.metric.2"`
check_status "$?"
check_output '[{"metric":"resolution.metric.2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396000000&m=avg:resolution.metric.2"`
check_status "$?"
check_output '[{"metric":"resolution.metric.2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":123.0,"'$TS2'":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
cleanup_home

# TT: ms, DATA: sec
check_tt_not_running
start_tt "--tsdb.timestamp.resolution=ms"
check_tt_running
ping_tt

insert_data_sec "3"

RESP=`query_tt_get "start=1600&msResolution=true&m=avg:resolution.metric.3"`
check_status "$?"
check_output '[{"metric":"resolution.metric.3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000&msResolution=true&m=avg:resolution.metric.3"`
check_status "$?"
check_output '[{"metric":"resolution.metric.3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000000&msResolution=true&m=avg:resolution.metric.3"`
check_status "$?"
check_output '[{"metric":"resolution.metric.3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396500&msResolution=true&m=avg:resolution.metric.3"`
check_status "$?"
check_output '[{"metric":"resolution.metric.3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396000000&msResolution=true&m=avg:resolution.metric.3"`
check_status "$?"
check_output '[{"metric":"resolution.metric.3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
cleanup_home

# TT: ms, DATA: ms
check_tt_not_running
start_tt "--tsdb.timestamp.resolution=ms"
check_tt_running
ping_tt

insert_data_ms "4"

RESP=`query_tt_get "start=1600&msResolution=true&m=avg:resolution.metric.4"`
check_status "$?"
check_output '[{"metric":"resolution.metric.4","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000&msResolution=true&m=avg:resolution.metric.4"`
check_status "$?"
check_output '[{"metric":"resolution.metric.4","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1600000000&msResolution=true&m=avg:resolution.metric.4"`
check_status "$?"
check_output '[{"metric":"resolution.metric.4","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396500&msResolution=true&m=avg:resolution.metric.4"`
check_status "$?"
check_output '[{"metric":"resolution.metric.4","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

RESP=`query_tt_get "start=1725396000000&msResolution=true&m=avg:resolution.metric.4"`
check_status "$?"
check_output '[{"metric":"resolution.metric.4","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'000":123.0,"'$TS2'000":123.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
cleanup_home

# TT: sec, DATA: json
check_tt_not_running
start_tt "--tsdb.timestamp.resolution=sec"
check_tt_running
ping_tt

# insert data in json format
api_put_http_json '{"metric":"resolution.metric.5","timestamp": 12345678,"value":8,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.5","timestamp": 123456789,"value":9,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.5","timestamp": 1234567890,"value":10,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.5","timestamp": 12345678901,"value":11,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.5","timestamp": 123456789012,"value":12,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.5","timestamp": 1234567890123,"value":13,"tags":{"t1":"v1"}}'

RESP=`query_tt_get "start=12345678&m=avg:resolution.metric.5"`
check_status "$?"
check_output '[{"metric":"resolution.metric.5","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"12345678":11.0,"123456789":12.0,"1234567890":13.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
cleanup_home

# TT: ms, DATA: json
check_tt_not_running
start_tt "--tsdb.timestamp.resolution=ms"
check_tt_running
ping_tt

# insert data in json format
api_put_http_json '{"metric":"resolution.metric.6","timestamp": 12345678,"value":8,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.6","timestamp": 123456789,"value":9,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.6","timestamp": 1234567890,"value":10,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.6","timestamp": 12345678901,"value":11,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.6","timestamp": 123456789012,"value":12,"tags":{"t1":"v1"}}'
api_put_http_json '{"metric":"resolution.metric.6","timestamp": 1234567890123,"value":13,"tags":{"t1":"v1"}}'

RESP=`query_tt_get "start=12345678&msResolution=true&m=avg:resolution.metric.6"`
check_status "$?"
echo "RESP=$RESP"
check_output '[{"metric":"resolution.metric.6","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"12345678000":8.0,"12345678901":11.0,"123456789000":9.0,"123456789012":12.0,"1234567890000":10.0,"1234567890123":13.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

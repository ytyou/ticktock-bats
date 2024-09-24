#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

TS=`date +%s`
TS2=`step_down $TS 60`
api_put_tcp "put duplicates.metric $TS 24 t1=v1 t2=v2"
check_status "$?"
sleep 1
api_put_http "put duplicates.metric $TS 42 t1=v1 t2=v2"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=none:duplicates.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS'":42.0}}]' "$RESP"


# aggregator=none
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-avg","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-count","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-first","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-last","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-max","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-min","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","downsample":"1m-sum","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"


# aggregator=avg
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-avg","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-count","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-first","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-last","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-max","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-min","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"avg","downsample":"1m-sum","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"


# aggregator=count
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-avg","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-count","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-first","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-last","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-max","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-min","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"count","downsample":"1m-sum","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"


# aggregator=max
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-avg","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-count","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-first","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-last","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-max","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-min","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"max","downsample":"1m-sum","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"


# aggregator=min
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-avg","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-count","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-first","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-last","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-max","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-min","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"min","downsample":"1m-sum","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"


# aggregator=sum
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-avg","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-count","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":1.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-first","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-last","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-max","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-min","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"sum","downsample":"1m-sum","metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"}}]}'`
check_status "$?"
check_output '[{"metric":"duplicates.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS2'":42.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

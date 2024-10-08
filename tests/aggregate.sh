#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

INC=10
TS=`date +%s`
TS1=$(( $TS - 6000 ))


# top & bottom
api_put_http '{"metric":"aggregate.metric","timestamp":'$TS1',"value":1,"tags":{"t1":"v1"}}'
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top1:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top10:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom1:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom10:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=max:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=min:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=count:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=avg:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"


api_put_http '{"metric":"aggregate.metric","timestamp":'$TS1',"value":2,"tags":{"t1":"v2"}}'
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top1:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top2:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top10:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom1:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom2:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom10:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=max:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=min:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=count:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=avg:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":1.5}}]' "$RESP"


api_put_http '{"metric":"aggregate.metric","timestamp":'$TS1',"value":3,"tags":{"t1":"v3"}}'
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output "$RESP" '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}}]'

RESP=`query_tt_get "start=1d-ago&m=top1:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top2:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top3:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=top10:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom1:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom2:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom3:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=bottom10:aggregate.metric%7Bt1=*%7D"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"aggregate.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS1'":2.0}},{"metric":"aggregate.metric","tags":{"t1":"v3"},"aggregateTags":[],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=max:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=min:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":1.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=count:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":6.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=avg:aggregate.metric"`
check_status "$?"
check_output '[{"metric":"aggregate.metric","tags":{},"aggregateTags":["t1"],"dps":{"'$TS1'":2.0}}]' "$RESP"


stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

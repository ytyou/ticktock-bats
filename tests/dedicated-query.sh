#!/bin/bash

. common.bash

check_tt_not_running
start_tt "--http.server.port=${HTTP_PORT},${HTTP2_PORT}"
check_tt_running
ping_tt

TS=`date +%s`
TS2=`step_down $TS 60`
api_put_http "put dedicated.query.metric $TS 1 t1=v1"
check_status "$?"
api_put_http "put dedicated.query.metric $TS 2 t1=v2"
check_status "$?"
sleep 1

RESP=`query_tt_get2 "start=1d-ago&m=none:dedicated.query.metric%7Bt1=v2%7D"`
check_status "$?"
check_output '[{"metric":"dedicated.query.metric","tags":{"t1":"v2"},"aggregateTags":[],"dps":{"'$TS'":2.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

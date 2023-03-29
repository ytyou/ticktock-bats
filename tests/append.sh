#!/bin/bash

. common.bash

start_tt --append.log.flush.frequency=5s
check_tt_running
ping_tt

TS=`date +%s`
api_put "put append.metric $TS 100 t1=v1 t2=v2"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1h-ago&m=none:append.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
check_output '[{"metric":"append.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS'":100.0}}]' "$RESP"

# wait for append.log to exist
while [ ! -f "${TT_HOME}/data/append.log" ]; do
    sleep 1
done

kill_tt
check_tt_not_running

# restart tt
start_tt
check_tt_running
ping_tt

RESP=`query_tt_get "start=1h-ago&m=none:append.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
echo "RESP=$RESP"
check_output '[{"metric":"append.metric","tags":{"t2":"v2","t1":"v1"},"aggregateTags":[],"dps":{"'$TS'":100.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

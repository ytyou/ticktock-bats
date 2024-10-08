#!/bin/bash

. common.bash

check_tt_not_running
#start_tt --append.log.flush.frequency=5s
start_tt
check_tt_running
ping_tt

TS=`date +%s`
api_put_http_gzip "put append.metric $TS 100 t1=v1 t2=v2"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1h-ago&m=none:append.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
check_output "$RESP" '[{"metric":"append.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS'":100.0}}]'

# query rollup data
TS1=$(($TS - ($TS % 3600)))
RESP=`query_tt_get "start=1h-ago&m=none:1h-min:append.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
check_output "$RESP" '[{"metric":"append.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS1'":100.0}}]'

cmd "append"

# wait for append.log to exist
while [ ! -f "${TT_HOME}/data/WAL/append.log" ]; do
    sleep 1
done

# make sure append.log has content
while : ; do
    APPEND_SIZE=$(stat --format=%s "${TT_HOME}/data/WAL/append.log")
    if [ $APPEND_SIZE -ne 0 ]; then
        break
    fi
done

kill_tt
sleep 2
check_tt_not_running

# restart tt
start_tt
check_tt_running
ping_tt
sleep 2

RESP=`query_tt_get "start=1h-ago&m=none:append.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
check_output "$RESP" '[{"metric":"append.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS'":100.0}}]'

RESP=`query_tt_get "start=1h-ago&m=none:1h-max:append.metric%7Bt1=v1,t2=v2%7D"`
check_status "$?"
check_output "$RESP" '[{"metric":"append.metric","tags":{"t1":"v1","t2":"v2"},"aggregateTags":[],"dps":{"'$TS1'":100.0}}]'

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

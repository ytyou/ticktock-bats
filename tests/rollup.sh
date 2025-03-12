#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

# Sun Jan  1 12:00:00 AM PST 2023
for s in {0..172800..60}
do
    TS=$((1672560000 + $s))
    api_put_http "put rollup.metric $TS ${s}00000 t1=v1"
    check_status "$?"
done
sleep 1

RESP=`query_tt_get "start=1672560000&end=1672732600&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP1=$RESP"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":717000000.0,"1672574400":2157000000.0,"1672588800":3597000000.0,"1672603200":5037000000.0,"1672617600":6477000000.0,"1672632000":7917000000.0,"1672646400":9357000000.0,"1672660800":10797000000.0,"1672675200":12237000000.0,"1672689600":13677000000.0,"1672704000":15117000000.0,"1672718400":16557000000.0}}]' "$RESP"

restart_tt
sleep 2

cmd "rollup"

RESP=`query_tt_get "start=1672560000&end=1672732600&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP2=$RESP"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":717000000.0,"1672574400":2157000000.0,"1672588800":3597000000.0,"1672603200":5037000000.0,"1672617600":6477000000.0,"1672632000":7917000000.0,"1672646400":9357000000.0,"1672660800":10797000000.0,"1672675200":12237000000.0,"1672689600":13677000000.0,"1672704000":15117000000.0,"1672718400":16557000000.0}}]' "$RESP"

restart_tt
sleep 2

RESP=`query_tt_get "start=1672560000&end=1672732600&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP3=$RESP"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":717000000.0,"1672574400":2157000000.0,"1672588800":3597000000.0,"1672603200":5037000000.0,"1672617600":6477000000.0,"1672632000":7917000000.0,"1672646400":9357000000.0,"1672660800":10797000000.0,"1672675200":12237000000.0,"1672689600":13677000000.0,"1672704000":15117000000.0,"1672718400":16557000000.0}}]' "$RESP"

# add one more day worth of data
for s in {60..86400..60}
do
    TS1=$(($TS + $s))
    api_put_http "put rollup.metric $TS1 ${s}00000 t1=v1"
    check_status "$?"
done
sleep 1

RESP=`query_tt_get "start=1672560000&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP4=$RESP"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":717000000.0,"1672574400":2157000000.0,"1672588800":3597000000.0,"1672603200":5037000000.0,"1672617600":6477000000.0,"1672632000":7917000000.0,"1672646400":9357000000.0,"1672660800":10797000000.0,"1672675200":12237000000.0,"1672689600":13677000000.0,"1672704000":15117000000.0,"1672718400":16557000000.0,"1672732800":789000000.0,"1672747200":2157000000.0,"1672761600":3597000000.0,"1672776000":5037000000.0,"1672790400":6477000000.0,"1672804800":7917000000.0,"1672819200":8640000000.0}}]' "$RESP"

cmd "rollup"

RESP=`query_tt_get "start=1672560000&m=none:1d-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP5=$RESP"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672617600":10077000000.0,"1672704000":7209000000.0,"1672790400":7200000000.0}}]' "$RESP"

cmd "rollup"

RESP=`query_tt_get "start=1672560000&m=none:1d-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
echo "RESP6=$RESP"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672617600":10077000000.0,"1672704000":7209000000.0,"1672790400":7200000000.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

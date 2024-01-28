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
    api_put_http "put rollup.metric $TS $s t1=v1"
    check_status "$?"
done
sleep 1

RESP=`query_tt_get "start=1672560000&end=1672732600&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":7170.0,"1672574400":21570.0,"1672588800":35970.0,"1672603200":50370.0,"1672617600":64770.0,"1672632000":79170.0,"1672646400":93570.0,"1672660800":107970.0,"1672675200":122370.0,"1672689600":136770.0,"1672704000":151170.0,"1672718400":165570.0}}]' "$RESP"

cmd "rollup"

RESP=`query_tt_get "start=1672560000&end=1672732600&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":7170.0,"1672574400":21570.0,"1672588800":35970.0,"1672603200":50370.0,"1672617600":64770.0,"1672632000":79170.0,"1672646400":93570.0,"1672660800":107970.0,"1672675200":122370.0,"1672689600":136770.0,"1672704000":151170.0,"1672718400":165570.0}}]' "$RESP"

restart_tt
sleep 2

RESP=`query_tt_get "start=1672560000&end=1672732600&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":7170.0,"1672574400":21570.0,"1672588800":35970.0,"1672603200":50370.0,"1672617600":64770.0,"1672632000":79170.0,"1672646400":93570.0,"1672660800":107970.0,"1672675200":122370.0,"1672689600":136770.0,"1672704000":151170.0,"1672718400":165570.0}}]' "$RESP"

# add one more day worth of data
for s in {60..86400..60}
do
    TS1=$(($TS + $s))
    api_put_http "put rollup.metric $TS1 $s t1=v1"
    check_status "$?"
done
sleep 1

RESP=`query_tt_get "start=1672560000&m=none:4h-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672560000":7170.0,"1672574400":21570.0,"1672588800":35970.0,"1672603200":50370.0,"1672617600":64770.0,"1672632000":79170.0,"1672646400":93570.0,"1672660800":107970.0,"1672675200":122370.0,"1672689600":136770.0,"1672704000":151170.0,"1672718400":165570.0,"1672732800":7890.0,"1672747200":21570.0,"1672761600":35970.0,"1672776000":50370.0,"1672790400":64770.0,"1672804800":79170.0,"1672819200":86400.0}}]' "$RESP"

cmd "rollup"

RESP=`query_tt_get "start=1672560000&m=none:1d-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672617600":100770.0,"1672704000":72090.0,"1672790400":72000.0}}]' "$RESP"

cmd "rollup"

RESP=`query_tt_get "start=1672560000&m=none:1d-avg:rollup.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"rollup.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"1672617600":100770.0,"1672704000":72090.0,"1672790400":72000.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

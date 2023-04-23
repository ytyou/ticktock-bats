#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

INC=10
TS=`date +%s`
TS1=$(( $TS - 6000 ))

api_put_tcp "put field.metric $TS1 1 t1=v1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"field.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

TS2=$(( $TS1 + $INC ))
api_put_tcp "put field.metric $TS2 2 t1=v1 _field=f1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric"`
check_status "$?"
check_output '[{"metric":"field.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"field.metric","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS2'":2.0}}]' "$RESP"

TS3=$(( $TS2 + $INC ))
api_write_http "field.metric,t1=v1 f1=3 $TS3"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric"`
check_status "$?"
check_output '[{"metric":"field.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"field.metric","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS2'":2.0,"'$TS3'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric%7B_field=f1%7D"`
check_status "$?"
check_output '[{"metric":"field.metric","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS2'":2.0,"'$TS3'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric%7B_field=_%7D"`
check_status "$?"
check_output '[{"metric":"field.metric","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"


api_put_tcp "put field.metric2 $TS1 1 t1=v1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric2%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"field.metric2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

api_write_http "field.metric2,t1=v1 f1=2 $TS2"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric2"`
check_status "$?"
check_output '[{"metric":"field.metric2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"field.metric2","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS2'":2.0}}]' "$RESP"

api_put_tcp "put field.metric2 $TS3 3 t1=v1 _field=f1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric2"`
check_status "$?"
check_output '[{"metric":"field.metric2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"field.metric2","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS2'":2.0,"'$TS3'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric2%7B_field=_%7D"`
check_status "$?"
check_output '[{"metric":"field.metric2","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"


api_write_http "field.metric3,t1=v1 f1=1 $TS1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric3%7Bt1=v1%7D"`
check_status "$?"
check_output '[{"metric":"field.metric3","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}}]' "$RESP"

api_put_tcp "put field.metric3 $TS2 2 t1=v1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric3"`
check_status "$?"
check_output '[{"metric":"field.metric3","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":1.0}},{"metric":"field.metric3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS2'":2.0}}]' "$RESP"

api_put_tcp "put field.metric3 $TS3 3 t1=v1 _field=f1"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric3"`
check_status "$?"
check_output '[{"metric":"field.metric3","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":1.0,"'$TS3'":3.0}},{"metric":"field.metric3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS2'":2.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric3%7B_field=_%7D"`
check_status "$?"
check_output '[{"metric":"field.metric3","tags":{"t1":"v1"},"aggregateTags":[],"dps":{"'$TS2'":2.0}}]' "$RESP"


api_put_tcp "put field.metric4 $TS1 5 t1=v1 _field=f1"
api_put_tcp "put field.metric4 $TS2 6 t1=v1 _field=f2"

RESP=`query_tt_get "start=1d-ago&m=none:field.metric4"`
check_status "$?"
check_output '[{"metric":"field.metric4","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":5.0}},{"metric":"field.metric4","tags":{"t1":"v1","_field":"f2"},"aggregateTags":[],"dps":{"'$TS2'":6.0}}]' "$RESP"


# restart TT
stop_tt
wait_for_tt_to_stop
check_tt_not_running
sleep 2
start_tt
check_tt_running


RESP=`query_tt_get "start=1d-ago&m=none:field.metric4"`
check_status "$?"
check_output '[{"metric":"field.metric4","tags":{"t1":"v1","_field":"f1"},"aggregateTags":[],"dps":{"'$TS1'":5.0}},{"metric":"field.metric4","tags":{"t1":"v1","_field":"f2"},"aggregateTags":[],"dps":{"'$TS2'":6.0}}]' "$RESP"


stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

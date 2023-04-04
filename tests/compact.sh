#!/bin/bash

. common.bash

query_and_verify() {
    TS1=$1
    INC=$2
    TAG=$3

    for i in {1..200}
    do
        TS2=$(( $TS1 + 1 ))
        RESP=`query_tt_get "start=${TS1}&end=${TS2}&m=none:compact.metric%7Bt1=${TAG}%7D"`
        check_status "$?"
        check_output '[{"metric":"compact.metric","tags":{"t1":"'$TAG'"},"aggregateTags":[],"dps":{"'$TS1'":'$i'.0}}]' "$RESP"
        TS1=$(( $TS1 + $INC ))
    done
}

check_tt_not_running
start_tt
check_tt_running
ping_tt

# insert data
TS=`date +%s`
START=$(( $TS - 2000 ))
TS1=$START
INC=10

for i in {1..200}
do
    api_put_http "put compact.metric $TS1 $i t1=v1"
    check_status "$?"
    TS1=$(( $TS1 + $INC ))
done
sleep 1

# query data
query_and_verify $START $INC "v1"

# trigger compaction
compact
sleep 1

# query data
query_and_verify $START $INC "v1"

# restart tt
restart_tt
sleep 1

# query data
query_and_verify $START $INC "v1"

# write some more data
TS1=$START
for i in {1..200}
do
    api_put_http "put compact.metric $TS1 $i t1=v2"
    check_status "$?"
    TS1=$(( $TS1 + $INC ))
done
sleep 1

# query data
query_and_verify $START $INC "v1"
query_and_verify $START $INC "v2"

# restart tt
restart_tt
sleep 1

# query data
query_and_verify $START $INC "v1"
query_and_verify $START $INC "v2"

# trigger compaction
compact
sleep 1

# query data
query_and_verify $START $INC "v1"
query_and_verify $START $INC "v2"

# restart tt
restart_tt
sleep 1

# query data
query_and_verify $START $INC "v1"
query_and_verify $START $INC "v2"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

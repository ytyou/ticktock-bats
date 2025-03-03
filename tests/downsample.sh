#!/bin/bash

. common.bash

check_tt_not_running
start_tt
check_tt_running
ping_tt

# inject data
TS1=1569888000
TS2=1569906000
VL1=0
VL2=1000

for i in {0..600}
do
    api_put_http "put downsample.metric.1 $TS1 $VL1 host=host1"
    check_status "$?"
    api_put_http "put downsample.metric.1 $TS2 $VL2 host=host2"
    check_status "$?"

    TS1=$((TS1 + 60))
    TS2=$((TS2 + 60))
    VL1=$((VL1 + 1))
    VL2=$((VL2 + 1))
done

# between minutes
api_put_http "put downsample.metric.1 1569888620 200000 host=host1"
check_status "$?"
api_put_http "put downsample.metric.1 1569888640 300000 host=host1"
check_status "$?"

TS=`date +%s`
TS1=$(( ($TS / 100) * 100 - 100 ))

api_put_http_gzip "put downsample.metric.2 $TS1 1 host=web01"
check_status "$?"
TS2=$(( $TS1 + 2 ))
api_put_http_gzip "put downsample.metric.2 $TS2 2 host=web01"
check_status "$?"
TS3=$(( $TS2 + 2 ))
api_put_http_gzip "put downsample.metric.2 $TS3 3 host=web01"
check_status "$?"
TS4=$(( $TS3 + 2 ))
api_put_http_gzip "put downsample.metric.2 $TS4 4 host=web01"
check_status "$?"
TS5=$(( $TS4 + 2 ))
api_put_http_gzip "put downsample.metric.2 $TS5 5 host=web01"
check_status "$?"
TS6=$(( $TS5 + 2 ))
api_put_http_gzip "put downsample.metric.2 $TS6 6 host=web01"
check_status "$?"
TS7=$(( $TS6 + 2 ))
api_put_http_gzip "put downsample.metric.2 $TS7 7 host=web01"
check_status "$?"

RESP=`query_tt_get "start=1d-ago&m=none:500ms-sum:downsample.metric.2%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.2","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS1'":1.0,"'$TS2'":2.0,"'$TS3'":3.0,"'$TS4'":4.0,"'$TS5'":5.0,"'$TS6'":6.0,"'$TS7'":7.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:10s-sum:downsample.metric.2%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.2","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS1'":15.0,"'$TS6'":13.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=none:10000ms-sum:downsample.metric.2%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.2","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS1'":15.0,"'$TS6'":13.0}}]' "$RESP"


# first 2 dps for host=host1, no downsample
RESP=`query_tt_get "start=1569888000&end=1569888060&m=none:downsample.metric.1%7Bhost=host1%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888000":0.0,"1569888060":1.0}}]' "$RESP"

# last 2 dps for host=host1, no downsample
RESP=`query_tt_get "start=1569923940&m=none:downsample.metric.1%7Bhost=host1%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569923940":599.0,"1569924000":600.0}}]' "$RESP"

# first 2 dps for host=host2, no downsample
RESP=`query_tt_get "start=1569906000&end=1569906060&m=none:downsample.metric.1%7Bhost=host2%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569906000":1000.0,"1569906060":1001.0}}]' "$RESP"

# last 2 dps for host=host2, no downsample
RESP=`query_tt_get "start=1569941940&m=none:downsample.metric.1%7Bhost=host2%7D"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569941940":1599.0,"1569942000":1600.0}}]' "$RESP"

# downsample with fill, query range covers 1 dp
RESP=`query_tt_get "start=1569888050&end=1569888070&m=none:10s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888050":0.0,"1569888060":1.0,"1569888070":0.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888050":0.0,"1569888060":0.0,"1569888070":0.0}}]' "$RESP"

# downsample with fill, query range covers no dp
RESP=`query_tt_get "start=1569888020&end=1569888040&m=none:10s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888020":0.0,"1569888030":0.0,"1569888040":0.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888020":0.0,"1569888030":0.0,"1569888040":0.0}}]' "$RESP"

RESP=`query_tt_get "start=1569888050&end=1569888130&m=none:10s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888050":0.0,"1569888060":1.0,"1569888070":0.0,"1569888080":0.0,"1569888090":0.0,"1569888100":0.0,"1569888110":0.0,"1569888120":2.0,"1569888130":0.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888050":0.0,"1569888060":0.0,"1569888070":0.0,"1569888080":0.0,"1569888090":0.0,"1569888100":0.0,"1569888110":0.0,"1569888120":0.0,"1569888130":0.0}}]' "$RESP"

# downsample without fill, query range covers no dp
RESP=`query_tt_get "start=1569888020&end=1569888040&m=none:10s-sum:downsample.metric.1"`
check_status "$?"
check_output '[]' "$RESP"

# no downsample, query range covers no dp
RESP=`query_tt_get "start=1569888020&end=1569888040&m=none:downsample.metric.1"`
check_status "$?"
check_output '[]' "$RESP"

# no downsample, query range covers no dp, even going back an hour
RESP=`query_tt_get "start=1569945900&end=1569945910&m=none:downsample.metric.1"`
check_status "$?"
check_output '[]' "$RESP"

# with downsample, query range covers no dp, even going back an hour
RESP=`query_tt_get "start=1569945900&end=1569945910&m=none:10s-sum:downsample.metric.1"`
check_status "$?"
check_output '[]' "$RESP"

RESP=`query_tt_get "start=1569945900&end=1569945910&m=none:10s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569945900":0.0,"1569945910":0.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569945900":0.0,"1569945910":0.0}}]' "$RESP"

# step-up, not step-down
RESP=`query_tt_get "start=1569888121&end=1569888239&m=none:60s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888180":3.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888180":0.0}}]' "$RESP"

# ???
RESP=`query_tt_get "start=1569888601&end=1569888659&m=none:60s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[]' "$RESP"

RESP=`query_tt_get "start=1569888599&end=1569888600&m=none:60s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888600":500010.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888600":0.0}}]' "$RESP"

RESP=`query_tt_get "start=1569888599&end=1569888660&m=none:60s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888600":500010.0,"1569888660":11.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888600":0.0,"1569888660":0.0}}]' "$RESP"

RESP=`query_tt_get "start=1569888601&end=1569888660&m=none:60s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888660":11.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888660":0.0}}]' "$RESP"

RESP=`query_tt_get "start=1569888600&end=1569888659&m=none:60s-sum-zero:downsample.metric.1"`
check_status "$?"
check_output '[{"metric":"downsample.metric.1","tags":{"host":"host1"},"aggregateTags":[],"dps":{"1569888600":500010.0}},{"metric":"downsample.metric.1","tags":{"host":"host2"},"aggregateTags":[],"dps":{"1569888600":0.0}}]' "$RESP"


stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

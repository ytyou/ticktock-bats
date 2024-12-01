#!/bin/bash

. common.bash

check_tt_not_running
start_tt "--log.level=HTTP"
check_tt_running
ping_tt

TS=`date +%s`

api_put_tcp "put lookup.metric.1 $TS 100 host=host1 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 200 host=host2 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 300 host=host3 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 400 host=host4 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 100 host=host5 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 200 host=host6 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 300 host=host7 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 400 host=host8 dc=na"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 100 host=host1 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 200 host=host2 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 300 host=host3 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.1 $TS 400 host=host4 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 100 host=host5 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 200 host=host6 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 300 host=host7 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.2 $TS 400 host=host8 dc=eu"
check_status "$?"
api_put_tcp "put lookup.metric.3 $TS 500 host=host20"
check_status "$?"
api_put_tcp "put lookup.metric.3 $TS 500 dc=na"
check_status "$?"

sleep 1

# one specific metric
RESP=`lookup_tt_get "limit=100&m=lookup.metric.1%7Bhost=*%7D"`
check_status "$?"
check_output_contains '{"type":"LOOKUP","limit":100,"startIndex":0,"totalResults":8,"metric":"lookup.metric.1","tags":[{"key":"host","value":"*"}],"results":[' "$RESP"
check_output_contains '{"tsuid":"000000000","metric":"lookup.metric.1","tags":{"dc":"na","host":"host1"}}' "$RESP"
check_output_contains '{"tsuid":"000000001","metric":"lookup.metric.1","tags":{"dc":"na","host":"host2"}}' "$RESP"
check_output_contains '{"tsuid":"000000002","metric":"lookup.metric.1","tags":{"dc":"na","host":"host3"}}' "$RESP"
check_output_contains '{"tsuid":"000000003","metric":"lookup.metric.1","tags":{"dc":"na","host":"host4"}}' "$RESP"
check_output_contains '{"tsuid":"000000008","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host1"}}' "$RESP"
check_output_contains '{"tsuid":"000000009","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host2"}}' "$RESP"
check_output_contains '{"tsuid":"00000000A","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host3"}}' "$RESP"
check_output_contains '{"tsuid":"00000000B","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host4"}}' "$RESP"

# one specific metric, with multiple tag filters
RESP=`lookup_tt_get "limit=100&m=lookup.metric.1%7Bhost=*,dc=eu%7D"`
check_status "$?"
check_output_contains '{"type":"LOOKUP","limit":100,"startIndex":0,"totalResults":4,"metric":"lookup.metric.1","tags":[{"key":"dc","value":"eu"},{"key":"host","value":"*"}],"results":[' "$RESP"
check_output_contains '{"tsuid":"000000008","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host1"}}' "$RESP"
check_output_contains '{"tsuid":"000000009","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host2"}}' "$RESP"
check_output_contains '{"tsuid":"00000000A","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host3"}}' "$RESP"
check_output_contains '{"tsuid":"00000000B","metric":"lookup.metric.1","tags":{"dc":"eu","host":"host4"}}' "$RESP"

# ALL metrics
RESP=`lookup_tt_get "limit=100&m=*%7Bhost=*%7D"`
check_status "$?"
check_output_contains '{"type":"LOOKUP","limit":100,"startIndex":0,"totalResults":17,"metric":"*","tags":[{"key":"host","value":"*"}],"results":[' "$RESP"
check_output_contains '{"tsuid":"000000000","metric":"*","tags":{"dc":"na","host":"host1"}}' "$RESP"
check_output_contains '{"tsuid":"000000001","metric":"*","tags":{"dc":"na","host":"host2"}}' "$RESP"
check_output_contains '{"tsuid":"000000002","metric":"*","tags":{"dc":"na","host":"host3"}}' "$RESP"
check_output_contains '{"tsuid":"000000003","metric":"*","tags":{"dc":"na","host":"host4"}}' "$RESP"
check_output_contains '{"tsuid":"000000004","metric":"*","tags":{"dc":"na","host":"host5"}}' "$RESP"
check_output_contains '{"tsuid":"000000005","metric":"*","tags":{"dc":"na","host":"host6"}}' "$RESP"
check_output_contains '{"tsuid":"000000006","metric":"*","tags":{"dc":"na","host":"host7"}}' "$RESP"
check_output_contains '{"tsuid":"000000007","metric":"*","tags":{"dc":"na","host":"host8"}}' "$RESP"
check_output_contains '{"tsuid":"000000008","metric":"*","tags":{"dc":"eu","host":"host1"}}' "$RESP"
check_output_contains '{"tsuid":"000000009","metric":"*","tags":{"dc":"eu","host":"host2"}}' "$RESP"
check_output_contains '{"tsuid":"00000000A","metric":"*","tags":{"dc":"eu","host":"host3"}}' "$RESP"
check_output_contains '{"tsuid":"00000000B","metric":"*","tags":{"dc":"eu","host":"host4"}}' "$RESP"
check_output_contains '{"tsuid":"00000000C","metric":"*","tags":{"dc":"eu","host":"host5"}}' "$RESP"
check_output_contains '{"tsuid":"00000000D","metric":"*","tags":{"dc":"eu","host":"host6"}}' "$RESP"
check_output_contains '{"tsuid":"00000000E","metric":"*","tags":{"dc":"eu","host":"host7"}}' "$RESP"
check_output_contains '{"tsuid":"00000000F","metric":"*","tags":{"dc":"eu","host":"host8"}}' "$RESP"

# limit
RESP=`lookup_tt_get "limit=5&m=lookup.metric.2%7Bhost=*%7D"`
check_status "$?"
check_output_contains '{"type":"LOOKUP","limit":5,"startIndex":0,"totalResults":8,"metric":"lookup.metric.2","tags":[{"key":"host","value":"*"}],"results":[' "$RESP"
check_output_contains '{"tsuid":"000000004","metric":"lookup.metric.2","tags":{"dc":"na","host":"host5"}}' "$RESP"
check_output_contains '{"tsuid":"000000005","metric":"lookup.metric.2","tags":{"dc":"na","host":"host6"}}' "$RESP"
check_output_contains '{"tsuid":"000000007","metric":"lookup.metric.2","tags":{"dc":"na","host":"host8"}}' "$RESP"
check_output_contains '{"tsuid":"00000000C","metric":"lookup.metric.2","tags":{"dc":"eu","host":"host5"}}' "$RESP"
check_output_contains '{"tsuid":"00000000D","metric":"lookup.metric.2","tags":{"dc":"eu","host":"host6"}}' "$RESP"

# pagination
RESP=`lookup_tt_get "limit=2&m=lookup.metric.2%7Bhost=*%7D"`
check_status "$?"
check_output_contains '{"type":"LOOKUP","limit":2,"startIndex":0,"totalResults":8,"metric":"lookup.metric.2","tags":[{"key":"host","value":"*"}],"results":[' "$RESP"
check_output_contains '{"tsuid":"000000004","metric":"lookup.metric.2","tags":{"dc":"na","host":"host5"}}' "$RESP"
check_output_contains '{"tsuid":"000000007","metric":"lookup.metric.2","tags":{"dc":"na","host":"host8"}}' "$RESP"

# pagination, continue
RESP=`lookup_tt_get "limit=2&startIndex=2&m=lookup.metric.2%7Bhost=*%7D"`
check_status "$?"
check_output_contains '{"type":"LOOKUP","limit":2,"startIndex":2,"totalResults":8,"metric":"lookup.metric.2","tags":[{"key":"host","value":"*"}],"results":[' "$RESP"
check_output_contains '{"tsuid":"00000000C","metric":"lookup.metric.2","tags":{"dc":"eu","host":"host5"}}' "$RESP"
check_output_contains '{"tsuid":"00000000D","metric":"lookup.metric.2","tags":{"dc":"eu","host":"host6"}}' "$RESP"

# pagination, continue
RESP=`lookup_tt_get "limit=1&startIndex=4&m=lookup.metric.2%7Bhost=*%7D"`
check_status "$?"
check_output '{"type":"LOOKUP","limit":1,"startIndex":4,"totalResults":8,"metric":"lookup.metric.2","tags":[{"key":"host","value":"*"}],"results":[{"tsuid":"000000005","metric":"lookup.metric.2","tags":{"dc":"na","host":"host6"}}]}' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

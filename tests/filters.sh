#!/bin/bash

. common.bash

check_tt_not_running
start_tt --append.log.flush.frequency=5s
check_tt_running
ping_tt

TS=`date +%s`
api_put_http_gzip "put filters.metric $TS 3 dc=dal host=web01"
check_status "$?"
api_put_http_gzip "put filters.metric $TS 2 dc=dal host=web02"
check_status "$?"
api_put_http_gzip "put filters.metric $TS 10 dc=dal host=web03"
check_status "$?"
api_put_http_gzip "put filters.metric $TS 1 host=web01"
check_status "$?"
api_put_http_gzip "put filters.metric $TS 4 host=web01 owner=jdoe"
check_status "$?"
api_put_http_gzip "put filters.metric $TS 8 dc=lax host=web01"
check_status "$?"
api_put_http_gzip "put filters.metric $TS 4 dc=lax host=web02"
check_status "$?"
sleep 2

# OpenTSDB 1.x - 2.1

RESP=`query_tt_get "start=1d-ago&m=sum:filters.metric%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"host":"web01","owner":"jdoe"},"aggregateTags":["dc"],"dps":{"'$TS'":16.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:filters.metric%7Bhost=web01,dc=dal%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"dc":"dal","host":"web01"},"aggregateTags":[],"dps":{"'$TS'":3.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:filters.metric%7Bhost=*,dc=dal%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"dc":"dal","host":"web01"},"aggregateTags":[],"dps":{"'$TS'":3.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web02"},"aggregateTags":[],"dps":{"'$TS'":2.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web03"},"aggregateTags":[],"dps":{"'$TS'":10.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:filters.metric%7Bdc=dal|lax%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"dc":"dal"},"aggregateTags":["host"],"dps":{"'$TS'":15.0}},{"metric":"filters.metric","tags":{"dc":"lax"},"aggregateTags":["host"],"dps":{"'$TS'":12.0}}]' "$RESP"


# OpenTSDB 2.2

# explicit tags
RESP=`query_tt_get "start=1d-ago&m=sum:explicit_tags:filters.metric%7Bhost=web01%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"host":"web01"},"aggregateTags":[],"dps":{"'$TS'":1.0}}]' "$RESP"

# explicit tags with non-grouping tags
RESP=`query_tt_get "start=1d-ago&m=sum:explicit_tags:filters.metric%7Bhost=web01%7D%7Bdc=*%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"host":"web01"},"aggregateTags":["dc"],"dps":{"'$TS'":11.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:explicit_tags:filters.metric%7Bhost=*%7D%7Bdc=dal%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"dc":"dal","host":"web01"},"aggregateTags":[],"dps":{"'$TS'":3.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web02"},"aggregateTags":[],"dps":{"'$TS'":2.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web03"},"aggregateTags":[],"dps":{"'$TS'":10.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:explicit_tags:filters.metric%7Bhost=*%7D%7Bdc=*%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"host":"web01"},"aggregateTags":["dc"],"dps":{"'$TS'":11.0}},{"metric":"filters.metric","tags":{"host":"web02"},"aggregateTags":["dc"],"dps":{"'$TS'":6.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web03"},"aggregateTags":[],"dps":{"'$TS'":10.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:explicit_tags:filters.metric%7Bhost=*,dc=*%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"dc":"dal","host":"web01"},"aggregateTags":[],"dps":{"'$TS'":3.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web02"},"aggregateTags":[],"dps":{"'$TS'":2.0}},{"metric":"filters.metric","tags":{"dc":"lax","host":"web01"},"aggregateTags":[],"dps":{"'$TS'":8.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web03"},"aggregateTags":[],"dps":{"'$TS'":10.0}},{"metric":"filters.metric","tags":{"dc":"lax","host":"web02"},"aggregateTags":[],"dps":{"'$TS'":4.0}}]' "$RESP"

# built-in 2.x filters
RESP=`query_tt_get "start=1d-ago&m=sum:filters.metric%7Bhost=literal_or(web01)%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"host":"web01","owner":"jdoe"},"aggregateTags":["dc"],"dps":{"'$TS'":16.0}}]' "$RESP"

RESP=`query_tt_get "start=1d-ago&m=sum:filters.metric%7Bhost=literal_or(web01|web02|web03)%7D"`
check_status "$?"
check_output '[{"metric":"filters.metric","tags":{"host":"web01","owner":"jdoe"},"aggregateTags":["dc"],"dps":{"'$TS'":16.0}},{"metric":"filters.metric","tags":{"host":"web02"},"aggregateTags":["dc"],"dps":{"'$TS'":6.0}},{"metric":"filters.metric","tags":{"dc":"dal","host":"web03"},"aggregateTags":[],"dps":{"'$TS'":10.0}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

#!/bin/bash

. common.bash

start_tt
check_tt_running
ping_tt

# non-conventional tags/values
TS=`date +%s`
api_put_tcp "put tags.metric $TS 123 0=1 1=0"
check_status "$?"
api_put_http "put tags.metric $TS 234 0=1 1=1"
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1d-ago&m=avg:tags.metric%7B0=1,1=0%7D"`
check_status "$?"
check_output '[{"metric":"tags.metric","tags":{"0":"1","1":"0"},"aggregateTags":[],"dps":{"'$TS'":123.0}}]' "$RESP"

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric","tags":{"0":"1"}}]}'`
check_status "$?"
check_output "$RESP"  '[{"metric":"tags.metric","tags":{"0":"1","1":"0"},"aggregateTags":[],"dps":{"'$TS'":123.0}},{"metric":"tags.metric","tags":{"0":"1","1":"1"},"aggregateTags":[],"dps":{"'$TS'":234.0}}]'

api_put_http_gzip "put tags.metric2 $TS 100 tag1=val1 tag2=val1"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 200 tag1=val1 tag2=val2"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 300 tag1=val1 tag2=val3"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 400 tag1=val2 tag2=val1"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 500 tag1=val2 tag2=val2"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 600 tag1=val2 tag2=val3"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 700 tag1=val3 tag2=val1"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 800 tag1=val3 tag2=val2"
check_status "$?"
api_put_http_gzip "put tags.metric2 $TS 900 tag1=val3 tag2=val3"
check_status "$?"

# no tags
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2"}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

# some, but not all, tags
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val1"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val2"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val3"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"val1"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"val2"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"val3"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

# all the tags
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"val3","tag1":"val2"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}}]'

# prefix search
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val*"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"val*"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

# star
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"*"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"*"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

# OR
RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val1|val2"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag1":"val0|val3"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

RESP=`query_tt_post '{"start":"1d-ago","queries":[{"aggregator":"none","metric":"tags.metric2","tags":{"tag2":"val0|val1|val2|val3"}}]}'`
check_status "$?"
check_output "$RESP" '[{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":100.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":200.0}},{"metric":"tags.metric2","tags":{"tag1":"val1","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":300.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":400.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":500.0}},{"metric":"tags.metric2","tags":{"tag1":"val2","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":600.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val1"},"aggregateTags":[],"dps":{"'$TS'":700.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val2"},"aggregateTags":[],"dps":{"'$TS'":800.0}},{"metric":"tags.metric2","tags":{"tag1":"val3","tag2":"val3"},"aggregateTags":[],"dps":{"'$TS'":900.0}}]'

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

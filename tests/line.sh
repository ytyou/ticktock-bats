#!/bin/bash

. common.bash

start_tt
check_tt_running
ping_tt

TS=`date +%s`
api_write $'cpu,cpu=cpu10,host=yi-IdeaPad usage_guest=0,usage_guest_nice=0,usage_user=0,usage_system=0,usage_idle=100,usage_irq=0,usage_softirq=0,usage_steal=0,usage_nice=0,usage_iowait=0 1678405650000000000'
check_status "$?"
api_write $'cpu,cpu=cpu11,host=yi-IdeaPad usage_softirq=0,usage_guest=0,usage_guest_nice=0,usage_user=0.10060362175144351,usage_iowait=0,usage_irq=0,usage_steal=0,usage_system=0.20120724346628763,usage_idle=99.69818913511166,usage_nice=0 1678405650000000000'
check_status "$?"
sleep 1

RESP=`query_tt_get "start=1678405650&m=avg:cpu%7Bcpu=cpu11,host=yi-IdeaPad,_field=usage_system%7D"`
check_status "$?"
check_output '[{"metric":"cpu","tags":{"_field":"usage_system","cpu":"cpu11","host":"yi-IdeaPad"},"aggregateTags":[],"dps":{"1678405650":0.2012072434662876}}]' "$RESP"

RESP=`query_tt_post '{"start":"1678405650","queries":[{"aggregator":"avg","metric":"cpu","tags":{"cpu":"cpu11","host":"yi-IdeaPad"}}]}'`
check_status "$?"
echo "$RESP"
check_output '[{"metric":"cpu","tags":{"cpu":"cpu11","host":"yi-IdeaPad"},"aggregateTags":["_field"],"dps":{"1678405650":10.000000000032939}}]' "$RESP"

stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

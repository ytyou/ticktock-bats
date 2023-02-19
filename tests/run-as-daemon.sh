#!/bin/bash

. common.bash

start_tt
check_tt_running
ping_tt
stop_tt
wait_for_tt_to_stop
check_tt_not_running

exit 0

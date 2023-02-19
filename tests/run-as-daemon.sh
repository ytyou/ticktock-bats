#!/bin/bash

. common.bash

# run tt as daemon
${TT_SRC}/bin/tt -r -d -c ${TT_SRC}/conf/tt.conf --ticktock.home=$TT_HOME 3>/dev/null
check_status "$?"

# make sure tt is running
pgrep -u $USER -x tt >/dev/null 2>&1
check_status "$?"

RESP=`${TT_SRC}/admin/ping.sh`
check_output "pong" "$RESP"

# stop tt
${TT_SRC}/admin/stop.sh
check_status "$?"
sleep 1

# make sure tt is NOT running
pgrep -u $USER -x tt >/dev/null 2>&1
check_not_status "$?"

exit 0

#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/button_codes.sh

for var in $@
do
	[[ -n "${button["$var"]}" ]] && var=${button["$var"]}
	echo $var > /tmp/irdata.fifo
	sleep 0.5
done

#!/bin/bash
source etc/button_codes.sh

for var in $@
do
	[[ -n "${button[$var]}" ]] && var=${button["$var"]}
	echo $var > /tmp/irdata.fifo
	sleep 0.5
done

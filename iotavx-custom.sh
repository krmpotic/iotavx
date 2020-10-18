#!/bin/bash

source button_codes

while read cmd;
do
	case $cmd in
	${button["play-pause"]})
		playerctl play-pause
		;;
	${button["mode"]})
		dbdb.sh -l 10 -fn "Sans:pixelsize=50"
		;;
	${button["shuffle"]})
		playerctl shuffle | grep On && playerctl shuffle Off || playerctl shuffle On
		;;
	*)
		echo ?? $cmd
		;;
	esac
done < $1

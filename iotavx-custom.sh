#!/bin/bash
dmenu_opts="-l 10 -m 0 -fn 'Sans:pixelsize=50'"


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/etc/button_codes.sh

f_ff="$(mktemp)" # add f-flag file
trap "rm -f $f_ff; echo cleaning up... " 1 2 15

rm -f $f_ff
while read cmd;
do
	if [ -a $f_ff ]; then
		case $cmd in
		${button["folder+"]})    xdotool key Home ;;
		${button["folder-"]})    xdotool key End ;;
		${button["next"]})       xdotool key Down ;;
		${button["previous"]})   xdotool key Up ;;
		${button["play-pause"]}) xdotool key Enter ;;
		${button["eject"]})      xdotool key Escape ;;
		*) ;;
		esac
		continue
	fi

	case $cmd in
	00) ;& 01) ;& 02) ;& 03) ;& 04) ;& 05) ;& 06) ;& 07) ;& 08) ;& 09)
		xdotool key $(echo $cmd | sed 's/0//')
		;;
	${button["play-pause"]}) # play/pause
		playerctl play-pause
		;;
	${button["next"]})       # next
		playerctl next
		;;
	${button["previous"]})   # previous
		playerctl previous
		;;
	${button["seek+"]})      # forward
		playerctl position 10+
		;;
	${button["seek-"]})      # backward
		playerctl position 10-
		;;
	${button["stop"]})       # stop
		playerctl stop
		;;
	${button["shuffle"]})    # shuffle on/off
		playerctl shuffle | grep On && \
			playerctl shuffle Off || playerctl shuffle On
		;;
	${button["repeat"]})     # loop none/playlist
		playerctl loop | grep None && \
			playerctl loop Playlist || playerctl loop None
		;;
	${button["eject"]})      # switch audio output
		$DIR/etc/switch-audio.sh
		;;
	${button["folder+"]})    # xdg-open with directory-browser
		touch $f_ff
		{ file=$($DIR/etc/dmenu-sel.sh $dmenu_opts) && \
			xdg-open $file; rm $f_ff; } &
		;;
	*)
		echo ?? $cmd
		;;
	esac
done < $1

rm -f $f_ff

#!/bin/bash
dmenu_opts="-l 10 -m 0 -fn 'Sans:pixelsize=50'"
f_ff="$(mktemp)" # add f-flag file

trap "rm -f $f_ff; echo cleaning up... " 1 2 15

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # necessary?
source $DIR/etc/button_codes.sh

rm -f $f_ff
while read cmd;
do
	if [ -a $f_ff ]; then
		echo "f flag ON"
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
	${button["play-pause"]}) # play/pause
		playerctl play-pause
		;;
	${button["next"]})       # next
		playerctl next
		;;
	${button["previous"]})   # previous
		playerctl previous
		;;
	${button["stop"]})       # stop
		playerctl stop
		;;
	${button["shuffle"]})    # shuffle on/off
		playerctl shuffle | grep On && playerctl shuffle Off || playerctl shuffle On
		;;
	${button["repeat"]})       # loop none/playlist
		playerctl loop | grep None && playerctl loop Playlist || playerctl loop None
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

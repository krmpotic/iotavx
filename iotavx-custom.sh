#!/bin/bash
dmenu_opts="-l 10 -m 0 -fn 'Sans:pixelsize=50'"
ms=(5 15 25 50) # mouse steps
ms_i=0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/etc/button_codes.sh

f_ff="$(mktemp)" # folder-flag file
m_ff="$(mktemp)" # mouse-flag file
trap "rm -f $f_ff $m_ff; echo cleaning up... " 1 2 15

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

	if [ -a $m_ff ]; then
		case $cmd in
		${button["mode"]})       rm -f $m_ff ;;
		${button["stop"]})       ms_i=$(expr \( $ms_i + 1 \) % ${#ms[@]}) ;;
		${button["folder+"]})    xdotool mousemove_relative 0 -${ms[$ms_i]} ;;
		${button["folder-"]})    xdotool mousemove_relative 0 +${ms[$ms_i]};;
		${button["next"]})       xdotool mousemove_relative +${ms[$ms_i]} ;;
		${button["previous"]})   xdotool mousemove_relative -${ms[$ms_i]} ;;
		${button["seek-"]})      xdotool click 1 ;;
		${button["play-pause"]}) xdotool click 2 ;;
		${button["seek+"]})      xdotool click 3 ;;
		${button["shuffle"]})    xdotool click 4 ;;
		${button["repeat"]})     xdotool click 5 ;;
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
		$DIR/custom/switch-audio.sh
		;;
	${button["folder+"]})    # xdg-open with directory-browser
		touch $f_ff
		{ file=$($DIR/custom/dmenu-sel.sh $dmenu_opts) && \
			xdg-open $file; rm $f_ff; } &
		;;
	${button["mode"]})       # mouse
		touch $m_ff
		;;
	*)
		echo ?? $cmd
		;;
	esac
done < $1

rm -f $f_ff $m_ff

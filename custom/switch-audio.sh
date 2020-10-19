#!/bin/bash

card=alsa_card.pci-0000_0b_00.3 
profiles=(output:analog-stereo output:iec958-stereo)

get_profile() {
	pacmd list-cards | \
	sed -n -e "/$1/,/active profile/ s/.*active profile.*<\(.*\)>.*/\1/p"
}


p=$(get_profile $card)
echo -n "switching audio-profile: $p -> "
[[ "$p" == "${profiles[0]}" ]] && p=${profiles[1]} || p=${profiles[0]}
echo "$p."

pactl set-card-profile $card $p || echo FAIL > /dev/stderr

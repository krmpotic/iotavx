#!/bin/sh
chosen="."
while [ -d "$chosen" ]; do
	cd "$chosen"
	chosen=$({ echo ..; ls -1; } | dmenu "$@")
done

xdg-open "$chosen"

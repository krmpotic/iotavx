#!/bin/bash
chosen="."
relpath=$chosen
while [ -d "$chosen" ]; do
	cd "$chosen"
	chosen=$({ echo ..; ls -1; } | dmenu "$@") || exit 1
	relpath=$relpath/$chosen
done

echo "$relpath"

#!/bin/bash

IMAGE=()
INTERVAL=3600
WALLPAPER=~/Pictures/Wallpaper

while [ true ]; do

	[ ${#IMAGE[@]} -eq 0 ] && IMAGE=( `ls -R $WALLPAPER | grep -v ':' | shuf`  )
	bg="${IMAGE[0]}"
	unset 'IMAGE[0]'
	IMAGE=( ${IMAGE[@]} )

	gsettings set org.gnome.desktop.background picture-uri "'file:///${WALLPAPER}/${bg}'"

	sleep $INTERVAL

done

exit

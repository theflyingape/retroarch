#!/bin/bash

# if you have Gnome session set for autologin:
# https://bugzilla.redhat.com/show_bug.cgi?id=1873592
killall gnome-keyring-daemon
echo -n "keyringpassword" | gnome-keyring-daemon -l -d
gnome-keyring-daemon -s
systemctl --user restart gnome-remote-desktop

IMAGE=()
WALLPAPER=~/Pictures/Wallpaper

while [ true ]; do

	[ ${#IMAGE[@]} -eq 0 ] && IMAGE=( `ls $WALLPAPER/**/* | grep -v ':' | shuf` )
	bg="${IMAGE[0]}"
	unset 'IMAGE[0]'
	IMAGE=( ${IMAGE[@]} )

	# no spaces in filename please
	gsettings set org.gnome.desktop.background picture-uri "'file:///${bg}'"
	sleep 200

	# go idle when a fullscreen game is active, eh?
	while pidof -q retroarch ; do sleep 60 ; done

done

exit

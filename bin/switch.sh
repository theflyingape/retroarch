#!/bin/sh
#
# change to virtual console #1 where autologin 'pi' is running menu.sh
# and shutdown the Mutter X11 desktop . . . 
#

sudo chvt 2
sleep 0.5
killall -HUP bash
sudo systemctl stop lightdm
exit


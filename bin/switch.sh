#!/bin/sh
#
# change to virtual console #1 where autologin 'pi' is running menu.sh
# and shutdown the Mutter X11 desktop . . . 
#
sudo chvt 1
sudo systemctl stop lightdm

exit

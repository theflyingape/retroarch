#!/bin/bash
shopt -s expand_aliases

# /etc/rc.local :: we can't buy green bananas 
# and we're not running on battery, 
# so we'd rather burn out than fade away . . . 
sudo chmod 666 /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

#RA=~/.config/retroarch
RA=/retroarch
BG=( yellow black blue black red magenta )
FG=( black green white white black white )

alias out='echo -e'
OFF='\x1b[m'
ON='\x1b[1m'
DIM='\x1b[2m'
RVS='\x1b[7m'
KEY='\x1b[47;30;1m'

crt() {
	out

	[ ${#GUN[@]} -eq 0 ] && GUN=( `shuf -e 0 1 2 3 4 5` )
	declare -i i=${GUN[0]}
	unset 'GUN[0]'
	GUN=( ${GUN[@]} )
	setterm --background ${BG[$i]} --foreground ${FG[$i]} --hbcolor bright yellow --store --clear=rest

	out

	setleds -F -num < /dev/tty1
}

floppy() {
	out 
	sleep 1
	setterm --background green --foreground white --hbcolor bright yellow --store --clear=rest
	out 
	out "  ${DIM}COMMODORE${OFF}: press ${KEY}\x1b[31m Pi ${OFF} logo key to toggle ${ON}STATUS BAR${OFF}"
	out "  Use Left ${KEY} Ctrl ${OFF} as ${KEY}\x1b[34mC\x1b[31m=${OFF} logo key and Right ${KEY} Ctrl ${OFF} to swap Joysticks 1/2"
	out 
	out "  ${DIM}C64 HOME${OFF} games use multiple floppy diskettes to play!"
	out 
	out "  ${KEY} Num Lock ${OFF} toggles ${ON}GAME FOCUS\x1b[35m OFF${OFF} to use floppy ${ON}DRIVE${OFF} controls:"
	out "    ${KEY} \ ${OFF} to toggle ${ON}EJECT${OFF}/${ON}INSERT${OFF} current disk"
	out "    ${KEY} [ ${OFF} swap to ${ON}PREVIOUS${OFF} disk"
	out "    ${KEY} ] ${OFF} swap to ${ON}NEXT${OFF} disk"
	out "  Toggle ${ON}GAME FOCUS\x1b[32m ON${OFF} as necessary for ${DIM}COMPUTER${OFF} keyboard control"
	out 
	out -n "  Press any key to continue: "
	read -n 1 -s -t 90 choice
	out -en "\r\x1b[K\x1b[A"
}

help() {
	out 
	setterm --background green --foreground black --hbcolor bright yellow --store --clear=rest
	out 
	out "  Computer games take ${ON}GAME FOCUS${OFF} keyboard control on startup"
	out "   -- use ${KEY} Num Lock ${OFF} to toggle Game Focus mode ON/OFF"
	out 
	out "  Press ${KEY} Backspace ${OFF} for the Quick ${ON}MENU${OFF}, or hold ${RVS} SELECT ${OFF} for 2-sec"
	out "  Press ${KEY} Delete ${OFF} to ${ON}QUIT${OFF} game, or hold ${RVS} START ${OFF} for 2-sec"
	out 
	out "  Game speed controls: ${KEY} 0 ${OFF} pause, ${KEY} - ${OFF} slow-motion, or hold ${KEY} = ${OFF} fast-forward"
}

menu() {
	crt
	out "            *=*=*=*=*=*=*[ ${ON}RetroArch Playlist Menu${OFF} ]*=*=*=*=*=*=*"
	out 
	out "  ${DIM}0${OFF}. Big Menu  12,100   ${DIM}5${OFF}. Break-Out! (mouse 1/2P)   ${DIM}a${OFF}. Asteroids      (1/2P)"
	out "  ${DIM}1${OFF}. Arcade     2,600   ${DIM}6${OFF}. Sprite Invaders  (1/2P)   ${DIM}b${OFF}. Bubble Bobble  (1/2P)"
	out "  ${DIM}2${OFF}. Computers  2,600   ${DIM}7${OFF}. Berzerk MMX               ${DIM}c${OFF}. Carnival       (1/2P)"
	out "  ${DIM}3${OFF}. Consoles   4,200   ${DIM}8${OFF}. Omega Fury                ${DIM}d${OFF}. Mr. Do!        (1/2P)"
	out "  ${DIM}4${OFF}. Handhelds  2,700   ${DIM}9${OFF}. Quikman+         (1/2P)   ${DIM}g${OFF}. Gyruss         (1/2P)"
	out "                                                     ${DIM}j${OFF}. Donkey Kong Jr (1/2P)"
	out "  ${DIM}P${OFF}. power-off Pi       ${DIM}R${OFF}. restart Pi                ${DIM}m${OFF}. Ms. Pac-Man    (1/2P)"
	out "                                                     ${DIM}s${OFF}. Sea Wolf      (mouse)"
	out "                                                     ${DIM}t${OFF}. Tempest       (mouse)"
}

play() {
	rsync -a $RA/template.cfg $RA/retroarch.cfg
	retroarch $@ >& /dev/null
}

homebrew() {
	play --appendconfig="$RA/play.cfg|$RA/one-shot.cfg" \
		--set-shader=$RA/shaders/shaders_slang/crt/crt-pi.slangp \
		$@
}

arcade() {
	roms="MAME 2003-Plus"
	core="mame2003_plus"
	if [ -n "$2" ]; then
		roms="MAME 2010"
		core="$2"
	fi
	retroarch --appendconfig="$RA/play.cfg|$RA/one-shot.cfg" \
		-L $core "$RA/roms/$roms/$1.zip" 2> /dev/null
}

out 
out "  The following entertaining content is brought to you by ${DIM}The Flying Ape${OFF}"
out 
#retroarch --version
#out 
out -n "  Press ${RVS} Z ${OFF} to startup into "	
sudo systemctl is-enabled lightdm > /dev/null \
 && out "this ${DIM}CONSOLE${OFF} directly" \
 || out "the ${ON}DESKTOP${OFF} instead"
help

while [ true ]; do

menu

out -en "\x1b[A  ${ON}Choose${OFF} (${DIM}X${OFF}=exit): ${DIM}"
read -n 1 choice
out -n "${OFF} - ${ON}"

# in case user switched here manually . . . 
pidof lightdm > /dev/null && sudo systemctl stop lightdm

case $choice in

0)
	out "Play!"
	play --appendconfig="$RA/all.cfg"
	;;
1)
	out "My Arcade"
	play --appendconfig="$RA/play.cfg|$RA/myarcade.cfg"
	;;
2)
	out "Computers"
	floppy
	play --appendconfig="$RA/play.cfg|$RA/computers.cfg"
	;;
3)
	out "Consoles"
	play --appendconfig="$RA/play.cfg|$RA/consoles.cfg"
	;;
4)
	out "Handhelds"
	play --appendconfig="$RA/play.cfg|$RA/handhelds.cfg"
	;;
5)
	out "Break-out!"
	homebrew -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/break-out!.prg"
	;;
6)
	out "Sprite Invaders"
	homebrew -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/sprite_invaders.prg"
	;;
7)
	out "Berzerk-MMX"
	homebrew -L vice_xvic "$RA/roms/homebrews/VIC20/16KB/berzerk-mmx-16k.prg"
	;;
8)
	out "Omega Fury"
	homebrew -L vice_xvic "$RA/roms/homebrews/VIC20/16KB/omega-fury.prg"
	;;
9)
	out "Quikman"
	homebrew -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/quikman+8k.prg"
	;;
a)
	out "Asteroids"
	arcade asteroid
	;;
b)
	out "Bubble Bobble"
	arcade bublbobl
	;;
c)
	out "Carnival"
	arcade carnival
	;;
d)
	out "Mr. Do!"
	arcade mrdo
	;;
g)
	out "Gyruss"
	arcade gyruss
	;;
h)
	out "Hack & Slash (ddgame.us)"
	setterm --background black --foreground white --hbcolor grey --store --clear=rest
	sleep 1
	telnet play.ddgame.us
	;;
j)
	out "Donkey Kong Jr"
	arcade dkongjr
	;;
m)
	out "Ms. Pac-Man"
	arcade mspacman
	;;
s)
	out "Sea Wolf"
	arcade seawolf mame2010
	;;
t)
	out "Tempest"
	arcade tempest
	;;
P)
	out "powering the Pi off ${OFF}. . . "
	sleep 1
	sudo shutdown -h now
	;;
R)
	out "restarting ${OFF}. . . "
	sleep 1
	sudo reboot
	;;
U)
	out "upgrading ${OFF}. . . possibly."
	sudo apt update \
       	 && sudo apt -y upgrade
	sudo rpi-eeprom-update -a
	sudo rpi-update
	;;
X)
	out "exiting ${OFF}. . . "
	setterm --background black --foreground white --hbcolor grey --store --clear=rest
	out "Starting ${ON}Light Display Manager${OFF}"
	sleep 1
	sudo chvt 7
	sudo systemctl start lightdm
	kill -KILL $PPID `pidof bash`
	;;
Z)
	sudo systemctl is-enabled lightdm > /dev/null \
	 && sudo systemctl disable lightdm \
	 || sudo systemctl enable lightdm
	;;
*)
	out "?? choose again ${OFF}\x07"
	help
	;;
esac

done


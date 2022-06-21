#!/bin/bash
shopt -s expand_aliases

# /etc/rc.local :: we can't buy green bananas 
# and we're not running on battery, 
# so we'd rather burn out than fade away . . . 
sudo chmod 666 /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
trap "sudo chvt 2; sleep 1; sudo killall fbi; exit" 1 3 15
sudo lastlog --clear --user $USER

# set RETROFE_PATH
export ROOTDIR=/home/pi
export RETROFE_PATH=$ROOTDIR/ARCADE

RA=/retroarch
BG=( yellow black blue black red magenta )
FG=( black green white white black white )

alias out='echo -e'
OFF='\e[0m'
ON='\e[0;1m'
DIM='\e[0;2m'
RVS='\e[0;7m'
KEY='\e[0;47;30;1m'
PAD='     '
DOWN='\x0e.\x0f'
LEFT='\x0e,\x0f'
RIGHT='\x0e+\x0f'
UP='\x0e-\x0f'

# render favorite games idle playlist
TAGGED="/run/user/$UID/favorites.lis"
rm -f $TAGGED &> /dev/null
core=( stella prosystem vice_x64sc mame2003_plus mupen64plus_next nestopia bsnes vice_xvic )
L=0
for lpl in 'Atari 2600' 'Atari 7800' 'C64' 'MAME 2003-Plus' 'Nintendo 64' 'Nintendo Entertainment System' 'Super Nintendo' 'VIC20'; do
	while read content ; do
		echo "-L ${core[$L]} ${content}" >> $TAGGED
	done < <( grep '"path":' "/retroarch/content_favorites.lpl" | grep "/$lpl/" | awk -F'"path": ' '{print $2}' | sed 's/.$//' )
	let L=$L+1
done
shuf $TAGGED -o $TAGGED


astrob() {
	out "Astro Blaster (c) 02/1981 Sega"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} WARP ${OFF}"
	out 
	out "${PAD}NOTE: Fuel is a very precious commodity in this game. If you run out of fuel,"
	out "${PAD}your game is over regardless of how many star ships you have left."
}

berzerk() {
	out "Berzerk (c) 10/1980 Stern Electronics"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}The first game to feature talking enemies.  The speech synthesis"
	out "${PAD}technology of the time being so new that it cost \$1000 to program"
	out "${PAD}each individual word into the game's ROM."
	out "${PAD}I was able to reuse the ROM words into a compatible format that"
	out "${PAD}allowed my VIC 20 conversion, Berzerk MMX, to speak using a"
	out "${PAD}software technique off its Volume register."
}

berzerk_mmx() {
	out "Berzerk-MMX (c) Robert Hurst"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey 10 && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/16KB/berzerk-mmx-16k.prg"
}

bombjack() {
	out "Bomb Jack (c) 10/1984 Tehkan"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}Pick up most of the bombs while their fuses are lit to earn"
	out "${PAD}maximum points."
}

breakout() {
	out "Break-out! (c) Robert Hurst"
	out "${OFF}"
	out "${PAD}Best used with a mouse/trackball."
	anykey 10 && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/break-out!.prg"
}

btime() {
	out "Burger Time (c) 1982 Data East"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PEPPER ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}It's possible to move chef Peter Pepper up & down on the ladders"
	out "${PAD}faster using rapid presses, rather than holding the direction."
}

centiped() {
	out "Centipede (c) 1980 Atari"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD} move"
	out 
	out "${PAD}Easier with a mouse/trackball and its button."
	out 
	out "${PAD}The first coin-op game designed by a woman, Dona Bailey."
	out "${PAD}Like Pac-Man, this game has special appeal to women."
}

clbowl() {
	out "Coors Light Bowling (c) 1989 Incredible Technologies"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${LEFT}${KEY} HOOK ${OFF}  ${KEY} HOOK ${OFF}${RIGHT}"
	out "${PAD}${PAD}aim/roll"
}

crossbow() {
	out "Crossbow (c) 10/1983 Exidy"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}  aim"
	out 
	out "${PAD}The first video game to completely use digitized sound and music."
}

defender() {
	out "Defender (c) 12/1980 Williams"
	out "${OFF}"
	out "${PAD}${PAD}shoulder  ${KEY} ${UP} ${OFF}  ${KEY} BOMB ${OFF}   ${KEY} WARP ${OFF}"
	out "${PAD}${PAD}   ${KEY}${LEFT}${RIGHT}${OFF}      |"
	out "${PAD}${PAD}reverse   ${KEY} ${DOWN} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	out 
	out "${PAD}Arcade industry insiders confidently predicted that both Defender"
	out "${PAD}and Pac-Man would be commercial flops and that Rally-X would be"
	out "${PAD}the next major arcade success."
	out "${PAD}Along with Pac-Man, Defender shares the title of 'Highest Grossing"
	out "${PAD}Video Game of All Time' and has earned more than \$1B."
}

docastle() {
	out "Mr. Do's Castle (c) 09/1983 Universal"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} MALLET ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
}

duckhunt() {
	out "Duck Hunt (c) 03/1985 Nintendo"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}  aim"
	out 
	out "${PAD}Easier with a mouse/trackball and its button."
}

galaxian() {
	out "Galaxian (c) 10/1979 Namco"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	out 
	out "${PAD}The Galaxian Flagship became a trademark and made cameo"
	out "${PAD}appearances in other Namco classics. It is also my Gravitar."
}

gngt() {
	out "Ghosts'n Goblins (c) 09/1985 Capcom"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
}

gorf() {
	out "GORF (c) 02/1981 Midway"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}Galactic Orbital Robot Force was the first game ever to show"
	out "${PAD}multiple scenes. A Star Trek tie in was originally planned by"
	out "${PAD}Midway, but when the first movie fell flat, the Enterprise sprite"
	out "${PAD}was reused as the Gorf flagship."
	out 
	out "${PAD}'Try again, I devour coins!', 'Ha ha ha ha!', 'Prepare for"
	out "${PAD}annihilation!', 'All hail the supreme Gorfian Empire!' and the"
	out "${PAD}infamous 'Long Live Gorf!'"
}

hattrick() {
	out "Hat Trick (c) 1984 Bally Sente"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SHOOT ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}Despite its simple skate, shoot and save gameplay, it was"
	out "${PAD}considered one of the better sports games of the early 1980's."
}

headon2() {
	out "Head On 2 (c) 10/1979 Sega"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FAST ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
}

kchampvs() {
	out "Karate Champ (c) 09/1984 Data East"
	out "${OFF}"
	out "${PAD}${PAD} left     right"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} STICK ${OFF}"
	out "${PAD}${PAD} move     attack"
	out 
	out "${PAD}The seminal one-on-one fighting game."
}

ladybug() {
	out "Lady Bug (c) 10/1981 Universal"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}Eat the \x1b[1;7;34mBLUE\x1b[m hearts (up to x5) as soon as possible."
}

mappy() {
	out "Mappy (c) 03/1983 Namco"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} DOOR ${OFF}"
}

minigolf() {
	out "Mini Golf (c) 11/1985 Bally Sente"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} PLACE ${OFF}"
	out "${PAD}${PAD} putt"
	out 
	out "${PAD}PLACE ball on one of the matt's starting position."
	out "${PAD}PUTT in the direction & force from an analog device."
}

missile() {
	out "Missile Command (c) 06/1980 Atari"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} FIRE ${OFF}"
	out 
	out "${PAD}Engineering loved the name Armageddon, but from the top came the"
	out "${PAD}message, 'We can't use that name, nobody'll know what it means,"
	out "${PAD}and nobody can spell it.'"
	out 
	out "${PAD}Easier with a mouse/trackball with ${KEY} A ${OFF} ${KEY} S ${OFF} ${KEY} D ${OFF}"
}

mpatrol() {
	out "Moon Patrol (c) 05/1982 Irem"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	out 
	out "${PAD}The first game to feature parallax scrolling."
}

omegrace() {
	out "Omega Race (c) 06/1981 Midway"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} THRUST ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD} rotate"
	out 
	out "${PAD}Its storyline was my inspiration to write a sequel, Omega Fury."
}

omega_fury() {
	out "Omega Fury (c) Robert Hurst"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey 10 && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/16KB/omega-fury.prg"
}

pacman() {
	out "Pac-Man (c) 10/1980 Namco"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}It is still regarded as the hallmark of the 'golden age' of video"
	out "${PAD}games."
}

polepos() {
	out "Pole Position (c) 09/1982 Namco"
	out "${OFF}"
	out "${PAD}${PAD}shoulder"
	out "${PAD}${PAD}${KEY} SHIFT ${OFF}${DOWN}${UP}"
	out "${PAD}${PAD}      left"
	out "${PAD}${PAD}     ${KEY} STICK ${OFF}  ${KEY} GAS ${OFF}  ${KEY} BRAKE ${OFF}"
	out "${PAD}${PAD}      rotate"
	out 
	out "${PAD}Use SHIFT to toggle between LO / HI gear. Check that it's in LO gear"
	out "${PAD}before START for quicker acceleration. Shift into HI around 180km."
	out "${PAD}Either release GAS or shift into LO to better navigate hairpin turn."
	out "${PAD}STICK steering will only slowly re-center itself.  As the Driver,"
	out "${PAD}you rotate the wheel back to center without over-correcting."
}

popeye() {
	out "Popeye (c) 12/1982 Nintendo"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PUNCH ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}Popeye and its cast of characters: Olive Oyl, Bluto, Wimpy,"
	out "${PAD}Sweetpea, the Sea Hag and her Vulture."
}

qix() {
	out "Qix (c) 10/1981 Taito"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SLOW ${OFF}  ${KEY} FAST ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}The author named the game 'QIX' (pronounced 'KICKS' and not"
	out "${PAD}'QUIX') because his car tags was 'JUS4QIX'."
}

quikman() {
	out "Quikman (c) Robert Hurst"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey 10 && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/quikman+8k.prg"

}

rallyx() {
	out "Rally-X (c) 10/1980 Namco"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SMOKE ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
}

ripoff() {
	out "Rip Off (c) 04/1980 Cinematronics"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} THRUST ${OFF}  ${KEY} FIRE ${OFF}"
	out 
	out "${PAD}The first two player cooperative video game."
}

robotron() {
	out "Robotron - 2084 (c) 03/1982 Williams"
	out "${OFF}"
	out "${PAD}${PAD} left     right"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} STICK ${OFF}"
	out "${PAD}${PAD} move     fire"
	out 
	out "${PAD}The design was influenced by Berzerk and the Commodore PET game"
	out "${PAD}Chase.  The inspiration for the character Mikey was from the"
	out "${PAD}1970's commercial for 'Life' cereal."
}

rthunder() {
	out "Rolling Thunder (c) 12/1986 Namco"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}It's possible to visit the ammo rooms more than once by ensuring"
	out "${PAD}that the door in question is completely off screen, then turn back."
}

rushatck() {
	out "Rush'n Attack (c) 07/1985 Konami"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} KNIFE ${OFF}  ${KEY} SHOOT ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}You will mainly rely on your trusty knife for this mission."
}

spacduel() {
	out "Space Duel (c) 02/1982 Atari"
	out "${OFF}"
	out "${PAD}${PAD}           ${KEY} SHIELD ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}   ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	out 
	out "${PAD}In 2 player mode, you can shoot your partner and it will"
	out "${PAD}regenerate their shield."
}
sprite_invaders() {
	out "Sprite Invaders (c) Robert Hurst"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	anykey 10 && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/sprite_invaders.prg"
}

starcas() {
	out "Star Castle (c) 09/1980 Cinematronics"
	out "${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	out 
	out "${PAD}The original inspiration came from a never-released game,"
	out "${PAD}Oops! in which the player controlled a sperm trying to fertilize"
	out "${PAD}an egg in the center of the screen."
}

startrek() {
	out "Star Trek - Strategic Operations Simulator (c) 1982 Sega"
	out "${OFF}"
	out "${PAD}${PAD} left    ${KEY} PHOTON ${OFF}  ${KEY} WARP ${OFF}"
	out "${PAD}${PAD}${KEY} STICK ${OFF}   ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	out "${PAD}${PAD} rotate"
	out 
	out "${PAD}As much as possible to maximize scoring, avoid resupplying at"
	out "${PAD}a starbase."
}

starwars() {
	out "Star Wars (c) 05/1983 Atari"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}  aim"
	out 
	out "${PAD}The first Atari game to have speech."
	out "${PAD}In the trench you can get extra bonus points by not shooting"
	out "${PAD}ANYTHING until 'USE THE FORCE' appears."
}

tailg() {
	out "Tail Gunner (c) 11/1979 Cinematronics"
	out "${OFF}"
	out "${PAD}${PAD} left"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} SHIELD ${OFF}"
	out "${PAD}${PAD}  aim"
	out 
	out "${PAD}Easier with a mouse and its two buttons."
	out "${PAD}Game ends when 10 ships get pass you."
}

tapper() {
	out "Tapper (Budweiser) (c) 12/1983 Bally Midway"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} POUR ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}Take your time in the first few levels.  You can make a high"
	out "${PAD}score by leaving one person and waiting for more people."
}

timeplt() {
	out "Time Pilot (c) 11/1982 Konami"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}On the second stage, don't shoot anything but the bombers."
	out "${PAD}Collect the parachutes while avoiding the planes."
}

tron() {
	out "Tron (c) 05/1982 Bally Midway"
	out "${OFF}"
	out "${PAD}${PAD} left     right"
	out "${PAD}${PAD}${KEY} STICK ${OFF}  ${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	out "${PAD}${PAD} move      aim"
	out 
	out "${PAD}The levels were named after programming languages and terminology."
	out "${PAD}The game starts out at RPG and advances through PASCAL, BASIC,"
	out "${PAD}ASSEMBLER, etc. until the USER level is reached."
	out "${PAD}Don't forget to twirl the knob as you rise into the MCP CONE."
}

xevious() {
	out "Xevious (c) 12/1982 Namco"
	out "${OFF}"
	out "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	out "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} BOMB ${OFF}"
	out "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	out 
	out "${PAD}The world's first vertically scrolling shoot-em-up."
	out "${PAD}You can hold down the fire and bomb buttons to constantly do"
	out "${PAD}both at a slower rate."
}

anykey() {
	out
	out -n "${PAD}Press any button/key to continue: \e[s"
	while read ev sym sel cmd; do
		[ "$ev" = "EV_ABS" -o "$ev" = "EV_REL" ] && continue
		[[ "$sym" =~ "REL" ]] && continue
		[ $sel -eq 0 ] && continue
		[ "$cmd" = "command" ] || continue
		break
	done < <( timeout -s SIGALRM $1 thd --dump /dev/input/event* ) 
	read -n 255 -t 0.1 mt 2> /dev/null
	out -n "\e[u\r\e[A\e[J"
	[ "$sym" = "KEY_ESC" ] && return 1 || return 0
}

crt() {
	setleds -L < /dev/tty1 &> /dev/null
	setleds -F -caps -num -scroll < /dev/tty1
	stty -echo

	[ ${#GUN[@]} -eq 0 ] && GUN=( `shuf -e 0 1 2 3 4 5` )
	declare -i i=${GUN[0]}
	unset 'GUN[0]'
	GUN=( ${GUN[@]} )
	setterm --background ${BG[$i]} --foreground ${FG[$i]} --hbcolor bright yellow --store --clear=rest
	out
	setterm --background ${BG[$i]} --foreground ${FG[$i]} --hbcolor bright yellow --store --clear=rest
}

floppy() {
	out 
	setterm --background green --foreground white --hbcolor bright yellow --store --clear=rest
	out 
	out "${PAD}${DIM}COMMODORE${OFF}: press ${KEY}\e[31m Pi ${OFF} logo key to toggle ${ON}STATUS BAR${OFF}"
	out "${PAD}Use Left ${KEY} Ctrl ${OFF} as ${KEY}\e[34mC\e[31m=${OFF} logo key and Right ${KEY} Ctrl ${OFF} to swap Joysticks 1/2"
	out 
	out "${PAD}${DIM}C64 HOME${OFF} games use multiple floppy diskettes to play!"
	out 
	out "${PAD}Use ${KEY} Num Lock ${OFF} to toggle ${ON}GAME FOCUS\e[35m OFF${OFF} for floppy ${ON}DRIVE${OFF} controls:"
	out "${PAD}${KEY} \ ${OFF} to toggle ${ON}EJECT${OFF}/${ON}INSERT${OFF} current disk"
	out "${PAD}${KEY} [ ${OFF} swap to ${ON}PREVIOUS${OFF} disk"
	out "${PAD}${KEY} ] ${OFF} swap to ${ON}NEXT${OFF} disk"
	out "${PAD}Toggle ${ON}GAME FOCUS\e[32m ON${OFF} when needed for ${DIM}COMPUTER${OFF} keyboard control"
	anykey 90
}

laserdiscs() {
	DISCS=( "" 1 2 3 4 5 6 )
	LABEL=( "" "Astron Belt" "Cliff Hanger" "Dragon's Lair" "Dragon's Lair II: Time Warp" "Space Ace" "Super Don Quixote" )
	ROM=( "" "astron" "cliff" "dle21" "lair2" "sae" "sdq" )
	INFO=( "" "${PAD}You fly through the universe battling alien ships to make your way to fight the main\n${PAD}Alien Battle Cruiser. Along the way, you fly across alien planets, through tunnels,\n${PAD}through trenches, and get involved in a few astro-dogfights with enemy space fighters." "${PAD}Cliff is on a mission to save Clarissa from being forced to marry the evil Count Draco.\n${PAD}The game consists of animated scenes, during which the player has to press direction buttons\n${PAD}or the sword button in the right moment to trigger the next segment of the movie.\n${PAD}The anime video used in the game are scenes from the Lupin III anime movies, mainly scenes\n${PAD}from The Castle of Cagliostro and the Mystery of Mamo animated movies." "${PAD}Originally released in the arcades as a laserdisc game, Dragon's Lair is an interactive\n${PAD}cartoon movie. Players control Dirk the Daring as he struggles his way through a dungeon\n${PAD}to fight Singe, the Dragon, and rescue the beautiful Princess Daphne.\n${PAD}The game consists of animated scenes, during which the player has to press direction buttons\n${PAD}or the sword button in the right moment to trigger the next segment of the movie." "${PAD}Princess Daphne has been spirited away to a wrinkle in time by the Evil Wizard Mordroc\n${PAD}who plans to force her into marriage. Only you, Dirk the Daring, can save her.\n${PAD}Transported by a bumbling old time machine, you begin the rescue mission.\n${PAD}But you must hurry, for once the Casket of Doom has opened, Mordroc will place the\n${PAD}Death Ring upon Daphne's finger in marriage and she will be lost forever in the\n${PAD}Time Warp!" "${PAD}Space Ace was unveiled in October 1983, just four months after the Dragon's Lair game,\n${PAD}then released in Spring 1984, and like its predecessor featured film-quality\n${PAD}animation played back from a laserdisc." "${PAD}The idea for this game comes from the stories about Don Quixote, the legendary Spanish knight.\n${PAD}In this game, the character looks very young and does not have a mustache. Also, he has a\n${PAD}sword for a weapon and his faithful sidekick Sancho Panza follows him around although\n${PAD}he does nothing (like Jon) to assist the hero (Randy).\n${PAD}An assortment of mythical creatures including demons, dragons, skeletons and so on\n${PAD}are encountered throughout the game.\n${PAD}The game ends when Don Quixote kills the evil witch and rescues Isabella.")
	i=0
	disc=

	setterm --background black --foreground cyan --hbcolor bright yellow --store --clear=rest
	out 
	out "${PAD}${DIM}1${OFF}. Astron Belt"
	out "${PAD}${DIM}2${OFF}. Cliff Hanger"
	out "${PAD}${DIM}3${OFF}. Dragon's Lair (extended)"
	out "${PAD}${DIM}4${OFF}. Dragon's Lair II: Time Warp"
	out "${PAD}${DIM}5${OFF}. Space Ace"
	out "${PAD}${DIM}6${OFF}. Super Don Quixote"
	out 
	out -n "${PAD}${ON}Disc \x0e.-\x0f${OFF}: ${DIM}\e[s"

	while read ev sym sel cmd; do
		[ $sel -eq 0 ] && continue
		[ "$cmd" = "command" ] || continue
		if [[ $sym =~ ABS_HAT0? ]] ; then
			[ $sel -eq 1 ] && sym="KEY_DOWN" || sym="KEY_UP"
		fi
		case $sym in
		BTN_DPAD_DOWN|BTN_SELECT|BTN_TR|KEY_DOWN)
			let i=$i+1
			[ $i -ge ${#DISCS[@]} ] && let i=0
			;;
		BTN_B|BTN_GAMEPAD|BTN_START|KEY_ENTER)
			out 
			break
			;;
		BTN_DPAD_UP|BTN_TL|KEY_UP)
			[ $i -gt 0 ] || let i=${#DISCS[@]}
			let i=$i-1
			;;
		KEY_[1-6])
			let i=${sym:(-1)}
			;;
		*)
			let i=0
			;;
		esac
		disc="${ROM[$i]}"
		[ $i -gt 0 ] && out -n "${i} ${OFF}-${ON} ${LABEL[$i]}"
		out -n "\e[K\e[u"
	done < <( timeout -s SIGALRM 40 thd --dump /dev/input/event* )

	out 
	if [ -n "${disc}" ]; then 
		setterm --background cyan --foreground black --hbcolor bright white --store --clear=rest
		out 
		out "${INFO[$i]}"
		out 
		out "${PAD}${KEY} 5 ${OFF} / ${KEY} 6 ${OFF} insert enough COIN(s) to START"
		out "${PAD}${KEY} 1 ${OFF} / ${KEY} 2 ${OFF} for player(s) START respectively"
		out "${PAD}${KEY} ESC ${OFF} to QUIT the game"
		anykey 60 && ~/Daphne/daphne.sh "${RA}/roms/Daphne/${disc}.daphne" &> /dev/null
	fi
}

legends() {
	out 
	setterm --background green --foreground white --hbcolor bright yellow --store --clear=rest
	out 
	out "${PAD}${KEY} LEFT ${OFF} / ${KEY} RIGHT ${OFF} toggles filter between ${DIM}ALL GAMES${OFF} and ${DIM}FAVORITES${OFF}"
	out "${PAD}${KEY} SELECT ${OFF} playlist filter and ${KEY} START ${OFF} toggles the title as a favorite"
	out "${PAD}Shoulder ${KEY} BUMPERS ${OFF} jump thru titles by letter"
	anykey 30 || return
	reset
	ln -sf "${RETROFE_PATH}/emulators/retroarch" ~/.config/ ; sync
	#~/ARCADE/emulators/retroarch/shaders/shaders_slang/motion-interpolation/shaders/motion_interpolation/.slang.sh
	trap "exit" 1 3 15
	~/ARCADE/retrofe.sh &> /dev/null
}

menu() {
	sudo systemctl is-enabled lightdm > /dev/null \
	 && STARTUP="CONSOLE" || STARTUP="DESKTOP"
	crt
	out "${PAD}                           *=*=*=*=*=*=*[ ${ON}RetroArch Playlist Menu${OFF} ]*=*=*=*=*=*=*"
	out 
	out "${PAD}${DIM}0${OFF}. Big Menu  12,200     ${DIM}5${OFF}. Break-Out!       (mouse)     ${DIM}a${OFF}. Asteroids      (1/2P)     ${DIM}A${OFF}. Angband          (1P)"
	out "${PAD}${DIM}1${OFF}. Arcade     2,600     ${DIM}6${OFF}. Sprite Invaders   (1/2P)     ${DIM}b${OFF}. Bubble Bobble  (1/2P)     ${DIM}C${OFF}. Cyberball      (1/2P)"
	out "${PAD}${DIM}2${OFF}. Computers  2,600     ${DIM}7${OFF}. Berzerk MMX         (1P)     ${DIM}c${OFF}. Carnival       (1/2P)     ${DIM}D${OFF}. Dank Domain      (1P)"
	out "${PAD}${DIM}3${OFF}. Consoles   4,300     ${DIM}8${OFF}. Omega Fury          (1P)     ${DIM}d${OFF}. Mr. Do!        (1/2P)     ${DIM}F${OFF}. Frogger        (1/2P)"
	out "${PAD}${DIM}4${OFF}. Handhelds  2,700     ${DIM}9${OFF}. Quikman+          (1/2P)     ${DIM}g${OFF}. Galaga         (1/2P)     ${DIM}G${OFF}. Gyruss         (1/2P)"
	out "${PAD}${DIM}l${OFF}. Legends      471     ${DIM}L${OFF}. Laser Disc games             ${DIM}j${OFF}. Donkey Kong Jr (1/2P)     ${DIM}K${OFF}. Kung-Fu Master (1/2P)"
	out "${PAD}${DIM}p${OFF}. power-off Pi         ${DIM}U${OFF}. upgrade Pi                   ${DIM}m${OFF}. Ms. Pac-Man    (1/2P)     ${DIM}Q${OFF}. Q*bert         (1/2P)"
	out "${PAD}${DIM}r${OFF}. restart Pi           ${DIM}Z${OFF}. toggle startup ${ON}${STARTUP}${OFF}       ${DIM}s${OFF}. Sea Wolf      (mouse)     ${DIM}S${OFF}. Space Invaders (1/2P)"
	out "${PAD}                                                        ${DIM}t${OFF}. Tempest       (mouse)     ${DIM}V${OFF}. 10-yard Fight  (1/2P)"
}

prompt() {
	sub=$1
	val=$2
	export ${val}="${CHOICE[${!sub}]}"

	out -n "\e[u${DIM}${!val} ${OFF}-${ON} ${MENU[${!sub}]}\e[K\e[u"

	while read ev sym sel cmd; do
		[ $sel -eq 0 ] && continue
		[ "$cmd" = "command" ] || continue
		if [[ $sym =~ ABS_HAT0? ]] ; then
			[ $sel -eq 1 ] && sym="KEY_DOWN" || sym="KEY_UP"
		fi
		case $sym in
		BTN_DPAD_DOWN|BTN_SELECT|BTN_TR|KEY_DOWN)
			let ${sub}=${!sub}+1
			[ ${!sub} -ge ${#CHOICE[@]} ] && let ${sub}=1
			;;
		BTN_B|BTN_GAMEPAD|BTN_START|KEY_ENTER)
			out -n "\e[u${DIM}${!val} ${OFF}-${ON} \e[J"
			return
			;;
		BTN_DPAD_UP|BTN_TL|KEY_UP)
			[ ${!sub} -gt 1 ] || let ${sub}=${#CHOICE[@]}
			let ${sub}=${!sub}-1
			;;
		KEY_ESC)
			export ${val}="X"
			return
			;;
		KEY_F10)
			break
			;;
		KEY_F12)
			export ${val}="WOPR"
			return
			;;
		KEY_LEFTMETA)
			out -n "\e[u${KEY}\e[31m Pi ${OFF} -${ON} \e[K"
			export ${val}="pi"
			return
			;;
		*KEY_?)
			export ${val}=${sym:(-1)}
			[[ $sym =~ [+]KEY_? ]] || export ${val}=`echo ${sym:(-1)} | tr [:upper:] [:lower:]`
			out -n "\e[u${DIM}${!val} ${OFF}-${ON} \e[J"
			return
			;;
		esac
		export ${val}="${CHOICE[${!sub}]}"
		out -n "\e[u${DIM}${!val} ${OFF}-${ON} ${MENU[${!sub}]}\e[K\e[u"
	done < <( timeout -s SIGALRM 36 thd --dump /dev/input/event* )

	export ${val}="attract"
}

reset() {
	out "\e[s\e[1;${LINES}r\e[u"
	setterm --background black --foreground white --hbcolor grey --store --clear=rest
	read -n 255 -t 0.1 mt 2> /dev/null
	stty echo
	setterm --background black --foreground white --hbcolor grey --store --clear=rest
}

play() {
	# in case user switched here manually . . . 
	pidof lightdm > /dev/null && sudo systemctl stop lightdm
	rsync -a $RA/template.cfg $RA/retroarch.cfg && ln -sf $RA ~/.config/
	sync
	retroarch "$@" &> /dev/null && return 0 || return 1
}

qstart() {
	play --appendconfig="$RA/play.cfg|$RA/one-shot.cfg" "$@"
	#    --set-shader="$RA/shaders/RetroPie_GLSL/zfast_crt_curve.glslp"
}

arcade() {
	# in case user switched here manually . . . 
	pidof lightdm > /dev/null && sudo systemctl stop lightdm
	ln -sf $RA ~/.config/ ; sync
	roms="MAME 2003-Plus"
	core="mame2003_plus"
	if [ -n "$2" ]; then
		roms="MAME 2010"
		core="$2"
	fi
	retroarch --appendconfig="$RA/play.cfg|$RA/one-shot.cfg" \
		-L $core "$RA/roms/$roms/$1.zip" 2> /dev/null
}

audio() {
	mpv --no-video "Music/$1" &> /dev/null
}

video() {
	#mplayer -vo fbdev2 -fs -xy 2 -zoom "Videos/$1" &> /dev/null
	mpv "Videos/$1" &> /dev/null
}


if pidof lightdm > /dev/null ; then
	sleep 86400
	exit
fi

sudo systemctl restart console-setup
out -n "\e[s\e[13;${LINES}r\e[u"
menu
pidof lightdm > /dev/null || sudo chvt 1

CHOICE=( "" "R" 0 1 2 3 4 "l" "p" "r" "X" )
MENU=( "" "random pick" "Play!" "Arcade" "Computers" "Consoles" "Handhelds" "Legends" "power-off" "restart" "exit")
n=1
choice=

while [ true ]; do

out
out -n "\e[A${PAD}${ON}Choose \x0e.-\x0f${OFF} (${DIM}X${OFF}=exit): ${DIM}\e[s\e[${LINES};102H${KEY} `date +'%a %I:%M%P'` "
prompt n choice

case $choice in
0)
	out "Play!"
	play
	;;
1)
	out "Arcade"
	play --appendconfig="$RA/play.cfg|$RA/myarcade.cfg"
	;;
2)
	out "Computers"
	floppy
	ln -fs "Computers.png" "$RA/assets/wallpapers/Main Menu.png"
	play --appendconfig="$RA/play.cfg|$RA/computers.cfg"
	ln -fs "Main.png" "$RA/assets/wallpapers/Main Menu.png"
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
	breakout
	;;
6)
	sprite_invaders
	;;
7)
	berzerk_mmx
	;;
8)
	omega_fury
	;;
9)
	quikman
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
e)
	out "Elevator Action"
	arcade elevator
	;;
f)
	out "Gridiron Fight"
	qstart -L mamearcade2016 "$RA/roms/MAME 2016/gridiron.zip"
	;;
g)
	out "Galaga"
	arcade galaga
	;;
h)
	out "Satan's Hollow"
	arcade shollow
	;;
i)
	out "Extra Innings"
	arcade einnings
	;;
j)
	out "Donkey Kong Jr"
	arcade dkongjr
	;;
k)
	out "Kick"
	arcade kick
	;;
l)
	out "Legends v2 by CoinOps"
	legends
	;;
m)
	out "Ms. Pac-Man"
	arcade mspacman
	;;
n)
	out "New Rally-X"
	arcade nrallyx
	;;
o)
	out "Spiders"
	qstart -L mamearcade2016 "$RA/roms/MAME 2016/spiders.zip"
	;;
p)
	out "powering off"
	audio "sounds/hone.mp3" & 
	sleep 1
	sudo chvt 2
	sleep 1
	audio "Shutdown/`ls Music/Shutdown | shuf | head -1`"
	sudo poweroff
	;;
q)
	out "Jumpman"
	qstart -L vice_x64 "$RA/roms/C64/Jumpman (1983)(Epyx).d64"
	;;
r|U)
	if [ "$choice" = "U" ]; then
		out "upgrading ${OFF}. . . possibly."
		reset
		audio "Radio Edit Alpha Team.mp3" &
		sudo apt update && sudo apt -y upgrade
		sudo rpi-eeprom-update -a
		sudo rpi-update
	else
		out "restarting"
		audio "sounds/hone.mp3"
	fi
	sudo chvt 2
	sleep 2
	sudo reboot
	;;
s)
	out "Sea Wolf"
	arcade seawolf mame2010
	;;
t)
	out "Tempest"
	arcade tempest
	;;
u)
	out "Sea Wolf II"
	arcade seawolf2 mame2010
	;;
v)
	out "video arcade"
	video arcade.mpg
	;;
w)
	out "Wizard"
	qstart -L vice_x64 "$RA/roms/C64/wizard.d64"
	;;
x)
	out "MegaMania: a space nightmare"
	qstart -L stella "$RA/roms/Atari 2600/MegaMania - A Space Nightmare (USA).zip"
	;;
y)
	out "Yar's Revenge"
	qstart -L stella "$RA/roms/Atari 2600/Yars' Revenge (USA).zip"
	;;
z)
	out "Mean 18"
	qstart -L prosystem "$RA/roms/Atari 7800/mean18.bin"
	;;
A)
	out "Angband"
	audio "sounds/bravery.mp3"
	reset
	angband
	kill -KILL $PPID `pidof bash`
	;;
B)
	out "Black Tiger"
	arcade blktiger
	;;
C)
	out "Cyberball"
	arcade cyberb2p
	;;
D)
	out "Hack & Slash (ddgame.us)"
	audio "sounds/ddd.mp3"
	reset
	node /usr/games/dankdomain/game/telnet	
	kill -KILL $PPID `pidof bash`
	;;
E)
	out "The Empire Strikes Back"
	arcade esb
	;;
F)
	out "Frogger"
	arcade frogger
	;;
G)
	out "Gyruss"
	arcade gyruss
	;;
H)
	out "Hang-on"
	arcade hangon
	;;
I)
	out "GBA Championship Basketball"
	qstart -L puae "$RA/roms/WHDLoad/GBAChampionshipBasketball_v1.0_2948.lha"
	;;
J)
	out "Jungle King"
	arcade junglek
	;;
K)
	out "Kung-Fu Master"
	arcade kungfum
	;;
L)
	out "play Laser Disc by DAPHNE"
	laserdiscs
	;;
M)
	out "Mario Kart 64"
	qstart -L mupen64plus_next "$RA/roms/Nintendo 64/Mario Kart 64 (USA).zip"
	;;
N)
	out "Super Mario Kart"
	qstart -L bsnes "$RA/roms/Super Nintendo/Super Mario Kart (USA).zip"
	;;
O)
	out "Hardball!"
	qstart -L puae "$RA/roms/WHDLoad/HardBall_v1.0_0490.lha"
	;;
P)
	out "Pitfall II: Lost Caverns"
	qstart -L stella "$RA/roms/Atari 2600/Pitfall II - Lost Caverns (USA).zip"
	;;
Q)
	out "Q*bert"
	arcade qbert
	;;
R)
	[ ${#GAME[@]} -eq 0 ] && GAME=( `shuf -e astrob berzerk bombjack btime centiped clbowl crossbow defender docastle duckhunt galaxian gngt gorf hattrick headon2 kchampvs ladybug mappy minigolf missile mpatrol omegrace pacman polepos popeye qix rallyx ripoff robotron rthunder rushatck spacduel starcas startrek starwars tailg tapper timeplt tron xevious` )
	${GAME[0]}
	anykey 60 && arcade ${GAME[0]}
	unset 'GAME[0]'
	GAME=( ${GAME[@]} )
	;;
S)
	out "Space Invaders"
	arcade invaders
	;;
T)
	out "Trog"
	arcade trog
	;;
V)
	out "10-yard Fight VS"
	arcade vsyard
	;;
W)
	out "WarCraft - Orcs and Humans"
	qstart -L dosbox_pure "$RA/roms/DOS/WarCraft - Orcs and Humans (1994).zip"
	;;
X)
	out "starting ${ON}Light Display Manager${OFF}"
	reset
	sleep 0.5
	sudo chvt 2
	sleep 1.5
	sudo systemctl start lightdm
	sleep 3
	kill -KILL $PPID `pidof bash`
	;;
Y)
	out "Magic Sword"
	arcade mswordu
	;;
Z)
	out "boot into ${DIM}${STARTUP}${OFF} mode"
	reset
	sudo systemctl is-enabled lightdm > /dev/null \
	 && sudo systemctl disable lightdm \
	 || sudo systemctl enable lightdm
	audio "sounds/level.mp3"
	;;
attract)
	pidof lightdm > /dev/null && continue
	if [ $(( $L % 2 )) -eq 0 ]; then
		FILE="Startup/`ls -t Videos/Startup | tail -1`"
		out "\e[Kdemo clip "`basename "${FILE%.*}"`
		touch "Videos/${FILE}"
		video "${FILE}"
	else
		CART=`head -1 $TAGGED`
		if [ -n "${CART}" ]; then
			FILE=$( basename "`echo $CART | awk -F'"' '{print $2}'`" )
	       		out "\e[Kplay `echo $CART | awk -F'/' '{print $4}'`: ${FILE%.*}"
			echo '-v' '--appendconfig="/retroarch/play.cfg|/retroarch/one-shot.cfg"' $CART | xargs -t timeout -s SIGQUIT 30 retroarch &> "/run/user/$UID/attract.log"
			tail +2 $TAGGED | tee $TAGGED &> /dev/null
		else
			reset
			break
		fi
	fi
	let L=$L+1
	;;
pi)
	FILE="Cherry Bomb.mp3"
	out "play ${FILE}"
	audio "${FILE}"
	;;
WOPR)
	out "JOSHUA\e[K"
	reset
	break
	;;
*)
	out -n "???\e[K"
	sleep 0.3
	out -n "\e[u\r"
	continue
	;;
esac

menu

done

sudo lastlog --clear --user $USER
exit

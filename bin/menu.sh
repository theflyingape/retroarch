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
LPAD='\x0eah\x0f   '
RPAD='   \x0eha\x0f'
DOT='\x0e~\x0f'
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

frame() {
	out -n "${LPAD}\e[110C${RPAD}\r"
	out "\e[5C$1"
}

anykey() {
	declare -i sec=$1
	[ $sec -le 0 ] && sec=50
	frame ""
	out -n "${LPAD}Press any button/key to continue: \e[s\e[76C${RPAD}\e[u"
	status=1
	while read ev sym sel cmd; do
		[ "$ev" = "EV_ABS" -o "$ev" = "EV_REL" ] && continue
		[[ "$sym" =~ "REL" ]] && continue
		[ $sel -eq 0 ] && continue
		[ "$cmd" = "command" ] || continue
		[ "$sym" = "KEY_ESC" -o "$sym" = "KEY_F12" ] && break
		status=0
		break
	done < <( timeout -s SIGALRM $sec thd --dump /dev/input/event* ) 
	read -n 255 -t 0.1 mt 2> /dev/null
	out "\e[1K\e[A"
	return $status
}

comp() {
	model=$1
	out -n "$2${OFF}\n\e[J"
	frame "\e[73C${KEY} Num Lock ${OFF} then ${KEY} Delete ${OFF} to quit game"
	frame "\e[74C${KEY}\e[31m Pi ${OFF} logo key to toggle ${ON}STATUS BAR${OFF}"
	lines=2
	if [ "$model" = "VIC" -o "$model" = "C64" ]; then
		out "\e[78C Left ${KEY} Ctrl ${OFF} is ${KEY}\e[34mC\e[31m=${OFF} logo key         ${RPAD}"
		lines=3
	fi
	if [ "$model" = "C64" ]; then
	       	out "\e[77C Right ${KEY} Ctrl ${OFF} swaps joysticks    ${RPAD}"
		lines=4
	fi
	out "\e[${lines}A"
}

pick() {
	out -n "$1${OFF}\n\e[J"
	frame "\e[73C${KEY} Delete ${OFF} or hold ${KEY} Start ${OFF} to quit game"
	frame "\e[73C${KEY} Enter ${OFF} / ${KEY} Start ${OFF} for Player start"
	frame "\e[73C${KEY} Shift ${OFF} / ${KEY} Select ${OFF} to deposit coin"
	out "\e[3A"
}

astrob() {
	pick "Astro Blaster (c) 02/1981 Sega"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} WARP ${OFF}"
	frame 
	frame "NOTE: Fuel is a very precious commodity in this game. If you run out"
	frame "of fuel, your game is over regardless of any star ships remaining."
}

berzerk() {
	pick "Berzerk (c) 10/1980 Stern Electronics"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame
	frame "The first game to feature talking enemies.  The speech synthesis"
	frame "technology of the time being so new that it cost \$1000 to program"
	frame "each individual word into the game's ROM."
	frame "I was able to reuse the ROM words into a compatible format that"
	frame "allowed my VIC 20 conversion, ${DIM}Berzerk MMX${OFF}, to speak using a"
	frame "software technique off its Volume register."
}

berzerk_mmx() {
	comp VIC "Berzerk-MMX (c) Robert Hurst"
	frame "${PAD}${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/16KB/berzerk-mmx-16k.prg"
}

bombjack() {
	pick "Bomb Jack (c) 10/1984 Tehkan"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "Pick up most of the bombs while their fuses are lit to earn"
	frame "maximum points."
}

breakout() {
	comp VIC "Break-out! (c) Robert Hurst"
	frame "Best used with a mouse/trackball."
	anykey && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/break-out!.prg"
}

btime() {
	pick "Burger Time (c) 1982 Data East"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PEPPER ${OFF}"
	frame "${PAD}${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "It's possible to move chef Peter Pepper up & down on the ladders"
	frame "faster using rapid presses, rather than holding the direction."
}

centiped() {
	pick "Centipede (c) 1980 Atari"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD} move"
	frame 
	frame "${PAD}Easier with a mouse/trackball and its button."
	frame 
	frame "The first coin-op game designed by a woman, Dona Bailey."
	frame "Like Pac-Man, this game has special appeal to women."
}

clbowl() {
	pick "Coors Light Bowling (c) 1989 Incredible Technologies"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${LEFT}${KEY} HOOK ${OFF}  ${KEY} HOOK ${OFF}${RIGHT}"
	frame "${PAD}aim/roll"
}

crossbow() {
	pick "Crossbow (c) 10/1983 Exidy"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}  aim"
	frame 
	frame "The first video game to completely use digitized sound and music."
}

defender() {
	pick "Defender (c) 12/1980 Williams"
	frame "${PAD}shoulder  ${KEY} ${UP} ${OFF}  ${KEY} BOMB ${OFF}   ${KEY} WARP ${OFF}"
	frame "${PAD}   ${KEY}${LEFT}${RIGHT}${OFF}      |"
	frame "${PAD}reverse   ${KEY} ${DOWN} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	frame 
	frame "Arcade industry insiders confidently predicted that both Defender"
	frame "and Pac-Man would be commercial flops and that ${DIM}Rally-X${OFF} would be"
	frame "the next major arcade success."
	frame "Along with ${DIM}Pac-Man${OFF}, Defender shares the title of 'Highest Grossing"
	frame "Video Game of All Time' and has earned more than \$1B."
}

docastle() {
	pick "Mr. Do's Castle (c) 09/1983 Universal"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} MALLET ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
}

duckhunt() {
	pick "Duck Hunt (c) 03/1985 Nintendo"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}  aim"
	frame 
	frame "Easier with a mouse/trackball and its button."
}

galaxian() {
	pick "Galaxian (c) 10/1979 Namco"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame 
	frame "The Galaxian Flagship became a trademark and made cameo"
	frame "appearances in other Namco classics. It is also my Gravitar."
}

gngt() {
	pick "Ghosts'n Goblins (c) 09/1985 Capcom"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
}

gorf() {
	pick "GORF (c) 02/1981 Midway"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "Galactic Orbital Robot Force was the first game ever to show"
	frame "multiple scenes. A Star Trek tie in was originally planned by"
	frame "Midway, but when the first movie fell flat, the Enterprise sprite"
	frame "was reused as the Gorf flagship."
	frame 
	frame "'Try again, I devour coins!', 'Ha ha ha ha!', 'Prepare for"
	frame "annihilation!', 'All hail the supreme Gorfian Empire!' and the"
	frame "infamous 'Long Live Gorf!'"
}

hattrick() {
	pick "Hat Trick (c) 1984 Bally Sente"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SHOOT ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "Despite its simple skate, shoot and save gameplay, it was"
	frame "considered one of the better sports games of the early 1980's."
}

headon2() {
	pick "Head On 2 (c) 10/1979 Sega"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FAST ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
}

kchampvs() {
	pick "Karate Champ (c) 09/1984 Data East"
	frame "${PAD} left     right"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} STICK ${OFF}"
	frame "${PAD} move     attack"
	frame 
	frame "The seminal one-on-one fighting game."
}

ladybug() {
	pick "Lady Bug (c) 10/1981 Universal"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "Eat the \e[1;7;34mBLUE\e[m hearts (up to x5) as soon as possible."
}

mappy() {
	pick "Mappy (c) 03/1983 Namco"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} DOOR ${OFF}"
}

minigolf() {
	pick "Mini Golf (c) 11/1985 Bally Sente"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} PLACE ${OFF}"
	frame "${PAD} putt"
	frame 
	frame "PLACE ball on one of the matt's starting position."
	frame "PUTT in the direction & force from an analog device."
}

missile() {
	pick "Missile Command (c) 06/1980 Atari"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} FIRE ${OFF}"
	frame 
	frame "Engineering loved the name ${DIM}Armageddon${OFF}, but from the top came the"
	frame "message, 'We can't use that name, nobody'll know what it means,"
	frame "and nobody can spell it.'"
	frame 
	frame "Easier with a mouse/trackball using ${KEY} A ${OFF} ${KEY} S ${OFF} ${KEY} D ${OFF} missile bases"
}

mpatrol() {
	pick "Moon Patrol (c) 05/1982 Irem"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	frame 
	frame "The first game to feature parallax scrolling."
}

omegrace() {
	pick "Omega Race (c) 06/1981 Midway"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} THRUST ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD} rotate"
	frame 
	frame "Its storyline was my inspiration to write a sequel, Omega Fury."
}

omega_fury() {
	comp VIC "Omega Fury (c) Robert Hurst"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/16KB/omega-fury.prg"
}

pacman() {
	pick "Pac-Man (c) 10/1980 Namco"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "It is still regarded as the hallmark of the 'golden age' of video"
	frame "games."
}

polepos() {
	pick "Pole Position (c) 09/1982 Namco"
	frame "${PAD}shoulder"
	frame "${PAD}${KEY} SHIFT ${OFF}${DOWN}${UP}"
	frame "${PAD}      left"
	frame "${PAD}     ${KEY} STICK ${OFF}  ${KEY} GAS ${OFF}  ${KEY} BRAKE ${OFF}"
	frame "${PAD}      rotate"
	frame 
	frame "Use SHIFT to toggle between LO / HI gear. Check that it's in LO gear"
	frame "before START for quicker acceleration. Shift into HI around 180km."
	frame "Either release GAS or shift into LO to better navigate hairpin turn."
	frame "STICK steering will only slowly re-center itself.  As the Driver,"
	frame "you rotate the wheel back to center without over-correcting."
}

popeye() {
	pick "Popeye (c) 12/1982 Nintendo"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PUNCH ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "Popeye and its cast of characters: Olive Oyl, Bluto, Wimpy,"
	frame "Sweetpea, the Sea Hag and her Vulture."
}

qix() {
	pick "Qix (c) 10/1981 Taito"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SLOW ${OFF}  ${KEY} FAST ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "The author named the game 'QIX' (pronounced 'KICKS' and not"
	frame "'QUIX') because his car tags was 'JUS4QIX'."
}

quikman() {
	comp VIC "Quikman (c) Robert Hurst"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/quikman+8k.prg"

}

rallyx() {
	pick "Rally-X (c) 10/1980 Namco"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SMOKE ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
}

ripoff() {
	pick "Rip Off (c) 04/1980 Cinematronics"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} THRUST ${OFF}  ${KEY} FIRE ${OFF}"
	frame 
	frame "The first two player cooperative video game."
}

robotron() {
	pick "Robotron - 2084 (c) 03/1982 Williams"
	frame "${PAD} left     right"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} STICK ${OFF}"
	frame "${PAD} move     fire"
	frame 
	frame "The design was influenced by Berzerk and the Commodore PET game"
	frame "Chase.  The inspiration for the character Mikey was from the"
	frame "1970's commercial for 'Life' cereal."
}

rthunder() {
	pick "Rolling Thunder (c) 12/1986 Namco"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "It's possible to visit the ammo rooms more than once by ensuring"
	frame "that the door in question is completely off screen, then turn back."
}

rushatck() {
	pick "Rush'n Attack (c) 07/1985 Konami"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} KNIFE ${OFF}  ${KEY} SHOOT ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "You will mainly rely on your trusty knife for this mission."
}

spacduel() {
	pick "Space Duel (c) 02/1982 Atari"
	frame "${PAD}           ${KEY} SHIELD ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}   ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	frame 
	frame "In 2 player mode, you can shoot your partner and it will"
	frame "regenerate their shield."
}

sprite_invaders() {
	comp VIC "Sprite Invaders (c) Robert Hurst"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	anykey && qstart -L vice_xvic "$RA/roms/homebrews/VIC20/8KB/sprite_invaders.prg"
}

starcas() {
	pick "Star Castle (c) 09/1980 Cinematronics"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	frame 
	frame "The original inspiration came from a never-released game,"
	frame "${DIM}Oops!${OFF} in which the player controlled a sperm trying to fertilize"
	frame "an egg in the center of the screen."
}

startrek() {
	pick "Star Trek - Strategic Operations Simulator (c) 1982 Sega"
	frame "${PAD} left    ${KEY} PHOTON ${OFF}  ${KEY} WARP ${OFF}"
	frame "${PAD}${KEY} STICK ${OFF}   ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}"
	frame "${PAD} rotate"
	frame 
	frame "As much as possible to maximize scoring, avoid resupplying at"
	frame "a starbase."
}

starwars() {
	pick "Star Wars (c) 05/1983 Atari"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}  aim"
	frame 
	frame "Best used with a mouse/trackball."
	frame 
	frame "The first Atari game to have speech."
	frame "In the trench you can get extra bonus points by not shooting"
	frame "ANYTHING until 'USE THE FORCE' appears."
}

tailg() {
	pick "Tail Gunner (c) 11/1979 Cinematronics"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} SHIELD ${OFF}"
	frame "${PAD}  aim"
	frame 
	frame "Easier with a mouse and its two buttons."
	frame "Game ends when 10 ships get pass you."
}

tapper() {
	pick "Tapper (Budweiser) (c) 12/1983 Bally Midway"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} POUR ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "Take your time in the first few levels.  You can make a high"
	frame "score by leaving one person and waiting for more people."
}

timeplt() {
	pick "Time Pilot (c) 11/1982 Konami"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "On the second stage, don't shoot anything but the bombers."
	frame "Collect the parachutes while avoiding the planes."
}

tron() {
	pick "Tron (c) 05/1982 Bally Midway"
	frame "${PAD} left     right"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD} move      aim"
	frame 
	frame "The levels were named after programming languages and terminology."
	frame "The game starts out at RPG and advances through PASCAL, BASIC,"
	frame "ASSEMBLER, etc. until the USER level is reached."
	frame "Don't forget to twirl the knob as you rise into the MCP CONE."
}

xevious() {
	pick "Xevious (c) 12/1982 Namco"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} BOMB ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "The world's first vertically scrolling shoot-em-up."
	frame "You can hold down the fire and bomb buttons to constantly do"
	frame "both at a slower rate."
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
	setterm --background ${BG[$i]} --foreground ${FG[$i]} --hbcolor bright yellow --store --clear=rest
	out "${LPAD}                                                                                                              ${RPAD}"
}

floppy() {
	setterm --background green --foreground white --hbcolor bright yellow --store --clear=rest
	frame 
	frame "${DIM}COMMODORE${OFF}: press ${KEY}\e[31m Pi ${OFF} logo key to toggle ${ON}STATUS BAR${OFF}"
	frame "Use Left ${KEY} Ctrl ${OFF} as ${KEY}\e[34mC\e[31m=${OFF} logo key and Right ${KEY} Ctrl ${OFF} to swap Joysticks 1/2"
	frame 
	frame "${DIM}C64 HOME${OFF} games use multiple floppy diskettes to play!"
	frame 
	frame "Use ${KEY} Num Lock ${OFF} to toggle ${ON}GAME FOCUS\e[35m OFF${OFF} for floppy ${ON}DRIVE${OFF} controls:"
	frame "${PAD}${PAD}${KEY} \ ${OFF} to toggle ${ON}EJECT${OFF}/${ON}INSERT${OFF} current disk"
	frame "${PAD}${PAD}${KEY} [ ${OFF} swap to ${ON}PREVIOUS${OFF} disk"
	frame "${PAD}${PAD}${KEY} ] ${OFF} swap to ${ON}NEXT${OFF} disk"
	frame "Toggle ${ON}GAME FOCUS\e[32m ON${OFF} when needed for ${DIM}COMPUTER${OFF} keyboard control"
	anykey 90
}

laserdiscs() {
	DISCS=( "" 1 2 3 4 5 6 )
	LABEL=( "" "Astron Belt" "Cliff Hanger" "Dragon's Lair" "Dragon's Lair II: Time Warp" "Space Ace" "Super Don Quixote" )
	ROM=( "" "astron" "cliff" "dle21" "lair2" "sae" "sdq" )
	INFO=( "" "You fly through the universe battling alien ships to make your way to fight the main\n${LPAD}Alien Battle Cruiser. Along the way, you fly across alien planets, through tunnels,\n${LPAD}through trenches, and get involved in a few astro-dogfights with enemy space fighters." "Cliff is on a mission to save Clarissa from being forced to marry the evil Count Draco.\n${LPAD}The game consists of animated scenes, during which the player has to press direction buttons\n${LPAD}or the sword button in the right moment to trigger the next segment of the movie.\n${LPAD}The anime video used in the game are scenes from the Lupin III anime movies, mainly scenes\n${LPAD}from The Castle of Cagliostro and the Mystery of Mamo animated movies." "Originally released in the arcades as a laserdisc game, Dragon's Lair is an interactive\n${LPAD}cartoon movie. Players control Dirk the Daring as he struggles his way through a dungeon\n${LPAD}to fight Singe, the Dragon, and rescue the beautiful Princess Daphne.\n${LPAD}The game consists of animated scenes, during which the player has to press direction buttons\n${LPAD}or the sword button in the right moment to trigger the next segment of the movie." "Princess Daphne has been spirited away to a wrinkle in time by the Evil Wizard Mordroc\n${LPAD}who plans to force her into marriage. Only you, Dirk the Daring, can save her.\n${LPAD}Transported by a bumbling old time machine, you begin the rescue mission.\n${LPAD}But you must hurry, for once the Casket of Doom has opened, Mordroc will place the\n${LPAD}Death Ring upon Daphne's finger in marriage and she will be lost forever in the\n${LPAD}Time Warp!" "Space Ace was unveiled in October 1983, just four months after the Dragon's Lair game,\n${LPAD}then released in Spring 1984, and like its predecessor featured film-quality\n${LPAD}animation played back from a laserdisc." "The idea for this game comes from the stories about Don Quixote, the legendary Spanish knight.\n${LPAD}In this game, the character looks very young and does not have a mustache. Also, he has a\n${LPAD}sword for a weapon and his faithful sidekick Sancho Panza follows him around although\n${LPAD}he does nothing (like Jon) to assist the hero (Randy).\n${LPAD}An assortment of mythical creatures including demons, dragons, skeletons and so on\n${LPAD}are encountered throughout the game.\n${LPAD}The game ends when Don Quixote kills the evil witch and rescues Isabella.")
	i=0
	disc=

	setterm --background black --foreground cyan --hbcolor bright yellow --store --clear=rest
	frame 
	frame "${DOT}${DIM}1${OFF}  Astron Belt"
	frame "${DOT}${DIM}2${OFF}  Cliff Hanger"
	frame "${DOT}${DIM}3${OFF}  Dragon's Lair (extended)"
	frame "${DOT}${DIM}4${OFF}  Dragon's Lair II: Time Warp"
	frame "${DOT}${DIM}5${OFF}  Space Ace"
	frame "${DOT}${DIM}6${OFF}  Super Don Quixote"
	frame
	frame
	out -n "\e[A\e[5C${ON}Disc ${DOWN}${UP}${OFF}: \e[s${DIM}"

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
			break
			;;
		BTN_DPAD_UP|BTN_TL|KEY_UP)
			[ $i -gt 0 ] || let i=${#DISCS[@]}
			let i=$i-1
			;;
		KEY_ESC|KEY_F12)
			let i=0
			disc=
			break
			;;
		KEY_[1-6])
			let i=${sym:(-1)}
			;;
		*)
			let i=0
			;;
		esac
		disc="${ROM[$i]}"
		[ $i -gt 0 ] && out -n "\e[u${i} ${OFF}${RIGHT}${ON} ${LABEL[$i]}"
		out -n "${PAD}${PAD}${PAD}${PAD}${PAD}\e[u"
	done < <( timeout -s SIGALRM 40 thd --dump /dev/input/event* )

	out 
	if [ -n "${disc}" ]; then 
		setterm --background cyan --foreground black --hbcolor bright white --store --clear=rest
		frame 
		frame "${INFO[$i]}"
		frame 
		frame "${KEY} 5 ${OFF} / ${KEY} 6 ${OFF} insert enough COIN(s) to START"
		frame "${KEY} 1 ${OFF} / ${KEY} 2 ${OFF} for player(s) START respectively"
		frame "${KEY} ESC ${OFF} to QUIT the game"
		anykey 90 && ~/Daphne/daphne.sh "${RA}/roms/Daphne/${disc}.daphne" &> /dev/null
	fi
}

legends() {
	setterm --background green --foreground white --hbcolor bright yellow --store --clear=rest
	frame
	frame "${KEY} LEFT ${OFF} / ${KEY} RIGHT ${OFF} toggles filter between ${DIM}ALL GAMES${OFF} and ${DIM}FAVORITES${OFF}"
	frame "${KEY} SELECT ${OFF} playlist filter and ${KEY} START ${OFF} toggles the title as a favorite"
	frame "Shoulder ${KEY} BUMPERS ${OFF} jump thru titles by letter"
	anykey || return
	reset
	ln -sf "${RETROFE_PATH}/emulators/retroarch" ~/.config/ ; sync
	trap "exit" 1 3 15
	~/ARCADE/retrofe.sh &> /dev/null
}

menu() {
	sudo systemctl is-enabled lightdm > /dev/null \
	 && STARTUP="CONSOLE" || STARTUP="DESKTOP"
	crt
	frame "\e[28C*=*=*=*=*=*=*[ ${ON}RetroArch Playlist Menu${OFF} ]*=*=*=*=*=*=*"
	frame 
	frame "${DOT}${DIM}0${OFF}  Big Menu  12,200    ${DOT}${DIM}5${OFF}  Break-Out!       (mouse)    ${DOT}${DIM}a${OFF}  Asteroids      (1/2P)    ${DOT}${DIM}A${OFF}  Angband          (1P)"
	frame "${DOT}${DIM}1${OFF}  Arcade     2,600    ${DOT}${DIM}6${OFF}  Sprite Invaders   (1/2P)    ${DOT}${DIM}b${OFF}  Bubble Bobble  (1/2P)    ${DOT}${DIM}C${OFF}  Cyberball      (1/2P)"
	frame "${DOT}${DIM}2${OFF}  Computers  2,600    ${DOT}${DIM}7${OFF}  Berzerk MMX         (1P)    ${DOT}${DIM}c${OFF}  Carnival       (1/2P)    ${DOT}${DIM}D${OFF}  Dank Domain      (1P)"
	frame "${DOT}${DIM}3${OFF}  Consoles   4,300    ${DOT}${DIM}8${OFF}  Omega Fury          (1P)    ${DOT}${DIM}d${OFF}  Mr. Do!        (1/2P)    ${DOT}${DIM}F${OFF}  Frogger        (1/2P)"
	frame "${DOT}${DIM}4${OFF}  Handhelds  2,700    ${DOT}${DIM}9${OFF}  Quikman+          (1/2P)    ${DOT}${DIM}g${OFF}  Galaga         (1/2P)    ${DOT}${DIM}G${OFF}  Gyruss         (1/2P)"
	frame "${DOT}${DIM}l${OFF}  Legends      471    ${DOT}${DIM}L${OFF}  Laser Disc games            ${DOT}${DIM}j${OFF}  Donkey Kong Jr (1/2P)    ${DOT}${DIM}K${OFF}  Kung-Fu Master (1/2P)"
	frame "                                                        ${DOT}${DIM}m${OFF}  Ms. Pac-Man    (1/2P)    ${DOT}${DIM}Q${OFF}  Q*bert         (1/2P)"
	frame "${DOT}${DIM}p${OFF}  power-off Pi        ${DOT}${DIM}U${OFF}  upgrade Pi                  ${DOT}${DIM}q${OFF}  Jumpman        (1/4P)    ${DOT}${DIM}S${OFF}  Space Invaders (1/2P)"
	frame "${DOT}${DIM}r${OFF}  restart Pi          ${DOT}${DIM}Z${OFF}  toggle startup ${ON}${STARTUP}${OFF}      ${DOT}${DIM}s${OFF}  Sea Wolf      (mouse)    ${DOT}${DIM}T${OFF}  Trog           (1/4P)"
	frame "                                                        ${DOT}${DIM}t${OFF}  Tempest       (mouse)    ${DOT}${DIM}V${OFF}  10-yard Fight  (1/2P)"
}

prompt() {
	sub=$1
	val=$2
	export ${val}="${CHOICE[${!sub}]}"

	out -n "\e[u${!val} ${OFF}${RIGHT}${ON} ${MENU[${!sub}]} ${OFF} ${PAD}${PAD}\e[u"

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
			out -n "\e[u${!val} ${OFF}${RIGHT}${ON} ${PAD}${PAD}${PAD}${PAD}\e[20D"
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
			out -n "\e[u${KEY}\e[31m Pi ${OFF} -${ON} ${PAD}${PAD}${PAD}${PAD}\e[20D"
			export ${val}="pi"
			return
			;;
		*KEY_?)
			export ${val}=${sym:(-1)}
			[[ $sym =~ [+]KEY_? ]] || export ${val}=`echo ${sym:(-1)} | tr [:upper:] [:lower:]`
			out -n "\e[u${!val} ${OFF}${RIGHT}${ON} ${PAD}${PAD}${PAD}${PAD}\e[20D"
			return
			;;
		esac
		export ${val}="${CHOICE[${!sub}]}"
		out -n "\e[u${!val} ${OFF}${RIGHT}${ON} ${MENU[${!sub}]} ${PAD}${PAD}${PAD}${PAD}\e[u"
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
	sleep 0.5
	retroarch "$@" &> /dev/null && return 0 || return 1
}

qstart() {
	play --appendconfig="$RA/play.cfg|$RA/one-shot.cfg" "$@"
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
out -n "\e[13;${LINES}r\e[12B"
menu
pidof lightdm > /dev/null || sudo chvt 1

CHOICE=( "" "R" 0 1 2 3 4 "l" "p" "r" "X" )
MENU=( "" "Rob's quick-pick" "Party time!" "Arcade emporium" "Computer craze" "Console mania" "Handheld hero" "Legends made here" "power-off" "restart" "Linux desktop")
n=1
choice=

while [ true ]; do

out
frame "${OFF}\e[89C${KEY}\x0eah\x0f `date +'%a %I:%M%P'` \x0eha\x0f${OFF}\e[2A"
frame "${ON}Choose ${DOWN}${UP}${OFF} (${DIM}X${OFF}=exit): ${DIM}\e[s"
prompt n choice

case $choice in
0)
	out "\e[1;31mRed Bull${OFF} and ${DIM}Doritos${OFF} -- time to play!"
	play
	;;
1)
	out "Off to the arcade -- bring quarters!"
	play --appendconfig="$RA/play.cfg|$RA/myarcade.cfg"
	;;
2)
	out "Happy keyboard hacking!"
	if floppy ; then
		ln -fs "Computers.png" "$RA/assets/wallpapers/Main Menu.png"
		play --appendconfig="$RA/play.cfg|$RA/computers.cfg"
		ln -fs "Main.png" "$RA/assets/wallpapers/Main Menu.png"
	fi
	;;
3)
	out "Pull something good off the shelf"
	play --appendconfig="$RA/play.cfg|$RA/consoles.cfg"
	;;
4)
	out "Into the magic screen"
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
	pick "Asteroids (c) 11/1979 Atari"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} THRUST ${OFF}  ${KEY} WARP ${OFF}"
	frame 
	frame "Originally called Cosmos, Asteroids original design brief was a simple"
	frame "copy of Space Wars; with asteroids littering the playfield purely for"
	frame "visual effect. Two years later, Atari introduced the concept of"
	frame "free-floating rocks."
	frame "On 17 June 1980, Atari's Asteroids and Lunar Lander were the first two"
	frame "video games to ever be registered in the Copyright Office."
	anykey && arcade asteroid
	;;
b)
	pick "Bubble Bobble (c) 08/1986 Taito"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} BUBBLE ${OFF}  ${KEY} JUMP ${OFF}"
	frame 
	frame "Simple-yet-involving gameplay with its two-player co-operative mode,"
	frame "coupled with the incredible amount of hidden secrets and potential"
	frame "for strategic play."
	frame "'The Trick!' is matching the 100s & 10s digit after popping the last monster."
	anykey && arcade bublbobl
	;;
c)
	pick "Carnival (c) 06/1980 Sega"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame 
	frame "The official record for this game is 386,750 points on June 3, 2001."
	anykey && arcade carnival
	;;
d)
	pick "Mr. Do! (c) 1983 Universal"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} BALL ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "It's possible to win 255 lives on the first screen, but only if an"
	frame "apple appears in the top two rows of the playfield."
	anykey && arcade mrdo
	;;
e)
	pick "Elevator Action (c) 07/1983 Taito"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "There is an internal time limit on how long you can take to get"
	frame "everything out of the building. If you take too much time, an alarm"
	frame "sounds to really make your life miserable."
	anykey && arcade elevator
	;;
f)
	pick "Gridiron Fight (c) 03/1985 Tehkan"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} ACTION ${OFF}"
	frame "${PAD}  run"
	anykey && qstart -L mamearcade2016 "$RA/roms/MAME 2016/gridiron.zip"
	;;
g)
	pick "Galaga (c) 09/1981 Namco"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	frame 
	frame "It is possible to end the game with a 200% ratio. The 200% hit-miss"
	frame "ratio trick can only be done with your first shot of the game."
	frame "When the game starts, don't move, and fire only one shot. If you time"
	frame "it correctly, two enemies will be killed at once."
	frame "Let your remaining ships be destroyed -- perfect, eh?"
	anykey && arcade galaga
	;;
h)
	pick "Satan's Hollow (c) 1981 Bally Midway"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}  ${KEY} SHIELD ${OFF}"
	frame 
	frame "Destroy the swarming gargoyles and win bridge pieces one-by-one."
	frame "Build the bridge and cross into the valley to battle Satan himself."
	anykey && arcade shollow
	;;
i)
	pick "Extra Inning (c) 03/1978 Midway"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} ACTION ${OFF}"
	anykey && arcade einnings
	;;
j)
	pick "Donkey Kong Jr. (c) 08/1982 Nintendo"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "The only Mario game in which he is cast as the villain."
	anykey && arcade dkongjr
	;;
k)
	pick "Kick Man (c) 12/1981 Midway"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} KICK ${OFF}"
	frame "${PAD} move"
	frame 
	frame "The game was first developed back in 1978 as a black and white game"
	frame "called 'Catch 40'."
	anykey && arcade kick
	;;
l)
	out "Legends v2 by CoinOps"
	sleep 0.5
	legends
	;;
m)
	pick "Ms. Pac-Man (c) 1981 Midway"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "In its initial run 110,000 units were produced in the U.S. making it"
	frame "the best selling domestic arcade video game of all time."
	anykey && arcade mspacman
	;;
n)
	pick "New Rally-X (c) 02/1981 Namco"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SMOKE ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "The sequel has slightly different graphics to the original game,"
	frame "and has more forgiving gameplay."
	anykey && arcade nrallyx
	;;
o)
	pick "Spiders (c) 07/1981 Sigma Enterprises"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	anykey && qstart -L mamearcade2016 "$RA/roms/MAME 2016/spiders.zip"
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
	comp C64 "Jumpman"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "If you like this game, try ${DIM}Jumpman Junior${OFF} and ${DIM}Wizard${OFF}"
	frame "off ${DOT}${DIM}2${OFF} Computers ${RIGHT} ${ON}Favorites${OFF} playlist."
	anykey && qstart -L vice_x64sc "$RA/roms/C64/Jumpman (1983)(Epyx).d64"
	;;
r|U)
	if [ "$choice" = "U" ]; then
		out "upgrading ${OFF}. . . possibly."
		reset
		audio "Radio Edit Alpha Team.mp3" &
		sudo apt list --upgradable && sudo apt -y upgrade
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
	pick "Sea Wolf (c) 03/1976 Midway"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD} scope"
	frame 
	frame "Sea Wolf has one of the all-time great cabinets (10,000 units made)."
	anykey && arcade seawolf mame2010
	;;
t)
	pick "Tempest (c) 10/1981 Atari"
	frame "Best used with a mouse/trackball."
	anykey && arcade tempest
	;;
u)
	pick "Sea Wolf II (c) 06/1978 Midway"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD} scope"
	frame 
	frame "Sea Wolf II is the first-ever sequel and probably represents the very"
	frame "first 'modern' video game."
	anykey && arcade seawolf2 mame2010
	;;
v)
	out "video arcade"
	video arcade.mpg
	;;
w)
	comp C64 "Wizard"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	frame "A more sophisticated ${DIM}Jumpman${OFF} game."
	anykey && qstart -L vice_x64sc "$RA/roms/C64/wizard.d64"
	;;
x)
	pick "MegaMania: a space nightmare"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	anykey && qstart -L stella "$RA/roms/Atari 2600/MegaMania - A Space Nightmare (USA).zip"
	;;
y)
	pick "Yar's Revenge"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} CANNON ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L stella "$RA/roms/Atari 2600/Yars' Revenge (USA).zip"
	;;
z)
	pick "Mean 18"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} SWING ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L prosystem "$RA/roms/Atari 7800/mean18.bin"
	;;
A)
	out "Angband"
	audio "sounds/bravery.mp3"
	reset
	angband
	kill -KILL $PPID `pidof bash`
	;;
B)
	pick "Black Tiger (c) 08/1987 Capcom"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} HIT ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade blktiger
	;;
C)
	pick "Cyberball - Football in the 21st Century (c) 09/1988 Atari Games"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PASS ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade cyberb2p
	;;
D)
	out "Dank Domain: the return of Hack & Slash (c) Robert Hurst"
	audio "sounds/ddd.mp3"
	reset
	node /usr/games/dankdomain/game/telnet	
	kill -KILL $PPID `pidof bash`
	;;
E)
	pick "The Empire Strikes Back (c) 03/1985 Atari Games"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD}  aim"
	frame 
	frame "Best used with a mouse/trackball."
	anykey && arcade esb
	;;
F)
	pick "Frogger (c) 06/1981 Konami"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	frame 
	anykey && arcade frogger
	;;
G)
	pick "Gyruss (c) 03/1983 Konami"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} FIRE ${OFF}"
	frame "${PAD} rotate"
	anykey && arcade gyruss
	;;
H)
	pick "Hang-on (c) 07/1985 Sega"
	frame "${PAD} left"
	frame "${PAD}${KEY} STICK ${OFF}  ${KEY} GAS ${OFF}"
	frame "${PAD} turn"
	anykey && arcade hangon
	;;
I)
	comp AMIGA "GBA Championship Basketball"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PASS ${OFF} or hold to JUMP/SHOOT"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L puae "$RA/roms/WHDLoad/GBAChampionshipBasketball_v1.0_2948.lha"
	;;
J)
	pick "Jungle King (c) 08/1982 Taito"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF} or KNIFE"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade junglek
	;;
K)
	pick "Kung-Fu Master (c) 12/1984 Irem"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PUNCH ${OFF}  ${KEY} KICK ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade kungfum
	;;
L)
	out "play Laser Disc by DAPHNE"
	laserdiscs
	;;
M)
	pick "Mario Kart 64"
	anykey && qstart -L mupen64plus_next "$RA/roms/Nintendo 64/Mario Kart 64 (USA).zip"
	;;
N)
	pick "Super Mario Kart"
	anykey && qstart -L bsnes "$RA/roms/Super Nintendo/Super Mario Kart (USA).zip"
	;;
O)
	comp AMIGA "Hardball!"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} ACTION ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L puae "$RA/roms/WHDLoad/HardBall_v1.0_0490.lha"
	;;
P)
	pick "Pitfall II: Lost Caverns"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} JUMP ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && qstart -L stella "$RA/roms/Atari 2600/Pitfall II - Lost Caverns (USA).zip"
	;;
Q)
	pick "Q*bert (c) 10/1982 Gottlieb"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade qbert
	;;
R)
	[ ${#GAME[@]} -eq 0 ] && GAME=( `shuf -e astrob berzerk bombjack btime centiped clbowl crossbow defender docastle duckhunt galaxian gngt gorf hattrick headon2 kchampvs ladybug mappy minigolf missile mpatrol omegrace pacman polepos popeye qix rallyx ripoff robotron rthunder rushatck spacduel starcas startrek starwars tailg tapper timeplt tron xevious` )
	${GAME[0]}
	anykey && arcade ${GAME[0]}
	unset 'GAME[0]'
	GAME=( ${GAME[@]} )
	;;
S)
	pick "Space Invaders (c) 07/1978 Taito"
	frame "${PAD}${KEY} ${LEFT} ${OFF} - ${KEY} ${RIGHT} ${OFF}  ${KEY} FIRE ${OFF}"
	anykey && arcade invaders
	;;
T)
	pick "Trog (c) 02/1991 Midway"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} PUNCH ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade trog
	;;
V)
	pick "10-yard Fight VS (c) 1983 Irem"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} RUN ${OFF}  ${KEY} PASS ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade vsyard
	;;
W)
	pick "WarCraft - Orcs and Humans"
	anykey && qstart -L dosbox_pure "$RA/roms/DOS/WarCraft - Orcs and Humans (1994).zip"
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
	pick "Magic Sword - Heroic Fantasy (c) 06/1990 Capcom"
	frame "${PAD}   ${KEY} ${UP} ${OFF}"
	frame "${PAD}${KEY} ${LEFT} ${OFF} + ${KEY} ${RIGHT} ${OFF}  ${KEY} FIGHT ${OFF}  ${KEY} MAGIC ${OFF}"
	frame "${PAD}   ${KEY} ${DOWN} ${OFF}"
	anykey && arcade mswordu
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
		out "Legends demo clip:${OFF} "`basename "${FILE%.*}"` $PAD
		sleep 0.5
		touch "Videos/${FILE}"
		video "${FILE}"
	else
		CART=`head -1 $TAGGED`
		if [ -n "${CART}" ]; then
			FILE=$( basename "`echo $CART | awk -F'"' '{print $2}'`" )
	       		out "play `echo $CART | awk -F'/' '{print $4}'`:${OFF} ${FILE%.*}" $PAD
			sleep 0.5
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
	out "JOSHUA ${PAD} ${PAD} ${PAD}"
	reset
	break
	;;
*)
	out -n "${ON}?${OFF}?${DIM}? ${PAD} ${PAD} ${PAD}"
	sleep 0.3
	out -n "\e[u\r"
	continue
	;;
esac

menu

done

sudo lastlog --clear --user $USER
exit

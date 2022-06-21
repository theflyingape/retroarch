#!/bin/sh
#
# My compile script for RetroArch targeted for Debian Bullseye arm64,
# but running off a Pi 4 launched from Mutter (vk_x context) desktop 
# To launch from a framebuffer (khr context) cli, VC comes only as armhf
#
cd ~

V="$1"

if [ -z "$V" ]; then
	# toolchain add-ons
	sudo apt install build-essential bison check code flex git mesa-utils ninja-build python3-mako \
		valgrind vim
	# toolchain libraries
	sudo apt install libasound2-dev libassimp-dev libavcodec-dev libavdevice-dev libavformat-dev \
		libavresample-dev libclc-dev libdrm* libelf-dev libflac-dev libfreetype6-dev libgbm-dev \
		libgbm1 libgnutls28-dev libmbedtls*-dev libmpv* libopenal-dev libroar-dev libsixel-dev \
		libssl-dev libswresample-dev libswscale-dev libsystemd-dev libudev-dev libunwind-dev \
		libusb-1.0-0-dev libv4l-dev libva-dev libxml2-dev libzstd-dev qtbase5-dev vc-dev yasm \
		zlib1g-dev
	# SDL
	sudo apt install glslang-dev glslang-tools mesa-vulkan-drivers spirv-tools libsdl-image1.2-dev \
		libsdl2-dev libvkd3d-dev libvulkan-dev vulkan-validationlayers-dev
	# X11
	sudo apt install libffi-dev libpciaccess-dev libpthread-stubs0-dev libx11-dev libx11-xcb-dev \
		libxcb*-dev libxcursor-dev libxdamage-dev libxext-dev libxfixes-dev libxkbcommon-dev \
		libxinerama-dev libxrandr-dev libxshmfence-dev libxxf86vm-dev x11proto-dri2-dev \
		x11proto-present-dev x11proto-randr-dev x11proto-xext-dev xutils-dev
	# OpenGL
	sudo apt install libegl-dev libegl-mesa0 libegl1 libegl1-mesa libegl1-mesa-dev \
		libgles2 libgles2-mesa libgles2-mesa-dev
	# Vulkan
	sudo apt install libvulkan-dev libvulkan1 vulkan-tools
	# Wayland
	sudo apt install libwayland-dev libwayland-egl-backend-dev wayland-protocols
	# needed for Daphne 32-bit build
	sudo apt install libglew2.1:armhf libsdl1.2debian:armhf libvorbisfile3:armhf
	# needed toys
	sudo apt install 7kaa* angband barrage basic256 bsdgames btanks empire extremetuxracer fbi \
		fonts-noto-color-emoji fs-uae gl-117* gnubg gpm iagno linuxlogo mame moria mpc mpd mplayer-gui mpv \
		nestopia neverball neverputt nodejs npm pysol* socat steam-devices stella timidity \
		vice widelands wordwarvi*

	sudo apt upgrade
	sudo rpi-eeprom-update -a
	sudo rpi-update

	vulkaninfo | grep Info || exit

	echo "pass 'git' or release version parameter as numeric major.minor.release to build/install"
	exit
fi

if [ "${V}" = "git" ]; then
	[ -d src ] || mkdir src
	cd src
	[ -d RetroArch ] || git clone https://github.com/libretro/RetroArch
	cd RetroArch
	git pull
else
	if [ ! -d RetroArch-${V} ]; then
		curl -LO "https://github.com/libretro/RetroArch/archive/v${V}.tar.gz"
		tar xzvf v${V}.tar.gz
		rm -fv v${V}.tar.gz
	fi
	cd RetroArch-${V}
fi

echo -n "Rebuild RetroArch? "
read yn

if [ "$yn" = "y" ]; then

# for videocore 32-bit build?
#PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/vc/lib/pkgconfig/" \
# build for Pi 400 / 4B running Bullseye
CFLAGS='-O2 -march=armv8-a -mcpu=cortex-a72 -mtune=cortex-a72' \
CXXFLAGS="${CFLAGS}" \
./configure \
	--disable-floathard --disable-neon --disable-rewind \
	--disable-caca --disable-cheats --disable-cheevos --disable-langextra \
	--disable-crtswitchres --disable-parport --disable-wifi --disable-winrawinput \
	--disable-opengl1 --disable-opengl --disable-sdl \
	--disable-vg --disable-videocore --disable-wayland --disable-xvideo \
	--disable-jack --disable-mpv --disable-oss --disable-tinyalsa \
	--enable-libusb --enable-qt --enable-ssl --enable-threads --enable-udev --enable-zlib \
	--enable-kms --enable-egl --enable-opengl_core --enable-x11 --enable-xshm \
	--enable-opengles --enable-opengles3 --enable-opengles3_1 --enable-opengles3_2 \
	--enable-vulkan --enable-vulkan_display \
	--enable-alsa --enable-ffmpeg --enable-pulse --enable-sdl2 \
|| exit
make -j4

sudo make install

fi


# https://github.com/libretro/stella
echo -n "Rebuild Stella core? "
read yn

if [ "$yn" = "y" ]; then
	[ -d ~/src ] || mkdir ~/src
	cd ~/src
	[ -d stella ] || git clone https://github.com/libretro/stella
	cd stella
	make
	cp -pv stella_libretro.so /retroarch/cores/
fi


# https://github.com/libretro/vice-libretro
echo -n "Rebuild VICE core? "
read yn

if [ "$yn" = "y" ]; then
	[ -d ~/src ] || mkdir ~/src
	cd ~/src
	[ -d vice-libretro ] || git clone https://github.com/libretro/vice-libretro
	cd vice-libretro
	git pull

	for type in x128 x64 x64sc xpet xplus4 xvic; do
		make clean
		make -j4 EMUTYPE=${type}
		cp -pv vice_${type}_libretro.so /retroarch/cores/
	done
fi


# https://github.com/libretro/mame2003-plus-libretro
echo -n "Rebuild MAME 2003-plus core? "
read yn

if [ "$yn" = "y" ]; then
	[ -d ~/src ] || mkdir ~/src
	cd ~/src
	[ -d mame2003-plus-libretro ] || git clone https://github.com/libretro/mame2003-plus-libretro
	cd mame2003-plus-libretro
	git pull
	make -j4
	cp -pv mame2003_plus_libretro.so /retroarch/cores/
fi


# https://github.com/libretro/same_cdi
echo -n "Rebuild SAME CDi core? "
read yn

if [ "$yn" = "y" ]; then
	[ -d ~/src ] || mkdir ~/src
	cd ~/src
	[ -d same_cdi ] || git clone https://github.com/libretro/same_cdi
	cd same_cdi
	git pull
	make -j4 -f Makefile.libretro
	cp -pv same_cdi_libretro.so /retroarch/cores/
fi


echo -n "Press RETURN to continue with libRetro Super: "
read cont

[ -d ~/src ] || mkdir ~/src
cd ~/src
[ -d libretro-super ] || git clone git://github.com/libretro/libretro-super.git
cd libretro-super
git pull
SHALLOW_CLONE=1 ./libretro-fetch.sh retroarch
make -j4

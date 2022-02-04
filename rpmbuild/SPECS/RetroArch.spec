Name:           RetroArch
Version:        1.10.0
Release:        1%{?dist}
Summary:        Cross-platform, sophisticated frontend for the libretro API. Licensed GPLv3

License:        GPLv3
URL:            http://www.libretro.com/
Source0:        https://github.com/libretro/%{name}/archive/RetroArch-%{version}.tar.gz

BuildRequires:	ffmpeg-devel
BuildRequires:	freetype-devel
BuildRequires:  libgudev-devel
#BuildRequires:	libXinerama-devel
BuildRequires:	libusb-devel
BuildRequires:	libv4l-devel
#BuildRequires:	libxkbcommon-devel
BuildRequires:	libxml2-devel
BuildRequires:	mesa-libEGL-devel
BuildRequires:	mesa-libgbm-devel
BuildRequires:	openal-soft-devel
BuildRequires:	perl-Net-DBus
#BuildRequires:	perl-X11-Protocol
BuildRequires:	pulseaudio-libs-devel
BuildRequires:  SDL-devel
BuildRequires:  SDL2-devel
BuildRequires:	vulkan-devel
BuildRequires:	zlib-devel

Requires:       alsa-lib
Requires:       bzip2-libs
Requires:       freetype
#Requires:       libX11
#Requires:       libXau
#Requires:       libXext
#Requires:       libXxf86vm
Requires:       libglvnd-egl
Requires:       libglvnd-glx
Requires:       libpng
#Requires:       libxcb
Requires:       pulseaudio-libs
Requires:       SDL2
Requires:       vulkan
Requires:       zlib

%description
RetroArch is the reference frontend for the libretro API. Popular examples of implementations for this API includes videogame system emulators and game engines, but also more generalized 3D programs. These programs are instantiated as dynamic libraries. We refer to these as "libretro cores".

%global debug_package %{nil}

%prep
%autosetup

%build
./configure --disable-x11 --disable-xrandr --disable-xinerama --enable-wayland --enable-lua --enable-pulse --enable-udev --enable-vulkan --prefix=/usr
%make_build

%install
rm -rf %{buildroot}
%make_install

%files
%license COPYING
%doc CHANGES.md CONTRIBUTING.md README.md README-exynos.md README-OMAP.md README-mali_fbdev_r4p0.md
%{_bindir}/retroarch
%{_bindir}/retroarch-cg2glsl
%{_datadir}/applications/retroarch.desktop
%{_datadir}/pixmaps/retroarch.svg
%{_datadir}/metainfo/com.libretro.RetroArch.appdata.xml
%{_docdir}/retroarch/COPYING
%{_docdir}/retroarch/README.md
%{_mandir}/man6/retroarch-cg2glsl.6.gz
%{_mandir}/man6/retroarch.6.gz
%{_sysconfdir}/retroarch.cfg

%changelog
* Tue Jan 25 2022 theflyingape
- forked from Fedora Copr: https://copr.fedorainfracloud.org/coprs/spoonsauce/RetroArch/
- Update to RetroArch 1.10.0
- suppress X11 build with dependencies allowing for udev controllers

* Mon Nov 8 2021 spoonsauce
- Update to RetroArch 1.9.13

* Fri Oct 29 2021 spoonsauce
- Update to RetroArch 1.9.12
- Add Fedora 35 support
- Remove Fedora 33 support

* Fri Oct 1 2021 spoonsauce
- Update to RetroArch 1.9.10

* Wed Jul 28 2021 spoonsauce
- Update to RetroArch 1.9.7

* Sun Jun 27 2021 spoonsauce
- Update to RetroArch 1.9.6

* Thu Jun 17 2021 spoonsauce
- Update to RetroArch 1.9.5

* Mon Jun 7 2021 spoonsauce
- Update to RetroArch 1.9.4

* Mon May 17 2021 spoonsauce
- Update to RetroArch 1.9.3

* Sat May 1 2021 spoonsauce
- Update to RetroArch 1.9.2
- Add Fedora 34 support
- Remove Fedora 32 support

* Tue Dec 8 2020 spoonsauce
- Add Fedora 33 support

* Thu Aug 13 2020 spoonsauce
- Update to RetroArch 1.9.0

* Fri Jul 10 2020 spoonsauce
- Update to RetroArch 1.8.9

* Wed Jun 10 2020 spoonsauce
- Update to RetroArch 1.8.8

* Sun May 17 2020 spoonsauce
- Update to RetroArch 1.8.7

* Wed Apr 29 2020 spoonsauce
- Add Fedora 32 support
- Remove Fedora 30 support

* Fri Mar 27 2020 spoonsauce
- Update to RetroArch 1.8.5

* Thu Jan 16 2020 spoonsauce
- Update to RetroArch 1.8.4

* Fri Jan 10 2020 spoonsauce
- Update to RetroArch 1.8.3

* Thu Jan 9 2020 spoonsauce
- Update to RetroArch 1.8.2
- Remove Fedora 29 support (i386 and x86_64)
- Remove Fedora 30 support (i386 only)
- Remove Fedora 31 support (i386 only)
- Remove Fedora Rawhide support (i386 only)

* Tue Nov 12 2019 spoonsauce
- Update to RetroArch 1.8.1

* Fri Nov 1 2019 spoonsauce
- Add Fedora 31 support (i386 and x86_64)
- Add Fedora Rawhide support (i386 and x86_64)

* Tue Oct 29 2019 spoonsauce
- Update to RetroArch 1.8.0

* Wed Oct 9 2019 spoonsauce
- Update to RetroArch 1.7.9.2

* Mon Sep 9 2019 spoonsauce
- Update to RetroArch 1.7.8.3

* Mon Aug 26 2019 spoonsauce
- Update to RetroArch 1.7.8

* Tue May 7 2019 spoonsauce
- Update to RetroArch 1.7.7
- Add Fedora 30 support (i386 and x86_64)

* Mon Feb 4 2019 spoonsauce
- Update to RetroArch 1.7.6

* Thu Nov 15 2018 spoonsauce
- Remove Fedora 27 support (i386 and x86_64)
- Add Fedora 29 support (i386 and x86_64)

* Fri Oct 5 2018 spoonsauce
- Update to RetroArch 1.7.5

* Wed Sep 5 2018 spoonsauce
- Update to RetroArch 1.7.4

* Tue May 22 2018 spoonsauce
- Update to RetroArch 1.7.3
- Remove Fedora 26 support (i386 and x86_64)
- Add Fedora 28 support (i386 and x86_64)

* Thu Apr 26 2018 spoonsauce
- Update to RetroArch 1.7.2

* Tue Feb 20 2018 spoonsauce
- Update to RetroArch 1.7.1

* Thu Jan 4 2018 spoonsauce
- Update to RetroArch 1.7.0

* Mon Dec 11 2017 spoonsauce
- Add Vulkan (vulkan, vulkan-devel) to build

* Tue Nov 21 2017 spoonsauce
- Update to RetroArch 1.6.9

* Mon Nov 20 2017 spoonsauce
- Add Fedora 27 support (i386 and x86_64)

* Mon Aug 21 2017 spoonsauce
- Update to RetroArch 1.6.7

* Thu Aug 17 2017 spoonsauce
- Update to RetroArch 1.6.6

* Tue Aug 8 2017 spoonsauce
- Update to RetroArch 1.6.4

* Fri Jul 28 2017 spoonsauce
- Update to RetroArch 1.6.3
- Add Fedora 25 support (i386 and x86_64)
- Add i386 build for Fedora 26

* Wed Jul 19 2017 spoonsauce
- Initial import

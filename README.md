# RetroArch support / knowledge base

- [Lakka](#lakka)
- [Linux / Potato](#linux--potato)
- [Windows](#windows)
- [Knowledge Base](#knowledge-base)
  - [Netplay](#netplay)
  - [MAME](#mame)
  - [Resources](#resources)

## Lakka

My configuration, playlists, and [theme](https://drive.google.com/drive/folders/1Fo4Qnv9zLNjl-XHyuM3rqs4L4WMneion) used on Raspberry Pi `400` and `4 model B` which provides reasonable Vulkan over OpenGL support in its emulation cores.

## Linux / Potato

Having a full [Fedora distro](https://getfedora.org/en/workstation/download/) loaded on my Intel machines (modern Vulkan or potato OpenGL) provides much better A/V support over Lakka - which is better suited as a Raspberry Pi dedicated gaming console. After fetching the stable version of the [source](https://retroarch.com/index.php?page=linux-instructions), a working example follows:

```bash
$ sudo dnf install rpm-build rpmdevtools
$ rpmdev-setuptree
$ mv Downloads/RetroArch-1.10.0.tar.gz rpmbuild/SOURCES
$ sudo dnf builddep RetroArch.spec
$ cp RetroArch.spec rpmbuild/SPECS
$ rpmbuild --rebuild rpmbuild/SPECS/RetroArch.spec
$ sudo dnf upgrade rpmbuild/RPMS/x86_64/RetroArch-1.10.0-1.fc35.x86_64.rpm
$ retroarch --help
===================================================================
RetroArch: Frontend for libretro -- v1.10.0
Compiler: GCC (11.2.1) 64-bit Built: Nov  8 2021
===================================================================
Usage: retroarch [OPTIONS]... [FILE]
...
```

### Remote access

It's easier to remote network into my consoles running in the mancave downstairs. While I am comfortable doing all things via SSH, it's convenient & comforting to use & see its autologin desktop. I use the `Remmina` tools:

```bash
... on remote machine:
$ gsettings list-recursively org.gnome.desktop.remote-desktop.vnc
org.gnome.desktop.remote-desktop.vnc view-only false
org.gnome.desktop.remote-desktop.vnc auth-method 'password'
org.gnome.desktop.remote-desktop.vnc encryption ['tls-anon']
$ killall gnome-keyring-daemon
$ echo -n "userpassword" | gnome-keyring-daemon -l -d
$ echo -n 'vncpassword' | secret-tool store --label="GNOME Remote Desktop VNC password" "xdg:schema" "org.gnome.RemoteDesktop.VncPassword"
$ systemctl enable --user gnome-remote-desktop
$ systemctl start --user gnome-remote-desktop
$ sudo dnf install cool-retro-term gnome-tweaks htop linuxconsoletools

... on client machine:
$ sudo dnf install remmina remmina-gnome-session remmina-plugins-spice remmina-plugins-www
$ nmap [remote-machine]
Starting Nmap 7.91 ( https://nmap.org ) at 2022-02-01 10:36 EST
Nmap scan report for [remote-machine] (192.168.1.xx)
Host is up (0.0020s latency).
Not shown: 998 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
5900/tcp open  vnc
```

Might as well replace `Terminal` with `Cool Retro Term` and resize it for a classic 80x25 screen. I use `htop` running in its window to help window sizing.

## Windows

## Knowledge Base

### Netplay

### MAME

> _Does not support state/sync, so regardless,_ `Netplay Stateless Mode` _will be set to_ `ON`

Those **2**-player arcade games that use only **one** controller might present an inconvenient problem. This core seems to insist on only auto-mapping inputs if a game controller is present. So if both machines only have **one** controller each, it does not auto-map Player 2 controls -- which is fine -- except it also does not map `Coin 2` and `Start 2`. Ugh.

Within the MAME UI (`Tab`) menu under `Input (this Game)`, map an _unused_ controller button like `R Button (Shoulder)` as `Start 2` -- the same on *both* machines.  That said, if one of those machines later add a 2nd controller, you might want to expunge that button assigment to revert it back to the default key assignment `2`.

Before the **Client** machine `Connect to Network Host` (or from one waiting on the `Netplay Host List`), change `Network` settings `Request Device 1` and `User 1 Network RetroPad` to `ON` states.

---
**MAME (2010)** default controller button assignments are auto-mapped from RetroArch's Input - Port 1 Controls:

```text
RetroArch             RetroPad (P1,P2,...)            RetroKey (P1)    MAME Equivalent (P1,P2,...)
D-Pad Up              RETRO_DEVICE_ID_JOYPAD_UP       Up               [KEY_JOYSTICK_U]
D-Pad Down            RETRO_DEVICE_ID_JOYPAD_DOWN     Down             [KEY_JOYSTICK_D]
D-Pad Left            RETRO_DEVICE_ID_JOYPAD_LEFT     Left             [KEY_JOYSTICK_L]
D-Pad Right           RETRO_DEVICE_ID_JOYPAD_RIGHT    Right            [KEY_JOYSTICK_R]
A Button (Right)      RETRO_DEVICE_ID_JOYPAD_A        x / lAlt         [KEY_BUTTON_1]
B Button (Down)       RETRO_DEVICE_ID_JOYPAD_B        z / lCtrl        [KEY_BUTTON_2]
X Button (Top)        RETRO_DEVICE_ID_JOYPAD_X        s                [KEY_BUTTON_3]
Y Button (Left)       RETRO_DEVICE_ID_JOYPAD_Y        a                [KEY_BUTTON_4]
Select Button         RETRO_DEVICE_ID_JOYPAD_SELECT   rShift           [KEY_COIN]
Start Button          RETRO_DEVICE_ID_JOYPAD_START    Return           [KEY_START]
L Button (Shoulder)   RETRO_DEVICE_ID_JOYPAD_L        q                [KEY_BUTTON_5]
R Button (Shoulder)   RETRO_DEVICE_ID_JOYPAD_R        w                [KEY_BUTTON_6]
L2 Button (Trigger)   RETRO_DEVICE_ID_JOYPAD_L2       Tab              [KEY_TAB]
L3 Button (Thumb)     RETRO_DEVICE_ID_JOYPAD_L3       F2               [KEY_F2]
R3 Button (Thumb)     RETRO_DEVICE_ID_JOYPAD_R3       F3               [KEY_F3]
```

> _Unlike standalone MAME, this UI does not allow for custom_ **keyboard** _assignments, only RetroPad. You can "hack" input assignments for P2,... such as COIN2 and START2 into any of the savefiles/mame2010/cfg files for next startup, but it rewrites both default + content cfg files without them on exit. If necessary, I have found only COIN1 and START1 can "switch" to another assignment and persist:_

```xml
<?xml version="1.0"?>
<!-- This file is autogenerated; comments and unknown tags will be stripped -->
<mameconfig version="10">
    <system name="default">
        <input>
            <port type="START1">
                <newseq type="standard">
                    KEYCODE_1
                </newseq>
            </port>
            <port type="COIN1">
                <newseq type="standard">
                    KEYCODE_5
                </newseq>
            </port>
            <port type="UI_CANCEL">
                <newseq type="standard">
                    KEYCODE_LALT
                </newseq>
            </port>
            <port type="UI_CLEAR">
                <newseq type="standard">
                    KEYCODE_LALT
                </newseq>
            </port>
        </input>
    </system>
</mameconfig>
```

For games like **Battlezone** and **Robotron** desiring to use both controller analog sticks, this `<input>` cfg assignment snippet made from MAME UI (tab) menu works just fine:

```xml
            <port tag="IN3" type="P1_JOYSTICKRIGHT_DOWN" mask="1" defvalue="0">
                <newseq type="standard">
                    KEYCODE_LALT
                </newseq>
            </port>
            <port tag="IN3" type="P1_JOYSTICKRIGHT_UP" mask="2" defvalue="0">
                <newseq type="standard">
                    KEYCODE_SPACE
                </newseq>
            </port>
            <port tag="IN3" type="P1_JOYSTICKLEFT_DOWN" mask="4" defvalue="0">
                <newseq type="standard">
                    KEYCODE_DOWN
                </newseq>
            </port>
            <port tag="IN3" type="P1_JOYSTICKLEFT_UP" mask="8" defvalue="0">
                <newseq type="standard">
                    KEYCODE_UP
                </newseq>
            </port>
            <port tag="IN3" type="P1_BUTTON1" mask="16" defvalue="0">
                <newseq type="standard">
                    KEYCODE_Z OR KEYCODE_X
                </newseq>
            </port>

```

### Resources

- Chrome OS: [legacy boot mode](<https://wiki.archlinux.org/title/Chrome_OS_devices#Introduction>)
- Pi 4 (model B): [Lakka guide](<https://www.reddit.com/r/emulation/comments/pvv534/raspberry_pi_4_lakka_emulation_guide/>)

### Hi there 👋

<!--
**Shock-OS/Shock-OS** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...
- 👯 I’m looking to collaborate on ...
- 🤔 I’m looking for help with ...
  - Translating: Shock OS is currently only in English, and may not function as intended if the locale is switched to another language. Please let me know if you want to help translate.
  - Porting: If anyone is interested in running Shock OS on a regular x86 computer, it is totally possible. All the programs it runs are x86 compatible, so porting it wouldn't be difficult. We just needs someone who knows how to make a Live ISO that will install it with the Calamares insaller.
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...
-->

Shock OS is a desktop Linux distribution designed specifically for the Raspberry Pi 4, 400, & 5 (although it can very easily be ported to x86 if those who are interested would like to contribute towards that). This GitHub repository contains the source code for Shock OS, including prototypes for the next release. The development branch always has the latest prototype, and other branches, with the exception of the `upgrades` branch, are frozen in the state they were when their correspondingly codenamed version of Shock OS was released. For example, branch `release-finlay` contains the source code for Shock OS 6.0 Finlay (which is ancient by the way, don't use it).

### Information
Shock OS aims to provide a full-fledged desktop experience for the Raspberry Pi 4+. It is based on Raspberry Pi OS Lite and designed from the ground up with the Raspberry Pi hardware in mind.

Goals of Shock OS:
 - Ease of use, ready to go out-of-the-box
 - Stability and reliability (low maintenance)
 - Comfort and familiarity
 - Speed and optimization
 - Features and customization
 - Looking pretty

Features:
 - GNOME and MATE Editions available
 - Built-in Flatpak support
 - Debian-based, so Snap free (yay!)

Shock OS is somewhat inspired by Linux Mint's philosophy, and was created out of an absence of a Pi-compatible version of Linux Mint (or an equivalent distro). It is NOT, however, based on or affiliated with Linux Mint.

Recommended Pi models:
 - Raspberry Pi 5 (4 GB of RAM or more for comfortable usage)
 - Raspberry Pi 500
 - Raspberry Pi 4 (4 GB of RAM or more for comfortable usage)
 - Raspberry Pi 400

Shock OS theoretically runs on all Pi models. However, because it is designed to be a general-purpose, everyday desktop OS, many older and lower-end Pi models are not fit for such usage, and performance is not guaranteed.

Visit [the Shock OS website](https://www.shockos.net/) for more information about what Shock OS is and the features it provides.

### Build Instructions

<b>NOTE: These instructions detail the process of installing the latest development build of Shock OS FOR TESTING PURPOSES ONLY. If you would like to ACTUALLY USE Shock OS, please download a stable relase from [the Shock OS Website](https://www.shockos.net/) or straight from [SourceForge](https://sourceforge.net/projects/shock-os-download-mirror/files/Stable/).</b>

Shock OS builds are made by installing a series .deb packages on top of a fresh install of Raspberry Pi OS Lite. To test-run the latest prototype, follow the instructions below to build Shock OS:

First, clone the Shock OS GitHub repository to your computer (or download the .zip file and extract it):

`$ git clone https://github.com/Shock-OS/Shock-OS.git`

`$ cd Shock-OS`

To build GNOME Edition:
`$ ./build.sh gnome`

Or, to build MATE Edition:
`$ ./build.sh mate`

A new directory called `BUILD-OUT` will be created, containing all the files necessary to build Shock OS. Hold on to these, you will need them later in the build process. Using Raspberry Pi Imager, install the latest version of Raspberry Pi OS Lite to a storage device for use with your Raspberry Pi. When finished, insert your newly formatted storage device into your Raspberry Pi and start it up. 

When prompted to create a user, use the username `shockos`. The password can be whatever you want (it doesn't really matter because the `shockos` user will be removed after the initial setup has been completed anyway).

When logged in, ensure you are connected to the internet. You can either use ethernet, or type `sudo raspi-config` and go to `System Options` > `Wireless LAN` to connect to a Wi-Fi network. Once connected, run `sudo apt update` to ensure that the connection is working properly.

Now you'll need the files in the `BUILD-OUT` directory that was created earlier. Copy all files in the `BUILD-OUT` directory to `/home/shockos/` on your Raspberry Pi. This can be done using a USB Flash drive. First, copy the files from the `BUILD-OUT` directory to a USB flash drive (preferrably an empty one), then insert the drive into your Raspberry Pi.
    
To mount the drive, use `sudo mount /dev/sdXN /media` (replace the `X` in `/dev/sdXN` with the drive letter of your USB drive, and `N` with the partition number (likely `1`). If Raspberry Pi OS Lite is installed on an SD card, the USB drive is likely `/dev/sda1`. If Raspberry Pi OS Lite is installed on a USB device, the USB drive containing the necessary files may be `/dev/sdb1`, `/dev/sdc`, etc. When it doubt, just keep going down the alphabet until it works.) 

Once the drive is mounted, run the following commands:

`$ cp /media/* .` --> Copies the build files to the current directory

`$ sudo umount /dev/sdXN` (use the same drive name as before) --> Unmounts the USB drive as it is no longer needed

`$ ./auto-install.sh` --> Begins the building process. This should take around 20-100 minutes, depending on your internet connection speed.

Now all that's left is to wait for the building process to finish. This will take a while, so feel to grab a snack, watch a movie, run some errands, play Mario Kart, or finally catch up on that homework we all know you've been procrastinating (jk xD).

Once the build process is complete, run the following command to reboot the system and begin the initial setup process (hopefully, unless it's broken in the development build for some reason):

`$ reboot`

That's it, enjoy!

### License

Shock OS is licensed under the GNU General Public License 3.0 (GPL-3.0)

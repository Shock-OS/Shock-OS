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

Shock OS is a desktop Linux distribution designed specifically for the Raspberry Pi 4 (although it can very easily be ported to x86 if those who are interested would like to contribute towards that). This GitHub repository contains the source code for Shock OS, including prototypes for the next release. The development branch always has the latest prototype, and other branches are named after their release codename. For example, branch 'finlay' contains the source code for Shock OS 6.0 Finlay. 

### Building

Shock OS is built by installing a .deb package on top of a fresh install of Raspberry Pi OS Lite. To test-run the latest prototype, use the following commands to build a .deb package to install:

```$ git clone https://github.com/Shock-OS/Shock-OS.git```

```cd Shock-OS```

```$ dpkg-deb --build -Zxz shockos-?.0-all.deb```

And there you go! Simply install that on top of a fresh install of Raspberry Pi OS Lite (32-bit or 64-bit NON-Legacy) and you've got a test-build!

NOTE: This is ONLY recommended for testing purposes, NOT as a daily driver OS. If you are looking to install Shock OS for actual, daily use, please head over to SourceForge to download a .img.xz file of an actual Shock OS release:

https://sourceforge.net/projects/shock-os-download-mirror/files/Stable/

These images can be flashed to a storage device, such as an SD card, USB stick, or external USB HDD or SSD, with Raspberry Pi Imager.

### Contributing

We are currently looking for the following contributions:
- Translators - Shock OS is currently only available in English. While the locale can be switched to a different language, the Shock OS software (programs in this repo designed for Shock OS) is still only in English, which may cause Shock OS to not function as intended if the system is set to a different language.
- Porting to x86 - For those interested in running Shock OS on a regular, Intel/AMD x86 or x86_64 computer, porting Shock OS should be very easy. All of the programs in this repo, as well as the programs that the .deb package installs, are x86 compatible. Instead of installing on top of Raspberry Pi OS Lite, the Shock OS .deb package can be installed on top of Debian standard. We just need people who know how to create a Live ISO of Shock OS with the Calamares installer. 

### License

Shock OS is licensed under the GNU General Public License 3.0 (GPL-3.0)

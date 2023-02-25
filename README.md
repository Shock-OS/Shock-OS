### Hi there 👋

Welcome to the Shock OS GitHub repository!

Branches in this repository:
Experimental - The latest Shock OS code (will eventually become the next stable release)
Other branches are frozen branches containing the code for a specific release of Shock OS. For example, the 'finlay' branch contains all the code for Shock OS 6.0 Finlay, 'garrett' for Shock OS 7.0 Garrett, etc.

This is NOT the repository to download Shock OS image files. Please go to https://www.shockos.net/download to download completed, stable Shock OS images.

- 🔭 I’m currently working on ...
  - Finishing touches on Shock OS 7.0 Garrett
- 🌱 I’m currently learning ...
  - A lot about bash, the MATE Desktop Environment, and Linux in general.
- 👯 I’m looking to collaborate on ...
  - The entire Shock OS project! Please reach out to me if you would like to contribute in any way!
- 🤔 I’m looking for help with ...
  - Translating
  - Creating a GUI app store (similar to gnome-software) for Shock OS with support for installing/upgrading/removing apt packages and, if the backends are installed, Flatpak and Snap packages.
  - Creating a GUI clock app (similar to gnome-clocks, but with support for 12-hour clock format as well).
- 💬 Ask me about ...
  - Whatever you have questions about.
- 📫 How to reach me: ...
  - Feel free to post a comment here on GitHub.

Welcome to the Shock OS GitHub repositore!

Branches in this repository:
Experimental - The latest Shock OS code (will eventually become the next stable release)
Other branches are frozen branches containing the code for a specific release of Shock OS. For example, the 'finlay' branch contains all the code for Shock OS 6.0 Finlay, 'garrett' for Shock OS 7.0 Garrett, etc.

This is NOT the repository to download Shock OS image files. Please go to https://www.shockos.net/download to download completed, stable Shock OS images.

=========================================================== STEPS TO INSTALL SHOCK OS FROM GITHUB ====================================================================================
If you wish to manually build Shock OS instead of using one of the ready-made images, this guide will tell you how to do so.

STEP 1: Install Raspberry Pi OS Lite (32 bit or 64 bit) on a SD card, USB stick or USB HDD/SSD.

STEP 2: When prompted, create the 'shock' user (username: shock, password: shock)

STEP 3: Download the code from your desired branch into a .ZIP file and extract it, then make a .deb file out of it using dpkg-deb.

STEP 4: Install the created .deb file on Shock OS using: sudo apt install ./[DEB PACKAGE NAME]

That's it!


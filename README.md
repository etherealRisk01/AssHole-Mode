# AssHole-Mode

This is a simple bash script to jam wireless networks and has been tested on Ubuntu and Kali. This should theoretically work on any Debian-based distro.

Required packages:

1. aircrack-ng
2. mdk3
3. macchanger

Required hardware:
laptop/desktop with wireless card or wireless adapter

To determine your wireless interface, run the following command in your terminal:

iwconfig

To check if your wireless card/wireless adapter is capable of packet injection, run
the following command in your terminal:

aireplay-ng -9 [wireless interface]

e.g. aireplay-ng -9 wlp2s0, aireplay-ng -9 wlan0

Check the output and if you see "Injection is working!" then you are good to go.

************************
Disclaimer:

1. This tool is for educational purposes only. :)
2 .Contrary to what I named this tool, don't be an asshole. Use it on wireless networks that YOU control.
3. Like your regular WiFi connection, sources of WiFi interference can also affect your ability to jam other wireless connections.
Please look at the following websites for reference:
https://support.apple.com/en-us/HT201542
https://www.netspotapp.com/wifi-interference.html
4. This will work until the WPA3 security protocol is rolled-out on all wireless devices.

************************

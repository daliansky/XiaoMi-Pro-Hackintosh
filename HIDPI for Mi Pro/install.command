#!/bin/bash

path=${0%/*}
sudo launchctl remove /Library/LaunchAgents/org.zysuper.riceCracker.plist
sudo pkill riceCrackerDaemon
sudo rm -f /Library/LaunchAgents/org.zysuper.ricecracker.daemon.plist
sudo rm -f /usr/bin/riceCrackerDaemon

sudo rm -rf /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5
echo 'Uninstall previous version complete！'

sudo cp -r "$path/DisplayVendorID-9e5" /System/Library/Displays/Contents/Resources/Overrides
sudo mkdir -p /System/Library/Displays/Contents/Resources/Overrides/backup
sudo cp /System/Library/Displays/Contents/Resources/Overrides/Icons.plist /System/Library/Displays/Contents/Resources/Overrides/backup/
sudo cp -r "$path/Icons.plist" /System/Library/Displays/Contents/Resources/Overrides/
echo 'This is the end of the installation, please reboot and choose 1344x756 in SysPref! '
bash read -p 'Press any key to exit'

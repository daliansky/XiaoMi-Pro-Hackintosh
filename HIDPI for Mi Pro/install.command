#!/bin/bash

# Uninstall HiScale (Added in commit https://github.com/daliansky/XiaoMi-Pro/commit/fa35968b5acf851e274932ca52e67c43fe747877)
path=${0%/*}
sudo launchctl remove /Library/LaunchAgents/org.zysuper.riceCracker.plist
sudo pkill riceCrackerDaemon
sudo rm -f /Library/LaunchAgents/org.zysuper.ricecracker.daemon.plist
sudo rm -f /usr/bin/riceCrackerDaemon

# Remove previous one-key-hidpi (Added in commit https://github.com/daliansky/XiaoMi-Pro/commit/a3b7f136209a91455944b4afece7e14a931e62ba)
sudo rm -rf /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5
echo 'Uninstall previous version complete！'

# Copy the display folder
sudo cp -r "$path/DisplayVendorID-9e5" /System/Library/Displays/Contents/Resources/Overrides/

# Create backup for Icons.plist
sudo mkdir -p /System/Library/Displays/Contents/Resources/Overrides/backup
sudo cp /System/Library/Displays/Contents/Resources/Overrides/Icons.plist /System/Library/Displays/Contents/Resources/Overrides/backup/

# Override Icon.plist
sudo cp -r "$path/Icons.plist" /System/Library/Displays/Contents/Resources/Overrides/

# Fix permission
sudo chown root:wheel /System/Library/Displays/Contents/Resources/Overrides/Icons.plist
sudo chown root:wheel /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5/DisplayProductID-747
sudo chown root:wheel /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5/DisplayProductID-747.icns
sudo chown root:wheel /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5/DisplayProductID-747.tiff

echo 'This is the end of the installation, please reboot and choose 1424x802 in SysPref! '
bash read -p 'Press any key to exit'

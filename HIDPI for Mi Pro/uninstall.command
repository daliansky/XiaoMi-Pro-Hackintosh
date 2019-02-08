#!/bin/bash

# Remove display folder
sudo rm -rf /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5

# Restore Icon.plist in backup folder if presents
if [ -f "/System/Library/Displays/Contents/Resources/Overrides/backup/Icons.plist" ];then
sudo cp -r /System/Library/Displays/Contents/Resources/Overrides/backup/Icons.plist /System/Library/Displays/Contents/Resources/Overrides/
fi

# Remove backup folder
sudo rm -rf /System/Library/Displays/Contents/Resources/Overrides/backup

echo 'Uninstallation complete, please restart！'
bash read -p 'Press any key to exit'

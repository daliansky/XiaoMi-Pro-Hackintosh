#!/bin/bash

sudo rm -rf /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-9e5
sudo rm -rf /System/Library/Displays/Contents/Resources/Overrides/Icons.plist
sudo cp -r /System/Library/Displays/Contents/Resources/Overrides/backup/* /System/Library/Displays/Contents/Resources/Overrides/
echo 'Uninstallation complete, please restart！'
bash read -p 'Press any key to exit'

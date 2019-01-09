#!/bin/bash


path=${0%/*}
sudo launchctl remove /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo rm -rf /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo rm -rf /usr/bin/ALCPlugFix
sudo rm -rf /usr/bin/hda-verb
sudo kextcache -i /
echo 'Uninstalling the ALCPlugFix daemon is complete!'
bash read -p 'Press any key to exit'
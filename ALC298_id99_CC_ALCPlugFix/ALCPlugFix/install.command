#!/bin/bash


path=${0%/*}
sudo cp -a "$path/ALCPlugFix" /usr/bin
sudo chmod 755 /usr/bin/ALCPlugFix
sudo chown root:wheel /usr/bin/ALCPlugFix
sudo cp -a "$path/hda-verb" /usr/bin
sudo chmod 755 /usr/bin/hda-verb
sudo chown root:wheel /usr/bin/hda-verb
sudo cp -a "$path/good.win.ALCPlugFix.plist" /Library/LaunchAgents/
sudo chmod 644 /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo chown root:wheel /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo launchctl load /Library/LaunchAgents/good.win.ALCPlugFix.plist
echo 'The installation of the ALCPlugFix daemon is complete'
echo 'Rebuild kextcache, please wait...'
sudo rm -rf /System/Library/Caches/com.apple.kext.caches/Startup/kernelcache
sudo rm -rf /System/Library/PrelinkedKernels/prelinkedkernel
sudo touch /System/Library/Extensions/ && sudo kextcache -u /
echo 'Rebuild kextcache is complete'
bash read -p 'Press any key to Exit'
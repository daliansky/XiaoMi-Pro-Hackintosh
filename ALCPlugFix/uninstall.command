#!/bin/bash


path=${0%/*}
sudo launchctl remove /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo rm -rf /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo rm -rf /usr/bin/ALCPlugFix

echo 'Rebuilding Kext Cache,please wait……'
sudo chmod -Rf 755 /S*/L*/E*
sudo chown -Rf 0:0 /S*/L*/E*
sudo chmod -Rf 755 /L*/E*
sudo chown -Rf 0:0 /L*/E*
sudo rm -Rf /S*/L*/PrelinkedKernels/*
sudo rm -Rf /S*/L*/Caches/com.apple.kext.caches/*
sudo touch -f /S*/L*/E*
sudo touch -f /L*/E*
sudo kextcache -Boot -U /
echo 'Uninstall the ALCPlugFix daemon complete!'
bash read -p 'Press any key to exit'
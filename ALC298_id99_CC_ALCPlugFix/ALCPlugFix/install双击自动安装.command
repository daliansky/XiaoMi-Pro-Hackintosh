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
echo '正在重建缓存中，请稍候......'
sudo chmod -Rf 755 /S*/L*/E*
sudo chown -Rf 0:0 /S*/L*/E*
sudo chmod -Rf 755 /L*/E*
sudo chown -Rf 0:0 /L*/E*
sudo rm -Rf /S*/L*/PrelinkedKernels/*
sudo rm -Rf /S*/L*/Caches/com.apple.kext.caches/*
sudo touch -f /S*/L*/E*
sudo touch -f /L*/E*
sudo kextcache -Boot -U /
echo '重建缓存完毕！'
echo '安装ALCPlugFix守护进程完成！'
bash read -p '按任何键退出'
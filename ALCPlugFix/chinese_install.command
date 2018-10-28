#!/bin/bash

path=${0%/*}
sudo cp -a "$path/fix/ALCPlugFix" /usr/bin
sudo chmod 755 /usr/bin/ALCPlugFix
sudo chown root:wheel /usr/bin/ALCPlugFix
sudo cp -a "$path/fix/hda-verb" /usr/bin
sudo chmod 755 /usr/bin/hda-verb
sudo chown root:wheel /usr/bin/hda-verb
sudo cp -a "$path/fix/good.win.ALCPlugFix.plist" /Library/LaunchAgents/
sudo chmod 644 /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo chown root:wheel /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo launchctl load /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo kextcache -i /
echo '安装ALCPlugFix守护进程完成！'
bash read -p '按任何键退出'

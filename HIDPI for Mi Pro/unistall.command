#!/bin/bash

path=${0%/*}
sudo launchctl remove /Library/LaunchAgents/org.zysuper.riceCracker.plist
sudo pkill riceCrackerDaemon
sudo rm -f /Library/LaunchAgents/org.zysuper.ricecracker.daemon.plist
sudo rm -f /usr/bin/riceCrackerDaemon

echo 'Uninstalling HiScale complete！'
echo 'This is the end of the uninstallation! '
bash read -p 'Press any key to exit'

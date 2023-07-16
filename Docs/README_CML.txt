This file includes some tips for XiaoMi-Pro TM1905/TM1963.

1. Change `enable-backlight-registers-fix` to `enable-backlight-registers-alternative-fix` if macOS Version >= 13.4.

2. If you have difficulty waking up your laptop from hibernation, you can try to disable hibernation. To disable hibernation, you need to run following commands in `Terminal.app`:

sudo pmset -a hibernatemode 0
sudo pmset autopoweroff 0
sudo pmset powernap 0
sudo pmset standby 0
sudo pmset proximitywake 0
sudo pmset tcpkeepalive 0

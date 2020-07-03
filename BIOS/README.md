# Update BIOS and Unlock Better Performance

**English** | [中文](README_CN.md)

## Introduction

The BIOS packet in [XMAKB5R0P0906](XMAKB5R0P0906) and [XMAKB5R0P0A07](XMAKB5R0P0A07.exe) are from Xiaomi stuff, so they are reliable. **These packets are only compatible with MX150 version.**

~The ME firmware in [ME](ME) folder is from [Fernando's Win-RAID Forum](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html). Using the latest ME firmware helps to avoid potential malicious attack. The ME firmware version in the folder is `Intel CSME 11.8 Consumer PCH-LP Firmware v11.8.55.3510` and the version of `Intel (CS)ME System Tools` is `Intel CSME System Tools v11 r14 - (2018-08-09)`.~

Warning: Since the operations are related to BIOS, it's possible that if some errors(such as force quit the update program) occur during the update process(so as to scripts in [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)), the whole system may unable to boot.

If unfortunately, this situation happens on you, you need to find Xiaomi stuff to fix your device. If you use this program, you should agree that you are the person who takes the whole responsibility, instead of the author.


### What's new in 0906 BIOS

- a new setting `KB Backlight Mode` appears in BIOS panel. Users can choose `Power Saving` (default, KB backlight off when keyboard idle 15s) or `Standard` (KB backlight always on in S0 mode)
- Reduce fan noise when CPU is running in low load


### What's new in 0A07 BIOS

- I have no idea about this version. The packet provider doesn't give much information.
- On my laptop, the `KB Backlight Mode` - `Standard` is not working.
- It's very easy to upgrade to this version. Just download and open [XMAKB5R0P0A07](XMAKB5R0P0A07.exe).


## How to update 0906 BIOS

 As the old proverb says "Fight no battle unprepared", **backing up important data is always a good choice.** Some users face with blue screen after running the updating program.

1. Download all the files in [XMAKB5R0P0906](XMAKB5R0P0906) folder.

2. Run `H2OFFT-Wx64.exe` with administrator.
  - IMPORTANT: From this step, your computer should keep in charged by AC adapter until the whole update process finishes.

3. A warning may appear, ignore it and update.

4. The laptop will restart, wait until the update process ends.


## How to unlock better performance

**MX150 Only.**
[FallenChromium](https://github.com/FallenChromium) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) created scripts for changing DVMT size from 32mb to 64mb, unlocking MSR 0xE2, and editing Embedded Controller(EC) firmware to reduce fan nosie. For more information, you can visit [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8) and [cybsuai's repository](https://github.com/cybsuai/Mi-Notebook-Pro-tweaks).


## Credits

- Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/) and [一土木水先生](http://bbs.xiaomi.cn/u-detail-1242799508) for providing 0906 BIOS packet. The original source is at [here](http://bbs.xiaomi.cn/t-36660609-1).
- Thanks to a friendly guy for providing 0A07 BIOS packet. He doesn't want to be in trouble so please don't spread the 0A07 BIOS packet.
- Thanks to [Cyb](http://4pda.ru/forum/index.php?showuser=914121) and [FallenChromium](https://github.com/FallenChromium) for writing incredible scripts to unlock better performance.

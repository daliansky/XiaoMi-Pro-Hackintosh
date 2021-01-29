# Update BIOS and Unlock Better Performance

**English** | [中文](README_CN.md)

## Contents

- [Introduction](#introduction)
- [TM1701](#tm1701)
  - Update History
  - How to Update
  - How to Unlock Better Performance
- [TM1707](#tm1707)
  - Update History
  - How to Update
- [TM1905](#tm1905)
  - Update History
  - How to Update
  - How to Unlock Better Performance
- [TM1963](#tm1963)
  - Update History
  - How to Update
- [Credits](#credits)


## Introduction

| Model | BIOS Packs Provided |
| ------ | ---------- |
| TM1701 | [XMAKB5R0P0603](TM1701/XMAKB5R0P0603), [XMAKB5R0P0906](TM1701/XMAKB5R0P0906), [XMAKB5R0P0A07](TM1701/XMAKB5R0P0A07.exe), [XMAKB5R0P0E07](TM1701/XMAKB5R0P0E07.exe) |
| TM1707 | [XMAKB5RRP0C05](TM1707/XMAKB5RRP0C05.exe) |
| TM1905 | [XMACM500P0401](TM1905/XMACM500P0401.exe) |
| TM1963 | [XMACM5B1P0201](TM1963/XMACM5B1P0201.exe) |

These BIOS packets are from Xiaomi official or after-sale service.

~The ME firmware in [ME](ME) folder is from [Fernando's Win-RAID Forum](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html). Using the latest ME firmware helps to avoid potential malicious attack. The ME firmware version in the folder is `Intel CSME 11.8 Consumer PCH-LP Firmware v11.8.55.3510` and the version of `Intel (CS)ME System Tools` is `Intel CSME System Tools v11 r14 - (2018-08-09)`.~

**Warning: Since the operations are related to BIOS, it's possible that if some errors(such as force quit the update program) occur during the update process(so as to scripts in [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)), the whole system may unable to boot.**

If unfortunately, this situation happens on you, you need to find Xiaomi stuff to fix your device. If you use this program, you should agree that you are the person who takes the whole responsibility, instead of the author.


## TM1701

### Update History

#### XMAKB5R0P0906

- A new setting `KB Backlight Mode` appears in BIOS panel. Users can choose `Power Saving` (default, KB backlight off when keyboard idle 15s) or `Standard` (KB backlight always on in S0 mode)
- Reduce fan noise when CPU is running in low load

#### XMAKB5R0P0A07 & XMAKB5R0P0E07

- I have no idea about these versions. The packet providers don't give much information.
- On my laptop, the `KB Backlight Mode` - `Standard` is not working on XMAKB5R0P0A07.
- It's very easy to upgrade to these versions. Just download and run the exe file.


### How to Update

#### XMAKB5R0P0603

**It's allowed to downgrade to this version**

1. Prepare a FAT32 U-disk, download all the files in [XMAKB5R0P0603](TM1701/XMAKB5R0P0603) folder and put them into the root directory of the U-disk.

2. Reboot the laptop with AC charge on, press `F12`, and choose the U-disk entry.

3. In the shell interface, type `unlockme.nsh`, and then the device may reboot. After that, repeat the second step and type `flash.nsh`.

4. Wait until the install process completes.

#### XMAKB5R0P0906

 As the old proverb says "Fight no battle unprepared", **backing up important data is always a good choice.** Some users face with blue screen after running the updating program.

1. Download all the files in [XMAKB5R0P0906](TM1701/XMAKB5R0P0906) folder.

2. Run `H2OFFT-Wx64.exe` with administrator.
  - IMPORTANT: From this step, your computer should keep in charged by AC adapter until the whole update process finishes.

3. A warning may appear, ignore it and update.

4. The laptop will restart, wait until the update process ends.

#### XMAKB5R0P0A07 and Above

Just run the exe file. Make sure AC power is connected during the update.


### How to Unlock Better Performance

[FallenChromium](https://github.com/FallenChromium) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) created scripts for changing DVMT size from 32mb to 64mb, unlocking MSR 0xE2, and editing Embedded Controller(EC) firmware to reduce fan nosie. Scripts are in [DVMT_and_0xE2_fix](TM1701/DVMT_and_0xE2_fix). For more information, you can visit [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8) and [cybsuai's repository](https://github.com/cybsuai/Mi-Notebook-Pro-tweaks).


## TM1707

### Update History

#### XMAKB5RRP0C05

- No information is provided by the BIOS pack vendor


### How to Update

#### XMAKB5RRP0C05

Just run the exe file. Make sure AC power is connected during the update.


## TM1905

### Update History

#### XMACM500P0401

- No information is provided by the BIOS pack vendor


### How to Update

#### XMACM500P0401

Just run the exe file. Make sure AC power is connected during the update.


### How to Unlock Better Performance

The following table is about some advanced BIOS configurations, thanks to [htmambo](https://github.com/htmambo).

| Item | Offset | Configuration | Options | Default | Recommend |
| ----- | ----- | ----- | ----- | ----- | ----- |
| RTC | 0x54A | SETUP | 0x0:ACPI Time and Alarm Device; 0x1:Legacy RTC | 0x0 | 0x1 |
| DVMT | 0x107 | SaSETUP | 0x0:0M, 0x1:32M, 0x2:64M | 0x1 | 0x2 |
| DVMT Total Gfx Mem | 0x108 | SaSETUP | 0x1:128M, 0x2:256M, 0x3:Max | 0x3 | 0x3 |
| CFG LOCK | 0x3E | CpuSetup | 0x0:Disabled, 0x1:Enabled | 0x1 | 0x0 |
| MSR LOCK | 0x2B | SETUP | 0x0:Disabled, 0x1:Enabled | 0x0 | 0x0 |
| BIOS Lock | 0x17 | SETUP | 0x0:Disabled, 0x1:Enabled | 0x1| 0x0 |


## TM1963

### Update History

#### XMACM5B1P0201

- No information is provided by the BIOS pack vendor


### How to Update

#### XMACM5B1P0201

Just run the exe file. Make sure AC power is connected during the update.


## Credits

- Thanks to a friendly guy for providing `XMAKB5R0P0A07` BIOS packet. He doesn't want to be in trouble so please don't spread the `XMAKB5R0P0A07` BIOS packet.
- Thanks to [Cyb](http://4pda.ru/forum/index.php?showuser=914121) and [FallenChromium](https://github.com/FallenChromium) for writing incredible scripts to unlock better performance on TM1701.
- Thanks to [htmambo](https://github.com/htmambo) for providing information about TM1905 BIOS advanced configuration.
- Thanks to Xiaomi after-sale service and [一土木水先生](http://bbs.xiaomi.cn/u-detail-1242799508) for providing `XMAKB5R0P0603` and `XMAKB5R0P0906` BIOS packet. The original source is at [here](http://bbs.xiaomi.cn/t-36660609-1).
- Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/drivers/15) for providing the `XMAKB5R0P0E07` packet.
- Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/drivers/15-game-gtx) for providing the `XMAKB5RRP0C05` packet.
- Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/drivers/A10) for providing the `XMACM500P0401` packet.
- Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/drivers/A10G5) for providing the `XMACM5B1P0201` packet.

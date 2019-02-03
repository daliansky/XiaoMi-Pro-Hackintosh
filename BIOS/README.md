# Update BIOS and Unlock Better Performance

[English](README.md) | [中文](README-CN.md)

## Introduction

The BIOS packet in [XMAKB5R0P0906](https://github.com/daliansky/XiaoMi-Pro/tree/master/BIOS/XMAKB5R0P0906) folder is from Xiaomi stuff, so it is reliable.

The ME firmware in [ME](https://github.com/daliansky/XiaoMi-Pro/tree/master/BIOS/ME) folder is from [Fernando's Win-RAID Forum](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html). Using the latest ME firmware helps avoiding potential malicious attack. The ME firmware version in the folder is `Intel CSME 11.8 Consumer PCH-LP Firmware v11.8.55.3510` and the version of `Intel (CS)ME System Tools` is `Intel CSME System Tools v11 r14 - (2018-08-09)`.

Warning: Since the operations are related to BIOS, there's possibility that if some errors(such as force quit the update program) occur during the update process(so as to scripts in [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)), the whole system may unable to boot.

If unfortunately this situation happens on you, you need to find Xiaomi stuff to fix your device. If you use this program, you should agree that you are the person who take whole responsibility, instead of the author.


### What's new in 0906 BIOS

- a new setting `KB Backlight Mode` appears in BIOS panel. Users can choose `Power Saving` (default, KB backlight off when keyboard idle 15s) or `Standard` (KB backligh always on in S0 mode).
- Reduce fan noise when CPU is running in low load.


## How to update BIOS

1. Download all the files in [XMAKB5R0P0906](https://github.com/daliansky/XiaoMi-Pro/tree/master/BIOS/XMAKB5R0P0906) folder.

2. Run `H2OFFT-Wx64.eve` with administrator.
  - IMPORTANT: From this step, your computer should keep in charged by AC adapter until the whole update process finishes.

3. A warning may appear, ignore it and update.

4. The laptop will restart, wait until the update process ends.


## How to update ME firmware

1. Download all the files in [ME](https://github.com/daliansky/XiaoMi-Pro/tree/master/BIOS/ME) folder.

2. Create a new folder within the drive C and name it "Win64" (path: C:\Win64) and copy all the files into "Win64" folder.

3. Make sure, that your notebook is connected to a charger and in the loading mode.

4. Run the Windows PowerShell as Admin and type the following:
```
cd C:\Win64
```
After having hit the Enter key you should now be within the related folder.

5. Now type the following command:
```
.\FWUpdLcl64.exe -F ME.bin
```
(note: the first character is a dot!) and hit the Enter key.
The rest will be done automaticly.

6. Wait until the process has been successfully completed.

7. Restart the notebook.


## How to unlock better performance

[FallenChromium](https://github.com/FallenChromium) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) created scripts for changing DVMT size from 32MB to 64MB, unlocking MSR 0xE2, and editing Embedded Controller(EC) firmware to reduce fan nosie. For more information, you can visit [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8) and [cybsuai's repository](https://github.com/cybsuai/Mi-Notebook-Pro-tweaks).


## Credits

Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/) and [一土木水先生](http://bbs.xiaomi.cn/u-detail-1242799508) for providing BIOS packet. The original source is at [here](http://bbs.xiaomi.cn/t-36660609-1).

Thanks to [Cyb](http://4pda.ru/forum/index.php?showuser=914121) and [FallenChromium](https://github.com/FallenChromium) for writing incredible scripts to unlock better performance.

Thanks to [plutomaniac's post](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html) for providing the ME firmware.

Thanks to [Fernando_Uno](http://en.miui.com/space-uid-2239545255.html) for providing the instruction of flashing ME firmware. The original instruction is at [here](http://en.miui.com/thread-3260884-1-1.html).

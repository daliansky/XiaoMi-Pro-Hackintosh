# XiaoMi NoteBook Pro 2017 & 2018 Hackintosh
[![release](https://img.shields.io/badge/download-release-blue.svg)](https://github.com/daliansky/XiaoMi-Pro/releases) [![wiki](https://img.shields.io/badge/support-wiki-green.svg)](https://github.com/daliansky/XiaoMi-Pro/wiki) [![Chat](https://img.shields.io/badge/chat-tonymacx86-red.svg)](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)

macOS Catalina & Mojave & High Sierra on XiaoMi NoteBook Pro 2017 & 2018

English | [中文](README_CN.md)

## Configuration

| Specifications | Detail                                                  |
| ------------------- | ------------------------------------------- |
| Computer model      | Xiaomi NoteBook Pro 15.6''(MX150/GTX)      |
| Processor           | Intel Core i5-8250U/i7-8550U Processor     |
| Memory              | 8GB/16GB Samsung DDR4 2400MHz              |
| Hard Disk           | Samsung NVMe SSD Controller PM961/PM981    |
| Integrated Graphics | Intel UHD Graphics 620                     |
| Monitor             | BOE NV156FHM-N61 FHD 1920x1080 (15.6 inch) |
| Sound Card          | Realtek ALC298 (layout-id:30/99)           |
| Wireless Card       | Intel Wireless 8265                        |
| SD Card Reader      | Realtek RTS5129/RTS5250S                   |


## Current Status in Clover

- <b>Ethernet is not working in macOS 10.15, help wanted</b>
- In macOS 10.15, you need to update [Wireless-USB-Adapter Driver](https://github.com/chris1111/Wireless-USB-Adapter-Clover/releases)
  - If you are not using macOS 10.15, it's still recommended to update the driver above
- Discrete graphic card is not working, since macOS doesn't support Optimus technology
  - Have used [SSDT-DDGPU](EFI/CLOVER/ACPI/patched/SSDT-DDGPU.dsl) to disable it in order to save power
- Fingerprint sensor is not working
  - Have used [SSDT-USB](EFI/CLOVER/ACPI/patched/SSDT-USB.dsl) to disable it in order to save power
- ~~Intel Bluetooth only works after warm restart from Windows~~
  - ~~View [Work-Around-with-Bluetooth](https://github.com/daliansky/XiaoMi-Pro/wiki/Work-Around-with-Bluetooth)~~
- Intel Wi-Fi(Intel Wireless 8265) is not working
  - Have used [SSDT-DRP08](EFI/CLOVER/ACPI/patched/SSDT-DRP08.dsl) to disable it in order to save power
  - Buy a USB Wi-Fi dongle or supported wireless card
- Realtek USB SD Card Reader(RTS5129) is not working
  - Have used [SSDT-USB](EFI/CLOVER/ACPI/patched/SSDT-USB.dsl) to disable it in order to save power
- Everything else works well


## Current Status in OpenCore

- Basically the same with [Current Status in Clover](#current-status-in-clover) section
- No theme

Need more testing...


## Improvements

- Use [ALCPlugFix](ALCPlugFix) to fix unworking jack after replug
- Use [DVMT_and_0xE2_fix](BIOS/DVMT_and_0xE2_fix) to set DVMT to 64MB and unlock CFG
- Use [one-key-hidpi](one-key-hidpi) to improve quality of system UI
- Use [one-key-cpufriend](one-key-cpufriend) to modify CPU power management


## Installation

### First-time installation

- Please refer to the detailed installation tutorial [Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724) or video tutorial [Xiaomi NoteBook PRO HACKINTOSH INSTALLATION GUIDE !!!](https://www.youtube.com/watch?v=72sPmkpxCvc).
- If the trackpad doesn't work during the installation, please plug a wired mouse or a wireless mouse projector before the installation. After the installation completes, open `Terminal.app` and run `sudo kextcache -i /`. Wait for the process ending and restart the device. Enjoy your trackpad!
- Complete EFI packs are available in the [releases](https://github.com/daliansky/XiaoMi-Pro/releases) page.
 - Please don't clone or download the master branch for daily use.
 
 <img src="img/donot_Clone_or_Download.jpg" width="300px" alt="donot_clone_or_download">
 <img src="img/get_Release.jpg" width="300px" alt="get_release">

### Upgrade

- A complete replacement of `BOOT` and `CLOVER`(or `OC`) folders is required. Delete these two folders and copy them from the [release pack](https://github.com/daliansky/XiaoMi-Pro/releases).
- You can also update EFI by running the following command in Terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/install.sh)"
```


## FAQ

### My device is locked by `Find My Mac` and can't be booted, what should I do now?

Press `Fn+F11` when you are in Clover boot page. Then Clover will refresh `nvram.plist`, and lock message should be removed.

### I opened the `FileVault` and I can't find macOS partition in Clover boot page, how can I solve it?

It is not recommended to open `FileVault`. You can press Fn + F3 in the Clover boot page and choose the icon with `FileVault`. Then you can boot in the system and close `FileVault`.

### My screen turns to black and has no response during the updating process.

If you have black screen for five minutes and get no response from the device, please force restart your laptop(Long press power button) and choose `Boot macOS Install from ~` entry.

### My touchpad isn't working after update.

You need to rebuild the kext cache after every system update. Use `Kext Utility.app` or type `sudo kextcache -i /` in `Terminal.app`. Then restart. If this still doesn't work, try to press F9.

### I can't boot in Windows/Linux by using Clover, but able to boot by press F12 and select OS.

Many people met this problem by using the new version of `AptioMemoryFix.efi`. A workaround is to delete `AptioMemoryFix.efi` in `/CLOVER/drivers/UEFI/` and replace it with the old version provided in [#93](https://github.com/daliansky/XiaoMi-Pro/issues/93).

Also make sure `Sandbox` and `Hyper-V` functions in Windows 10 are disabled.

### Please refer to detailed FAQ in [wiki FAQ](https://github.com/daliansky/XiaoMi-Pro/wiki/FAQ).


## Changelog

You can view [Changelog](Changelog.md) for detailed information.


## A reward

All the project is made for free, but you can reward me if you want.

| Wechat                                                     | Alipay                                               |
| ---------------------------------------------------------- | ---------------------------------------------------- |
| ![wechatpay_160](http://7.daliansky.net/wechatpay_160.jpg) | ![alipay_160](http://7.daliansky.net/alipay_160.jpg) |


## Credits

- Thanks to [Acidanthera](https://github.com/acidanthera) for providing [AppleALC](https://github.com/acidanthera/AppleALC), [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg), [AptioFixPkg](https://github.com/acidanthera/AptioFixPkg), [HibernationFixup](https://github.com/acidanthera/HibernationFixup), [Lilu](https://github.com/acidanthera/Lilu), [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg), [VirtualSMC](https://github.com/acidanthera/VirtualSMC), [VoodooPS2](https://github.com/acidanthera/VoodooPS2), and [WhateverGreen](https://github.com/acidanthera/WhateverGreen).
- Thanks to [alexandred](https://github.com/alexandred) for providing [VoodooI2C](https://github.com/alexandred/VoodooI2C).
- Thanks to [apianti](https://sourceforge.net/u/apianti), [blackosx](https://sourceforge.net/u/blackosx), [blusseau](https://sourceforge.net/u/blusseau), [dmazar](https://sourceforge.net/u/dmazar), and [slice2009](https://sourceforge.net/u/slice2009) for providing [Clover](https://github.com/CloverHackyColor/CloverBootloader).
- Thanks to [daliansky](https://github.com/daliansky) for providing [OC-little](https://github.com/daliansky/OC-little).
- Thanks to [FallenChromium](https://github.com/FallenChromium), [jackxuechen](https://github.com/jackxuechen), [Javmain](https://github.com/javmain), [johnnync13](https://github.com/johnnync13), [Menchen](https://github.com/Menchen), [Pasi-Studio](https://github.com/Pasi-Studio), and [qeeqez](https://github.com/qeeqez) for valuable suggestions.
- Thanks to [hieplpvip](https://github.com/hieplpvip) and [syscl](https://github.com/syscl) for providing sample of DSDT patches.
- Thanks to [kprinssu](https://github.com/kprinssu) for providing [VoodooInput](https://github.com/kprinssu/VoodooInput) and [VoodooInputEngine](https://github.com/kprinssu/VoodooInputEngine).
- Thanks to [RehabMan](https://github.com/RehabMan) for providing [EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander), [EFICheckDisabler](https://github.com/RehabMan/hack-tools/tree/master/kexts/EFICheckDisabler.kext), [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config), [OS-X-Null-Ethernet](https://github.com/RehabMan/OS-X-Null-Ethernet), [OS-X-USB-Inject-All](https://github.com/RehabMan/OS-X-USB-Inject-All), and [SATA-unsupported](https://github.com/RehabMan/hack-tools/tree/master/kexts/SATA-unsupported.kext).
- Thanks to [zxystd](https://github.com/zxystd) for providing [IntelBluetoothFirmware](https://github.com/zxystd/IntelBluetoothFirmware)

- For more detail, please go to [Reference page](https://github.com/daliansky/XiaoMi-Pro/wiki/References).


## Support and discussion

- Mi Notebooks supported by other projects:
  - [Mi-Gaming-Laptop](https://github.com/johnnync13/XiaomiGaming) by [johnnync13](https://github.com/johnnync13)
  - [Mi-NB-Air-125-6y30](https://github.com/johnnync13/EFI-Xiaomi-Notebook-air-12-5) by [johnnync13](https://github.com/johnnync13)
  - [Mi-NB-Air-125-7y30](https://github.com/influenist/Mi-NB-Gaming-Laptop-MacOS) by [influenist](https://github.com/influenist)
  - [Mi-NB-Air-133-Gen1](https://github.com/johnnync13/Xiaomi-Notebook-Air-1Gen) by [johnnync13](https://github.com/johnnync13)
  - [Mi-NB-Air-133-2018](https://github.com/johnnync13/Xiaomi-Mi-Air) by [johnnync13](https://github.com/johnnync13)

- tonymacx86.com:
  - [[Guide] Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)

- QQ:
  - 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  - 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)
  - 689011732 [小米笔记本Pro黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=dde06295030ea1692d6655564e392d86ad874bd0608afd7d408c347d1767981b)

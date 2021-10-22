<img src="Docs/img/XiaoMi_Hackintosh_with_text_Small.png" width="679" height="48"/>

[![Build Status](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/workflows/CI/badge.svg)](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/actions) [![Release](https://img.shields.io/github/v/release/daliansky/XiaoMi-Pro-Hackintosh?label=download)](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/latest) [![Wiki](https://img.shields.io/badge/support-Wiki-green.svg)](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/wiki) [![Chat](https://img.shields.io/badge/chat-Discussions-orange.svg)](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/discussions)
-----

**English** | [中文](Docs/README_CN.md)

## Contents

- [Configuration](#configuration)
- [Current Status](#current-status)
  - [Clover](#clover)
  - [OpenCore](#opencore)
- [Installation](#installation)
  - [Identify Your Model](#identify-your-model)
  - [First-time installation](#first-time-installation)
  - [Build](#build)
  - [Upgrade](#upgrade)
- [Improvements](#improvements)
- [FAQ](#faq)
- [Changelog](#changelog)
- [Credits](#credits)
- [Support and discussion](#support-and-discussion)


## Configuration

### TM1701 & TM1707

| Specifications | Detail                                                  |
| ------------------- | ------------------------------------------- |
| Computer model | Xiaomi NoteBook Pro 15.6'' (MX150/GTX) |
| Processor | Intel Core i5-8250U / i7-8550U Processor |
| Memory | 8GB/16GB Samsung DDR4 2400MHz |
| Hard Disk | Samsung NVMe SSD Controller PM961 / ~~PM981~~ |
| Integrated Graphics | Intel UHD Graphics 620 |
| Monitor | BOE NV156FHM-N61 FHD 1920x1080 (15.6 inch) |
| Sound Card | Realtek ALC298 (layout-id: 30/99) |
| Wireless Card | Intel Wireless-AC 8265 |
| Trackpad | ETD2303 |
| SD Card Reader | Realtek RTS5129 / RTS5250S |

### TM1905 & TM1963

| Specifications | Detail                                                  |
| ------------------- | ------------------------------------------- |
| Computer model | Xiaomi NoteBook Pro 15.6'' (MX250/MX350) |
| Processor | Intel Core i5-10210U / i7-10510U Processor |
| Memory | 8GB/16GB Samsung DDR4 2666MHz |
| Hard Disk | Intel SSD 660P Series |
| Integrated Graphics | Intel UHD Graphics 620 |
| Monitor | LQ156M1JW01 SHP14C3 1920x1080 344x194mm 15.5-inch |
| Sound Card | Realtek ALC256 (layout-id: 69/99) |
| Wireless Card | Intel Wireless-AC 9462 |
| Trackpad | ELAN2303 |
| SD Card Reader | Realtek RTS5129 |


## Current Status

- **HDMI** may not work when you first-time plug it in
  - You have to re-plug it, or close the lid for about five seconds and reopen the lid
- **Ethernet may not work on macOS10.15+, view [#256](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/256)**
- On macOS10.15+, you need to update [Wireless-USB-Adapter Driver](https://github.com/chris1111/Wireless-USB-Adapter/releases)
  - If you are not using macOS10.15+, it's still recommended to update the driver above
- **Discrete graphic card** is not working, since macOS doesn't support Optimus technology
  - Have used `SSDT-DDGPU` to disable it in order to save power
- **Fingerprint sensor** is not working
  - Have used `SSDT-USB` to disable it in order to save power
- **Intel Bluetooth** does not support some Bluetooth devices
  - On macOS12+, you can not `Turn Bluetooth Off` and turn it back on; a restart is required to turn it on
  - On macOS12+, you may have to use `MacBookPro14,1` or `MacBookPro15,2` SMBIOS model to drive Intel Bluetooth
  - View [Work-Around-with-Bluetooth](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/wiki/Work-Around-with-Bluetooth)
- **Intel Wi-Fi** works with low performance
  - macOS Big Sur or higher is recommended; macOS version < 11 needs to rebuild kextcache and restart if Intel Wi-Fi does not work
  - Buy a USB Wi-Fi dongle or supported wireless card
  - Read [Frequently Asked Questions](https://openintelwireless.github.io/itlwm/FAQ.html) for more information
- **Realtek USB SD Card Reader** works with some setups
  - Read [FAQ](https://github.com/0xFireWolf/RealtekCardReader/blob/main/Docs/FAQ.md) for more information and add [RealtekCardReader](https://github.com/0xFireWolf/RealtekCardReader) + [RealtekCardReaderFriend](https://github.com/0xFireWolf/RealtekCardReaderFriend)
  - Or you can instead use VMware to let it work, see [2.0 Setup SD Card Reader](https://github.com/ManuGithubSteam/XiaoMi-Pro-2018-HackintoshOC/wiki/2.0-Setup-SD-Card-Reader)
- Everything else works well

### Clover
- TM1701 & TM1707: Supports macOS10.13 ~ macOS12
  - **[v1.5.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.9) is the last EFI version that supports macOS High Sierra & Mojave**
- TM1905 & TM1963: Supports macOS10.15 ~ macOS12
-----
- Have to choose `~ via Preboot` to boot Big Sur
- Should Clean NVRAM after using OpenCore
  - Press `Space` in OpenCore boot page, and then select `Reset NVRAM` entry
  - Then reboot and use Clover
- r5127 do not support Intel Wi-Fi on macOS version < Big Sur due to incomplete ForceKextsToLoad functionality (Only v1.4.7 supports Intel Wi-Fi on old macOS versions, or you can add `IO80211Family.kext` to the kext folder)

### OpenCore
- TM1701 & TM1707: Supports macOS10.13 ~ macOS12
  - **[v1.5.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.9) is the last EFI version that supports macOS High Sierra & Mojave**
- TM1905 & TM1963: Supports macOS10.15 ~ macOS12
-----
- **Software in Windows may lose activation due to different hardware UUID generated by OpenCore**
  - According to [OpenCore Official Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf), you can try to inject the original firmware UUID to `PlatformInfo - Generic - SystemUUID` in `/OC/config.plist`
- Should Clean NVRAM after using Clover
  - Press `Space` in OpenCore boot page, and then select `Reset NVRAM` entry
- Limited theme
- **Recommend Reading: [Security and FileVault | OpenCore Post-Install](https://dortania.github.io/OpenCore-Post-Install/universal/security.html) and [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf)**, especially the **UEFI Secure Boot** section


## Installation

### Identify Your Model

If you are using XiaoMi-Pro with **8th Gen** CPU, then it's a **KBL** (Kaby Lake) machine. (Actually Kaby Lake Refresh)  
If you are using XiaoMi-Pro with **10th Gen** CPU, then it's a **CML** (Comet Lake) machine.  
You will need this information when you download the [EFI release](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases).


### First-time installation

- Please refer to the following installation tutorials
  - [Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)
  - [Xiaomi Mi Notebook Pro MacOS Catalina Installation Guide || ENGLISH](https://bit.ly/34biTqw)
- or video tutorials
  - [Xiaomi NoteBook PRO HACKINTOSH INSTALLATION GUIDE !!!](https://www.youtube.com/watch?v=72sPmkpxCvc)
  - [GUIA HACKINTOSH ESPAÑOL 2020 || Instalación de macOS Catalina Xiaomi Mi Notebook Pro](https://www.youtube.com/watch?v=rfG4sGwhE2g)
- If the trackpad doesn't work during the installation, please plug a wired mouse or a wireless mouse projector before the installation. After the installation completes, open `Terminal.app` and run `sudo kextcache -i /`. Wait for the process ending and restart the device. Enjoy your trackpad!
- Complete EFI packs are available in the [releases](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases) page.
 - Please don't clone or download the main branch for daily use.
 
 <img src="Docs/img/README_donot_Clone_or_Download.jpg" width="300px" alt="donot_clone_or_download">
 <img src="Docs/img/README_get_Release.jpg" width="300px" alt="get_release">


### Build

Build the latest beta EFI by running the following command in Terminal:
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/main/makefile.sh)"
```
Or run the following command in Terminal:
```shell
git clone --depth=1 https://github.com/daliansky/XiaoMi-Pro-Hackintosh.git
cd XiaoMi-Pro-Hackintosh
./makefile.sh
```
Some advanced usages are:
```shell
# Build EFI with kexts and OpenCore in Debug version
./makefile.sh --debug_KextOC
# Ignore errors when the script is running
./makefile.sh --ignore_err
# Bundled with Chinese verison Docs
./makefile.sh --lang=zh_CN
# Generate EFI release for Comet Lake model
./makefile.sh --model=CML
# Preserve work files during the building stage
./makefile.sh --no_clean_up
# Use GitHub API
./makefile.sh --gh_api
# Build the latest beta EFI with pre-release kexts
./makefile.sh --pre_release=Kext
# Build the latest beta EFI with pre-release OpenCore
./makefile.sh --pre_release=OC
```


### Upgrade
- If you are using XiaoMi-Pro with **8th Gen** CPU, then it's a **KBL** (Kaby Lake) machine. (Actually Kaby Lake Refresh)
- If you are using XiaoMi-Pro with **10th Gen** CPU, then it's a **CML** (Comet Lake) machine.
-----
- Download the latest EFI release from the [release page](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases) or beta EFI release from artifacts in the [action page](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/actions).
- A complete replacement of `BOOT` and `CLOVER`(or `OC`) folders is required. Delete these two folders and copy them from the [release pack](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases).


## Improvements

- Use [Hackintool](https://github.com/headkaze/Hackintool) to inject EDID (AAPL00,override-no-connect)
- Change `#enable-backlight-smoother` to `enable-backlight-smoother` in `config.plist` to adjust the panel brightness smoothly
- Use [xzhih](https://github.com/xzhih)'s [one-key-hidpi](https://github.com/xzhih/one-key-hidpi) to improve quality of system UI
  - Support 1424x802 HiDPI resolution
  - TM1701: On macOS > 10.13.6, to enable higher HiDPI resolution (<=1520x855), you need to use [DVMT_and_0xE2_fix](BIOS/TM1701/DVMT_and_0xE2_fix) to set DVMT to 64mb
- Add `forceRenderStandby=0` in `config - NVRAM - Add - 7CXXX - boot-args` (OpenCore) or `config - Boot - Arguments` (Clover) if NVMe Kernel Panic CSTS=0xffffffff occurs
- Use [NVMeFix](https://github.com/acidanthera/NVMeFix) to enable APST on NVMe SSDs
- TM1701 & TM1707: Use [ALCPlugFix](ALCPlugFix) to fix unworking jack after replug
- TM1701: Use [DVMT_and_0xE2_fix](BIOS/TM1701/DVMT_and_0xE2_fix) to set DVMT to 64mb and unlock CFG


## FAQ

#### I can't click to drag or right click using the trackpad.

Starts from [VoodooI2C v2.4.1](https://github.com/alexandred/VoodooI2C/releases/tag/2.4.1), the click down action is emulated to force touch, which causes the failure of click down and drag and right click gestures. You can turn off `Force Click` in `SysPref - Trackpad`, and I recommend enabling `three finger drag` in `SysPref - Accessibility - Mouse & Trackpad - Trackpad Options`.

#### My screen turns to black and has no response during the updating process.

If you have black screen for five minutes and get no response from the device, please force restart your laptop(Long press power button) and choose `Boot macOS Install from ~` entry.

#### Stuck on Apple logo or fail to boot.

A reset of NVRAM is recommended. For Clover users, press `Fn+F11` when you are in Clover boot page.  
For OC users, press `Space` key when you are in OpenCore boot page and choose `Reset NVRAM`. If this does not work, you can try to set `SecureBootModel` to `Disabled` in `config.plist`.  
For Clover users, try to delete `HWTarget` in `config.plist`.

#### My device is locked by `Find My Mac` and can't be booted, what should I do now?

For Clover users, press `Fn+F11` when you are in Clover boot page. Then Clover will refresh `nvram.plist`, and lock message should be removed.  
For OC users, press `Esc` to enter the boot menu during startup. Then, press `Space` key and choose `Reset NVRAM`.

#### [Clover] I opened the `FileVault`, and I can't find macOS partition in Clover boot page, how can I solve it?

It is not recommended to open `FileVault`. You can press `Fn+F3` in the Clover boot page and choose the icon with `FileVault`. Then you can boot in the system and close `FileVault`.

#### [OC] How to skip the boot menu and automatically boot into the system?

First, in macOS, open `SysPref - Startup Disk`. Choose the target system.  
Then, open `/EFI/OC/config.plist`, and turn off `ShowPicker`.  
When you want to switch OS, press `Esc` during startup to call the boot menu.

#### [OC] How to enable startup chime? (TM1701 & TM1707)

Change `#AudioDxe.efi` to `AudioDxe.efi` in `config.plist - UEFI - Drivers`.  
Enable `AudioSupport` in `config.plist - UEFI - Audio`.  
If you are using macOS Big Sur, go to `SysPref - Sound` and turn on `Play sound on startup`.  
For macOS version  < Big Sur, open `Terminal.app` and run `sudo nvram StartupMute=%00`.

### Please refer to detailed FAQ in [wiki FAQ](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/wiki/FAQ).


## Changelog

You can view [Changelog](Changelog.md) for detailed information.


## Credits

- Thanks to [0xFireWolf](https://github.com/0xFireWolf) for providing [RealtekCardReader](https://github.com/0xFireWolf/RealtekCardReader) and [RealtekCardReaderFriend](https://github.com/0xFireWolf/RealtekCardReaderFriend).
- Thanks to [Acidanthera](https://github.com/acidanthera) for providing [AppleALC](https://github.com/acidanthera/AppleALC), [BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM), [HibernationFixup](https://github.com/acidanthera/HibernationFixup), [Lilu](https://github.com/acidanthera/Lilu), [NVMeFix](https://github.com/acidanthera/NVMeFix), [OcBinaryData](https://github.com/acidanthera/OcBinaryData), [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg), [RestrictEvents](https://github.com/acidanthera/RestrictEvents), [VirtualSMC](https://github.com/acidanthera/VirtualSMC), [VoodooInput](https://github.com/acidanthera/VoodooInput), [VoodooPS2](https://github.com/acidanthera/VoodooPS2), and [WhateverGreen](https://github.com/acidanthera/WhateverGreen).
- Thanks to [agasecond](https://github.com/agasecond) and [htmambo](https://github.com/htmambo) for valuable suggestions on 10th Gen model.
- Thanks to [apianti](https://sourceforge.net/u/apianti), [blackosx](https://sourceforge.net/u/blackosx), [blusseau](https://sourceforge.net/u/blusseau), [dmazar](https://sourceforge.net/u/dmazar), and [slice2009](https://sourceforge.net/u/slice2009) for providing [Clover](https://github.com/CloverHackyColor/CloverBootloader).
- Thanks to [daliansky](https://github.com/daliansky) for providing [OC-little](https://github.com/daliansky/OC-little).
- Thanks to [FallenChromium](https://github.com/FallenChromium), [jackxuechen](https://github.com/jackxuechen), [Javmain](https://github.com/javmain), [johnnync13](https://github.com/johnnync13), [IlikemacOS](https://github.com/IlikemacOS), [ManuGithubSteam](https://github.com/ManuGithubSteam), [MarFre22](https://github.com/MarFre22), [Menchen](https://github.com/Menchen), [Pasi-Studio](https://github.com/Pasi-Studio), [qeeqez](https://github.com/qeeqez), and [williambj1](https://github.com/williambj1) for valuable suggestions on 8th Gen model.
- Thanks to [hieplpvip](https://github.com/hieplpvip) and [syscl](https://github.com/syscl) for providing samples of DSDT patches.
- Thanks to [OpenIntelWireless](https://github.com/OpenIntelWireless) for providing [AirportItlwm](https://github.com/OpenIntelWireless/itlwm) and [IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware).
- Thanks to [RehabMan](https://github.com/RehabMan) for providing [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config), [OS-X-Null-Ethernet](https://github.com/RehabMan/OS-X-Null-Ethernet), and [SATA-unsupported](https://github.com/RehabMan/hack-tools/tree/master/kexts/SATA-unsupported.kext).
- Thanks to [RehabMan](https://github.com/RehabMan) and [Sniki](https://github.com/Sniki) for providing [EAPD-Codec-Commander](https://github.com/Sniki/EAPD-Codec-Commander).
- Thanks to [VoodooI2C](https://github.com/VoodooI2C) for providing [VoodooI2C](https://github.com/VoodooI2C/VoodooI2C).

### For more detail, please go to [Reference page](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/wiki/References).


## Support and discussion

Mi Notebooks supported by other projects:
  - [Mi-Gaming-Laptop](https://github.com/johnnync13/XiaomiGaming) by [johnnync13](https://github.com/johnnync13)
  - [Mi-NB-Air-125-6y30](https://github.com/johnnync13/EFI-Xiaomi-Notebook-air-12-5) by [johnnync13](https://github.com/johnnync13)
  - [Mi-NB-Air-125-7y30](https://github.com/influenist/Mi-NB-Gaming-Laptop-MacOS) by [influenist](https://github.com/influenist)
  - [Mi-NB-Air-133-Gen1](https://github.com/johnnync13/Xiaomi-Notebook-Air-1Gen) by [johnnync13](https://github.com/johnnync13)
  - [Mi-NB-Air-133-2018](https://github.com/johnnync13/Xiaomi-Mi-Air) by [johnnync13](https://github.com/johnnync13)

tonymacx86.com:
  - [[Guide] Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)

QQ:
  - 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  - 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)
  - 689011732 [小米笔记本Pro黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=dde06295030ea1692d6655564e392d86ad874bd0608afd7d408c347d1767981b)

# XiaoMi NoteBook Pro for macOS Mojave & High Sierra

Hackintosh your XiaoMi Pro Notebook

[English](README.md) | [中文](README-CN.md)

## Features

* Support 10.13.x and 10.14.
* ACPI fixes use hotpatch; related files are located in `/CLOVER/ACPI/patched`.

### Audio
* The model of the sound card is `Realtek ALC298`, which is drived by `AppleALC` on layout-id 99; injection information is located in `/CLOVER/config.plist`. 
* If headphones are not working, please download [ALCPlugFix](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/ALCPlugFix) folder, run `install.command`, and restart to patch the audio driver. You may need to replug the headphone after every boot.
* Some i5 devices may fail to drive microphone, please follow instructions in [#13](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/13).
    
### Bluetooth
* Native Bluetooth is [not working well](https://github.com/daliansky/XiaoMi-Pro/issues/50). The model is `Intel® Dual Band Wireless-AC 8265`. There are two options you can do with it:
    * Disable it to save power or use a BT dongle. Please read instructions here: [#24](https://github.com/daliansky/XiaoMi-Pro/issues/24).
    * Buy and insert a supported wireless card in M.2 slot and carefully solder D+ and D- wires to the WLAN_LTE slot. After that, please replace the archive in [#7](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/7).

### CPU
* The model is `i5-8250U` or `i7-8550U`, and XCPM power management is native supported. 
* XCPM and HWP are recommended to work together to reach better power management (>=10.13.6). Please replace `/CLOVER/kexts/Other/CPUFriendDataProvider.kext` with the archive in [#53](https://github.com/daliansky/XiaoMi-Pro/issues/53) to enable HWP.

### Graphics
* The model name is `Intel UHD Graphics 620`, faked to `Intel HD Graphics 620` by injecting ig-platform-id `00001659`.
* The discrete graphics' name is `NVIDIA GeForce MX150`, disabled by `SSDT-DDGPU.aml` becuase macOS doesn't support Optimus technology.
* Use HDMI port on the left side may cause black internal display, please try to reopen the lid.
* Native brightness hotkey support; related file is located in `/CLOVER/ACPI/patched/SSDT-LGPA.aml`.

### Keyboard
* Caps Lock may not function well, please read instructions in [#2](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/2) to uncheck `Use the Caps Lock key to switch to and from ABC`. 
* The latest keyboard driver can temporily disable the touchpad during typing. If you are not happy with the lag, a workaround is provided in [#19](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/19).

### SSD
* Recent model uses `PM981` SSD instead of `PM961`. This EFI doesn't fully support `PM981`, and `PM981` users can replace their SSDs or visit [How to fix PM981 in 10.3.3](https://www.tonymacx86.com/threads/how-to-fix-pm981-in-10-13-3-17d47.245063).
    * `PM981` SSD's serial number starts with `MZVLB`, and `PM961` SSD's serial number starts with `MZVLW`.

### Touchpad
* The model name is `ETD2303`(ELAN), and the driver is a patched verison of `VoodooI2C`, which has no scale problem or sleep issue.
* Don't forget to uncheck `Smart Zoom` in `SysPref - Trackpad - Scroll & Zoom` to help trackpad work better.

### USB
* USB Port Patching uses [Intel FB-Patcher](https://www.tonymacx86.com/threads/release-intel-fb-patcher-v1-4-1.254559), related file is located in `/CLOVER/kexts/Other/USBPower.kext`.
* SD Card Reader's model name is `RTS5129`. It is not supported and be disabled to save power.

### Wi-Fi
* The wireless model is `Intel® Dual Band Wireless-AC 8265`. Unfortunately, there's no way to enable it. You can follow [Intel WiFi Driver Effort](https://www.tonymacx86.com/threads/intel-wifi-driver-effort.186344) to check the latest progress.
* A workaround is to insert a supported wireless card into M.2 slot. More information can be viewed in [Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724).


## Q&A

### My device is locked by `Find My Mac` and can't be booted, what should I do now?

I believe there are many ways to solve this problem. I give a most understandable one here (at least for me). The solution is to refresh your BIOS in order to clean `nvram.plist`. Please read `How to update BIOS` in [BIOS folder](https://github.com/daliansky/XiaoMi-Pro/blob/master/BIOS/README.md).


### I opened the `FileVault` and I can't find macos partition in Clover boot page, how can I solve it?

It is not recommened to open `FileVault`. You can press Fn + F3 in the Clover boot page and choose the icon with `FileVault`. Then you can boot in the system and close `FileVault`.


### My touchpad isn't working after update.

You need to rebuild the kext cache after every system update. Use `Kext Utility.app` or type `sudo kextcache -i /` in `Terminal.app`. Then restart. If this still doesn't work, try to press F9.


## Credits

- [Acidanthera](https://github.com/acidanthera) Updated [AppleALC](https://github.com/acidanthera/AppleALC) and [CPUFriend](https://github.com/acidanthera/CPUFriend) and [HibernationFixup](https://github.com/acidanthera/HibernationFixup) and [Lilu](https://github.com/acidanthera/Lilu) and `USBPower` and [VirtualSMC](https://github.com/acidanthera/VirtualSMC) and [WhateverGreen](https://github.com/acidanthera/WhateverGreen) for maintenance

- [alexandred](https://github.com/alexandred) and [hieplpvip](https://github.com/hieplpvip) Updated [VoodooI2C](https://github.com/alexandred/VoodooI2C) for maintenance

- [apianti](https://sourceforge.net/u/apianti) and [blackosx](https://sourceforge.net/u/blackosx) and [blusseau](https://sourceforge.net/u/blusseau) and [dmazar](https://sourceforge.net/u/dmazar) and [slice2009](https://sourceforge.net/u/slice2009) Updated [Clover](https://sourceforge.net/projects/cloverefiboot) for maintenance

- [FallenChromium](https://github.com/FallenChromium) and [Javmain](https://github.com/javmain) and [johnnync13](https://github.com/johnnync13) for valuable suggestions

- [RehabMan](https://github.com/RehabMan) Updated [AppleBacklightFixup](https://github.com/RehabMan/AppleBacklightFixup) and [EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander) and [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) and [OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) and [SATA-unsupported](https://github.com/RehabMan/hack-tools/tree/master/kexts/SATA-unsupported.kext) for maintenance


## Installation

Please refer to the detailed installation tutorial [Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724) or video tutorial [Xiaomi NoteBook PRO HACKINTOSH INSTALLATION GUIDE !!!](https://www.youtube.com/watch?v=72sPmkpxCvc).

A complete EFI archive is available in [releases](https://github.com/daliansky/XiaoMi-Pro/releases) page,Thanks to the continuous update of [stevezhengshiqi](https://github.com/stevezhengshiqi).

If the tracpad doesn't work during installation, please plug a wired mouse or a wireless mouse projector before the installation. After the installation completes, open `Terminal.app` and type `sudo kextcache -i /`. Wait for the process ending and restart the device. Enjoy your trackpad!


## Changelog

You can view [Changelog](Changelog.md) for detailed information.


## A reward

All the project is made for free, but you can reward me if you want.

| Wechat                                                     | Alipay                                               |
| ---------------------------------------------------------- | ---------------------------------------------------- |
| ![wechatpay_160](http://7.daliansky.net/wechatpay_160.jpg) | ![alipay_160](http://7.daliansky.net/alipay_160.jpg) |


## Support and discussion

- tonymacx86.com:
  - [[Guide] Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)

- QQ:
  - 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  - 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)
  - 331686786 [一起吃苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)
  - 688324116 [一起黑苹果](https://shang.qq.com/wpa/qunwpa?idkey=6bf69a6f4b983dce94ab42e439f02195dfd19a1601522c10ad41f4df97e0da82)
  - 257995340 [一起啃苹果](http://shang.qq.com/wpa/qunwpa?idkey=8a63c51acb2bb80184d788b9f419ffcc33aa1ed2080132c82173a3d881625be8)

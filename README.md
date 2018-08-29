# XiaoMi NoteBook Pro for macOS Mojave & High Sierra

Hackintosh your XiaoMi Pro Notebook

[English](README.md) | [中文](README-CN.md)

## Features

* Support 10.13.x and 10.14.
* CPU native support. For people who want better performance (or longer battery life), please replace `/CLOVER/kexts/Other/CPUFriendDataProvider.kext` with the archive in [#53](https://github.com/daliansky/XiaoMi-Pro/issues/53).
* The model of the sound card is `Realtek ALC298`, which is drived by `AppleALC` in layout-id 99; injection information is located in `/CLOVER/config.plist`. If headphones are not working, please download [ALCPlugFix](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/ALCPlugFix) folder and run `install.command` to patch the audio driver.
* Touchpad driver is `VoodooI2C`, which supports multiple gestures without drift.
* Other ACPI fixes use hotpatch; related files are located in `/CLOVER/ACPI/patched`.
* USB power property injection and the custom SSDT for `USBInjectAll.kext` are located in `/CLOVER/ACPI/patched/SSDT-USB.aml`.
* Native Brightness hotkey support; related file is located in `/CLOVER/ACPI/patched/SSDT-LGPA.aml`.
* Native Bluetooth is [not working well](https://github.com/daliansky/XiaoMi-Pro/issues/50). The model is `Intel® Dual Band Wireless-AC 8265`. There are two options you can do with it:
    * Disable it to save power or use a BT dongle. Please read instructions here: [#24](https://github.com/daliansky/XiaoMi-Pro/issues/24).
    * Buy and insert a supported wireless card in M.2 slot and carefully solder D+ and D- wires to the WLAN_LTE slot. After that, please replace your `/CLOVER/ACPI/patched/SSDT-USB.aml` with the archive in [#7](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/7).


## Credits

- [RehabMan](https://github.com/RehabMan) Updated [AppleBacklightInjector](https://github.com/RehabMan/HP-ProBook-4x30s-DSDT-Patch/tree/master/kexts/AppleBacklightInjector.kext) and [EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander) and [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) and [OS-X-USB-Inject-All](https://github.com/RehabMan/OS-X-USB-Inject-All) and [OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) for maintenance

- [vit9696](https://github.com/vit9696) Updated [AppleALC](https://github.com/acidanthera/AppleALC) and [HibernationFixup](https://github.com/acidanthera/HibernationFixup) and [Lilu](https://github.com/acidanthera/Lilu) and [VirtualSMC](https://github.com/acidanthera/VirtualSMC) and [WhateverGreen](https://github.com/acidanthera/WhateverGreen) for maintenance

- [PMheart](https://github.com/PMheart) Updated [CPUFriend](https://github.com/PMheart/CPUFriend) for maintenance

- [alexandred](https://github.com/alexandred) and [hieplpvip](https://github.com/hieplpvip) Updated [VoodooI2C](https://github.com/alexandred/VoodooI2C) for maintenance

- [PavelLJ](https://github.com/PavelLJ) and [Javmain](https://github.com/javmain) and [johnnync13](https://github.com/johnnync13) for valuable suggestions


## Installation

Please refer to the detailed installation tutorial (Chinese version) [macOS安装教程兼小米Pro安装过程记录](https://blog.daliansky.net/MacOS-installation-tutorial-XiaoMi-Pro-installation-process-records.html).

A complete EFI archive is available [releases](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases) page,Thanks to the continuous update of [stevezhengshiqi](https://github.com/stevezhengshiqi/XiaoMi-Pro).

If the tracpad doesn't work during installation, please plug a wired mouse or a wireless mouse projector before the installation. After the installation completes, open `Terminal.app` and type `sudo kextcache -i /`. Wait for the process ending and restart the device. Enjoy your trackpad!


## Change Log:

- 10-14-2017
    
    - EFI update, touch pad is working


- 10-17-2017
    
    - EFI update, fixed graphics driver
    - Add HDMI Audio output
    - Driver Update:
        - `Lilu` v1.2.0
        - `AppleALC` v1.2.1
        - `IntelGraphicsDVMTFixup` v1.2.0
        - `AirportBrcmFixup` v1.1.0
    - Driver repair:
        - `IntelGraphicsFixup` v1.2.0


- 10-18-2017

    - tested graphics driver is not as good as the first version, now the graphics driver is restored to fake 0x19160000
    - ACPI repair
    - Driver fixes
    - Remove `USBInjectAll` with `SSDT-UIAL.aml` built-in USB device


- 10-19-2017

    - Graphics driver is normal
    - The touchpad turns on normally, multi-gestures are normal after waking up
    - normal sleep
    - Battery information is normal


- 10-31-2017

    - Update sound card driver, fix earphone problem
    - New driver to increase layoutid: 13
    - Supports four nodes to support the headset to switch freely, Mic / LineIn is working properly


- 11-2-2017
    
    - `Lilu` v1.2.0 update, support 10.13.2Beta
    - `AppleALC` update, using the latest revision of Lilu co-compiler to solve 10.13.1 update can not be driven after the problem


- 11-5-2017

    - Integrate `AppleALC_ALC298_id13_id28.kext` driver to EFI
    - Add EFL directory ALCPlugFix directory, please enter the ALCPlugFix directory after the installation is complete, double-click the `install.command` to automatically install. Command Install the headset plug-in state correction daemon
    - Fixed Drivers64UEFI to solve the problem that can not be installed
    - Updated `apfs.efi` to version 10.13.1


- 11-7-2017
    
    - `Lilu` v1.2.1 is not stable at the moment, with the risk of inability to enter the system, so downgrade to v1.2.0
    - `AppleALC` downgraded to V1.2.0
       **EFI temporarily does not support macOS 10.13.2Beta version of the installation, Lilu does not exhaust will continue to update**


- 1-25-2018
    
    - Support for 10.13.x installation
    - Updated `VoodooI2C` to version 2.0.1, supports multi-gestures, touchpad boot can be used normally, no drift, no wakeup
    - Fixed the issue of percentage refreshes
    - Fix sound card sleep wake up soundless problem
    - Fixed screen brightness can not be saved problem
    - Updated `Lilu` v1.2.2
    - Updated `AppleALC` v1.2.2 support millet pro, injection ID: 99
    - Update `IntelGraphicsFixup` v1.2.3   


- 4-8-2018
  
    - Support for 10.13.4 installation
    - Updated `ACPIBatteryManager` v1.81.4
    - Updated `AppleALC` v1.2.6
    - Updated `FakeSMC` v6.26-344-g1cf53906.1787
    - Updated `IntelGraphicsDVMTFixup` v1.2.1
    - Updated `IntelGraphicsFixup` v1.2.7, no need kexts for faking Intel Graphics' ID
    - Updated `Lilu` v1.2.3
    - Updated `Shiki` v2.2.6
    - Updated `USBInjectAll` v0.6.4
    - Add `AppleBacklightInjector` to widen the range of brightness
    - Add `CPUFriend` and `CPUFriendDataProvider` to enable native XCPM
    - Add boot flags `shikigva=1`, `igfxrst=1` and `igfxfw=1` to make the Graphics card more powerful and fix strange secondary boot interface.
    - Add `SSDT-LGPA.aml`, support native brightness hotkey


- 4-13-2018

    - Update `AppleALC` v1.2.7
    - Update `SSDT-IMEL.aml`, `SSDT-PTSWAK.aml`, `SSDT-SATA.aml`, `SSDT-XOSI.aml` from Rehabman's Github
    - Edit `SSDT-LPC.aml` to load native AppleLPC
    - Update `Clover` r4438


- 5-14-2018

    - Rename some SSDTs to fit with Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config. Also update `SSDT-GPRW.aml`, `SSDT-DDGPU.aml`, `SSDT-RMCF.aml` and `SSDT-XHC.aml`
    - Delete some useless renames in config and incorrect boot flag `shikigva=1`
    - Redo the USB Injection, now it supports type-c USB3.0
    - Delete `SSDT-ADBG.aml` since it's useless
    - Delete `SSDT-IMEI.aml` to avoid kernel error report(Graphics id is automatically injected by `IntelGraphicsFixup`)
    - Add `SSDT-EC.aml` and `SSDT-SMBUS.aml` to launch AppleBusPowerController and AppleSMBusPCI
    - Edit `SSDT-PCIList.aml` to let System Information.app show correct information
    - Update `Lilu` v1.2.4
    - Update `CPUFriendDataProvider` to save power
    - Update `Clover` r4458


- 7-27-2018
    
    - Update `Clover` r4625
    - Update `AppleALC` v1.3.1
    - Update `Lilu` v1.2.6
    - Update `CPUFriendDataProvider` by using MBP15,2's PM template to enable native HWP
    - Update `VoodooI2C` v2.0.3
    - Update `USBInjectAll` v0.6.6
    - Update `CodecCommander` v2.6.3 by merging `SSDT-MiPro_ALC298.aml`
    - Delete useless boot flags `igfxfw=1` and  `-disablegfxfirmware`
    - Edit `SSDT-PCIList.aml` to let `System Information.app` show more PCI devices
    - Use `WhateverGreen` to replace `IntelGraphicsFixup`, `Shiki` and `IntelGraphicsDVMTFixup`
    - Use `VoodooPS2Controller` to replace `ApplePS2SmartTouchPad`
    - Add minStolen Clover patch
    - Add support for Mojave (the installation instruction is at above)


- 8-9-2018
 
    - Update `Clover` r4641
    - Update `WhateverGreen` v1.2.1
    - Update `AppleALC`
    - Update `CPUFriendDataProvider` by using default EPP value to enhance performance
    - Update `Lilu`
    - Update `config.plist`, using AddProperties to replace minStolen Clover patch
    - Change AppleIntelFramebuffer@0's connertor-type from LVDS to eDP because MiPro uses eDP pin
    - No injection of ig-platform-id 0x12345678 by using `config_install.plist` anymore, `WhateverGreen` can help do this.
    - Mojave installation become easier


- 8-13-2018
    - Reverse back `CPUFriendProvider.kext` to the one in v1.2.2 because the one in v1.2.5 will cause KP in some devices in 10.13.3~10.13.5. If you want better CPU performance or better battery life, please read [#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)


## A reward

I don't need any reward. Good suggestions and ideas are welcomed.


## Support and discussion

- QQ群:
  - 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  - 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)
  - 331686786 [一起吃苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)
  - 688324116 [一起黑苹果](https://shang.qq.com/wpa/qunwpa?idkey=6bf69a6f4b983dce94ab42e439f02195dfd19a1601522c10ad41f4df97e0da82)
  - 257995340 [一起啃苹果](http://shang.qq.com/wpa/qunwpa?idkey=8a63c51acb2bb80184d788b9f419ffcc33aa1ed2080132c82173a3d881625be8)




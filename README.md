# XiaoMi NoteBook Pro for macOS High Sierra & Sierra

Hackintosh your XiaoMi Pro Notebook



## Features

* Support 10.13.x
  * CPU native support
  * video card fake support, platform-id is 0x19160000, injection information is loaded by /CLOVER/ACPI/patched/SSDT-Config.aml
  * The sound card is ALC298, fake with AppleALC, layout-id is 99, injection information is located at `/CLOVER/ACPI/patched/SSDT-Config.aml`
  * Touchpad driver using `VoodooI2C`, support for multiple gestures, touchpad boot can be used normally, no drift, no wakeup
  * Other ACPI patch fixes using hotpatch mode, file located in `/CLOVER/ACPI/patched`
  * USB shadowing using `/CLOVER/kexts/Other/USBInjectAll_patched.kext`
  * Native Brightness hotkey support, related file is located at `/CLOVER/ACPI/patched/SSDT-LGPA.aml`
  * Wider range of brightness.


## Credits

- [RehabMan](https://github.com/RehabMan) Updated [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) and [Laptop-DSDT-Patch](https://github.com/RehabMan/Laptop-DSDT-Patch) and [patch-nvme](https://github.com/RehabMan/patch-nvme) and [OS-X-USB-Inject-All](https://github.com/RehabMan/OS-X-USB-Inject-All) for maintenance

- [vit9696](https://github.com/vit9696) Updated [Lilu](https://github.com/vit9696/Lilu) and [AppleALC](https://github.com/vit9696/AppleALC) and [WhateverGreen](https://github.com/vit9696/WhateverGreen)  for maintenance

- [Pike R. Alpha](https://github.com/Piker-Alpha) Updated [ssdtPRGen.sh](https://github.com/Piker-Alpha/ssdtPRGen.sh) and [AppleIntelInfo](https://github.com/Piker-Alpha/AppleIntelInfo) and [HandyScripts](https://github.com/Piker-Alpha/HandyScripts) for maintenance

- [toleda](https://github.com/toleda), [Mirone](https://github.com/Mirone) and certain others for audio patches and layouts

- [PMheart](https://github.com/PMheart) Updated [CPUFriend](https://github.com/PMheart/CPUFriend) for maintenance

- [alexandred](https://github.com/alexandred) Updated [VoodooI2C](https://github.com/alexandred/VoodooI2C) for maintenance

- [PavelLJ](https://github.com/PavelLJ) for valuable suggestions


## Installation

Please refer to the detailed installation tutorial (Chinese version) [macOS安装教程兼小米Pro安装过程记录](https://blog.daliansky.net/MacOS-installation-tutorial-XiaoMi-Pro-installation-process-records.html).

A complete EFI archive is available [releases](https://github.com/daliansky/XiaoMi-Pro/releases) page.



## Change Log:

- 10-14-2017
   - EFI update, touch pad is working

- 10-17-2017
   - EFI update, fixed graphics driver
   - Add HDMI Audio output
   - Driver Update:
     - Lilu v1.2.0
     - AppleALC v1.2.1
     - IntelGraphicsDVMTFixup v1.2.0
     - AirportBrcmFixup v1.1.0
   - Driver repair:
     - IntelGraphicsFixup v1.2.0

- 10-18-2017
   - tested graphics driver is not as good as the first version, now the graphics driver is restored to fake 0x19160000
   - ACPI repair
       Driver fixes
   - Remove USBInjectAll with SSDT-UIAL.aml built-in USB device

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
   - Lilu v1.2.0 update, support 10.13.2Beta
   - AppleALC update, using the latest revision of Lilu co-compiler to solve 10.13.1 update can not be driven after the problem

- 11-5-2017
   - Integrate AppleALC_ALC298_id13_id28.kext driver to EFI
   - Add EFL directory ALCPlugFix directory, please enter the ALCPlugFix directory after the installation is complete, double-click the install double-click to automatically install. Command Install the headset plug-in state correction daemon
   - Fixed Drivers64UEFI to solve the problem that can not be installed
   - Updated apfs.efi to version 10.13.1

- 11-7-2017
   - Lilu v1.2.1 is not stable at the moment, with the risk of inability to enter the system, so downgrade to v1.2.0
   - AppleALC downgraded to V1.2.0
       **EFI temporarily does not support macOS 10.13.2Beta version of the installation, Lilu does not exhaust will continue to update**

- 1-25-2018
   - Support for 10.13.x installation
   - Updated VoodooI2C to version 2.0.1, supports multi-gestures, touchpad boot can be used normally, no drift, no wakeup
   - Fixed the issue of percentage refreshes
   - Fix sound card sleep wake up soundless problem
   - Fixed screen brightness can not be saved problem
   - Updated Lilu v1.2.2
   - Updated AppleALC v1.2.2 support millet pro, injection ID: 99
   - Update IntelGraphicsFixup v1.2.3   
- 4-8-2018
   - Support for 10.13.4 installation
   - Updated ACPIBatteryManager v1.81.4
   - Updated AppleALC v1.2.6
   - Updated FakeSMC v6.26-344-g1cf53906.1787
   - Updated IntelGraphicsDVMTFixup v1.2.1
   - Updated IntelGraphicsFixup v1.2.7, no need kexts for faking Intel Graphics' ID
   - Updated Lilu v1.2.3
   - Updated Shiki v2.2.6
   - Updated USBInjectAll v0.6.4
   - Add AppleBacklightInjector to widen the range of brightness
   - Add CPUFriend and CPUFriendDataProvider to enable native XCPM and HWP
   - Add boot parameters "shikigva=1", "igfxrst=1" and "igfxfw=1" to make the Graphics card more powerful and fix strange secondary boot interface.
   - Add SSDT-LGPA.aml, support native brightness hotkey
- 4-12-2018
   - Update AppleALC v1.2.7
   - Update SSDT-IMEL.aml, SSDT-PTSWAK.aml, SSDT-SATA.aml, SSDT-XOSI.aml from Rehabman's Github
   - Edit SSDT-LPC.aml to load native AppleLPC
   - Update Clover r4438

- 4-13-2018

   - Released Clover v2.4 r4438 XiaoMi PRO special installer

     ![Clover_v2.4k_r4438](http://7.daliansky.net/clover4438/2.png)

- 5-11-2018
   - Rename some SSDTs to fit with Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config. Also update SSDT-GPRW.aml, SSDT-DDGPU.aml, SSDT-RMCF.aml, SSDT-XHC.aml
   - Delete some useless renames in config
   - Redo the USB Injection, now it supports type-c USB3.0
   - Update Lilu v1.2.4
   - Update Clover r4458

## A reward

| Wechat                                   | Alipay                                   |
| ---------------------------------------- | ---------------------------------------- |
| ![wechatpay_160](http://ous2s14vo.bkt.clouddn.com/wechatpay_160.jpg) | ![alipay_160](http://ous2s14vo.bkt.clouddn.com/alipay_160.jpg) |

## Support and discussion

- QQ群:
  - 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  - 331686786 [一起吃苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)
  - 688324116 [一起黑苹果](https://shang.qq.com/wpa/qunwpa?idkey=6bf69a6f4b983dce94ab42e439f02195dfd19a1601522c10ad41f4df97e0da82)[群已满,请加其它群]
  - 257995340 [一起啃苹果](http://shang.qq.com/wpa/qunwpa?idkey=8a63c51acb2bb80184d788b9f419ffcc33aa1ed2080132c82173a3d881625be8)




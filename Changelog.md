# XiaoMi NoteBook Pro EFI Changelog

English | [中文](Changelog_CN.md)

## 10-14-2017

  - EFI update, trackpad is working


## 10-17-2017

  - EFI update, fixed graphics driver

### Update
  - Update `Lilu` v1.2.0
  - Update `AppleALC` v1.2.1
  - Update `IntelGraphicsDVMTFixup` v1.2.0
  - Update `AirportBrcmFixup` v1.1.0

### Add
  - Add HDMI Audio output

### Change
  - Fix `IntelGraphicsFixup` v1.2.0


## 10-18-2017

  - tested graphics driver is not as good as the first version, now the graphics driver is restored to fake 0x19160000

### Remove
  - Remove `USBInjectAll`, replace with `SSDT-UIAC.aml` to customize USB device

### Change
  - Fix ACPI
  - Fix Drivers


## 10-19-2017

  - Graphics driver is normal
  - The touchpad turns on normally, multi-gestures are normal after waking up
  - normal sleep
  - Battery information is normal


## 10-31-2017

  - Update sound card driver, fix earphone problem
  - New driver to add layout-id: 13
  - Support four nodes to support the headset to switch freely, Mic / LineIn is working properly


## 11-2-2017

### Update
  - Update `Lilu` v1.2.0, support 10.13.2Beta
  - Update `AppleALC`, using the latest revision of Lilu co-compiler to solve 10.13.1 update can not be driven after the problem


## 11-5-2017

### Update
  - Update `apfs.efi` to version 10.13.1

### Add
  - Add ALCPlugFix directory, please enter the ALCPlugFix directory after the installation is complete, double-click the `install.command` to automatically install. Command Install the headset plug-in state correction daemon

### Change
  - Integrate `AppleALC_ALC298_id13_id28.kext` driver to EFI
  - Fix Drivers64UEFI to solve the problem that can not be installed


## 11-7-2017

### Downgrade
  - Downgrade `Lilu` v1.2.0, because v1.2.1 is not stable at the moment and may fail to enter the system
  - Downgrade `AppleALC` v1.2.0


## [XiaoMi NoteBook Pro EFI v1.0.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.0.0)
## 1-25-2018

  - Support for 10.13.x installation

### Update
  - Update `Lilu` v1.2.2
  - Update `AppleALC` v1.2.2 to support XiaoMi-Pro, layout-id: 99
  - Update `IntelGraphicsFixup` v1.2.3
  - Update `VoodooI2C` to version 2.0.1, supports multi-gestures, touchpad boot can be used normally, no drift, no wakeup

### Change
  - Fix the issue of percentage refreshes
  - Fix sound card sleep wake up soundless problem
  - Fix screen brightness can not be saved problem


## [XiaoMi NoteBook Pro EFI v1.1.1](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.1.1)
## 4-8-2018

  - Support for 10.13.4 installation

### Update
  - Update `ACPIBatteryManager` v1.81.4
  - Update `AppleALC` v1.2.6
  - Update `FakeSMC` v6.26-344-g1cf53906.1787
  - Update `IntelGraphicsDVMTFixup` v1.2.1
  - Update `IntelGraphicsFixup` v1.2.7, no need kexts for faking Intel Graphics ID
  - Update `Lilu` v1.2.3
  - Update `Shiki` v2.2.6
  - Update `USBInjectAll` v0.6.4

### Add
  - Add `AppleBacklightInjector` to widen the range of brightness
  - Add `CPUFriend` and `CPUFriendDataProvider` to enable native XCPM and HWP power management
  - Add boot-args `shikigva=1`, `igfxrst=1` and `igfxfw=1` to make the Graphics card more powerful and fix strange secondary boot interface.
  - Add `SSDT-LGPA.aml`, support native brightness hotkey


## 4-13-2018

### Update
  - Update `Clover` r4438
  - Update `AppleALC` v1.2.7
  - Update `SSDT-IMEI.aml`, `SSDT-PTSWAK.aml`, `SSDT-SATA.aml`, `SSDT-XOSI.aml` from Rehabman's Github

### Change
  - Edit `SSDT-LPC.aml` to load native AppleLPC


## [XiaoMi NoteBook Pro EFI v1.2.2](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.2)
## 5-14-2018

### Update
  - Update `Clover` r4458
  - Update `Lilu` v1.2.4
  - Update `CPUFriendDataProvider` to save power

### Add
  - Add `SSDT-EC.aml` and `SSDT-SMBUS.aml` to launch AppleBusPowerController and AppleSMBusPCI

### Remove
  - Remove some useless renames in config and incorrect boot-args `shikigva=1`
  - Remove `SSDT-ADBG.aml` since it's useless
  - Remove `SSDT-IMEI.aml` to avoid kernel error report(Graphics id is automatically injected by `IntelGraphicsFixup`)

### Change
  - Rename some SSDTs to fit with Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config. Also update `SSDT-GPRW.aml`, `SSDT-DDGPU.aml`, `SSDT-RMCF.aml` and `SSDT-XHC.aml`
  - Redo the USB Injection, now it supports type-c USB3.0
  - Edit `SSDT-PCIList.aml` to let System Information.app show correct information


## [XiaoMi NoteBook Pro EFI v1.2.4](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.4)
## 7-27-2018

### Update
  - Update `Clover` r4625
  - Update `AppleALC` v1.3.1
  - Update `Lilu` v1.2.6
  - Update `CPUFriendDataProvider` by using MBP15,2's PM template to enable native HWP
  - Update `VoodooI2C` v2.0.3
  - Update `USBInjectAll` v0.6.6
  - Update `CodecCommander` v2.6.3 by merging `SSDT-MiPro_ALC298.aml`

### Add
  - Add minStolen Clover patch
  - Add support for Mojave
  - Add `WhateverGreen` to replace `IntelGraphicsFixup`, `Shiki` and `IntelGraphicsDVMTFixup`
  - Add `VoodooPS2Controller` to replace `ApplePS2SmartTouchPad`

### Remove
  - Remove useless boot-args `igfxfw=1` and  `-disablegfxfirmware`

### Change
  - Edit `SSDT-PCIList.aml` to let `System Information.app` show more PCI devices


## [XiaoMi NoteBook Pro EFI v1.2.5](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.5)
## 8-9-2018

  - Mojave installation become easier

### Update
  - Update `Clover` r4641
  - Update `WhateverGreen` v1.2.1
  - Update `AppleALC`
  - Update `CPUFriendDataProvider` by using default EPP value to enhance performance
  - Update `Lilu`
  - Update `config.plist`, using AddProperties to replace minStolen Clover patch

### Change
  - Edit `config.plist` to increase VRAM from 1536MB to 2048MB
  - Change AppleIntelFramebuffer@0's connertor-type from LVDS to eDP because MiPro uses eDP pin
  - No injection of ig-platform-id 0x12345678 by using `config_install.plist` anymore, `WhateverGreen` can help do this.


## [XiaoMi NoteBook Pro EFI v1.2.6](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.6)
## 8-13-2018

### Change
  - Reverse back `CPUFriendProvider.kext` to the one in v1.2.2 because the one in v1.2.5 will cause KP in some devices in 10.13.3~10.13.5. If you want better CPU performance or better battery life, please read [#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)


## [XiaoMi NoteBook Pro EFI v1.2.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.7)
## 9-15-2018

### Update
  - Update `Clover` r4671
  - Update  `WhateverGreen` v1.2.3
  - Update `AppleALC` v1.3.2
  - Update `CPUFriend` v1.1.5
  - Update `Lilu` v1.2.7
  - Update `USBInjectAll` v0.6.7
  - Update `SSDT-GPRW.aml` and `SSDT-RMCF.aml` from Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config
  - Update `SSDT-PCIList.aml` to add more Properties in PCI0 devices

### Add
  - Add `SSDT-DMAC.aml` , `SSDT-MATH.aml` , `SSDT-MEM2.aml` , and `SSDT-PMCR.aml` to enhace performance like a real Mac. Inspired by [syscl](https://github.com/syscl/XPS9350-macOS/tree/master/DSDT/patches)
  - Add `HibernationFixup` to enable time setting in `System Preferences - Energy Saver`
  - Add `VirtualSMC` to replace `FakeSMC`. You can get more CPU Core Information by using `iStat Menus`, and more SMC keys are added in nvram.

### Remove
  - Remove VRAM 2048MB patch in `config.plist`, the actual VRAM isn't affected by this patch

### Change
  - Drop useless ACPI tables in `config.plist`
  - Reverse AppleIntelFramebuffer@0's connertor-type to default value


## [XiaoMi NoteBook Pro EFI v1.2.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.8)
## 9-28-2018

### Downgrade
  - Downgrade [`Clover` r4658.RM-4903.ca9576f3](https://github.com/RehabMan/Clover) because Rehabman's version is more reliable

### Update
  - Update `WhateverGreen`, `AppleALC`, `Lilu`, `CPUFriend`, and `HibernationFixup` by using official release
  - Update `AppleBacklightInjector` to support HD630
  - Update `SSDT-PNLF.aml` to support HD630
  - Update `VoodooI2C*` v2.1.4. (This driver is a patched version from [official release](https://github.com/alexandred/VoodooI2C/releases), the official one has scalling issue.)
  - Update `VoodooPS2Controller` v1.9.0 to stop trackpad when using keyboard
  - Update headers in hotpatch

### Add
  - Add `USBPower` to replace `USBInjectAll` and `SSDT-USB.aml`

### Remove
  - Remove `SSDT-MATH.aml`, replace with `MATH._STA -> XSTA` rename

### Change
  - Clean code in `config.plist`


## [XiaoMi NoteBook Pro EFI v1.2.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.9)
## 12-26-2018

### Update
  - Update `Clover` r4821
  - Update `VoodooPS2Controller` v1.9.2
  - Update `CodecCommander` v2.7.1
  - Update `Lilu` v1.2.9
  - Update `AppleALC` v1.3.4
  - Update `WhateverGreen` v1.2.6
  - Update `VirtualSMC` v1.0.2
  - Update `USBPower` to `USBPorts`
  - Update `SSDT-PNLF`, `SSDT-LGPA`, `SSDT-RMCF`, and `SSDT-PTSWAK`
  - Update `VoodooI2C` to the latest commit
  - Update `MATH._STA -> XSTA` rename to `MATH._STA and LDR2._STA -> XSTA` rename

### Add
  - Add back Trim patch to `config.plist`
  - Add argument `RtcHibernateAware` according to [Official Explanations](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?page=5)
  - Add `SATA-unsupported` to replace `SSDT-SATA`
  - Add `SSDT-HPET` to behave more like a real Mac
  - Add `SSDT-LGPAGTX` to let GTX version works better (GTX users need to replace `SSDT-LGPA` with `SSDT-LGPAGTX`)
  - Add IRQ fixes in `config.plist`

### Remove
  - Remove `SSDT-ALS0`
  - Remove `AppleBacklightInjector` because `WhateverGreen` includes it
  - Remove tgtbridge because it has problem
  - Remove `HighCurrent` argument

### Change
  - Move PCI Information from `SSDT-PCIList` to `config.plist`
  - Change layout-id's datatype
  - Clean up `config.plist`
  - Clean up SSDTs' formats


## [XiaoMi NoteBook Pro EFI v1.3.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.0)
## 2-10-2019

### Update
  - Update `Clover` r4871
  - Update `Lilu` v1.3.1
  - Update `AppleALC` v1.3.5
  - Update `SSDT-PXSX`

 ### Add
  - Add `SSDT-RTC` to remove IRQFlags safely, `FixRTC` will shorten the IO length

### Remove
  - Remove `CPUFriend*` because different macOS version have different plists in `/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/`. Use [one-key-cpufriend](one-key-cpufriend/README.md) to customize kext is recommended
  - Remove `HibernationFixup` because it's not stable, `RtcHibernateAware` is may enough for device to hibernate
  - Remove `dart=0`
  - Remove `AddClockID`, because it doesn't make a difference in new macOS version

### Change
  - Change layout-id to 30


## [XiaoMi NoteBook Pro EFI v1.3.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.1)
## 3-1-2019

### Update
  - Update `Clover` r4892
  - Update `USBPorts` to support more models

### Remove
  - Remove `SSDT-PNLF` and replace with `AddPNLF` argument as suggested in [WhateverGreen FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#adjusting-the-brightness-on-a-laptop)
  - Remove `RtcHibernateAware` and replace with `NeverHibernate`. Sleep will consume more battery. Only after unlocking CFG then `RtcHibernateAware` could work properly

### Change
  - Change `igfxrst=1` to `gfxrst=1` according to [WhateverGreen README](https://github.com/acidanthera/WhateverGreen/blob/master/README.md)


## [XiaoMi NoteBook Pro EFI v1.3.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.2)
## 3-28-2019

### Update
  - Update `Clover` r4910
  - Update `AppleALC` v1.3.6
  - Update `WhateverGreen` v1.2.8
  - Update `Lilu` v1.3.5
  - Update `VoodooPS2`
  - Update `USBPorts` and merge `SSDT-USBX`

### Remove
  - Remove `SSDT-PTSWAK` because Xiaomi-Pro doesn't need it
  - Remove `SMCSuperIO.kext` because it failed to detect supported SuperIO chip

### Change
  - Edit hotpatches to fit ACPI 6.3 standard
  - Change `AppleRTC` back to true and `InjectKexts` mode to `Detect`


## [XiaoMi NoteBook Pro EFI v1.3.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.3)
## 4-16-2019

### Update
  - Update `Clover` r4920
  - Update `AppleALC` v1.3.7
  - Update `WhateverGreen`
  - Update `VoodooPS2`
  - Update `VoodooI2C` v2.1.6

### Remove
  - Remove `SSDT-RTC` and replace with `Rtc8Allowed` and `FixRTC`


## [XiaoMi NoteBook Pro EFI v1.3.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.4)
## 7-10-2019

  - Support macOS10.15

### Update
  - Update `Clover` r4986
  - Update `Lilu` v1.3.7
  - Update `AppleALC` v1.3.9
  - Update `WhateverGreen` v1.3.1
  - Update `VirtualSMC` v1.0.6
  - Update and edit `VoodooPS2` v2.0.2 to avoid F11 disabling trackpad
  - Update `VoodooI2C`
  - Update Device Properties obtained by `Hackintool`
  - Update `SSDT-MEM2`
  - Update `SSDT-HPET`
  - Update comments in `config.plist` using `Hackintool` style

### Add
  - Add `OpenCore`
  - Add `SSDT-TPD0` to solve unworking trackpad after removing `SSDT-XOSI` and  `_OSI -> XOSI`
  - Add back `SSDT-ALS0` to ensure backlight can be preserved
  - Add back `HibernationFixup`
  - Add `enable-hdmi-dividers-fix` properties for HDMI

### Remove
  - Remove `GFX0 -> IGPU`, `HECI -> IMEI`, and `HDAS -> HDEF` according to [WhateverGreen FAQ.IntelHD.en.md](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#general-recommendations)
  - Remove `SSDT-XOSI` and  `_OSI -> XOSI` because as [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) says, "Avoid patching _OSI to support a higher level of feature sets unless absolutely required. Commonly this enables a number of hacks on APTIO firmwares, which result in the need to add more patches. Modern firmwares generally do not need it at all, and those that do are fine with much smaller patches."
  - Remove `_DSM -> XDSM` because as [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) says, "Try to avoid hacky changes like renaming _PRW or _DSM whenever possible."
  - Remove `SAT0 -> SATA`
  - Remove IRQ fixes due to [OpenCore discussion](https://www.insanelymac.com/forum/topic/338516-opencore-discussion/?do=findComment&comment=2675659), "...but be very careful about the IRQs, some people remove them, yet this is usually strongly undesired."
  - Remove `SSDT-DDGPU` because `disable-external-egpu` does the same thing
  - Remove `SSDT-PXSX` and move device properties to `config.plist`
  - Remove `Drop DRAM` and replace with `dart=0`
  - Remove `AppleKeyFeeder.efi` and `DataHubDxe-64.efi` which XiaoMi-Pro doesn't need
  - Remove `USBPorts.kext` and replace with `SSDT-USB`, according to [#197](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/197)


## [XiaoMi NoteBook Pro EFI v1.3.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.5)
## 7-17-2019

### Update
  - Update `Clover` r5018
  - Update `OpenCore` v0.0.4
  - Update `WhateverGreen` to improve HDMI
  - Update `SSDT-LGPA`
  - Update `SSDT-TPD0`

### Add
  - Add `TPD0._INI -> XINI` and `TPD0._CRS -> XCRS`, pair with `SSDT-TPD0`

### Remove
  - Remove `enable-hdmi-dividers-fix`

### OC
  - [OC] Update config to support `OpenCore` v0.0.4


## [XiaoMi NoteBook Pro EFI v1.3.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.6)
## 3-10-2020

### Update
  - Update `Clover` r5104
  - Update `OpenCore` v0.5.6
  - Update `Lilu` v1.4.2
  - Update `AppleALC` v1.4.7
  - Update `WhateverGreen` v1.3.7
  - Update `HibernationFixup` v1.3.2
  - Update `VirtualSMC` v1.1.1
  - Update `VoodooPS2` v2.1.2
  - Update `AppleSupportPkg` v2.1.6
  - Update `VoodooI2C` v2.3
  - Update `SSDT-USB`
  - Update `SSDT-MCHC`

### Add
  - Add `IntelBluetoothFirmware` and `IntelBluetoothInjector` to support native Intel Bluetooth
  - Add `SSDT-DRP08` to disable Intel Wireless Card
  - Add `SSDT-PS2K` to customize `VoodooPS2Keyboard` instead of directly editing `info.plist`
  - Add `complete-modeset-framebuffers` property to improve HDMI
  - Add `EFICheckDisabler`
  - Add `NVMeFix`
  - Add back `SSDT-DDGPU` to disable discrete graphics card instead of using `disable-external-egpu`

### Remove
  - Remove AppleIntelLpssI2C patches because https://github.com/alexandred/VoodooI2C/commit/c6e3c278cda84a26f400a77f5ea57d819df9e405 solved the race problem

### Change
  - Change layout-id back to 30

### Clover
  - [Clover] Add `PanicNoKextDump` to replace panic kext logging patches

### OC
  - [OC] Update config to support `OpenCore` v0.5.6


## [XiaoMi NoteBook Pro EFI v1.3.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.7)
## 3-25-2020

### Update
  - Update `Clover` r5107 to support macOS10.15.4
  - Update `USBInjectAll` v0.7.3 from [Sniki's fork](https://github.com/Sniki/OS-X-USB-Inject-All/releases)
    - The origin [Rehabman's fork](https://github.com/RehabMan/OS-X-USB-Inject-All) does not update a long time ago
  - Update `SSDT-USB`
    - Our type-c ports are with switch, so the `UsbConnector` should be `0x09`

### Clover
  - [Clover] Update `Xiaomi` theme to support Clover r5105+
  - [Clover] Add `setpowerstate_panic=0` kernel patch for macOS10.15 according to [Acidanthera/AppleALC#513](https://github.com/acidanthera/bugtracker/issues/513#issuecomment-542838126)
  - [Clover] Remove MSR 0xE2 patch because Clover can automatically patch

### OC
  - [OC] Update config to better support `OpenCore` v0.5.6


## [XiaoMi NoteBook Pro EFI v1.3.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.8)
## 4-10-2020

### Update
  - Update `Clover` r5109
  - Update `OpenCore` v0.5.7
  - Update `Lilu` v1.4.3
  - Update `AppleALC` v1.4.8
  - Update `VirtualSMC` v1.1.2
  - Update `WhateverGreen` v1.3.8
  - Update `NVMeFix` v1.0.2
  - Update `VoodooPS2` v2.1.3
  - Update `VoodooI2C` v2.4, support trackpad in Recovery mode, and no need to rebuild kextcache after system update
  - Update `IntelBluetoothFirmware` v1.0.3
  - Update `SSDT-TPD0`, based on [#365](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/365)
  - Update `SSDT-LGPA`

### Add
  - Add `VoodooInput`
  - Add `framebuffer-flags` property to support 1440x810 HiDPI resolution
  - Add `force-online` and `force-online-framebuffers` properties to fix HDMI on macOS10.15.4

### Remove
  - Remove `MATH._STA and LDR2._STA -> XSTA` rename
  - Remove `TPD0._INI -> XINI` and `TPD0._CRS -> XCRS` renames

### Clover
  - [Clover] Update `setpowerstate_panic=0` kernel patch for macOS10.15.4

### OC
  - [OC] Update config to support `OpenCore` v0.5.7


## [XiaoMi NoteBook Pro EFI v1.3.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.9)
## X-XX-2020

### Update
  - Update `SSDT-USB`
  - Update `framebuffer-flags` property

### Add
  - Add `UPC -> XUPC` rename

### Remove
  - Remove `SSDT-DRP08` to unlock Intel Wi-Fi
  - Remove `USBInjectAll`

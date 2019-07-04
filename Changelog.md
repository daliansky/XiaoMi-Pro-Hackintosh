# XiaoMi NoteBook Pro EFI Changelog

[English](Changelog.md) | [中文](Changelog_CN.md)

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
    - Edit `config.plist` to increase VRAM from 1536MB to 2048MB
    - Change AppleIntelFramebuffer@0's connertor-type from LVDS to eDP because MiPro uses eDP pin
    - No injection of ig-platform-id 0x12345678 by using `config_install.plist` anymore, `WhateverGreen` can help do this.
    - Mojave installation become easier


- 8-13-2018

    - Reverse back `CPUFriendProvider.kext` to the one in v1.2.2 because the one in v1.2.5 will cause KP in some devices in 10.13.3~10.13.5. If you want better CPU performance or better battery life, please read [#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)
    
    
- 9-15-2018

    - Update `Clover` r4671
    - Update  `WhateverGreen` v1.2.3
    - Update `AppleALC` v1.3.2
    - Update `CPUFriend` v1.1.5
    - Update `Lilu` v1.2.7
    - Update `USBInjectAll` v0.6.7
    - Update `SSDT-GPRW.aml` and `SSDT-RMCF.aml` from Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config
    - Update `SSDT-PCIList.aml` to add more Properties in PCI0 devices 
    - Add `SSDT-DMAC.aml` , `SSDT-MATH.aml` , `SSDT-MEM2.aml` , and `SSDT-PMCR.aml` to enhace performance like a real Mac. Inspired by [syscl](https://github.com/syscl/XPS9350-macOS/tree/master/DSDT/patches)
    - Add `HibernationFixup` to enable time setting in `System Preferences - Energy Saver`
    - Use `VirtualSMC` to replace `FakeSMC`. You can get more CPU Core Information by using `iStat Menus`, and more SMC keys are added in nvram.
    - Remove VRAM 2048MB patch in `config.plist`, the actual VRAM isn't affected by this patch
    - Drop useless ACPI tables in `config.plist`
    - Reverse  AppleIntelFramebuffer@0's connertor-type to default value


- 9-28-2018

    - Downgrade [`Clover` r4658.RM-4903.ca9576f3](https://github.com/RehabMan/Clover) because Rehabman's version is more reliable
    - Update `WhateverGreen`, `AppleALC`, `Lilu`, `CPUFriend`, and `HibernationFixup` by using official release
    - Update `AppleBacklightInjector` to support HD630
    - Update `SSDT-PNLF.aml` to support HD630
    - Update `VoodooI2C*` v2.1.4. (This driver is a patched version from [official release](https://github.com/alexandred/VoodooI2C/releases), the official one has scalling issue.)
    - Update `VoodooPS2Controller` v1.9.0 to stop trackpad when using keyboard
    - Update headers in hotpatch
    - Add `USBPower` to replace `USBInjectAll` and `SSDT-USB.aml`
    - Remove `SSDT-MATH.aml`
    - Clean code in `config.plist` 


- 12-26-2018

    - Add back Trim patch to `config.plist`
    - Add argument `RtcHibernateAware` according to [Official Explanations](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?page=5)
    - Add `SATA-unsupported` to replace `SSDT-SATA`
    - Add `SSDT-HPET` to behave more like a real Mac
    - Add `SSDT-LGPAGTX` to let GTX version works better (GTX users need to replace `SSDT-LGPA` with `SSDT-LGPAGTX`)
    - Add IRQ fixes in `config.plist`
    - Move PCI Information from `SSDT-PCIList` to `config.plist`
    - Update `VoodooPS2Controller` v1.9.2
    - Update `CodecCommander` v2.7.1
    - Update `Lilu` v1.2.9
    - Update `AppleALC` v1.3.4
    - Update `WhateverGreen` v1.2.6
    - Update `VirtualSMC` v1.0.2
    - Update `USBPower` to `USBPorts`
    - Update `SSDT-PNLF`, `SSDT-LGPA`, `SSDT-RMCF`, and `SSDT-PTSWAK`
    - Update `Clover` r4821
    - Update `VoodooI2C` to the latest commit
    - Remove `SSDT-ALS0`
    - Remove `AppleBacklightInjector` because `WhateverGreen` includes it
    - Remove tgtbridge because it has problem
    - Remove `HighCurrent` argument
    - Change layout-id's datatype
    - Clean up `config.plist`
    - Clean up SSDTs' formats


- 2-10-2019

    - Update `Clover` r4871
    - Update `Lilu` v1.3.1
    - Update `AppleALC` v1.3.5
    - Update `SSDT-PXSX`
    - Remove `CPUFriend*` because different macOS version have different plists in `/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/`. Use [one-key-cpufriend](one-key-cpufriend/README.md) to customize kext is recommended
    - Remove `HibernationFixup` because it's not stable, `RtcHibernateAware` is may enough for device to hibernate
    - Remove `dart=0`
    - Remove `AddClockID`, because it doesn't make a difference in new macOS version
    - Add `SSDT-RTC` to remove IRQFlags safely, `FixRTC` will shorten the IO length
    - Change layout-id to 30


- 3-1-2019

    - Update `Clover` r4892
    - Update `USBPorts` to support more models
    - Remove `SSDT-PNLF` and replace with `AddPNLF` argument as suggested in [WhateverGreen FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#adjusting-the-brightness-on-a-laptop)
    - Remove `RtcHibernateAware` and replace with `NeverHibernate`. Sleep will consume more battery. Only after unlocking CFG then `RtcHibernateAware` could work properly
    - Change `igfxrst=1` to `gfxrst=1` according to [WhateverGreen README](https://github.com/acidanthera/WhateverGreen/blob/master/README.md)


- 3-28-2019

    - Update `Clover` r4910
    - Update `AppleALC` v1.3.6
    - Update `WhateverGreen` v1.2.8
    - Update `Lilu` v1.3.5
    - Update `VoodooPS2`
    - Update `USBPorts` and merge `SSDT-USBX`
    - Edit hotpatches to fit ACPI 6.3 standard
    - Remove `SSDT-PTSWAK` because Xiaomi-Pro doesn't need it
    - Remove `SMCSuperIO.kext` because it failed to detect supported SuperIO chip
    - Change `AppleRTC` back to true and `InjectKexts` mode to `Detect`


- 4-16-2019

    - Update `Clover` r4920
    - Update `AppleALC` v1.3.7
    - Update `WhateverGreen`
    - Update `VoodooPS2`
    - Update `VoodooI2C` v2.1.6
    - Remove `SSDT-RTC` and replace with `Rtc8Allowed` and `FixRTC`


- X-XX-2019

    - Update `Clover` r4979
    - Update `Lilu` v1.3.7
    - Update `AppleALC` v1.3.9
    - Update `WhateverGreen` v1.3.0
    - Update `VirtualSMC` v1.0.5
    - Update and edit `VoodooPS2` v2.0.1 to avoid F11 disabling trackpad
    - Update `VoodooI2C`
    - Update Device Properties obtained by `Hackintool`
    - Update `SSDT-MEM2`
    - Update `SSDT-HPET`
    - Update comments in `config.plist` using `Hackintool` style
    - Remove `GFX0 -> IGPU`, `HECI -> IMEI`, and `HDAS -> HDEF` according to [WhateverGreen FAQ.IntelHD.en.md](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#general-recommendations)
    - Remove `SSDT-XOSI` and  `_OSI -> XOSI` because as [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) says, "Avoid patching _OSI to support a higher level of feature sets unless absolutely required. Commonly this enables a number of hacks on APTIO firmwares, which result in the need to add more patches. Modern firmwares generally do not need it at all, and those that do are fine with much smaller patches."
    - Remove `_DSM -> XDSM` because as [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) says, "Try to avoid hacky changes like renaming _PRW or _DSM whenever possible."
    - Remove IRQ fixes due to [OpenCore discussion](https://www.insanelymac.com/forum/topic/338516-opencore-discussion/?do=findComment&comment=2675659), "...but be very careful about the IRQs, some people remove them, yet this is usually strongly undesired."
    - Remove `SSDT-DDGPU` because `disable-external-egpu` does the same thing
    - Remove `SSDT-PXSX` and move device properties to `config.plist`
    - Remove `Drop DRAM` and replace with `dart=0`
    - Remove `AppleKeyFeeder.efi` and `DataHubDxe-64.efi` which XiaoMi-Pro doesn't need
    - Remove `USBPorts.kext` and replace with `SSDT-USB`
    - Add `SSDT-TPD0` to solve unworking trackpad after removing `SSDT-XOSI` and  `_OSI -> XOSI`
    - Add back `SSDT-ALS0` to ensure backlight can be preserved
    - Add back `HibernationFixup`
    - Add `enable-hdmi-dividers-fix` and `enable-lspcon-support` properties for HDMI, and needs testing...
    - Waiting for update of `SMCBatteryManager` to support 10.15b3...

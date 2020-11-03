# XiaoMi NoteBook Pro EFI 更新日志

[English](Changelog.md) | **中文**

## [XiaoMi NoteBook Pro EFI v1.4.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.7)
## 11-3-2020

### 移除
  * 移除 `AAPL,slot-name` 来支持 macOS11 上的 HEVC

### Clover
  * Clover: 新增 `AirportItlwm` 来支持原生英特尔 Wi-Fi


## [XiaoMi NoteBook Pro EFI v1.4.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.6)
## 11-2-2020

### 更新
  * 更新 `OpenCore` v0.6.3
  * 更新 `Lilu` v1.4.9
  * 更新 `VirtualSMC` v1.1.8
  * 更新 `AppleALC` v1.5.4
  * 更新 `WhateverGreen` v1.4.4
  * 更新 `HibernationFixup` v1.3.7
  * 更新 `VoodooPS2` v2.1.8
  * 更新 `VoodooI2C` v2.5.2

### Clover
  * Clover: 禁用 `RtcHibernateAware`，如果想提升休眠请手动打开

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.6.3
  * OC: 新增 `AirportItlwm` 来支持原生英特尔 Wi-Fi


## [XiaoMi NoteBook Pro EFI v1.4.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.5)
## 10-5-2020

### 更新
  * 更新 `OpenCore` v0.6.2
  * 更新 `Lilu` v1.4.8
  * 更新 `VirtualSMC` v1.1.7
  * 更新 `AppleALC` v1.5.3
  * 更新 `WhateverGreen` v1.4.3
  * 更新 `HibernationFixup` v1.3.6
  * 更新 `VoodooInput` v1.0.8
  * 更新 `VoodooPS2` v2.1.7
  * 更新 `VoodooI2C` v2.5.1

### 移除
  * 移除 `-shikioff` 因为需要 `Shiki` 来播放 DRM

### Clover
  * Clover: 新增回 `RtcHibernateAware` 来提升休眠
  
### OC
  * OC: 更新 config 来支持 `OpenCore` v0.6.2
  * OC: 禁用 macOS11.0+ 的 `IntelBluetoothInjector.kext` 来恢复启动速度
  * OC: 新增回 `Disable RTC wake scheduling` 补丁


## [XiaoMi NoteBook Pro EFI v1.4.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.4)
## 9-8-2020

### 更新
  * 更新 `Clover` r5122
  * 更新 `OpenCore` v0.6.1
  * 更新 `Lilu` v1.4.7
  * 更新 `VirtualSMC` v1.1.6
  * 更新 `AppleALC` v1.5.2
  * 更新 `WhateverGreen` v1.4.2
  * 更新 `HibernationFixup` v1.3.5
  * 更新 `VoodooI2C` v2.4.4（更新至 [VoodooI2C/VoodooI2C@3527ec3](https://github.com/VoodooI2C/VoodooI2C/commit/3527ec36d2f5860253544f39bec6f0998a7044e2)）
  * 更新 `SSDT-LGPAGTX`

### 新增
  * 新增 `-shikioff` 引导参数来禁用 `Shiki`

### 移除
  * 移除 `NVMeFix` 因为它不兼容部分 NVMe SSD

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.6.1
  * OC: 关闭 `Disable RTC wake scheduling` 补丁因为它可能导致 Intel Wi-Fi 唤醒后不工作


## [XiaoMi NoteBook Pro EFI v1.4.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.3)
## 8-3-2020

### 更新
  * 更新 `Clover` r5120
  * 更新 `OpenCore` v0.6.0
  * 更新 `Lilu` v1.4.6
  * 更新 `VirtualSMC` v1.1.5 来支持 macOS11.0 beta 3 (20A5323l)
  * 更新 `AppleALC` v1.5.1
  * 更新 `WhateverGreen` v1.4.1
  * 更新 `VoodooPS2` v2.1.6
  * 更新 `VoodooInput` v1.0.7
  * 更新 `NVMeFix` v1.0.3
  * 更新 `HibernationFixup` v1.3.4
  * 更新 `IntelBluetoothFirmware` v1.1.2
  * 更新 `SSDT-LGPA` 来修复睡眠唤醒后意外的键位触发

### Clover
  * Clover: 更新 config 来支持 `Clover` r5120
  * Clover: 移除 `SetIntelBacklight` 和 `SetIntelMaxBacklight` 因为我们使用 `SSDT-PNLF`

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.6.0


## [XiaoMi NoteBook Pro EFI v1.4.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.2)
## 7-16-2020

### 更新
  * 更新 `OpenCore` v0.6.0（更新至 [acidanthera/OpenCorePkg@20e60b0](https://github.com/acidanthera/OpenCorePkg/commit/20e60b0cbb273ea91a567440f0b7e230ecae3ec8)）
  * 更新 `Lilu` v1.4.6（更新至 [acidanthera/Lilu@28122d0](https://github.com/acidanthera/Lilu/commit/28122d0084dc5fe1b486bd52945160cf5be64d49)）
  * 更新 `VirtualSMC` v1.1.5（更新至 [acidanthera/VirtualSMC@fab53dc](https://github.com/acidanthera/VirtualSMC/commit/fab53dc600eef3b559c9a99b6cfd598c5f24927e)）来在 macOS11 上显示电量百分比
  * 更新 `AppleALC` v1.5.1（更新至 [acidanthera/AppleALC@f07c1f8](https://github.com/acidanthera/AppleALC/commit/f07c1f8c65270f58a50f96bac2588710d0ff7683)）
  * 更新 `WhateverGreen` v1.4.1（更新至 [acidanthera/WhateverGreen@b97c692](https://github.com/acidanthera/WhateverGreen/commit/b97c692aee9672786a181423dd476a05782ba7e9)）
  * 更新 `VoodooPS2` v2.1.6（更新至 [acidanthera/VoodooPS2@60a4566](https://github.com/acidanthera/VoodooPS2/commit/60a4566c237f9c39bf38122ec8c0910a388dbe9d)）

### Clover
  * Clover: 移除 `NoRomInfo` 键值

### OC
  * OC: 更新 config


## [XiaoMi NoteBook Pro EFI v1.4.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.1)
## 7-12-2020

### 更新
  * 更新 `OpenCore` v0.6.0（更新至 [acidanthera/OpenCorePkg@eee51ba](https://github.com/acidanthera/OpenCorePkg/commit/eee51bae932b5a366351e994ea2a1909c46c3ebf)）来支持 macOS11.0 beta 1 (20A4299v)
  * 更新 `Lilu` v1.4.6（更新至 [acidanthera/Lilu@8a81e92](https://github.com/acidanthera/Lilu/commit/8a81e92f5641f9eee333d348d39add4ecaef0b37)）
  * 更新 `AppleALC` v1.5.1（更新至 [acidanthera/AppleALC@df23c40](https://github.com/acidanthera/AppleALC/commit/df23c409d832449867263d4a5eb32aaa570935f3)）
  * 更新 `VirtualSMC` v1.1.5（更新至 [acidanthera/VirtualSMC@90b1f45](https://github.com/acidanthera/VirtualSMC/commit/90b1f45475c82566fe6533c03f4938594f17bb49)）
  * 更新 `WhateverGreen` v1.4.1（更新至 [acidanthera/WhateverGreen@39e3b55](https://github.com/acidanthera/WhateverGreen/commit/39e3b557fb55dcb0e38e6ecd05d217c780ba8a2c)）
  * 更新 `VoodooPS2` v2.1.6（更新至 [acidanthera/VoodooPS2@071850a](https://github.com/acidanthera/VoodooPS2/commit/071850a089de027dad3b1d372b3a2a53f5813016)）
  * 更新 `VoodooInput` v1.0.7（更新至 [acidanthera/VoodooInput@46a01f9](https://github.com/acidanthera/VoodooInput/commit/46a01f90c4c81cc193b57d523156cc035321e8ea)）
  * 更新 `VoodooI2C` v2.4.4（更新至 [VoodooI2C/VoodooI2C@451739c](https://github.com/VoodooI2C/VoodooI2C/commit/451739ce4a736fa8afb591f73ef45f7fec240960)）
  * 更新 `NVMeFix` v1.0.3（更新至 [acidanthera/NVMeFix@48a0fda](https://github.com/acidanthera/NVMeFix/commit/48a0fda97650fd6a7563d65e479421524685bcee)）
  * 更新 `HibernationFixup` v1.3.4（更新至 [acidanthera/HibernationFixup@bb49d28](https://github.com/acidanthera/HibernationFixup/commit/bb49d28c7dd5d379f8729121c92bd9ad98509245)）
  * 更新 `IntelBluetoothFirmware` v1.1.1
  * 更新 `SSDT-LGPA` 和 `SSDT-PS2K` 来支持原生截图键，镜像键，和调度中心键；映射 PrtScn 键到 F11，Insert 键到 F12，和双击 FN 键到 F13
    * 镜像键和调度中心键仅支持 MX150 BIOS 版本 >= 0A07

### 变更
  * 关闭 `FBEnableDynamicCDCLK` 因为它会造成休眠后黑屏；想开启大于 1424x802 HiDPI 分辨率的话请把 `framebuffer-flags` 设置为 `CwfjAA==`

### Clover
  * Clover: 新增 `OcQuirks.efi`，`OpenRuntime.efi` 和 `OcQuirks.plist` 来替代 `AptioMemoryFix.efi`
  * Clover: 新增 `NoRomInfo` 来隐藏 Apple ROM 信息

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.6.0


## [XiaoMi NoteBook Pro EFI v1.4.1 beta 1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.1-beta1)
## 6-14-2020

### 更新
  * 更新 `Clover` r5119
  * 更新 `VoodooI2C` v2.4.3

### Clover
  * 更新 `setpowerstate_panic=0` 内核补丁
  * 移除 `AudioDxe.efi`

### OC
  * 更新 config


## [XiaoMi NoteBook Pro EFI v1.4.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.0)
## 6-1-2020

### 更新
  * 更新 `Clover` r5118
  * 更新 `OpenCore` v0.5.9
  * 更新 `Lilu` v1.4.5
  * 更新 `AppleALC` v1.5.0
  * 更新 `VirtualSMC` v1.1.4
  * 更新 `WhateverGreen` v1.4.0
  * 更新 `VoodooPS2` v2.1.5
  * 更新 `SSDT-TPD0`
  * 更新 `SSDT-PS2K`
  * 更新 `SSDT-XCPM`

### 变更
  * 使用 `VoodooI2C` 内置的 `VoodooInput`

### Clover
  * Clover: 移除 `DropOEM_DSM` 因为 `Clover` r5117 移除了该键值
  * Clover: 回滚 `Xiaomi` 主题里的 font.png，因为 `Clover` r5116 修复了字体问题

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.5.9


## [XiaoMi NoteBook Pro EFI v1.3.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.9)
## 5-4-2020

### 更新
  * 更新 `Clover` r5115
  * 更新 `OpenCore` v0.5.8
  * 更新 `Lilu` v1.4.4
  * 更新 `AppleALC` v1.4.9
  * 更新 `WhateverGreen` v1.3.9
  * 更新 `HibernationFixup` v1.3.3
  * 更新 `VoodooInput` v1.0.5
  * 更新 `VoodooI2C` v2.4.2
  * 更新 `VoodooPS2` v2.1.4
  * 更新 `VirtualSMC` v1.1.3
  * 更新 `SSDT-USB`
  * 更新 `framebuffer-flags` 属性
  * 更新 PCI 设备属性

### 新增
  * 新增 `_UPC -> XUPC` 重命名

### 移除
  * 移除 `SSDT-DRP08` 来解锁内置 Intel Wi-Fi
  * 移除 `USBInjectAll`

### Clover
  * Clover: 更新 `Xiaomi` 主题的 font.png 来兼容 `Clover` r5115

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.5.8


## [XiaoMi NoteBook Pro EFI v1.3.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.8)
## 4-10-2020

### 更新
  * 更新 `Clover` r5109
  * 更新 `OpenCore` v0.5.7
  * 更新  `Lilu` v1.4.3
  * 更新 `AppleALC` v1.4.8
  * 更新 `VirtualSMC` v1.1.2
  * 更新 `WhateverGreen` v1.3.8
  * 更新 `NVMeFix` v1.0.2
  * 更新 `VoodooPS2` v2.1.3
  * 更新 `VoodooI2C` v2.4，支持在恢复模式下使用触控板，并且每次升级后不用重建缓存
  * 更新 `IntelBluetoothFirmware` v1.0.3
  * 更新 `SSDT-TPD0`，基于 [#365](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/365)
  * 更新 `SSDT-LGPA`

### 新增
  * 新增 `VoodooInput`
  * 新增 `framebuffer-flags` 属性来支持 1440x810 HiDPI 分辨率
  * 新增 `force-online` 和 `force-online-framebuffers` 属性来修正 macOS10.15.4 下的 HDMI

### 移除
  * 移除 `MATH._STA and LDR2._STA -> XSTA` 重命名
  * 移除 `TPD0._INI -> XINI` 和 `TPD0._CRS -> XCRS` 重命名

### Clover
  * Clover: 更新 `setpowerstate_panic=0` 内核补丁来适配 macOS10.15.4

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.5.7


## [XiaoMi NoteBook Pro EFI v1.3.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.7)
## 3-25-2020

### 更新
  * 更新 `Clover` r5107 来支持 macOS10.15.4
  * 更新 `USBInjectAll` v0.7.3 来自 [Sniki的分支](https://github.com/Sniki/OS-X-USB-Inject-All/releases)
    * 原[Rehabman的分支](https://github.com/RehabMan/OS-X-USB-Inject-All)很长时间没有更新了
  * 更新 `SSDT-USB`
    * 我们机型上的type-c口带有转向器，所以 `UsbConnector` 应该为 `0x09`

### Clover
  * Clover: 更新 `Xiaomi` 主题以支持 Clover r5105+
  * Clover: 新增 `setpowerstate_panic=0` macOS10.15 内核补丁，根据 [Acidanthera/AppleALC#513](https://github.com/acidanthera/bugtracker/issues/513#issuecomment-542838126)
  * Clover: 移除 MSR 0xE2 补丁因为 Clover 可以自动修正

### OC
  * OC: 更新 config 来更好地支持 `OpenCore` v0.5.6


## [XiaoMi NoteBook Pro EFI v1.3.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.6)
## 3-10-2020

### 更新
  * 更新 `Clover` r5104
  * 更新 `OpenCore` v0.5.6
  * 更新 `Lilu` v1.4.2
  * 更新 `AppleALC` v1.4.7
  * 更新 `WhateverGreen` v1.3.7
  * 更新 `HibernationFixup` v1.3.2
  * 更新 `VirtualSMC` v1.1.1
  * 更新 `VoodooPS2` v2.1.2
  * 更新 `AppleSupportPkg` v2.1.6
  * 更新 `VoodooI2C` v2.3
  * 更新 `SSDT-USB`
  * 更新 `SSDT-MCHC`

### 新增
  * 新增 `IntelBluetoothFirmware` 和 `IntelBluetoothInjector` 来支持内置Intel蓝牙
  * 新增 `SSDT-DRP08` 来禁用Intel无线网卡
  * 新增 `SSDT-PS2K` 来定制 `VoodooPS2Keyboard` 而不是直接修改 `info.plist`
  * 新增 `complete-modeset-framebuffers` 来改善HDMI
  * 新增 `EFICheckDisabler`
  * 新增 `NVMeFix`
  * 放回 `SSDT-DDGPU` 来禁用独显，而不是用 `disable-external-egpu`

### 移除
  * 移除 AppleIntelLpssI2C 补丁因为 [alexandred/VoodooI2C@c6e3c27](https://github.com/alexandred/VoodooI2C/commit/c6e3c278cda84a26f400a77f5ea57d819df9e405) 修正了驱动冲突问题

### 变更
  * 修改 layout-id 回 30

### Clover
  * Clover: 新增 `PanicNoKextDump` 来替代 panic kext logging 补丁

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.5.6


## [XiaoMi NoteBook Pro EFI v1.3.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.5)
## 7-17-2019

### 更新
  * 更新 `Clover` r5018
  * 更新 `OpenCore` v0.0.4
  * 更新 `WhateverGreen` 来改善HDMI
  * 更新 `SSDT-LGPA`
  * 更新 `SSDT-TPD0`

### 新增
  * 新增 `TPD0._INI -> XINI` 和 `TPD0._CRS -> XCRS`，搭配 `SSDT-TPD0`

### 移除
  * 移除 `enable-hdmi-dividers-fix`

### OC
  * OC: 更新 config 来支持 `OpenCore` v0.0.4


## [XiaoMi NoteBook Pro EFI v1.3.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.4)
## 7-10-2019

  * 支持macOS10.15

### 更新
  * 更新 `Clover` r4986
  * 更新 `Lilu` v1.3.7
  * 更新 `AppleALC` v1.3.9
  * 更新 `WhateverGreen` v1.3.1
  * 更新 `VirtualSMC` v1.0.6
  * 更新并修改 `VoodooPS2` v2.0.2 以防止F11键禁用触控板
  * 更新 `VoodooI2C`
  * 更新从 `Hackintool` 获取的设备信息
  * 更新 `SSDT-MEM2`
  * 更新 `SSDT-HPET`
  * 更新 `config.plist` 里的注释，采用 `Hackintool` 风格

### 新增
  * 新增 `OpenCore`
  * 新增 `SSDT-TPD0` 来解决移除 `SSDT-XOSI` 和  `_OSI -> XOSI` 后触控板无法使用的问题
  * 放回 `SSDT-ALS0` 来保证背光被保存
  * 放回 `HibernationFixup`
  * 新增 `enable-hdmi-dividers-fix` 来更好地支持HDMI

### 移除
  * 移除 `GFX0 -> IGPU`，`HECI -> IMEI` 和 `HDAS -> HDEF` 根据[WhateverGreen FAQ.IntelHD.cn.md](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.cn.md#建议)
  * 移除 `SSDT-XOSI` 和  `_OSI -> XOSI` 因为如[OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf)所说，“避免修正_OSI来支持更高级别的功能集，除非一定必要。通常这个补丁会引发很多APTIO固件的问题，导致需要更多的补丁。新版固件通常不需要这个补丁了，而且需要用到_OSI补丁的情况也可以用更轻量的补丁来代替”
  * 移除 `_DSM -> XDSM` 因为如[OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf)所说，“尝试避免风险操作，例如只要有可能就给_PRW或_DSM重命名”
  * 移除 `SAT0 -> SATA`
  * 移除IRQ修复，根据[OpenCore discussion](https://www.insanelymac.com/forum/topic/338516-opencore-discussion/?do=findComment&comment=2675659), "...但是要非常小心IRQ，很多人移除了他们，尽管这通常是很不需要的。"
  * 移除 `SSDT-DDGPU` 因为和 `disable-external-egpu` 功能重叠
  * 移除 `SSDT-PXSX` 并迁移设备信息到 `config.plist`
  * 移除 `Drop DRAM` 并替换成 `dart=0`
  * 移除 `AppleKeyFeeder.efi` 和 `DataHubDxe-64.efi` 因为小米Pro不需要
  * 移除 `USBPorts.kext` 并替换成 `SSDT-USB`，根据[#197](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/197)


## [XiaoMi NoteBook Pro EFI v1.3.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.3)
## 4-16-2019

### 更新
  * 更新 `Clover` r4920
  * 更新 `AppleALC` v1.3.7
  * 更新 `WhateverGreen`
  * 更新 `VoodooPS2`
  * 更新 `VoodooI2C` v2.1.6

### 移除
  * 移除 `SSDT-RTC` 并用 `Rtc8Allowed` 和 `FixRTC` 来代替


## [XiaoMi NoteBook Pro EFI v1.3.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.2)
## 3-28-2019

### 更新
  * 更新 `Clover` r4910
  * 更新 `AppleALC` v1.3.6
  * 更新 `WhateverGreen` v1.2.8
  * 更新 `Lilu` v1.3.5
  * 更新 `VoodooPS2`
  * 更新 `USBPorts`，合并 `SSDT-USBX`

### 移除
  * 移除 `SSDT-PTSWAK` 因为小米Pro不需要它
  * 移除 `SMCSuperIO.kext` 因为它没检测到受支持的SuperIO芯片

### 变更
  * 修改热补丁来适配ACPI 6.3标准
  * 修改 `AppleRTC` 为true，`InjectKexts` 模式为 `Detect`


## [XiaoMi NoteBook Pro EFI v1.3.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.1)
## 3-1-2019

### 更新
  * 更新 `Clover` r4892
  * 更新 `USBPorts` 来支持更多型号

### 移除
  * 移除 `SSDT-PNLF` 并替换为 `AddPNLF`，根据[WhateverGreen FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#adjusting-the-brightness-on-a-laptop)
  * 移除 `RtcHibernateAware` 并替换为 `NeverHibernate`。解决一些睡眠重启问题，但会消耗更多电能。 `RtcHibernateAware` 需要解锁CFG才会正常工作。

### 变更
  * 修改 `igfxrst=1` 为 `gfxrst=1`，根据[WhateverGreen README](https://github.com/acidanthera/WhateverGreen/blob/master/README.md)


## [XiaoMi NoteBook Pro EFI v1.3.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.0)
## 2-10-2019

### 更新
  * 更新 `Clover` r4871
  * 更新 `Lilu` v1.3.1
  * 更新 `AppleALC` v1.3.5
  * 更新 `SSDT-PXSX`

### 新增
  * 新增 `SSDT-RTC` 来安全地移除IRQFlags，`FixRTC` 会缩短IO长度

### 移除
  * 移除 `CPUFriend*` 因为不同macOS版本有不同的plists在 `/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/`。推荐使用[one-key-cpufriend_cn](one-key-cpufriend/README_CN.md)来定制驱动
  * 移除 `HibernationFixup` 因为它不稳定，`RtcHibernateAware` 可能足够让机子睡眠
  * 移除 `dart=0`
  * 移除 `AddClockID`，因为它对新系统不起作用

### 变更
  * 修改layout-id为30


## [XiaoMi NoteBook Pro EFI v1.2.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.9)
## 12-26-2018

### 更新
  * 更新 `Clover` r4821
  * 更新 `VoodooPS2Controller` v1.9.2
  * 更新 `CodecCommander` v2.7.1
  * 更新 `Lilu` v1.2.9
  * 更新 `AppleALC` v1.3.4
  * 更新 `WhateverGreen` v1.2.6
  * 更新 `VirtualSMC` v1.0.2
  * 更新 `USBPower` 到 `USBPorts`
  * 更新 `SSDT-PNLF`， `SSDT-LGPA`，`SSDT-RMCF` 和 `SSDT-PTSWAK`
  * 更新 `VoodooI2C` 作者最新提交
  * 更新 `MATH._STA -> XSTA` 重命名为 `MATH._STA and LDR2._STA -> XSTA` 重命名

### 新增
  * 新增回 `config.plist` 里的TRIM补丁 
  * 新增参数 `RtcHibernateAware` 根据[官方解答](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?page=5)
  * 新增 `SATA-unsupported` 来替代 `SSDT-SATA`
  * 新增 `SSDT-HPET` 让机子表现得更像白果
  * 新增 `SSDT-LGPAGTX` 使GTX版运行得更好 (GTX用户需要把 `SSDT-LGPA` 替换成 `SSDT-LGPAGTX`)
  * 新增 IRQ修复 到 `config.plist`

### 移除
  * 移除 `SSDT-ALS0`
  * 移除 `AppleBacklightInjector` 因为 `WhateverGreen` 囊括了它
  * 移除 tgtbridge 因为它会导致问题
  * 移除 `HighCurrent` 参数

### 变更
  * 迁移PCI信息从 `SSDT-PCIList` 到 `config.plist`
  * 更改 layout-id 的数据类型
  * 清洁 `config.plist` 代码
  * 清洁 SSDTs 的格式


## [XiaoMi NoteBook Pro EFI v1.2.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.8)
## 9-28-2018

### 降级
  * 降级 [`Clover` r4658.RM-4903.ca9576f3](https://github.com/RehabMan/Clover) 因为Rehabman的版本更稳定

### 更新
  * 更新 `WhateverGreen`, `AppleALC`, `Lilu`, `CPUFriend` 和 `HibernationFixup`，来源于官方release
  * 更新 `AppleBacklightInjector` 来支持HD630
  * 更新 `SSDT-PNLF.aml` 来支持HD630
  * 更新  `VoodooI2C*` v2.1.4 （注意这个版本是修改过后的，不是[官方原版](https://github.com/alexandred/VoodooI2C/releases)，官方版本存在着缩放问题。）
  * 更新 `VoodooPS2Controller` v1.9.0，使用键盘的时候自动禁用触控板
  * 更新 热补丁的头部代码

### 新增
  * 新增 `USBPower` 来代替 `USBInjectAll` 和 `SSDT-USB.aml`

### 移除
  * 移除 `SSDT-MATH.aml`，替换为 `MATH._STA -> XSTA` 重命名

### 变更
  * 清洁 `config.plist` 里的代码


## [XiaoMi NoteBook Pro EFI v1.2.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.7)
## 9-15-2018

### 更新
  * 更新 `Clover` r4671 
  * 更新 `WhateverGreen` v1.2.3
  * 更新 `AppleALC` v1.3.2
  * 更新 `CPUFriend` v1.1.5
  * 更新 `Lilu` v1.2.7
  * 更新 `USBInjectAll` v0.6.7
  * 更新 `SSDT-GPRW.aml` 和 `SSDT-RMCF.aml`，源自Rehabman的仓库：https://github.com/RehabMan/OS-X-Clover-Laptop-Config
  * 更新 `SSDT-PCIList.aml`，给PCI0设备添加更多属性

### 新增
  * 新增 `SSDT-DMAC.aml` , `SSDT-MATH.aml` , `SSDT-MEM2.aml` , 和 `SSDT-PMCR.aml` 来增强性能，表现得更像白果。启发于[syscl](https://github.com/syscl/XPS9350-macOS/tree/master/DSDT/patches)
  * 新增 `HibernationFixup`，`系统偏好设置 - 节能` 的时间调整将会被保存
  * 新增 `VirtualSMC` 来代替 `FakeSMC`。你可以使用 `iStat Menus` 获得更多传感器数据，而且更多SMC键值被添加进nvram

### 移除
  * 移除 `config.plist` 里的VRAM 2048MB补丁，真实的VRAM并没有被改变

### 变更
  * 修改 `config.plist` 以丢掉无用ACPI表
  * 回滚 AppleIntelFramebuffer@0 的接口类型


## [XiaoMi NoteBook Pro EFI v1.2.6](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.6)
## 8-13-2018

### 变更
  * 回滚 `CPUFriendProvider.kext` 至v1.2.2版本，因为v1.2.5的会导致部分机器在10.13.3～10.13.5下内核报错。如果你想要更好的CPU性能，请阅读[#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)


## [XiaoMi NoteBook Pro EFI v1.2.5](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.5)
## 8-9-2018

  * Mojave的安装变得更简单

### 更新
  * 更新 `Clover` r4641
  * 更新 `WhateverGreen` v1.2.1
  * 更新 `AppleALC`
  * 更新 `CPUFriendDataProvider`, 使用默认的EPP值来增强性能
  * 更新 `Lilu`
  * 更新 `config.plist`，用AddProperties来代替minStolen Clover补丁

### 变更
  * 修改 `config.plist` 来增加VRAM至2048MB
  * 修改 AppleIntelFramebuffer@0 的接口类型（由原本的LVDS改为eDP），因为MiPro采用的是eDP输入
  * 不用通过 `config_install.plist` 注入显卡id 0x12345678了，新版  `WhateverGreen` 可以做到


## [XiaoMi NoteBook Pro EFI v1.2.4](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.4)
## 7-27-2018

### 更新
  * 更新 `Clover` r4625
  * 更新 `AppleALC` v1.3.1
  * 更新 `Lilu` v1.2.6
  * 更新 `CPUFriendDataProvider` 通过使用MBP15,2的电源配置来驱动原生HWP
  * 更新 `VoodooI2C` v2.0.3
  * 更新 `USBInjectAll` v0.6.6
  * 更新 `CodecCommander` v2.6.3, 融合了 `SSDT-MiPro_ALC298.aml`

### 新增
  * 新增 minStolen Clover 补丁
  * 新增对Mojave的支持
  * 新增 `WhateverGreen` 来代替 `IntelGraphicsFixup`, `Shiki` 和 `IntelGraphicsDVMTFixup`
  * 新增 `VoodooPS2Controller` 来代替 `ApplePS2SmartTouchPad`

### 移除
  * 移除多余引导参数 `igfxfw=1` 和 `-disablegfxfirmware`

### 变更
  * 修改 `SSDT-PCIList.aml`，让 `系统报告.app` 显示更多PCI设备


## [XiaoMi NoteBook Pro EFI v1.2.2](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.2)
## 5-14-2018

### 更新
  * 更新 `Clover` r4458
  * 更新 `Lilu` v1.2.4
  * 更新 `CPUFriendDataProvider` 让系统更省电

### 新增
  * 新增 `SSDT-EC.aml` 和 `SSDT-SMBUS.aml` 来加载 AppleBusPowerController 和 AppleSMBusPCI

### 移除
  * 移除 config 里的一些无用重命名和错误引导参数 `shikigva=1`
  * 移除 `SSDT-ADBG.aml`，它是个无用的方法覆写
  * 移除 `SSDT-IMEI.aml` 来避免开机日志里出现的错误信息（显卡id能被`IntelGraphicsFixup`自动注入）

### 变更
  * 重命名了一些SSDT，让他们更符合Rehabman的标准，方便后期维护。同时更新了 `SSDT-GPRW.aml`, `SSDT-DDGPU.aml`, `SSDT-RMCF.aml` 和 `SSDT-XHC.aml`
  * 重做了USB驱动，现在type-c接口支持USB3.0了 
  * 修改 `SSDT-PCIList.aml`，使 `系统报告.app` 显示正确的信息


## 4-13-2018

### 更新
  * 更新 `Clover` r4438
  * 更新 `AppleALC` v1.2.7
  * 更新 `SSDT-IMEI.aml`, `SSDT-PTSWAK.aml`, `SSDT-SATA.aml`, `SSDT-XOSI.aml`

### 变更
  * 修改 `SSDT-LPC.aml` 已加载原生电源驱动 AppleLPC


## [XiaoMi NoteBook Pro EFI v1.1.1](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.1.1)
## 4-8-2018

  * 支持10.13.4安装使用

### 更新
  * 更新 `ACPIBatteryManager` v1.81.4
  * 更新 `AppleALC` v1.2.6
  * 更新 `FakeSMC` v6.26-344-g1cf53906.1787
  * 更新 `IntelGraphicsDVMTFixup` v1.2.1
  * 更新 `IntelGraphicsFixup` v1.2.7，不再需要额外的驱动给显卡注入id了
  * 更新 `Lilu` v1.2.3
  * 更新 `Shiki` v2.2.6
  * 更新 `USBInjectAll` v0.6.4

### 新增
  * 新增 `AppleBacklightInjector`，开启更多档位的亮度调节
  * 新增 `CPUFriend` 和`CPUFriendDataProvider`，开启原生 XCPM 和 HWP 电源管理方案
  * 新增引导参数 `shikigva=1`，`igfxrst=1` 和 `igfxfw=1` 增强核显性能，并用新的方法修正启动第二阶段的八个苹果
  * 新增 `SSDT-LGPA.aml`，支持原生亮度快捷键


## [XiaoMi NoteBook Pro EFI v1.0.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.0.0)
## 1-25-2018

  * 支持10.13.x安装使用

### 更新
  * 更新 `Lilu` v1.2.2
  * 更新 `AppleALC` v1.2.2 支持小米Pro，注入ID:99
  * 更新 `IntelGraphicsFixup` v1.2.3
  * 更新 `VoodooI2C` 到2.0.1版本，支持多手势，触摸板开机可正常使用，不漂移，无需唤醒

### 变更
  * 修正电量百分比不刷新的问题
  * 修正声卡睡眠唤醒无声音的问题
  * 修正屏幕亮度无法保存的问题


## 11-7-2017

### 降级
  * 降级 `Lilu` v1.2.0，因为v1.2.1目前还不稳定，存在无法进入系统的风险
  * 降级 `AppleALC` v1.2.0


## 11-5-2017

### 更新
  * 更新 `apfs.efi` 到10.13.1版本

### 新增
  * 新增 ALCPlugFix 目录，请安装完成后进入ALCPlugFix目录，双击 `install双击自动安装.command` 安装耳机插入状态修正守护程序

### 变更
  * 整合 `AppleALC_ALC298_id13_id28.kext` 驱动到EFI
  * 修正 Drivers64UEFI，解决无法安装问题


## 11-2-2017

### 更新
  * 更新 `Lilu` v1.2.0，支持10.13.2Beta
  * 更新 `AppleALC`，使用最新修正版Lilu联合编译，解决10.13.1更新后无法驱动的问题


## 10-31-2017

  * 更新声卡驱动，修正耳机问题
  * 新驱动增加layout-id：13
  * 支持四节点，支持耳麦自由切换，Mic/LineIn工作正常


## 10-19-2017

  * 显卡驱动正常
  * 触摸板开机正常，睡眠唤醒后多手势使用正常
  * 睡眠正常
  * 电池信息正常


## 10-18-2017

  * 经测试显卡驱动不如第一版的好，现将显卡驱动恢复为仿冒0x19160000

### 移除
  * 移除 `USBInjectAll`，替换为 `SSDT-UIAC.aml` 来内建USB设备

### 变更  
  * 修正 ACPI
  * 修正 驱动程序


## 10-17-2017

  * EFI更新，修正显卡驱动

### 更新
  * 更新 `Lilu` v1.2.0 
  * 更新 `AppleALC` v1.2.1
  * 更新 `IntelGraphicsDVMTFixup` v1.2.0
  * 更新 `AirportBrcmFixup` v1.1.0

### 新增
  * 新增 HDMI 声音输出

### 变更
  * 修正 `IntelGraphicsFixup` v1.2.0 


## 10-14-2017

  * EFI更新，触摸板工作正常

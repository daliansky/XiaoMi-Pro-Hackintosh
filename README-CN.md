# 小米笔记本PRO安装macOS Mojave & High Sierra 使用说明

让你的小米PRO笔记本吃上黑苹果

[English](README.md) | [中文](README-CN.md)

## 支持列表

* 支持10.13.x 和 10.14。
* ACPI补丁修复使用hotpatch方式，相关文件位于 `/CLOVER/ACPI/patched` 。

### 声卡
* 声卡型号为 `Realtek ALC298`，采用 `AppleALC` 仿冒，layout-id为99，注入信息位于 `/CLOVER/config.plist`。
* 如果耳机工作不正常，请下载[ALCPlugFix](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/ALCPlugFix) 文件夹，运行`install.command`，然后重启来给声卡驱动打补丁。每次开机后可能需要重新插拔耳机。
* 一些i5机型可能麦克风工作不正常，请按照[#13](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/13)里的步骤来修复。

### 蓝牙
* 原生蓝牙[不完美](https://github.com/daliansky/XiaoMi-Pro/issues/50)。型号是`Intel® Dual Band Wireless-AC 8265`。有两种方式可以让你的体验更好：
    * 禁用原生蓝牙来省电或者使用USB蓝牙代替原生蓝牙，请阅读[#24](https://github.com/daliansky/XiaoMi-Pro/issues/24)给出的步骤。
    * 购买一个兼容的内置网卡并插在M.2插槽。小心地把D+和D-线焊接到WLAN_LTE接口上。然后替换[#7](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/7)里的附件。

### CPU
* 型号是 `i5-8250U` 或 `i7-8550U`。原生支持XCPM电源管理。
* XCPM和HWP最好同时工作来达到高效电源管理 (>=10.13.6)。请前往[#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)，把附件的`CPUFriendDataProvider.kext` 替换进 `/CLOVER/kexts/Other/`来开启HWP。

### 显卡
* 型号是 `Intel UHD Graphics 620`，通过注入ig-platform-id `00001659` 仿冒成 `Intel HD Graphics 620`。
* 使用左侧的HDMI接口可能会导致笔记本内屏黑屏，可以尝试合盖再开盖来恢复。
* 原生亮度快捷键支持，注入信息位于 `/CLOVER/ACPI/patched/SSDT-LGPA.aml`。

### 键盘
* 大小写切换键可能工作不正常，请阅读[#2](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/2)里的步骤来关闭 `使用大写锁定键切换“ABC”输入模式`。
* 最新键盘驱动在打字的时候会短暂禁用触控板。如果你感觉体验不佳，请阅读[#19](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/19)里的解决方法。

### 硬盘
* 最近的机型采用了 `PM981` SSD而不是原来的 `PM961`。此EFI不完全支持 `PM981`。装有 `PM981` 的机友可以更换SSD或者阅读[10.13.X-10.14.X 解决PM981死机以及开启建兴/浦科特/海力士 NVMe原生支持补丁](http://bbs.pcbeta.com/viewthread-1774117-1-1.html)。

### 触控板
* 触摸板驱动使用修正过的 `VoodooI2C`，解决了缩放和休眠问题。

### USB
* USB遮盖使用的是[Intel FB-Patcher](https://blog.daliansky.net/Intel-FB-Patcher-tutorial-and-insertion-pose.html)，相关文件位于 `/CLOVER/kexts/Other/USBPower.kext`。
* SD读卡器型号是 `RTS5129`。因为它不被支持，所以禁用了它来增加续航。

### 无线网卡
* 无线网卡型号是 `Intel® Dual Band Wireless-AC 8265`。很不幸，没有驱动支持它。你可以访问[Intel无线网卡macOS驱动 是的你没有看错就是Intel无线网卡macOS驱动](http://bbs.pcbeta.com/viewthread-1791409-1-1.html)来获取最新进展。
* 你也可以插入一个兼容的无线网卡到M.2插槽。更多信息可以加入[小米PRO黑苹果高级群(群号:247451054)](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)参与讨论。


## 常见问题解答

### 我的设备被 `查找我的Mac` 锁住了，无法开机，怎么办？

有很多种解决办法。对于我来说最好理解的方法是刷BIOS来清理`nvram.plist`。请阅读[BIOS文件夹](https://github.com/daliansky/XiaoMi-Pro/blob/master/BIOS/README-CN.md)里的 `怎么升级BIOS`。


### 我开启了 `文件保险箱`，开机时找不到macos启动项，怎么办？

一般情况下不推荐开启 `文件保险箱`。你可以在Clover开机界面时按下Fn + F3，然后选择下方小字含有 `FileVault` 的苹果图标。进入系统后关闭 `文件保险箱`。


### 我的触控板升级系统后无法使用。

你需要在每次更新系统后重建缓存。运行 `Kext Utility.app` 或者在 `终端.app` 输入 `sudo kextcache -i /`，然后重启。如果触控板还是失效，试试按下F9键。


## 鸣谢

- [Acidanthera](https://github.com/acidanthera) 提供 [AppleALC](https://github.com/acidanthera/AppleALC) 和 [CPUFriend](https://github.com/acidanthera/CPUFriend) 和 [HibernationFixup](https://github.com/acidanthera/HibernationFixup) 和 [Lilu](https://github.com/acidanthera/Lilu) 和 `USBPower` 和 [VirtualSMC](https://github.com/acidanthera/VirtualSMC) 和 [WhateverGreen](https://github.com/acidanthera/WhateverGreen) 的维护

- [alexandred](https://github.com/alexandred) 和 [hieplpvip](https://github.com/hieplpvip) 提供 [VoodooI2C](https://github.com/alexandred/VoodooI2C) 的维护

- [apianti](https://sourceforge.net/u/apianti) 和 [blackosx](https://sourceforge.net/u/blackosx) 和 [blusseau](https://sourceforge.net/u/blusseau) 和 [dmazar](https://sourceforge.net/u/dmazar) 和 [slice2009](https://sourceforge.net/u/slice2009) 提供 [Clover](https://sourceforge.net/projects/cloverefiboot) 的维护

- [FallenChromium](https://github.com/FallenChromium) 和 [Javmain](https://github.com/javmain) 和 [johnnync13](https://github.com/johnnync13) 的宝贵建议

- [RehabMan](https://github.com/RehabMan) 提供 [AppleBacklightFixup](https://github.com/RehabMan/AppleBacklightFixup) 和 [EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander) 和 [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) 和 [OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) 和 [SATA-unsupported](https://github.com/RehabMan/hack-tools/tree/master/kexts/SATA-unsupported.kext) 的维护


## 安装

请参考详细的安装教程[macOS安装教程兼小米Pro安装过程记录](https://blog.daliansky.net/MacOS-installation-tutorial-XiaoMi-Pro-installation-process-records.html)，视频教程[小米笔记本Pro安装macOS 10.13.4（黑苹果+Windows双系统）过程](https://www.bilibili.com/video/av23052183)。

完整的EFI压缩版请访问 [releases](https://github.com/daliansky/XiaoMi-Pro/releases) 页面，感谢[stevezhengshiqi](https://github.com/stevezhengshiqi)的持续更新。

如果安装过程中触控板失效，请在安装前插上有线鼠标或者无线鼠标发射器。安装完成后打开 `终端.app` 并输入 `sudo kextcache -i /`，等待进程结束重启即可使用触控板。


## 更新日期：

* 10-14-2017

    * EFI更新，触摸板工作正常


* 10-17-2017

    * EFI更新，修正显卡驱动
    * 增加HDMI Audio声音输出
    * 驱动更新：
        * `Lilu` v1.2.0 
        * `AppleALC` v1.2.1
        * `IntelGraphicsDVMTFixup` v1.2.0
        * `AirportBrcmFixup` v1.1.0
    * 驱动修复：
        * `IntelGraphicsFixup` v1.2.0 


* 10-18-2017

    * 经测试显卡驱动不如第一版的好，现将显卡驱动恢复为仿冒0x19160000
    * ACPI修复
    * 驱动程序修正
    * 去掉 `USBInjectAll` 采用 `SSDT-UIAL.aml` 内建USB设备


* 10-19-2017

    * 显卡驱动正常
    * 触摸板开机正常，睡眠唤醒后多手势使用正常
    * 睡眠正常
    * 电池信息正常


* 10-31-2017

    * 更新声卡驱动，修复耳机问题
    * 新驱动增加layoutid：13
    * 支持四节点，支持耳麦自由切换，Mic/LineIn工作正常


* 11-2-2017

    * `Lilu` v1.2.0更新，支持10.13.2Beta
    * `AppleALC` 更新，使用最新修正版Lilu联合编译，解决10.13.1更新后无法驱动的问题


* 11-5-2017

    * 整合 `AppleALC_ALC298_id13_id28.kext` 驱动到EFI
    * EFI目录下添加ALCPlugFix目录，请安装完成后进入ALCPlugFix目录，双击 `install双击自动安装.command` 安装耳机插入状态修正守护程序
    * 修正Drivers64UEFI，解决无法安装问题
    * 更新 `apfs.efi` 到10.13.1版本


* 11-7-2017

    * `Lilu` v1.2.1目前还不稳定，存在无法进入系统的风险，所以降级到v1.2.0版本
    * `AppleALC` 降级到V1.2.0


* 1-25-2018

    * 支持10.13.x安装使用
    * 更新 `VoodooI2C` 到2.0.1版本，支持多手势，触摸板开机可正常使用，不漂移，无需唤醒
    * 修复电量百分比不刷新的问题
    * 修复声卡睡眠唤醒无声音的问题
    * 修复屏幕亮度无法保存的问题
    * 更新 `Lilu` v1.2.2
    * 更新 `AppleALC` v1.2.2 支持小米Pro，注入ID:99
    * 更新 `IntelGraphicsFixup` v1.2.3


* 4-8-2018

    * 支持10.13.4安装使用
    * 更新 `ACPIBatteryManager` v1.81.4
    * 更新 `AppleALC` v1.2.6
    * 更新 `FakeSMC` v6.26-344-g1cf53906.1787
    * 更新 `IntelGraphicsDVMTFixup` v1.2.1
    * 更新 `IntelGraphicsFixup` v1.2.7，不再需要额外的驱动给显卡注入id了
    * 更新 `Lilu` v1.2.3
    * 更新 `Shiki` v2.2.6
    * 更新 `USBInjectAll` v0.6.4
    * 新增驱动 `AppleBacklightInjector`，开启更多档位的亮度调节
    * 新增驱动 `CPUFriend` 和`CPUFriendDataProvider`，开启原生XCPM和HWP电源管理方案
    * 新增启动参数 `shikigva=1`，`igfxrst=1` 和 `igfxfw=1` 增强核显性能，并用新的方法修复启动第二阶段的八个苹果
    * 新增 `SSDT-LGPA.aml`，支持原生亮度快捷键
    
    
* 4-13-2018

    * 更新 `AppleALC` v1.2.7
    * 更新 `SSDT-IMEI.aml`, `SSDT-PTSWAK.aml`, `SSDT-SATA.aml`, `SSDT-XOSI.aml`
    * 修改 `SSDT-LPC.aml` 已加载原生电源驱动AppleLPC
    * 更新 `Clover` r4438
    * 发布Clover v2.4 r4438小米笔记本PRO专用安装程序
        ![Clover_v2.4k_r4438](http://7.daliansky.net/clover4438/2.png)


* 5-14-2018

    * 重命名了一些SSDT，让他们更符合Rehabman的标准，方便后期维护。同时更新了 `SSDT-GPRW.aml`, `SSDT-DDGPU.aml`, `SSDT-RMCF.aml` 和 `SSDT-XHC.aml`
    * 删除config里的一些无用重命名和错误启动参数 `shikigva=1`
    * 重做了USB驱动，现在type-c接口支持USB3.0了 
    * 删除 `SSDT-ADBG.aml`，它是个无用的方法覆写
    * 删除 `SSDT-IMEI.aml` 来避免开机日志里出现的错误信息（显卡id能被`IntelGraphicsFixup`自动注入）
    * 新增 `SSDT-EC.aml` 和 `SSDT-SMBUS.aml` 来加载AppleBusPowerController和AppleSMBusPCI
    * 修改 `SSDT-PCIList.aml`，使 `系统报告.app` 显示正确的信息
    * 更新 `Lilu` v1.2.4
    * 更新 `CPUFriendDataProvider` 让系统更省电
    * 更新 `Clover` r4458


* 7-27-2018

    * 更新 `Clover` r4625
    * 更新 `AppleALC` v1.3.1
    * 更新 `Lilu` v1.2.6
    * 更新 `CPUFriendDataProvider` 通过使用MBP15,2的电源配置来驱动原生HWP
    * 更新 `VoodooI2C` v2.0.3
    * 更新 `USBInjectAll` v0.6.6
    * 更新 `CodecCommander` v2.6.3, 融合了 `SSDT-MiPro_ALC298.aml`
    * 删除多余启动参数 `igfxfw=1` 和 `-disablegfxfirmware`
    * 修改 `SSDT-PCIList.aml`，让 `系统报告.app` 显示更多PCI设备
    * 新增 `WhateverGreen` 来代替 `IntelGraphicsFixup`, `Shiki` 和 `IntelGraphicsDVMTFixup`
    * 新增 `VoodooPS2Controller` 来代替 `ApplePS2SmartTouchPad`
    * 新增minStolen的Clover补丁
    * 新增对Mojave的支持（安装教程在下面）


* 8-9-2018

    * 更新 `Clover` r4641
    * 更新 `WhateverGreen` v1.2.1
    * 更新 `AppleALC`
    * 更新 `CPUFriendDataProvider`, 使用默认的EPP值来增强性能
    * 更新 `Lilu`
    * 更新 `config.plist`，用AddProperties来代替minStolen Clover补丁
    * 修改 `config.plist` 来增加VRAM至2048MB
    * 修改AppleIntelFramebuffer@0的接口类型（由原本的LVDS改为eDP），因为MiPro采用的是eDP输入
    * 不用通过 `config_install.plist` 注入显卡id 0x12345678了，新版  `WhateverGreen` 可以做到
    * Mojave的安装变得更简单


* 8-13-2018

    * 将 `CPUFriendProvider.kext` 回滚至v1.2.2版本，因为v1.2.5的会导致部分机器在10.13.3～10.13.5下内核报错。如果你想要更好的CPU性能，请阅读[#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)


* 9-15-2018

    * 更新 `Clover` r4671 
    * 更新 `WhateverGreen` v1.2.3
    * 更新 `AppleALC` v1.3.2
    * 更新 `CPUFriend` v1.1.5
    * 更新 `Lilu` v1.2.7
    * 更新 `USBInjectAll` v0.6.7
    * 更新 `SSDT-GPRW.aml` 和 `SSDT-RMCF.aml`，源自Rehabman的仓库：https://github.com/RehabMan/OS-X-Clover-Laptop-Config
    * 更新 `SSDT-PCIList.aml`，给PCI0设备添加更多属性
    * 新增 `SSDT-DMAC.aml` , `SSDT-MATH.aml` , `SSDT-MEM2.aml` , 和 `SSDT-PMCR.aml` 来增强性能，表现得更像白果。启发于[syscl](https://github.com/syscl/XPS9350-macOS/tree/master/DSDT/patches)
    * 新增 `HibernationFixup`，`系统偏好设置 - 节能` 的时间调整将会被保存
    * 新增 `VirtualSMC` 来代替 `FakeSMC`。你可以使用 `iStat Menus` 获得更多传感器数据，而且更多SMC键值被添加进nvram
    * 移除 `config.plist` 里的VRAM 2048MB补丁，真实的VRAM并没有被改变
    * 修改 `config.plist` 以丢掉无用ACPI表
    * 还原AppleIntelFramebuffer@0的接口类型


* 9-28-2018

    * 降级 [`Clover` r4658.RM-4903.ca9576f3](https://github.com/RehabMan/Clover) 因为Rehabman的版本更稳定
    * 更新 `WhateverGreen`, `AppleALC`, `Lilu`, `CPUFriend` 和 `HibernationFixup`，来源于官方release
    * 更新 `AppleBacklightInjector` 来支持HD630
    * 更新 `SSDT-PNLF.aml` 来支持HD630
    * 更新  `VoodooI2C*` v2.1.4 （注意这个版本是修改过后的，不是[官方原版](https://github.com/alexandred/VoodooI2C/releases)，官方版本存在着缩放问题。）
    * 更新 `VoodooPS2Controller` v1.9.0，使用键盘的时候自动禁用触控板
    * 更新 热补丁的头部代码
    * 新增 `USBPower` 来代替 `USBInjectAll` 和 `SSDT-USB.aml`
    * 移除 `SSDT-MATH.aml`
    * 清洁 `config.plist` 里的代码


## 关于打赏

如果您认可我的工作，请通过打赏支持我后续的更新

| 微信                                                       | 支付宝                                               |
| ---------------------------------------------------------- | ---------------------------------------------------- |
| ![wechatpay_160](http://7.daliansky.net/wechatpay_160.jpg) | ![alipay_160](http://7.daliansky.net/alipay_160.jpg) |


## 支持与讨论

* tonymacx86.com:
  * [[Guide] Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)

* QQ群:
  * 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  * 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)
  * 331686786 [一起吃苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)
  * 688324116 [一起黑苹果](https://shang.qq.com/wpa/qunwpa?idkey=6bf69a6f4b983dce94ab42e439f02195dfd19a1601522c10ad41f4df97e0da82)
  * 257995340 [一起啃苹果](http://shang.qq.com/wpa/qunwpa?idkey=8a63c51acb2bb80184d788b9f419ffcc33aa1ed2080132c82173a3d881625be8)

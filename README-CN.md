# 小米笔记本PRO安装macOS Mojave & High Sierra 使用说明

让你的小米PRO笔记本吃上黑苹果

[English](README.md) | [中文](README-CN.md)

## 支持列表

* 支持10.13.x 和 10.14。
* CPU为第八代，原生支持。如果需要更高的性能（或者更长续航），请前往[#53](https://github.com/daliansky/XiaoMi-Pro/issues/53)，把附件的`CPUFriendDataProvider.kext` 替换进 `/CLOVER/kexts/Other/`。
* 声卡型号为`Realtek ALC298`，采用 `AppleALC` 仿冒，layout-id为99，注入信息位于 `/CLOVER/config.plist`。如果耳机工作不正常，请下载[ALCPlugFix](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/ALCPlugFix) 文件夹，运行`install.command`，然后重启来给声卡驱动打补丁。
* 触摸板驱动使用 `VoodooI2C`，支持多手势，触摸板开机可正常使用，不漂移，无需唤醒。
* 其他ACPI补丁修复使用hotpatch方式，相关文件位于 `/CLOVER/ACPI/patched` 。
* USB遮盖使用的是[Intel FB-Patcher](https://www.tonymacx86.com/threads/release-intel-fb-patcher-v1-4-1.254559/)，相关文件位于 `/CLOVER/kexts/Other/USBPower.kext`。
* 原生亮度快捷键支持，注入信息位于 `/CLOVER/ACPI/patched/SSDT-LGPA.aml`。
* 原生蓝牙[不完美](https://github.com/daliansky/XiaoMi-Pro/issues/50)。型号是`Intel® Dual Band Wireless-AC 8265`。有两种方式可以让你的体验更好：
    * 禁用原生蓝牙来省电或者使用USB蓝牙代替原生蓝牙，请阅读[#24](https://github.com/daliansky/XiaoMi-Pro/issues/24)给出的步骤。
    * 购买一个兼容的内置网卡并插在M.2插槽。小心地把D+和D-线焊接到WLAN_LTE接口上。然后替换[#7](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/7)里的附件。


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

    **EFI暂不支持macOS 10.13.2Beta版本的安装，Lilu不抽风后会持续更新**


* 1-25-2018

    * 支持10.13.x安装使用
    * 更新 `VoodooI2C` 到2.0.1版本，支持多手势，触摸板开机可正常使用，不漂移，无需唤醒
    * 修复电量百分比不刷新的问题
    * 修复声卡睡眠唤醒无声音的问题
    * 修复屏幕亮度无法保存的问题
    * 更新 `Lilu` v1.2.2
    * 更新 `AppleALC` v1.2.2 支持小米Pro，注入ID:99


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


## 鸣谢

- [RehabMan](https://github.com/RehabMan) 提供 [AppleBacklightInjector](https://github.com/RehabMan/HP-ProBook-4x30s-DSDT-Patch/tree/master/kexts/AppleBacklightInjector.kext) 和 [EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander) 和 [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) 和 [OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) 的维护

- [vit9696](https://github.com/vit9696) 提供 [AppleALC](https://github.com/acidanthera/AppleALC) 和 [HibernationFixup](https://github.com/acidanthera/HibernationFixup) 和 [Lilu](https://github.com/acidanthera/Lilu) 和 `USBPower` 和 [VirtualSMC](https://github.com/acidanthera/VirtualSMC) 和 [WhateverGreen](https://github.com/acidanthera/WhateverGreen) 的维护

- [PMheart](https://github.com/PMheart) 提供 [CPUFriend](https://github.com/PMheart/CPUFriend) 的维护

- [alexandred](https://github.com/alexandred) 和 [hieplpvip](https://github.com/hieplpvip) 提供 [VoodooI2C](https://github.com/alexandred/VoodooI2C) 的维护

- [FallenChromium](https://github.com/FallenChromium) 和 [Javmain](https://github.com/javmain) 和 [johnnync13](https://github.com/johnnync13) 的宝贵建议


## 安装

请参考详细的安装教程（中文版）[macOS安装教程兼小米Pro安装过程记录](https://blog.daliansky.net/MacOS-installation-tutorial-XiaoMi-Pro-installation-process-records.html).
完整的EFI压缩版请访问 [releases](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases) 页面，感谢[stevezhengshiqi](https://github.com/stevezhengshiqi/XiaoMi-Pro)的持续更新.

如果安装过程中触控板失效，请在安装前插上有线鼠标或者无线鼠标发射器。安装完成后打开`终端.app`并输入 `sudo kextcache -i /`，等待进程结束重启即可使用触控板。


## 关于打赏

您的建设性提议和意见就是对我最好的奖赏。


## 支持与讨论

* QQ群:
* 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
* 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)

  ​


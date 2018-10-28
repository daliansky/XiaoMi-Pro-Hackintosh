# 小米笔记本PRO安装macOS Mojave & High Sierra 使用说明

让你的小米PRO笔记本吃上黑苹果

[English](README.md) | [中文](README-CN.md)

## 支持列表

* 支持10.13.x 和 10.14。
* ACPI补丁修复使用hotpatch方式，相关文件位于 `/CLOVER/ACPI/patched` 。

### 声卡
* 声卡型号为 `Realtek ALC298`，采用 `AppleALC` 仿冒，layout-id为99，注入信息位于 `/CLOVER/config.plist`。
* 如果耳机工作不正常，请阅读[ALCPlugFix](https://github.com/daliansky/XiaoMi-Pro/tree/master/ALCPlugFix/README-CN.md)。每次开机后可能需要重新插拔耳机。
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
* 独显型号是 `NVIDIA GeForce MX150`，通过 `SSDT-DDGPU.aml` 来禁用，因为macOS不支持Optimus显卡切换技术。
* 使用左侧的HDMI接口可能会导致笔记本内屏黑屏，可以尝试合盖再开盖来恢复。
* 原生亮度快捷键支持，注入信息位于 `/CLOVER/ACPI/patched/SSDT-LGPA.aml`。

### 键盘
* 大小写切换键可能工作不正常，请阅读[#2](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/2)里的步骤来关闭 `使用大写锁定键切换“ABC”输入模式`。
* 最新键盘驱动在打字的时候会短暂禁用触控板。如果你感觉体验不佳，请阅读[#19](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/19)里的解决方法。

### 硬盘
* 最近的机型采用了 `PM981` SSD而不是原来的 `PM961`。此EFI不完全支持 `PM981`。装有 `PM981` 的机友可以更换SSD或者阅读[10.13.X-10.14.X 解决PM981死机以及开启建兴/浦科特/海力士 NVMe原生支持补丁](http://bbs.pcbeta.com/viewthread-1774117-1-1.html)。
    * `PM981` 硬盘序列号以 `MZVLB` 开头，`PM961` 硬盘序列号以 `MZVLW` 开头。

### 触控板
* 型号是 `ETD2303`(ELAN)，触摸板驱动使用修正过的 `VoodooI2C`，解决了缩放和休眠问题。
* 记得要取消 `系统偏好设置 - 触控板 - 滚动缩放` 里的 `智能缩放` 来让触控板工作得更好。

### USB
* USB遮盖使用的是[Intel FB-Patcher](https://blog.daliansky.net/Intel-FB-Patcher-tutorial-and-insertion-pose.html)，相关文件位于 `/CLOVER/kexts/Other/USBPower.kext`。
* SD读卡器型号是 `RTS5129`。因为它不被支持，所以禁用了它来增加续航。

### 无线网卡
* 无线网卡型号是 `Intel® Dual Band Wireless-AC 8265`。很不幸，没有驱动支持它。你可以访问[Intel无线网卡macOS驱动 是的你没有看错就是Intel无线网卡macOS驱动](http://bbs.pcbeta.com/viewthread-1791409-1-1.html)来获取最新进展。
* 你也可以插入一个兼容的无线网卡到M.2插槽。更多信息可以加入[小米PRO黑苹果高级群(群号:247451054)](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)参与讨论。


## 常见问题解答

### 我的设备被 `查找我的Mac` 锁住了，无法开机，怎么办？

有很多种解决办法。对于我来说最好理解的方法是刷BIOS来清理`nvram.plist`。请阅读[BIOS文件夹](https://github.com/daliansky/XiaoMi-Pro/blob/master/BIOS/README-CN.md)里的 `怎么升级BIOS`。


### 我开启了 `文件保险箱`，开机时找不到macOS启动项，怎么办？

一般情况下不推荐开启 `文件保险箱`。你可以在Clover开机界面时按下Fn + F3，然后选择下方小字含有 `FileVault` 的苹果图标。进入系统后关闭 `文件保险箱`。


### 我的触控板升级系统后无法使用。

你需要在每次更新系统后重建缓存。运行 `Kext Utility.app` 或者在 `终端.app` 输入 `sudo kextcache -i /`，然后重启。如果触控板还是失效，试试按下F9键。


## 安装

请参考详细的安装教程[macOS安装教程兼小米Pro安装过程记录](https://blog.daliansky.net/MacOS-installation-tutorial-XiaoMi-Pro-installation-process-records.html)，视频教程[小米笔记本Pro安装macOS 10.13.4（黑苹果+Windows双系统）过程](https://www.bilibili.com/video/av23052183)。

完整的EFI压缩版请访问 [releases](https://github.com/daliansky/XiaoMi-Pro/releases) 页面，感谢[stevezhengshiqi](https://github.com/stevezhengshiqi)的持续更新。

如果安装过程中触控板失效，请在安装前插上有线鼠标或者无线鼠标发射器。安装完成后打开 `终端.app` 并输入 `sudo kextcache -i /`，等待进程结束重启即可使用触控板。


## 更新日志

详细更新日志请看 [更新日志中文版](Changelog-CN.md)。


## 关于打赏

如果您认可我的工作，请通过打赏支持我后续的更新

| 微信                                                       | 支付宝                                               |
| ---------------------------------------------------------- | ---------------------------------------------------- |
| ![wechatpay_160](http://7.daliansky.net/wechatpay_160.jpg) | ![alipay_160](http://7.daliansky.net/alipay_160.jpg) |


## 鸣谢

- 感谢 [Acidanthera](https://github.com/acidanthera) 提供 [AppleALC](https://github.com/acidanthera/AppleALC)，[CPUFriend](https://github.com/acidanthera/CPUFriend)，[HibernationFixup](https://github.com/acidanthera/HibernationFixup)，[Lilu](https://github.com/acidanthera/Lilu)， `USBPower`，[VirtualSMC](https://github.com/acidanthera/VirtualSMC) 和 [WhateverGreen](https://github.com/acidanthera/WhateverGreen)。

- 感谢 [alexandred](https://github.com/alexandred) 和 [hieplpvip](https://github.com/hieplpvip) 提供 [VoodooI2C](https://github.com/alexandred/VoodooI2C)。

- 感谢 [apianti](https://sourceforge.net/u/apianti)，[blackosx](https://sourceforge.net/u/blackosx)，[blusseau](https://sourceforge.net/u/blusseau)，[dmazar](https://sourceforge.net/u/dmazar) 和 [slice2009](https://sourceforge.net/u/slice2009) 提供 [Clover](https://sourceforge.net/projects/cloverefiboot)。

- 感谢 [FallenChromium](https://github.com/FallenChromium)，[Javmain](https://github.com/javmain) 和 [johnnync13](https://github.com/johnnync13) 的宝贵建议。

- 感谢 [RehabMan](https://github.com/RehabMan) 提供 [AppleBacklightFixup](https://github.com/RehabMan/AppleBacklightFixup)，[EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander)，[OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config)，[OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) 和 [SATA-unsupported](https://github.com/RehabMan/hack-tools/tree/master/kexts/SATA-unsupported.kext)。


## 支持与讨论

* tonymacx86.com:
  * [[Guide] Xiaomi Mi Notebook Pro High Sierra 10.13.6](https://www.tonymacx86.com/threads/guide-xiaomi-mi-notebook-pro-high-sierra-10-13-6.242724)

* QQ群:
  * 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  * 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)
  * 331686786 [一起吃苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)
  * 688324116 [一起黑苹果](https://shang.qq.com/wpa/qunwpa?idkey=6bf69a6f4b983dce94ab42e439f02195dfd19a1601522c10ad41f4df97e0da82)
  * 257995340 [一起啃苹果](http://shang.qq.com/wpa/qunwpa?idkey=8a63c51acb2bb80184d788b9f419ffcc33aa1ed2080132c82173a3d881625be8)

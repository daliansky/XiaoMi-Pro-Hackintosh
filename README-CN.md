# 小米笔记本PRO安装MacOS High Sierra & Sierra 使用说明

让你的小米PRO笔记本吃上黑苹果



## 支持列表

* 支持10.13 / 10.12.6
* CPU为第八代，原生支持
* 声卡为ALC298，采用AppleALC仿冒，layout-id为99，注入信息位于 `/CLOVER/ACPI/patched/SSDT-ALC298_XiaoMiPro.aml`
* 触摸板驱动程序使用VoodooI2C，支持多手势，触摸板开机可正常使用，不漂移，无需唤醒
* 其他ACPI补丁修复使用hotpatch方式，文件位于 `/CLOVER/ACPI/patched` 中
* USB遮盖使用 `/CLOVER/ACPI/patched/SSDT-USB.aml`
* 原生亮度快捷键支持，注入信息位于 `/CLOVER/ACPI/patched/SSDT-LGPA.aml`
* 原生蓝牙不完美。如果你想禁用它来省电或者用USB蓝牙代替原生蓝牙，请阅读https://github.com/daliansky/XiaoMi-Pro/issues/24 给出的步骤。



## 更新日期：

* 10-14-2017
    * EFI更新，触摸板工作正常

* 10-17-2017
    * EFI更新，修正显卡驱动
    * 增加HDMI Audio声音输出
    * 驱动更新：
        * Lilu v1.2.0 
        * AppleALC v1.2.1
        * IntelGraphicsDVMTFixup v1.2.0
        * AirportBrcmFixup v1.1.0
    * 驱动修复：
        * IntelGraphicsFixup v1.2.0 

* 10-18-2017
    * 经测试显卡驱动不如第一版的好，现将显卡驱动恢复为仿冒0x19160000
    * ACPI修复
    * 驱动程序修正
    * 去掉USBInjectAll采用SSDT-UIAL.aml内建USB设备

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
    * Lilu v1.2.0更新，支持10.13.2Beta
    * AppleALC更新，使用最新修正版Lilu联合编译，解决10.13.1更新后无法驱动的问题

* 11-5-2017
    * 整合 `AppleALC_ALC298_id13_id28.kext` 驱动到EFI
    * EFI目录下添加ALCPlugFix目录，请安装完成后进入ALCPlugFix目录，双击 `install双击自动安装.command` 安装耳机插入状态修正守护程序
    * 修正Drivers64UEFI，解决无法安装问题
    * 更新apfs.efi到10.13.1版本

* 11-7-2017
    * Lilu v1.2.1目前还不稳定，存在无法进入系统的风险，所以降级到v1.2.0版本
    * AppleALC降级到V1.2.0

    **EFI暂不支持macOS 10.13.2Beta版本的安装，Lilu不抽风后会持续更新**

* 1-25-2018

    * 支持10.13.x安装使用
    * 更新`VoodooI2C`到2.0.1版本，支持多手势，触摸板开机可正常使用，不漂移，无需唤醒
    * 修复电量百分比不刷新的问题
    * 修复声卡睡眠唤醒无声音的问题
    * 修复屏幕亮度无法保存的问题
    * 更新`Lilu` v1.2.2
    * 更新`AppleALC` v1.2.2 支持小米Pro，注入ID:99


* 4-8-2018

    * 支持10.13.4安装使用
    * 更新`ACPIBatteryManager` v1.81.4
    * 更新`AppleALC` v1.2.6
    * 更新`FakeSMC` v6.26-344-g1cf53906.1787
    * 更新`IntelGraphicsDVMTFixup` v1.2.1
    * 更新`IntelGraphicsFixup` v1.2.7，不再需要额外的驱动给显卡注入id了
    * 更新`Lilu` v1.2.3
    * 更新`Shiki` v2.2.6
    * 更新`USBInjectAll` v0.6.4
    * 新增驱动`AppleBacklightInjector`，开启更多档位的亮度调节
    * 新增驱动`CPUFriend` 和`CPUFriendDataProvider`，开启原生XCPM和HWP电源管理方案
    * 新增启动参数`shikigva=1`，`igfxrst=1`和`igfxfw=1`增强核显性能，并用新的方法修复启动第二阶段的八个苹果
    * 新增`SSDT-LGPA.aml`，支持原生亮度快捷键
    
* 4-13-2018
    
    * 更新`AppleALC` v1.2.7
    * 更新`SSDT-IMEI.aml`, `SSDT-PTSWAK.aml`, `SSDT-SATA.aml`, `SSDT-XOSI.aml`
    * 修改`SSDT-LPC.aml`已加载原生电源驱动`AppleLPC`
    * 更新Clover r4438
    * 发布Clover v2.4 r4438小米笔记本PRO专用安装程序

        ![Clover_v2.4k_r4438](http://7.daliansky.net/clover4438/2.png)

* 5-14-2018
    
    * 重命名了一些SSDT，让他们更符合Rehabman的标准，方便后期维护。同时更新了`SSDT-GPRW.aml`, `SSDT-DDGPU.aml`, `SSDT-RMCF.aml`和`SSDT-XHC.aml`
    * 删除config里的一些无用重命名
    * 重做了USB驱动，现在type-c接口支持USB3.0了 
    * 删除`SSDT-ADBG.aml`，它是个无用的方法覆写
    * 删除`SSDT-IMEI.aml`来避免开机日志里出现的错误信息（显卡id能被`IntelGraphicsFixup`自动注入）
    * 新增`SSDT-EC.aml`和`SSDT-SMBUS.aml`来加载AppleBusPowerController和AppleSMBusPCI
    * 修改`SSDT-PCIList.aml`，使系统信息.app显示正确的信息
    * 更新`Lilu` v1.2.4
    * 更新`CPUFriendDataProvider`让系统更省电
    * 更新Clover r4458


## 鸣谢

- [RehabMan](https://github.com/RehabMan) Updated [OS-X-Clover-Laptop-Config](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) and [OS-X-USB-Inject-All](https://github.com/RehabMan/OS-X-USB-Inject-All) and [OS-X-FakeSMC-kozlek](https://github.com/RehabMan/OS-X-FakeSMC-kozlek) and [OS-X-ACPI-Battery-Driver](https://github.com/RehabMan/OS-X-ACPI-Battery-Driver) and [OS-X-Null-Ethernet](https://github.com/RehabMan/OS-X-Null-Ethernet) and [OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) for maintenance

- [vit9696](https://github.com/vit9696) Updated [Lilu](https://github.com/vit9696/Lilu) and [AppleALC](https://github.com/vit9696/AppleALC) and [Shiki](https://github.com/vit9696/Shiki) for maintenance

- [BarbaraPalvin](https://github.com/BarbaraPalvin) Updated [IntelGraphicsDVMTFixup](https://github.com/BarbaraPalvin/IntelGraphicsDVMTFixup) for maintenance

- [Pike R. Alpha](https://github.com/Piker-Alpha) Updated [ssdtPRGen.sh](https://github.com/Piker-Alpha/ssdtPRGen.sh) and [AppleIntelInfo](https://github.com/Piker-Alpha/AppleIntelInfo) for maintenance

- [toleda](https://github.com/toleda), [Mirone](https://github.com/Mirone) and certain others for audio patches and layouts

- [PMheart](https://github.com/PMheart) Updated [CPUFriend](https://github.com/PMheart/CPUFriend) for maintenance

- [alexandred](https://github.com/alexandred) Updated [VoodooI2C](https://github.com/alexandred/VoodooI2C) for maintenance

- [PavelLJ](https://github.com/PavelLJ) for valuable suggestions

- [Javmain](https://github.com/javmain) for valuable suggestions


## 安装

请参考详细的安装教程（中文版）[macOS安装教程兼小米Pro安装过程记录](https://blog.daliansky.net/MacOS-installation-tutorial-XiaoMi-Pro-installation-process-records.html).
完整的EFI压缩版请访问 [releases](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases) 页面.



## 关于打赏

如果您认可我的工作，请通过打赏支持我后续的更新

| 微信                                       | 支付宝                                      |
| ---------------------------------------- | ---------------------------------------- |
| ![wechatpay_160](http://ous2s14vo.bkt.clouddn.com/wechatpay_160.jpg) | ![alipay_160](http://ous2s14vo.bkt.clouddn.com/alipay_160.jpg) |

## 支持与讨论

* QQ群:
  * 247451054 [小米PRO黑苹果高级群](http://shang.qq.com/wpa/qunwpa?idkey=6223ea12a7f7efe58d5972d241000dd59cbd0260db2fdede52836ca220f7f20e)
  * 137188006 [小米PRO黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=c17e190b9466a73cf12e8caec36e87124fce9e231a895353ee817e9921fdd74e)

  ​


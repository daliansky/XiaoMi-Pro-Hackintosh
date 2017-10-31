# 小米笔记本PRO安装MacOS High Sierra & Sierra 使用说明

## CLOVER
* 支持10.13 / 10.12.6
* CPU为第八代，原生支持
* 显卡仿冒支持，platform-id为0x19160000，注入信息通过 `/CLOVER/ACPI/patched/SSDT-Config.aml` 加载
* 声卡为ALC298，采用AppleALC仿冒，layout-id为28，注入信息位于 `/CLOVER/ACPI/patched/SSDT-Config.aml`
* 触摸板驱动程序使用VoodooI2C + ApplePS2SmartTouchPad，启动后触摸板可用，睡眠唤醒后触摸板支持多手势
* 其他ACPI补丁修复使用hotpatch方式，文件位于 `/CLOVER/ACPI/patched` 中
* USB遮盖使用 `/CLOVER/kexts/Other/USBInjectAll_patched.kext` ，`SSDT-MiPro_USB.aml` 未加载，原因未知

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
    ![ALC298声卡驱动安装](http://ous2s14vo.bkt.clouddn.com/ALC298声卡驱动安装.png)

    

## 关于打赏
如果您认可我的工作，请通过打赏支持我后续的更新

|微信|支付宝|
| --- | --- |
|![wechatpay_160](http://ous2s14vo.bkt.clouddn.com/wechatpay_160.jpg)|![alipay_160](http://ous2s14vo.bkt.clouddn.com/alipay_160.jpg)|

#### QQ群:
331686786 [一起黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)


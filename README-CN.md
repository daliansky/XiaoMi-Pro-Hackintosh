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
* 下一版更新内容：
    * 添加BCM94352z无线网卡驱动

#### QQ群:
331686786 [一起黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)


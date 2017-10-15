# XiaoMi Note Pro for macOS High Sierra & Sierra

## CLOVER
* 支持10.13 / 10.12.6
* CPU本机支持
* 显卡仿冒支持，platform-id为0x19160000，注入信息通过/CLOVER/ACPI/patched/SSDT-Config.aml加载
* 声卡为ALC298，采用AppleALC伪造，layout-id为28，注入信息位于/CLOVER/ACPI/patched/SSDT-Config.aml
* 触摸板驱动程序使用VoodooI2C + ApplePS2SmartTouchPad，启动正常触摸的工作，正常手势后唤醒
* 其他ACPI补丁修复使用hotpatch方式，文件位于/ CLOVER / ACPI / patch中

#### QQ群:
331686786 [一起黑苹果](http://shang.qq.com/wpa/qunwpa?idkey=db511a29e856f37cbb871108ffa77a6e79dde47e491b8f2c8d8fe4d3c310de91)


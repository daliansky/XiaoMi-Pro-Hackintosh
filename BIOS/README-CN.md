# 升级BIOS和增强性能

[English](README.md) | [中文](README-CN.md)

### 简介

文件夹 [Firmware v0603](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/Firmware%20v0603) 的BIOS包来自小米官方，来源可靠。建议把BIOS升级到 `0603` 版本，因为后文的风扇逻辑优化脚本是基于这个版本制作的。

文件夹 [ME](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/ME) 的ME固件来自于 [Fernando's Win-RAID 论坛](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html)。更新最新的ME固件有助于抵御潜在的恶意攻击。上述文件夹里的ME固件版本是 `Intel CSME 11.8 Consumer PCH-LP Firmware v11.8.55.3510`，`Intel (CS)ME System Tools` 的版本是 `Intel CSME System Tools v11 r14 - (2018-08-09)`。

警告：因为操作涉及到BIOS等底层代码，如果在升级过程中出现错误（比如升级程序强制退出，或不正确地运行[#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)里的脚本)，电脑可能无法启动。

如果很不幸这些悲惨的事情发生在你身上，建议你去咨询小米售后进行维修。如果你使用了本仓库的任意脚本或固件包，你需要承担所有后果，作者只是提供固件和途径，请大家谨慎斟酌。


### 怎么升级BIOS

1. 下载 [Firmware v0603](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/Firmware%20v0603) 文件夹里的所有文件。

2. 提取所有文件，并把它们拷贝进一个FAT32文件格式的U盘的根目录。

3. 重启你的电脑并狂按 `F12` 来选择U盘启动。
  - 注意：从这一步开始，你的电脑最好接上电源，直到整个安装进程结束。

4. 在出现的命令操作界面，输入 `unlockme.nsh`，然后按 `Enter`。接着电脑会自动重启。

5. 重复第三步，这次在出现的命令操作界面输入 `flash.nsh`。

6. 耐心等待直到安装进程结束。


### 怎么升级ME固件

1. 下载 [ME](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/ME) 文件夹里的所有文件。

2. 在C盘根目录下创建一个文件夹，命名为 `Win64` (路径: C:\Win64) 然后把第一步里得到的所有文件拷贝进 `Win64` 文件夹。

3. 确保你的电脑插上了电源而且状态正常。

4. 用管理员身份运行 `Windows PowerShell`，然后输入以下命令：
```
cd C:\Win64
```
按下 `Enter` 键之后 `PowerShell` 应该定位到了相关文件夹。

5. 现在输入以下命令：
```
.\FWUpdLcl64.exe -F ME.bin
```
(注意：第一个字符是一个点！) 然后按下 `Enter` 键。
之后的操作会由系统自动完成。

6. 耐心等待，直到这个程序成功结束。

7. 重启电脑。


### 怎么提升性能

[PavelLJ](https://github.com/PavelLJ) 和 [Cyb](http://4pda.ru/forum/index.php?showuser=914121) 制作了脚本用来扩大DVMT大小（从32MB扩大到64MB），解锁MSR 0xE2寄位器，和修改EC固件来减少风扇噪声。如果想获取更多的信息，你可以访问 [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8) 和 [cybsuai的仓库](https://github.com/cybsuai/Mi-Notebook-Pro-tweaks)。


### 鸣谢

感谢 [Xiaomi Official](https://www.mi.com/service/bijiben/) 提供BIOS包。

感谢 [Cyb](http://4pda.ru/forum/index.php?showuser=914121) 和 [PavelLJ](https://github.com/PavelLJ) 提供优秀的脚本来增强性能。

感谢 [plutomaniac's post](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html) 提供ME固件。

感谢 [Fernando_Uno](http://en.miui.com/space-uid-2239545255.html) 提供升级ME固件的教程。原教程在 [这里](http://en.miui.com/thread-3260884-1-1.html)。

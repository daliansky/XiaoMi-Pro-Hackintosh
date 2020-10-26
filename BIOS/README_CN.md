# 升级 BIOS 和增强性能

[English](README.md) | **中文**

## 简介

[XMAKB5R0P0603](XMAKB5R0P0603) 和 [XMAKB5R0P0906](XMAKB5R0P0906) 里的 BIOS 包和 [XMAKB5R0P0A07](XMAKB5R0P0A07.exe) 都来自小米官方，来源可靠。**这些包仅支持 MX150 版本。**

~文件夹 [ME](ME) 的 ME 固件来自于 [Fernando's Win-RAID 论坛](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html)。更新最新的 ME 固件有助于抵御潜在的恶意攻击。上述文件夹里的 ME 固件版本是 `Intel CSME 11.8 Consumer PCH-LP Firmware v11.8.55.3510`，`Intel (CS)ME System Tools` 的版本是 `Intel CSME System Tools v11 r14 - (2018-08-09)`。~

警告：因为操作涉及到 BIOS 等底层代码，如果在升级过程中出现错误（比如升级程序强制退出，或不正确地运行[#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)里的脚本)，电脑可能无法启动。

如果很不幸这些悲惨的事情发生在你身上，建议你去咨询小米售后进行维修。如果你使用了本仓库的任意脚本或固件包，你需要承担所有后果，作者只是提供固件和途径，请大家谨慎斟酌。


### 0906 BIOS 更新了什么

- BIOS 面板里新增 `KB Backlight Mode` 选项，可选择 `Power Saving` （默认，键盘灯空闲15秒后自动熄灭）或 `Standard` （键盘灯在系统非睡眠时常亮）
- 减少低负载下的风扇噪声


### 0A07 和 0E07 BIOS 更新了什么

- 我对这些版本的新特性完全不知情。提供者们没有给予很多的信息。
- 在我的电脑上 0A07 版本的 `KB Backlight Mode` - `Standard` 不工作。
- 升级到这些 BIOS 版本十分简单，下载并打开 [XMAKB5R0P0A07](XMAKB5R0P0A07.exe) 或 [XMAKB5R0P0E07](XMAKB5R0P0E07.exe) 即可。


## 怎么升级/降级到 0603 BIOS

1. 准备一个 FAT32 U盘，下载 [XMAKB5R0P0603](XMAKB5R0P0603) 文件夹里的所有文件并把它们放入U盘的根目录。

2. 插上电源并重启电脑，按 `F12`，并选择U盘启动项。

3. 在 shell 界面，输入 `unlockme.nsh`，然后电脑可能会自动重启。然后重复第 2 步并输入 `flash.nsh`。

4. 等待安装过程结束。


## 怎么升级 0906 BIOS

有句老话说得好，“不打无准备之仗”。**备份重要资料永远不会错。** 有用户反映运行程序后会遇到蓝屏问题。

1. 下载 [XMAKB5R0P0906](XMAKB5R0P0906) 文件夹里的所有文件。

2. 用管理员权限运行 `H2OFFT-Wx64.exe`。
  - 注意：从这一步开始，你的电脑最好接上电源，直到整个安装进程结束。

3. 一个警告可能会出现，忽视它并继续更新。

4. 电脑会自动重启，等待，直到安装过程结束。


## 怎么提升性能

**仅支持 MX150。**
[FallenChromium](https://github.com/FallenChromium) 和 [Cyb](http://4pda.ru/forum/index.php?showuser=914121) 制作了脚本用来扩大动态显存大小（从32mb扩大到64mb），解锁 MSR 0xE2 寄位器，和修改 EC 固件来减少风扇噪声。如果想获取更多的信息，你可以访问 [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8) 和 [cybsuai的仓库](https://github.com/cybsuai/Mi-Notebook-Pro-tweaks)。


## 鸣谢

- 感谢 [小米官方](https://www.mi.com/service/bijiben/drivers/15/) 提供 0E07 BIOS 包。
- 感谢 [小米官方](https://www.mi.com/service/bijiben/) 和 [一土木水先生](http://bbs.xiaomi.cn/u-detail-1242799508) 提供 BIOS 包。原出处在[这里](http://bbs.xiaomi.cn/t-36660609-1)。
- 感谢一个热心的朋友提供 0A07 BIOS 包。他不想惹上麻烦，所以还请大家不要随意流传 0A07 BIOS 包。**不建议QQ群友讨论并上传此包，会给上传者带来很大的麻烦。**
- 感谢 [Cyb](http://4pda.ru/forum/index.php?showuser=914121) 和 [FallenChromium](https://github.com/FallenChromium) 提供优秀的脚本来增强性能。

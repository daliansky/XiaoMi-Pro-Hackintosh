# ALC 耳机修复

[English](README.md) | [中文](README-CN.md)

## 简介

* 它可以解决耳机插拔状态的切换。
* 它是通过使用命令: `hda-verb 0xNode SET_PIN_WIDGET_CONTROL 0xVerbs` 的方式进行状态切换
* `hda-verb` 是原本来自于linux下面的 `alsa-project` 的一条命令，它的作用是发送HD-audio命令。


## 怎么安装

* 下载整个 [XiaoMi-Pro包](https://github.com/daliansky/XiaoMi-Pro/archive/master.zip), 前往 `ALCPlugFix` 文件夹， 双击 `chinese_install.command`。

* 等待脚本部署补丁文件和重建缓存（补丁文件在 `fix` 文件夹），这可能要花上几秒。

* 当你看到 `按任何键退出` 时，说明安装结束。请按任意键回车，然后重启电脑，完成。

注意：每次开机后，你可能需要重新插拔耳机来让耳机正常工作。


## 鸣谢

* 感谢 [goodwin](https://github.com/goodwin) 提供 [ALCPlugFix](https://github.com/goodwin/ALCPlugFix)。

* 感谢 [Keven Lefebvre](https://github.com/orditeck) 对脚本的改善。

* 感谢 [Rehabman](https://github.com/RehabMan) 提供 [hda-verb](https://github.com/RehabMan/EAPD-Codec-Commander) 的维护。

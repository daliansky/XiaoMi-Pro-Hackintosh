# ALC 耳机修复

[English](README.md) | **中文**

## 简介

* 它可以解决耳机插拔状态的切换。
* 它是通过使用命令: `hda-verb 0xNode SET_PIN_WIDGET_CONTROL 0xVerbs` 的方式进行状态切换
* `hda-verb` 是原本来自于Linux下面的 `alsa-project` 的一条命令，它的作用是发送 HD-audio 命令。


## 使用方法

- 在终端输入以下命令并回车：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/one-key-alcplugfix_cn.sh)"
```

- 重启电脑，完成。

注意：每次开机后，你可能需要重新插拔耳机来让耳机正常工作。


## 鸣谢

* 感谢 [goodwin](https://github.com/goodwin) 和 [Menchen](https://github.com/Menchen/ALCPlugFix) 提供和维护 [ALCPlugFix](https://github.com/goodwin/ALCPlugFix)。

* 感谢 [Keven Lefebvre](https://github.com/orditeck) 对脚本的改善。

* 感谢 [Rehabman](https://github.com/RehabMan) 提供 [hda-verb](https://github.com/RehabMan/EAPD-Codec-Commander) 的维护。

# 开启macOS HIDPI

[English](README.md) | [中文](README-CN.md)

### 简介

此脚本的目的是为中低分辨率的屏幕开启 HiDPI 选项，并且具有原生的 HiDPI 设置，不需要 RDM 软件即可在系统显示器设置中设置。开启后分辨率会伪装成2688 x 1512，UI看起来像1344 x 756。相比之前的版本，这个脚本解决了开机花屏和唤醒花屏问题。

macOS 的 DPI 机制和 Windows 下不一样，比如 1080p 的屏幕在 Windows 下有 125%、150% 这样的缩放选项，而同样的屏幕在 macOS 下，缩放选项里只是单纯的调节分辨率，这就使得在默认分辨率下字体和UI看起来很小，降低分辨率又显得模糊。

开机的第二阶段 logo 总是会稍微放大，因为分辨率是仿冒的。

目录里的脚本为小米笔记本Pro专用。


### 使用方法

下载整个文件夹，然后运行目录里的 `install.command`，重启。

在 `系统偏好设置 - 显示器` 里选择 `1344 x 756`。

### 恢复

如果使用此脚本后，开机无法进入系统，请到恢复模式中或使用 clover `-x` 安全模式进入系统 ，使用终端删除 `/System/Library/Displays/Contents/Resources/Overrides` 下删除显示器 VendorID 对应的文件夹，并把 backup 文件夹中的备份复制出来。

具体命令如下：

```
$ cd /Volumes/你的系统盘/System/Library/Displays/Contents/Resources/Overrides
$ VendorID=$(ioreg -l | grep "DisplayVendorID" | awk '{print $8}')
$ Vid=$(echo "obase=16;$VendorID" | bc | tr 'A-Z' 'a-z')
$ rm -rf ./DisplayVendorID-$Vid
$ cp -r ./backup/* ./
```


## 鸣谢

感谢 [zysuper](https://github.com/zysuper) 提供基本功能。

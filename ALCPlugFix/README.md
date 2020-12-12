# ALC Plug Fix

**English** | [中文](README_CN.md)

## Introduction

* The script can solve unworking headphone jack.
* It sends command: `hda-verb 0xNode SET_PIN_WIDGET_CONTROL 0xVerbs` to activate headphone jack.
* `hda-verb` is originally from a command of `alsa-project` in Linux. Its function is to send HD-audio commands.


## How to install

- Run the following command in Terminal:

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/main/ALCPlugFix/one-key-alcplugfix.sh)"
```

- When it's done, restart your computer. The installation now completes.

ATTENTION: You may have to replug the headphone after every boot to let headphone work.


## Credits

* Thanks to [goodwin](https://github.com/goodwin) and [Menchen](https://github.com/Menchen/ALCPlugFix) for providing and maintaining [ALCPlugFix](https://github.com/goodwin/ALCPlugFix).

* Thanks to [Keven Lefebvre](https://github.com/orditeck) for updating the script.

* Thanks to [Rehabman](https://github.com/RehabMan) for providing [hda-verb](https://github.com/RehabMan/EAPD-Codec-Commander).

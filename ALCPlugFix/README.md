# ALC Plug Fix

[English](README.md) | [中文](README-CN.md)

## Introduction

* The script can solve unworking headphone jack.
* It sends command: `hda-verb 0xNode SET_PIN_WIDGET_CONTROL 0xVerbs` to activate headphone jack.
* `hda-verb` is originally from a command of `alsa-project` in linux. Its function is to send HD-audio commands.


## How to Install

* Download the whole [XiaoMi-Pro Pack](https://github.com/daliansky/XiaoMi-Pro/archive/master.zip), go to `ALCPlugFix` folder, and double click `english_install.command`.

* Wait while the script copies the required files and reflash kextcache (related files are in the `fix` folder). It may take a few seconds.

* When it's done, you'll see `Press any key to Exit`. Type any key and press Enter, then restart your computer. The installation now completes.

ATTENTION: You may have to replug the headphone after every boot to let headphone work.


## Credit

* Thanks to [goodwin](https://github.com/goodwin) for providing [ALCPlugFix](https://github.com/goodwin/ALCPlugFix).

* Thanks to [Keven Lefebvre](https://github.com/orditeck) for updating the script.

* Thanks to [Rehabman](https://github.com/RehabMan) for providing [hda-verb](https://github.com/RehabMan/EAPD-Codec-Commander).

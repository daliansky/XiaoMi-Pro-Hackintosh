# Open macOS HiDPI

English | [中文](README_CN.md)

## Instruction

This program is to open native Apple HiDPI settings for non-Retina screen, and no need for RDM. The resolution is faked to 2848 x 1604, and UI looks like 1424 x 802. Comparing to the previous version, this one solves glitter in boot page and in wake up.

macOS has different dpi mechanism with Windows 10. For example, Win10 provides 125% scale or 150% scale option, while macOS can only change to lower resolution if users choose "Scale" on a non-Retina screen. In this way, the vision experience is bad since UI and text seem small in 1080p, and they seem fuzzy if people choose "Scale".

Logo scaling up may not be resolved, because the higher resolution is faked.

In addition, this program is only for Mi Pro.


## How to install

- Run the following command in Terminal:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-hidpi/one-key-hidpi.sh)"
```


## Recovery

If you cant boot into system, or get any another issues, you can use clover `-x ` reboot or into Recovery mode, remove `DisplayVendorID-9e5` folder under `/System/Library/Displays/Contents/Resources/Overrides` , and move backup files.

In Terminal: 

```
$ cd /Volumes/"Your System Disk Part"/System/Library/Displays/Contents/Resources/Overrides
$ rm -rf ./DisplayVendorID-9e5
$ cp -r ./backup/* ./
```


## Credits

- Thanks to [xzhih](https://github.com/xzhih) for providing interface.
    - Father script: [one-key-hidpi](https://github.com/xzhih/one-key-hidpi)
- Thanks to [zysuper](https://github.com/zysuper) for providing resolution.

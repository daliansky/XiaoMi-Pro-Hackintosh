# Open macOS HIDPI

[English](README.md) | [中文](README-CN.md)

## Instruction

This program is to open native Apple HiDPI settings for non-Retina screen, and no need for RDM. The resolution is faked to 2848 x 1604, and UI looks like 1424 x 802. Comparing to the previous version, this one solves glitter in boot page and in wake up.

macOS has different dpi mechanism with Windows 10. For example, Win10 provides 125% scale or 150% scale option, while macOS can only change to lower resolution if users choose "Scale" on a non-Retina screen. In this way, the vision experience is bad since UI and text seem small in 1080p, and they seem fuzzy if people choose "Scale".

Logo scaling up may not be resolved, because the higher resolution is faked.

In addition, this program is only for Mi Pro.


## How to install

Download the whole folder and run `install.command`, then restart.

Choose `1424 x 802` in `SysPref - Display`.


## Recovery

If you cant boot into system, or get any another issues, you can use clover `-x ` reboot or into Recovery mode, remove your display's DisplayVendorID folder under `/System/Library/Displays/Contents/Resources/Overrides` , and move backup files.

In Terminal: 

```
$ cd /Volumes/"Your System Disk Part"/System/Library/Displays/Contents/Resources/Overrides
$ VendorID=$(ioreg -l | grep "DisplayVendorID" | awk '{print $8}')
$ Vid=$(echo "obase=16;$VendorID" | bc | tr 'A-Z' 'a-z')
$ rm -rf ./DisplayVendorID-$Vid
$ cp -r ./backup/* ./
```


## Credits

Thanks to [zysuper](https://github.com/zysuper) for providing base function of this program.

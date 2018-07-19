# Run Two Files to open MacOS HIDPI

### Instruction

This program is to open native Apple HiDPI settings for non-Retina screen, and no need for RDM. (Currently I found that macOS 10.13.4 only supports 1440x810 HiDPI, and macOS 10.13.3 works great.)

MacOS has different dpi mechanism with Windows 10. For example, Win10 provides 125% scale or 150% scale option, while MacOS can only change to lower resolution if users choose "Scale" on a non-Retina screen. In this way, the experience is bad since UI and text seem small in 1080p, and they seem fuzzy if people choose "Scale".

In addition, this program is adjusted for Mi Pro to avoid wake problems.

Appearance:

![HIDPI.png](https://i.loli.net/2018/05/27/5b09ff7b4745c.jpg)

### How to install

Run script in Terminal

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"
```

![RUN](./img/run.jpg)

Then, also run `install.command`. This program is used to avoid wake problems.

### Recovery

If you cant boot into system, or get any another issues, you can use clover `-x ` reboot or into Recovery mode, remove your display's DisplayVendorID folder under `/System/Library/Displays/Contents/Resources/Overrides` , and move backup files

In Terminal: 

```
$ cd /Volumes/"Your System Disk Part"/System/Library/Displays/Contents/Resources/Overrides
$ VendorID=$(ioreg -l | grep "DisplayVendorID" | awk '{print $8}')
$ Vid=$(echo "obase=16;$VendorID" | bc | tr 'A-Z' 'a-z')
$ rm -rf ./DisplayVendorID-$Vid
$ cp -r ./backup/* ./
```


## Credit

Thanks for [xzhih](https://github.com/xzhih) for providing base function of this program.

Thanks for [zysuper](https://github.com/zysuper) for providing base function of this program.

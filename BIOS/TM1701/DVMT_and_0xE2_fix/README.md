# DVMT and 0xE2 fix

**English** | [中文](README_CN.md)

## Instruction

**MX150 Only!**

0. **SUPER IMPORTANT! Modifications only checked on BIOS 603. Neither @FallenChromium nor Cyb is responsible for any damage, all is working for us, but you're doing all on your risk.**
    - After several tests, I found that the script is safe for 0906 BIOS.

1. **IMPORTANT - Make a backup file using `backup.cmd`, save output file `mybackup.bin` somewhere in the cloud. This is a proof-of-concept and not stable revision.**

2. Before any other manipulations, make sure PowerShell scripts execution is allowed on your Windows machine. Further info [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6). I set all of policies (CurrentUser and etc.) to Unrestricted and only after this executables worked for me.

3. Execute `bios_unlock.cmd` before making any further changes to BIOS.

4. Execute `DVMT_set.cmd` to make DVMT=64mb. You need to restart to let it work. You can't apply all the patches and restart aftetward as it would apply only the latest patch.

5. Execute `CFG_unlock.cmd`, restart again. 

6. Execute `bios_lock.cmd` to lock BIOS settings for security.

7. Delete DVMT patches and change `framebuffer-flags`.

- **For both Clover and OC users:**
  - Open `/EFI/CLOVER (or OC)/config.plist`, delete the following code:
```xml
    <key>framebuffer-fbmem</key>
    <data>AACQAA==</data>
    <key>framebuffer-stolenmem</key>
    <data>AAAwAQ==</data>
```
- Then edit the `framebuffer-flags` to enable `FBEnableDynamicCDCLK`
```diff
    <key>framebuffer-flags</key>
-   <data>CwfDAA==</data>
+   <data>CwfjAA==</data>
```
- Optional, change `ig-platform-id` to `0x05001c59` (macOS version > 10.14) to enhance graphic performance
```diff
    <key>AAPL,ig-platform-id</key>
-   <data>AAAWWQ==</data>
+   <data>BQAcWQ==</data>
    <key>AAPL,slot-name</key>
    <string>Internal</string>
    <key>complete-modeset-framebuffers</key>
    <data>AAAAAAAAAAE=</data>
    <key>device-id</key>
    <data>FlkAAA==</data>
    <key>force-online</key>
    <data>AQAAAA==</data>
    <key>force-online-framebuffers</key>
    <data>AAAAAAAAAAE=</data>
-   <key>framebuffer-con0-enable</key>
-   <data>AQAAAA==</data>
-   <key>framebuffer-con0-flags</key>
-   <data>mAQAAA==</data>
    <key>framebuffer-con1-enable</key>
    <data>AQAAAA==</data>
-   <key>framebuffer-con1-flags</key>
-   <data>xwMAAA==</data>
    <key>framebuffer-con1-pipe</key>
    <data>CgAAAA==</data>
    <key>framebuffer-con1-type</key>
    <data>AAgAAA==</data>
    <key>framebuffer-con2-enable</key>
    <data>AQAAAA==</data>
-   <key>framebuffer-con2-flags</key>
-   <data>xwMAAA==</data>
```

8. Disable MSR 0xE2 patch.

-  For Clover users, change the following code to disable MSR 0xE2 patch:
```diff
    <key>KernelPm</key>
-   <true/>
+   <false/>
```
-  For OC users, change the following code to disable MSR 0xE2 patch:
```diff
    <key>AppleXcpmCfgLock</key>
-   <true/>
+   <false/>
```


## Tutorial

You can watch video tutorial in this link:[Xiaomi Mi Notebook Pro Прошивка BIOS + Патч кулеров [4K]](https://www.youtube.com/watch?v=he4QNY2slE0&feature=youtu.be)


## Credits

- Thanks to [FallenChromium](https://github.com/FallenChromium) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) for writing the script and instruction.

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

7. Delete DVMT patches

- **For both Clover and OC users:**
  - Open `/EFI/CLOVER (or OC)/config.plist`, delete the following code:
```
<key>framebuffer-fbmem</key>
<data>AACQAA==</data>
<key>framebuffer-stolenmem</key>
<data>AAAwAQ==</data>
```

8. Delete OC MSR 0xE2 patch

Open `/EFI/OC/config.plist`, find the following code:
```
<key>AppleCpuPmCfgLock</key>
<true/>
<key>AppleXcpmCfgLock</key>
<true/>
```
Change to:
```
<key>AppleCpuPmCfgLock</key>
<false/>
<key>AppleXcpmCfgLock</key>
<false/>
```


## Tutorial

You can watch video tutorial in this link:[Xiaomi Mi Notebook Pro Прошивка BIOS + Патч кулеров [4K]](https://www.youtube.com/watch?v=he4QNY2slE0&feature=youtu.be)


## Credits

- Thanks to [FallenChromium](https://github.com/FallenChromium) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) for writing the script and instruction.

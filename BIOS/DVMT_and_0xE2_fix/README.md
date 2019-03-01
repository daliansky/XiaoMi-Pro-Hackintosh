# DVMT and 0xE2 fix

[English](README.md) | [中文](README_CN.md)

## Instruction

0. <b>SUPER IMPORTANT! Modifications only checked on BIOS 603. Neither @FallenChromium nor Cyb is responsible for any damage, all is working for us, but you're doing all on your risk.</b>
    - After several tests, I found that the script is safe for 0906 BIOS.

1. <b>IMPORTANT - Make a backup file using `backup.cmd`, save output file `mybackup.bin` somewhere in the cloud. This is proof-of-concept and not stable revision.</b>

2. Before any other manipulations, make sure PowerShell scripts execution is allowed on your Windows machine. Further info [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6). I set all of policies (CurrentUser and etc.) to Unrestricted and only after this executables worked for me.

3. Execute `bios_unlock.cmd` before making any further changes to BIOS.

4. Execute `DVMT_set.cmd` to make DVMT=64mb. You need to restart again and it wouldn't work if you wouldn't, you can't apply all patches and restart aftetwards as it would apply only latest patch.

5. Execute `CFG_unlock.cmd`, restart again. 

6. Now you can delete DVMT patches and enable `RtcHibernateAware` to get more power-saving sleep. 

6a. Delete DVMT patches

- Open `/EFI/CLOVER/config.plist`, delete the following code:
```
    <key>framebuffer-fbmem</key>
    <data>AACQAA==</data>
    <key>framebuffer-stolenmem</key>
    <data>AAAwAQ==</data>
```

6b. Enable `RtcHibernateAware`

- Open `/EFI/CLOVER/config.plist`, find the following code:
```
    <key>NeverHibernate</key>
```

- Replace with:
```
    <key>RtcHibernateAware</key>
```

7. Execute `bios_lock.cmd` to lock BIOS settings for security.


## Credits

- Thanks to [FallenChromium](https://github.com/FallenChromium) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) for writing the script and instruction.

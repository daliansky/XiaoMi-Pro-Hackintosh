# Update BIOS and Unlock Better Performance

### Introduction

The BIOS packet in [Firmware v0603](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/Firmware%20v0603) folder is from Xiaomi stuff, so it is reliable. It is highly recommended to update to `0603` version because the script for fan fix is based on that version.

The ME firmware in [ME](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/ME) folder is from [Fernando's Win-RAID Forum](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html). Using the latest ME firmware helps avoiding potential malicious attack.

Warning: Since the operations are related to BIOS, there's possibility that if some errors(such as force quit the update program) occur during the update process(so as to scripts in [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)), the whole system may fail to boot.

If unfortunately this situation happens on you, you need to find Xiaomi stuff to fix your device. If you use this program, you should agree that you are the person who take whole responsibility, instead of the author.


### How to update BIOS

1. Download all the files in [Firmware v0603](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/Firmware%20v0603) folder.

2. Extract all the files and copy them to the root directory of a FAT32 U disk.

3. Restart your laptop and press `F12` botton to choose U disk to boot.
  - IMPORTANT: From this step, your computer should keep in charged by AC adapter until the whole update process finishes.

4. In the new shell interface, type `unlockme.nsh` and press `Enter`, then the system will automatically restart.

5. Repeat the third step, and this time type `flash.nsh`.

6. Wait until the update process ends.


### How to update ME firmware

1. Download all the files in [ME](https://github.com/stevezhengshiqi/XiaoMi-Pro/tree/master/BIOS/ME) folder.

2. Create a new folder within the drive C and name it "Win64" (path: C:\Win64) and copy all the files into "Win64" folder.

3. Make sure, that your notebook is connected to a charger and in the loading mode.

4. Run the Windows PowerShell as Admin and type the following:
```
cd C:\Win64
```
After having hit the Enter key you should now be within the related folder.

5. Now type the following command:
```
.\FWUpdLcl64.exe -F ME.bin
```
(note: the first character is a dot!) and hit the Enter key.
The rest will be done automaticly.

6. Wait until the process has been successfully completed.

7. Restart the notebook.


### How to unlock better performance

[PavelLJ](https://github.com/PavelLJ) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) created scripts for changing DVMT size from 32MB to 64MB, unlocking MSR 0xE2, and editing Embedded Controller(EC) firmware to reduce fan nosie. For more information, you can visit [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8).


### Credit

Thanks to [Xiaomi Official](https://www.mi.com/service/bijiben/) for providing BIOS packet.

Thanks to [Cyb](http://4pda.ru/forum/index.php?showuser=914121) and [PavelLJ](https://github.com/PavelLJ) for writing incredible scripts to unlock better performance.

Thanks to plutomaniac's [post](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html) for providing ME firmware.

Thanks to [Fernando_Uno](http://en.miui.com/space-uid-2239545255.html) for providing the instruction of flashing ME firmware. The origin instruction is [here](http://en.miui.com/thread-3260884-1-1.html).

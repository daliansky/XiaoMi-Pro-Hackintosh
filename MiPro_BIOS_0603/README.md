# Update Your Xiaomi NoteBook Pro BIOS and Unlock Better Performance

### Introduction
This BIOS packet is directly from Xiaomi stuff, so it is reliable. It is highly recommended to update to `0603` version because the script for fan fix is based on that version.

Warning: Since it's a BIOS update, there's possibility that if some errors(such as force quit the update program) occur during the update process(so as to scripts in [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8)), the whole system may fail to boot.

If unfortunately this situation happens on you, you need to find Xiaomi stuff to fix your device. If you use this program, you should agree that you are the person who take whole responsibility, instead of the author.


### How to update BIOS

1. Download all the files in this BIOS folder.

2. Extract all the files and copy them to the root directory of a FAT32 U disk.

3. Restart your laptop and press `F12` botton to choose U disk to boot.
  - IMPORTANT: From this step, your computer should keep in charged by AC adapter until the whole update process finishes.

4. In the new shell interface, type `unlockme.nsh` and press `Enter`, then the system will automatically restart.

5. Repeat the third step, and this time type `flash.nsh`.

6. Wait until the update process ends.


### How to unlock better performance

[PavelLJ ](https://github.com/PavelLJ) and [Cyb](http://4pda.ru/forum/index.php?showuser=914121) created scripts for changing DVMT size from 32MB to 64MB, unlocking MSR 0xE2, and editing Embedded Controller(EC) firmware to reduce fan nosie. For more information, you can visit [#8](https://github.com/stevezhengshiqi/XiaoMi-Pro/issues/8).


### Credit

Thanks for [Xiaomi Official](https://www.mi.com/service/bijiben/) for providing BIOS packet.
Thanks for [Cyb](http://4pda.ru/forum/index.php?showuser=914121) and [PavelLJ ](https://github.com/PavelLJ) for writing incredible scripts to unlock better performance

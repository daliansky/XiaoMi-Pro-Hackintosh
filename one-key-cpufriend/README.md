# Modify macOS CPU Performance

English | [中文](README_CN.md)

## Instruction

[I](https://github.com/stevezhengshiqi) am a newcomer for bash language, and welcome pros to help improve the script.

<b>The script is only for 8th generation CPU(KBL-R, CNL, CFL...).</b>

The script can modify low frequency mode and energy performance preference, and use [ResourceConverter.sh](https://github.com/acidanthera/CPUFriend/tree/master/ResourceConverter) to generate customized `CPUFriendDataProvider.kext`.

By using this script, no file under the System folder will be edited. If you are not happy with the modification, just remove `CPUFriend*.kext` from `/CLOVER/kexts/Other/` and restart.


## Before install

- Read [CPUFriend WARNING](https://github.com/acidanthera/CPUFriend/blob/master/Instructions.md#warning)
- Good network
- Make sure `IOPlatformPluginFamily.kext` untouched
- Make sure [Lilu](https://github.com/acidanthera/Lilu) is working
- `plugin-type=1`


## How to install

- Run the following command in Terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-cpufriend/one-key-cpufriend.sh)"
```

- <b>For Clover users:</b>
  - Copy `CPUFriend.kext` and `CPUFriendDataProvider.kext` from desktop to `/CLOVER/kexts/Other/` and restart.

- <b>For OC users:</b>
  - Copy `CPUFriend.kext` and `CPUFriendDataProvider.kext` from desktop to `/OC/Kexts/`.
  - Open `/OC/config.plist` and find the following code:
```
<dict>
    <key>BundlePath</key>
    <string>CPUFriend.kext</string>
    <key>Comment</key>
    <string>Power Management</string>
    <key>Enabled</key>
    <false/>
    <key>ExecutablePath</key>
    <string>Contents/MacOS/CPUFriend</string>
    <key>MaxKernel</key>
    <string></string>
    <key>MinKernel</key>
    <string></string>
    <key>PlistPath</key>
    <string>Contents/Info.plist</string>
</dict>
<dict>
    <key>BundlePath</key>
    <string>CPUFriendDataProvider.kext</string>
    <key>Comment</key>
    <string>Power Management</string>
    <key>Enabled</key>
    <false/> 
```
Change to:
```
<dict>
    <key>BundlePath</key>
    <string>CPUFriend.kext</string>
    <key>Comment</key>
    <string>Power Management</string>
    <key>Enabled</key>
    <true/>
    <key>ExecutablePath</key>
    <string>Contents/MacOS/CPUFriend</string>
    <key>MaxKernel</key>
    <string></string>
    <key>MinKernel</key>
    <string></string>
    <key>PlistPath</key>
    <string>Contents/Info.plist</string>
    </dict>
<dict>
    <key>BundlePath</key>
    <string>CPUFriendDataProvider.kext</string>
    <key>Comment</key>
    <string>Power Management</string>
    <key>Enabled</key>
    <true/>  
```


## Recovery

- <b>For Clover users:</b>
  - If you are not happy with the modification, just remove `CPUFriend.kext` and `CPUFriendDataProvider.kext` from `/CLOVER/kexts/Other/` and restart.

  - If unfortunately, you can't boot into the system, and you are sure the issue is caused by `CPUFriend*.kext`,
 
    - Press `Space` when you are in Clover page
    - Use keyboard to choose `Block Injected kexts` - `Other`
    - Check `CPUFriend.kext` and `CPUFriendDataProvider.kext`
    - Return to the main menu and boot into the system, then delete `CPUFriend*.kext` from your CLOVER folder
    
- <b>For OC users:</b>
  - Reverse the [How to install](#how-to-install) part and restart


## Modify macOS CPU voltage

[fladnaG86](https://github.com/fladnaG86) provided script to lower down voltage of CPU/GPU/cache memory in [#150](https://github.com/daliansky/XiaoMi-Pro/issues/150), and welcome everyone to test it!


## Credits

- Thanks to [Acidanthera](https://github.com/acidanthera) for providing [CPUFriend](https://github.com/acidanthera/CPUFriend).
- Thanks to [shuhung](https://www.tonymacx86.com/members/shuhung.957282) for providing [configuration modification ideas](https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7).
- Thanks to [PMheart](https://github.com/PMheart) and [xzhih](https://github.com/xzhih) for giving me advice.

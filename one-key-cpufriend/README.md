# Modify macOS CPU Performance

[English](README.md) | [中文](README-CN.md)

## Instruction

[I](https://github.com/stevezhengshiqi) am really a newcomer for bash language, and welcome pros to help improve the script.

<b>The script is only for 8th generation CPU(KBL-R, CNL, CFL...) yet.<b/> I will try to add support for more models if needed.

The script can modify certain configurations of power management, and use [ResourceConverter.sh](https://github.com/acidanthera/CPUFriend/tree/master/ResourceConverter) to generate customized `CPUFriendDataProvider.kext`.

By using this script, no file under the System folder will be edited. If you are not happy with the modification, just remove `CPUFriend*.kext` from `/CLOVER/kexts/Other/` and restart.


## Before install

- Make sure [Lilu](https://github.com/acidanthera/Lilu) is working
- `plugin-type=1`
- Make sure `IOPlatformPluginFamily.kext` untouched


## How to install

Download the whole folder and run `one-key-cpufriend.command`.

Copy `CPUFriend.kext` and `CPUFriendDataProvider.kext` from desktop to `/CLOVER/kexts/Other/` and restart.


## Recovery

If you are not happy with the modification, just remove `CPUFriend.kext` and `CPUFriendDataProvider.kext` from `/CLOVER/kexts/Other/` and restart.

If unfortunately, you can't boot into the system, and you are sure the issue is caused by `CPUFriend*.kext`,
 
 - Press `Space` when you are in Clover page
 - Use keyboard to choose `Block Injected kexts` - `Other`
 - Uncheck `CPUFriend.kext` and `CPUFriendDataProvider.kext`
 - Return to the main menu and boot into the system, then delete `CPUFriend*.kext` from your CLOVER folder


## Modify macOS CPU voltage

[fladnaG86](https://github.com/fladnaG86) provided script to lower down voltage of CPU/GPU/cache memory in [#150](https://github.com/daliansky/XiaoMi-Pro/issues/150), and welcome everyone to test it!


## Credits

Thanks to [Acidanthera](https://github.com/acidanthera) for providing [CPUFriend](https://github.com/acidanthera/CPUFriend).
Thanks to [shuhung](https://www.tonymacx86.com/members/shuhung.957282) for providing [configuration modification ideas](https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7).

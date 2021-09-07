# OC Update script

This script is for OpenCore only, it need an existing and sane configuration of OpenCore, the main aim of this script to make updating EFI less of a chore.

# How to use
```bash
bash <(curl -sL --proto-redir -all,https https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/main/Scripts/install_oc.sh)
```

If for some reason, you want to use a custom EFI(that follow the main repos formats) or GitHub , you can force it with:
```bash
# Force url prompt 
CUSTOM_EFI_URL=1 bash <(curl -sL --proto-redir -all,https https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/main/Scripts/install_oc.sh)
# Fetch patch's in custom repo
REPO_NAME='daliansky' REPO_BRANCH='main' bash <(curl -sL --proto-redir -all,https https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/main/Scripts/install_oc.sh)
```

# Feature
- Automatically detect and download EFI for CML/KBL model.
- Interactive and colorful log.
- Smart backup that check content with diff.
- 0xE2 and DVMT/FrameBuffer detection.
- Bluetooth detection.
- PlatformInfo/Serial detection.
- BootArgs interactive diff.
- SIP interactive diff.
- Kext/SSDT interactive diff.
- Validation with `ocvalidate` and custom check for missing SSDT/Kext file.
- Automatic installation.
- Custom patch support.

# Credits
- Thanks to [Acidanthera](https://github.com/acidanthera) for providing [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg) and many useful Kext's.
- Thanks to [stevezhengshiqi](https://github.com/stevezhengshiqi) for the script review/advices and the old install script.
- Thanks to [Rehabman](https://github.com/RehabMan) for [mount_efi.sh](https://raw.githubusercontent.com/RehabMan/hack-tools/master/mount_efi.sh).
- Thanks to [Menchen](https://github.com/Menchen) for creating this script.

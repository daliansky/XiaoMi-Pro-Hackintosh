# XiaoMi NoteBook Pro EFI Changelog

**English** | [中文](Docs/Changelog_CN.md)

## XiaoMi NoteBook Pro EFI v1.9.0
## 2025-XX-XX
### OC
  - Enable `ForceBooterSignature` to support hibernation

### Change
  - KBL: Remove `-no_compat_check` boot-args


## [XiaoMi NoteBook Pro EFI v1.8.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.9)
## 2025-06-15
Supported macOS Version: 10.15, 11, 12, 13, 14, 15, 26.0 beta 1 (OpenCore Only)  
OpenCore version supports macOS 26.0 beta 1 (25A5279m). On macOS 26.0 beta 1 (25A5279m), [acidanthera/bugtraker](https://github.com/acidanthera/bugtracker) has reports of unbootable FileVault volumes [acidanthera/bugtracker#2499](https://github.com/acidanthera/bugtracker/issues/2499). On macOS 26.0 beta 2 (25A5295e), [acidanthera/bugtraker](https://github.com/acidanthera/bugtracker) has reports of no sound due to dropped `AppleHDA` [acidanthera/bugtracker#2501](https://github.com/acidanthera/bugtracker/issues/2501).  
Intel Wi-Fi is NOT supported on macOS 15+ (Sequoia+). Try itlwm + HeliPort or Ventura kext + OCLP (risky)
### Upgrade
  - Update `OpenCore` v1.0.5 (up to [acidanthera/OpenCorePkg@e8437f7](https://github.com/acidanthera/OpenCorePkg/commit/e8437f737708c7151b243d967f9ceca54193d97e)) to support macOS26.0 beta 1 (25A5279m)
  - Update `Clover` r5162 to support macOS26.0 beta 1 (25A5279m)
  - Update `Lilu` v1.7.1 (up to [acidanthera/Lilu@dc01cb5](https://github.com/acidanthera/Lilu/commit/dc01cb583295ceded4f42a6310a15e3abac1c025)) to support macOS26.0 beta 1 (25A5279m)
  - Update `VirtualSMC` v1.3.7 (up to [acidanthera/VirtualSMC@dbd1ae1](https://github.com/acidanthera/VirtualSMC/commit/dbd1ae1ee5adc7f2debd9311bf28ca2902d1bfcc)) to support macOS26.0 beta 1 (25A5279m)
  - Update `AppleALC` v1.9.5 (up to [acidanthera/AppleALC@aed10e1](https://github.com/acidanthera/AppleALC/commit/aed10e1953671d2e4acd4aa6f7d5aff3caea6b74)) to support macOS26.0 beta 1 (25A5279m), but NOT support macOS 26.0 beta 2 (25A5295e) due to dropped `AppleHDA`
  - Update `WhateverGreen` v1.7.0 (up to [acidanthera/WhateverGreen@3251496](https://github.com/acidanthera/WhateverGreen/commit/32514961df000100aa1c8aebd5479cabd4ca3070)) to support macOS26.0 beta 1 (25A5279m)
  - Update `HibernationFixup` v1.5.4 (up to [acidanthera/HibernationFixup@99c056d](https://github.com/acidanthera/HibernationFixup/commit/99c056dc92690f49f458ded1d1ccec51d6ee97c9)) to support macOS26.0 beta 1 (25A5279m)
  - Update `RestrictEvents` v1.1.6 (up to [acidanthera/RestrictEvents@3ff8491](https://github.com/acidanthera/RestrictEvents/commit/3ff8491859606f95957c0cc1dcdf2233a0e1a459)) to support macOS26.0 beta 1 (25A5279m)
  - Update `BrcmPatchRAM` v2.7.1 (up to [acidanthera/BrcmPatchRAM@3ad0963](https://github.com/acidanthera/BrcmPatchRAM/commit/3ad0963b5008dae84d1960b32c4b391dd617fb3e)) to support macOS26.0 beta 1 (25A5279m)
  - Update `NullEthernet` v1.0.8 and change source from [RehabMan/OS-X-Null-Ethernet](https://github.com/RehabMan/OS-X-Null-Ethernet) to [stevezhengshiqi/OS-X-Null-Ethernet](https://github.com/stevezhengshiqi/OS-X-Null-Ethernet), due to that [RehabMan/OS-X-Null-Ethernet Bitbucket](https://bitbucket.org/RehabMan/os-x-null-ethernet/downloads/) no longer supports downloads

### Change
  - KBL: Add `-no_compat_check` boot-args to support macOS26 Tahoe as `MacBookPro15,4` is removed from macOS26 Tahoe model support list


## [XiaoMi NoteBook Pro EFI v1.8.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.8)
## 2025-04-08
Supported macOS Version: 10.15, 11, 12, 13, 14, 15  
Intel Wi-Fi is NOT supported on macOS 15 (Sequoia). Try itlwm + HeliPort or Ventura kext + OCLP (risky)
### Upgrade
  - Update `OpenCore` v1.0.5 (up to [acidanthera/OpenCorePkg@b68f91c](https://github.com/acidanthera/OpenCorePkg/commit/b68f91c92370d0ba6bdf5262dfaf4ced0ae2f5f9))
  - Update `Clover` r5161
  - Update `Lilu` v1.7.1 (up to [acidanthera/Lilu@41269ae](https://github.com/acidanthera/Lilu/commit/41269ae2b2bc9d3b21a710a86237d239568bc6d2))
  - Update `VirtualSMC` v1.3.6
  - Update `AppleALC` v1.9.4
  - Update `HibernationFixup` v1.5.3
  - Update `BrcmPatchRAM` v2.7.0

### OC
  - Add NVRAM variables `7C436110-AB2A-4BBB-A880-FE41995C9F82:bluetoothExternalDongleFailed` — `00` and `7C436110-AB2A-4BBB-A880-FE41995C9F82:bluetoothInternalControllerInfo` — `0000000000000000000000000000` because `BluetoolFixup` v2.7.0 no longer patches it by default


## [XiaoMi NoteBook Pro EFI v1.8.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.7)
## 2024-12-15
Supported macOS Version: 10.15, 11, 12, 13, 14, 15  
Intel Wi-Fi is NOT supported on macOS 15 (Sequoia). Try itlwm + HeliPort or Ventura kext + OCLP (risky)
### Upgrade
  - Update `OpenCore` v1.0.3 (up to [acidanthera/OpenCorePkg@b70d558](https://github.com/acidanthera/OpenCorePkg/commit/b70d558e444e75f9e09db8a42f82b93387f7a8e8))

### Change
  - Downgrade `VoodooI2C` v2.8 but compiled with `VoodooInput` v1.1.6 to support macOS 15, solve unresponsive trackpad brought by v2.9.1 [#766](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/766)


## [XiaoMi NoteBook Pro EFI v1.8.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.6)
## 2024-12-03
Supported macOS Version: 10.15, 11, 12, 13, 14, 15  
Intel Wi-Fi is NOT supported on macOS 15 (Sequoia). Try itlwm + HeliPort or Ventura kext + OCLP (risky)
### Upgrade
  - Update `OpenCore` v1.0.3
  - Update `Lilu` v1.7.0
  - Update `VirtualSMC` v1.3.5 (up to [acidanthera/VirtualSMC@4be2a60](https://github.com/acidanthera/VirtualSMC/commit/4be2a60de4cfd02ed2804b618f0f2afb09d3a608))
  - Update `AppleALC` v1.9.3
  - Update `WhateverGreen` v1.6.9
  - Update `VoodooI2C` v2.9.1


## [XiaoMi NoteBook Pro EFI v1.8.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.5)
## 2024-11-01
Supported macOS Version: 10.15, 11, 12, 13, 14, 15  
Intel Wi-Fi is NOT supported on macOS 15 (Sequoia). Try itlwm + HeliPort or Ventura kext + OCLP (risky)
### Upgrade
  - Update `OpenCore` v1.0.3 (up to [acidanthera/OpenCorePkg@6fb63d4](https://github.com/acidanthera/OpenCorePkg/commit/6fb63d4b3eeeccc12988edb26dfafbb7edd23417))
  - Update `AppleALC` v1.9.3 (up to [acidanthera/AppleALC@dfeb479](https://github.com/acidanthera/AppleALC/commit/dfeb4791d30da9f197fb56ebfa2da4d1e4cd66b9))
  - Update `VoodooPS2` v2.3.7 (up to [acidanthera/VoodooPS2@bdbf806](https://github.com/acidanthera/VoodooPS2/commit/bdbf80639936701337f4574bae8c3ea25bb8dd3d))

### OC
  - Update `MaxKernel` for kexts that are compatible with macOS Sequoia


## [XiaoMi NoteBook Pro EFI v1.8.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.4)
## 2024-10-08
Supported macOS Version: 10.15, 11, 12, 13, 14  
Intel Wi-Fi is NOT supported on macOS 15 (Sequoia). Try itlwm + HeliPort or Ventura kext + OCLP (risky)
### Upgrade
  - Update `OpenCore` v1.0.2
  - Update `Clover` r5160
  - Update `Lilu` v1.6.9
  - Update `VirtualSMC` v1.3.4
  - Update `AppleALC` v1.9.2
  - Update `WhateverGreen` v1.6.8
  - Update `HibernationFixup` v1.5.2
  - Update `RestrictEvents` v1.1.5
  - Update `VoodooInput` v1.1.6
  - Update `VoodooPS2` v2.3.6
  - Update `BrcmPatchRAM` v2.6.9
  - Update `IntelBluetoothFirmware` (up to [OpenIntelWireless/IntelBluetoothFirmware@01cc180](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/01cc1806d71f5cc64c464851b9f4811a3e7b4791))
  - Update `AirportItlwm` v2.4.0 (up to [OpenIntelWireless/itlwm@53c51c2](https://github.com/OpenIntelWireless/itlwm/commit/53c51c2cdd6e4b69beb91f310d74c53422b0f8bd))

### OC
  - Enable `FixupAppleEfiImages` for VMs
  - Update config to support `OpenCore` v1.0.2


## [XiaoMi NoteBook Pro EFI v1.8.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.3)
## 2024-05-15
Supported macOS Version: 10.15, 11, 12, 13, 14
### Upgrade
  - Update `OpenCore` v1.0.1 (up to [acidanthera/OpenCorePkg@614b733](https://github.com/acidanthera/OpenCorePkg/commit/614b733342392004f907a73236f488d567a962bb))
  - Update `Clover` r5158
  - Update `Lilu` v1.6.8 (up to [acidanthera/Lilu@a7fc69b](https://github.com/acidanthera/Lilu/commit/a7fc69b7cc3ebb08ed72c41e873ae7c5f2451731))
  - Update `AppleALC` v1.9.1 (up to [acidanthera/AppleALC@6318299](https://github.com/acidanthera/AppleALC/commit/63182991831b9f0205db163c424679a39034ee35))
  - Update `HibernationFixup` v1.5.1 (up to [acidanthera/HibernationFixup@55a3e9d](https://github.com/acidanthera/HibernationFixup/commit/55a3e9d8fda1ed4dcef225aa04bc0dcb39c77247))
  - Update `AirportItlwm` v2.3.0 (up to [OpenIntelWireless/itlwm@4ac4c79](https://github.com/OpenIntelWireless/itlwm/commit/4ac4c79bc7e34f8764038fc382630a29eb46213d))


## [XiaoMi NoteBook Pro EFI v1.8.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.2)
## 2024-03-12
Supported macOS Version: 10.15, 11, 12, 13, 14
### Upgrade
  - Update `OpenCore` v0.9.9
  - Update `Clover` r5157
  - Update `AppleALC` v1.8.9
  - Update `OcBinaryData` (up to [acidanthera/OcBinaryData@af09b0b](https://github.com/acidanthera/OcBinaryData/commit/af09b0bf763363ec9f4ecdbbe2f0adeb970948d8))
  - Update `IntelBluetoothFirmware` v2.5.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@8b88140](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/8b88140dd09eb9810e49e57ee4aa06360cefa75c))
  - Update `AirportItlwm` v2.3.0 to support Sonoma 14.4+ (up to [OpenIntelWireless/itlwm@d48ea5d](https://github.com/OpenIntelWireless/itlwm/commit/d48ea5d0857bea11bd8173b983951509bb8537a6))
    - For Sonoma Verison < 14.4 with Clover user, [AirportItlwm-Sonoma14.0 kext](https://github.com/OpenIntelWireless/itlwm/releases) has to be manually downloaded and placed in `/EFI/CLOVER/kexts/14/`. `AirportItlwm_Sonoma144.kext` should also be deleted.

### Clover
  - config: Disable `ProvideConsoleGop`


## [XiaoMi NoteBook Pro EFI v1.8.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.1)
## 2023-11-06
Supported macOS Version: 10.15, 11, 12, 13, 14.0 - 14.3.1
### Upgrade
  - Update `OpenCore` v0.9.6
  - Update `AppleALC` v1.8.6
  - Update `AirportItlwm` v2.3.0 (up to [OpenIntelWireless/itlwm@ff1138b](https://github.com/OpenIntelWireless/itlwm/commit/ff1138b026d3198beb9a716f73efe4f4a86ed68b))

### Clover
  - Remove IO80211Family entry in ForceKextsToLoad


## [XiaoMi NoteBook Pro EFI v1.8.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.8.0)
## 2023-09-12
Supported macOS Version: 10.15, 11, 12, 13, 14.0 - 14.3.1
### Upgrade
  - Update `OpenCore` v0.9.5
  - Update `Clover` r5155
  - Update `AppleALC` v1.8.5

### OC
  - Disable `ProvideConsoleGop` to solve Black screen during OC picker
  - Update config to support `OpenCore` v0.9.5

### Clover
  - Add `BlockSkywalk`, disabled by default


## [XiaoMi NoteBook Pro EFI v1.7.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.9)
## 2023-07-17
Supported macOS Version: 10.15, 11, 12, 13, 14.0 - 14.0 beta 4
### Upgrade
  - Update `OpenCore` v0.9.4 (up to [acidanthera/OpenCorePkg@afa5974](https://github.com/acidanthera/OpenCorePkg/commit/afa5974a4c33e6ffbfa816eb86b604949d772832))
  - Update `Clover` r5153
  - Update `Lilu` v1.6.7 (up to [acidanthera/Lilu@1827e19](https://github.com/acidanthera/Lilu/commit/1827e19108e93128856e5426a3c6fc5d0c106096))
  - Update `VirtualSMC` v1.3.3 (up to [acidanthera/VirtualSMC@038200e](https://github.com/acidanthera/VirtualSMC/commit/038200ee31a73b1c038c865a18cfc7ae6384bc53))
  - Update `AppleALC` v1.8.4 (up to [acidanthera/AppleALC@cbdaeed](https://github.com/acidanthera/AppleALC/commit/cbdaeedb5a46bf135f8c3831ddd9e7b84dcb21c9))
  - Update `WhateverGreen` v1.6.6 (up to [acidanthera/WhateverGreen@c7c8dc7](https://github.com/acidanthera/WhateverGreen/commit/c7c8dc70381af3b48a4b65c177acf8835da080eb))
  - Update `HibernationFixup` v1.5.0 (up to [acidanthera/HibernationFixup@1eb0ddb](https://github.com/acidanthera/HibernationFixup/commit/1eb0ddb6cd7b2cd0a72e157a15e8833399afe7e8))
  - Update `RestrictEvents` v1.1.3 (up to [acidanthera/RestrictEvents@9f45386](https://github.com/acidanthera/RestrictEvents/commit/9f45386b846c48de83a2df33837596713a43f384))
  - Update `BrcmPatchRAM` v2.6.8 (up to [acidanthera/BrcmPatchRAM@2305aaa](https://github.com/acidanthera/BrcmPatchRAM/commit/2305aaa145a0021559f444d33a5adaacb6469050))
  - Update `VoodooPS2` v2.3.6 (up to [acidanthera/VoodooPS2@7f4e069](https://github.com/acidanthera/VoodooPS2/commit/7f4e0698f1cd68e00f1a78d70ffaeecf145ca45a))
  - Update `IntelBluetoothFirmware` (up to [OpenIntelWireless/IntelBluetoothFirmware@592507a](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/592507aa8cb3d0df3e524bb869f2836271e4fb48))
  - Update `AirportItlwm` v2.3.0 (up to [OpenIntelWireless/itlwm@bd47afe](https://github.com/OpenIntelWireless/itlwm/commit/bd47afe94836e178402bf9ca7bb031d35ea6d90b))

### Remove
  - Remove `SSDT-DMAC` because it is only related to AppleSmartIO2/AppleWWANSupport/AudioDMAController/AMDRadeonX5000GLDriver/AMDRadeonX4000GLDriver/AMDRadeonX6000GLDriver

### OC
  - Update config to support [acidanthera/OpenCorePkg@53a00be](https://github.com/acidanthera/OpenCorePkg/commit/53a00be4e3c3439c5fcab4ec5d7eff85f0632e15)
  - Update `MinKernel` and `MaxKernel` based on [OpenCorePkg/Docs/Kexts.md](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Kexts.md)


## [XiaoMi NoteBook Pro EFI v1.7.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.8)
## 2023-05-08
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.9.2
  - Update `Lilu` v1.6.5
  - Update `AppleALC` v1.8.2
  - Update `RestrictEvents` v1.1.1

### Change
  - KBL: ACPI: Rename `SSDT-PMC` to `SSDT-PMCR` to avoid confusion with `SSDT-PMC` used on Intel 300-series
  - ACPI: Change `SSDT-ALS0` code source to [Acidanthera's SSDT-ALS0](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-ALS0.dsl)
  - ACPI: Re-structure `SSDT-XCPM` to `SSDT-PLUG` based on [Acidanthera's SSDT-PLUG](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-PLUG.dsl)
  - ACPI: Change `SSDT-EC` to `SSDT-EC-USBX` to inject USBX device(which was done in `SSDT-USB`), according to [Acidanthera's SSDT-EC-USBX.dsl](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-EC-USBX.dsl)
  - ACPI: Change `SSDT-USB*` to remove USBX device injection

### OC
  - Update config to support `OpenCore` v0.9.2


## [XiaoMi NoteBook Pro EFI v1.7.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.7)
## 2023-04-04
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)	
### Upgrade
  - Update `OpenCore` v0.9.1
  - Update `AppleALC` v1.8.1
  - Update `BrcmPatchRAM` v2.6.5
  - Update `VoodooPS2` v2.3.5
  - Update `RestrictEvents` v1.1.0

### Remove
  - Remove `NVMeFix` again due to 3rd party NVMe controller panic

### OC
  - Update config to support `OpenCore` v0.9.1


## [XiaoMi NoteBook Pro EFI v1.7.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.6)
## 2023-03-06
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.9.0
  - Update `Lilu` v1.6.4
  - Update `AppleALC` v1.8.0
  - Update `VirtualSMC` v1.3.1
  - Update `VoodooPS2` v2.3.4


## [XiaoMi NoteBook Pro EFI v1.7.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.5)
## 2023-02-18
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.9
  - Update `Clover` r5151
  - Update `AppleALC` v1.7.9
  - Update `WhateverGreen` v1.6.4
  - Update `HibernationFixup` v1.4.8
  - Update `HfsPlus.efi` (up to [acidanthera/OcBinaryData@c2a9898](https://github.com/acidanthera/OcBinaryData/commit/c2a98980d30e39a571a2843ab26aa8d2b9188094))
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@ddd2768](https://github.com/OpenIntelWireless/itlwm/commit/ddd27687dbd672adc608f00957b68785e825b28d))
  - Update `VoodooI2C` v2.8

### OC
  - Update config to support `OpenCore` v0.8.9


## [XiaoMi NoteBook Pro EFI v1.7.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.4)
## 2023-01-03
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.8
  - Update `Lilu` v1.6.3
  - Update `AppleALC` v1.7.8
  - Update `WhateverGreen` v1.6.3
  - Update `VoodooInput` v1.1.3
  - Update `VoodooPS2` v2.3.3
  - Update `VoodooI2C` v2.7.1
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@e0f745e](https://github.com/OpenIntelWireless/itlwm/commit/e0f745e75156854b7e0d18299a48f31db23ced10))

### Add
  - Add back `NVMeFix` to enable APST on SSDs

### OC
  - CML: Change `HibernateMode` back to `Auto`

### Clover
  - CML: Enable `HibernationFixup`

### Change
  - config: Delete `reg-ltrovr` property as the tolerance latency's effect is unknown for hackintosh


## [XiaoMi NoteBook Pro EFI v1.7.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.3)
## 2022-12-06
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.7
  - Update `AppleALC` v1.7.7
  - Update `WhateverGreen` v1.6.2
  - Update `HibernationFixup` v1.4.7
  - Update `VoodooPS2` v2.3.2
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@bb33666](https://github.com/OpenIntelWireless/itlwm/commit/bb33666a988f96b45724f3bca79ff07e20038bf2))
  - Update `IntelBluetoothFirmware` v2.3.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@693f2dc](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/693f2dcaefe218f7f0205957bfbe381cdf5354ae))

### OC
  - Update config to support `OpenCore` v0.8.7

### Change
  - Add boot-args `ps2kbdonly=1` to disable `VoodooPS2` 's mouse clock line
  - CML: Remove possibly faulty EDID injection; EDID customization is rarely required, and users should generate their own EDID


## [XiaoMi NoteBook Pro EFI v1.7.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.2)
## 2022-11-08
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.6
  - Update `Clover` r5150
  - Update `AppleALC` v1.7.6
  - Update `RestrictEvents` v1.0.9

### OC
  - Update config to support `OpenCore` v0.8.6

### Clover
  - Update config


## [XiaoMi NoteBook Pro EFI v1.7.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.1)
## 2022-10-04
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.5
  - Update `BrcmPatchRAM` v2.6.4
  - Update `VoodooPS2` v2.3.1 to fix CML model unresponsive keyboard at BootPicker after restart on Monterey+
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@ee56708](https://github.com/OpenIntelWireless/itlwm/commit/ee567086f288951766f4259f8239c472be66679f))

### Clover
  - Remove `ApfsDriverLoader.efi`, `AppleGenericInput.efi` & `AppleUiSupport.efi` from [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg) and replace them with `ApfsDriverLoader.efi` and `AppleKeyFeeder.efi` embedded in [CloverBootloader](https://github.com/CloverHackyColor/CloverBootloader)
  - Add missing `BlueToolFixup` to 13 kext folder


## [XiaoMi NoteBook Pro EFI v1.7.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.7.0)
## 2022-09-05
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.4
  - Update `Clover` r5149
  - Update `AppleALC` v1.7.5
  - Update `VoodooPS2` v2.3.0
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@bb86d9f](https://github.com/OpenIntelWireless/itlwm/commit/bb86d9f6b9388fbe725d3e42ca72fbf3b27dddc5))
  - Update `IntelBluetoothFirmware` v2.3.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@18fcde3](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/18fcde3519bcb00ad9b46286d604a73661cf52b1))

### OC
  - Update config to support `OpenCore` v0.8.4


## [XiaoMi NoteBook Pro EFI v1.6.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.9)
## 2022-08-02
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.3.1 (a)
### Upgrade
  - Update `OpenCore` v0.8.3
  - Update `Clover` r5148
  - Update `Lilu` v1.6.2
  - Update `AppleALC` v1.7.4
  - Update `WhateverGreen` v1.6.1
  - Update `VoodooPS2` v2.2.9 (up to [acidanthera/VoodooPS2@fdb8be5](https://github.com/acidanthera/VoodooPS2/commit/fdb8be58ac0b5c4c76b1bfe12f7c88b63fff1e10))
  - Update `VoodooI2C` v2.7 (up to [VoodooI2C/VoodooI2C@9ab9831](https://github.com/VoodooI2C/VoodooI2C/commit/9ab98319b6411c4a4822cc12f840df85cc684bfc))
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@34441bc](https://github.com/OpenIntelWireless/itlwm/commit/34441bc68ad35b57d4299f5d28d9ff7879beed4f))
  - Update `IntelBluetoothFirmware` v2.2.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@bbdde1f](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/bbdde1f6ca5211824adf2a0e6540647b6ba656ce))

### OC
  - Update config to support `OpenCore` v0.8.3


## [XiaoMi NoteBook Pro EFI v1.6.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.8)
## 2022-07-05
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.0 beta 2
### Upgrade
  - Update `OpenCore` v0.8.2
  - Update `Clover` r5147
  - Update `Lilu` v1.6.1
  - Update `VirtualSMC` v1.3.0
  - Update `AppleALC` v1.7.3
  - Update `WhateverGreen` v1.6.0
  - Update `HibernationFixup` v1.4.6
  - Update `RestrictEvents` v1.0.8
  - Update `BrcmPatchRAM` v2.6.3
  - Update `VoodooPS2` v2.2.9
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@6a804ef](https://github.com/OpenIntelWireless/itlwm/commit/6a804ef81215634a5ea3547782e8d3741042f9b1))
  - Update `IntelBluetoothFirmware` v2.2.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@a9aec13](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/a9aec134ca258f6367078b27f942c0223a368406))


## [XiaoMi NoteBook Pro EFI v1.6.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.7)
## 2022-06-13
Supported macOS Version: 10.15, 11, 12, 13.0 - 13.0 beta 2
### Upgrade
  - Update `OpenCore` v0.8.2 (up to [acidanthera/OpenCorePkg@e05a69d](https://github.com/acidanthera/OpenCorePkg/commit/e05a69da640009ac1983c7c8c78af4f0d9b4bc6f))to support macOS13.0 beta 1 (22A5266r)
  - Update `Lilu` v1.6.1 (up to [acidanthera/Lilu@9775e8b](https://github.com/acidanthera/Lilu/commit/9775e8b8b3a05f7ed016fd9b587d43839f3c7cbf)) to support macOS13.0 beta 1 (22A5266r)
  - Update `VirtualSMC` v1.3.0 (up to [acidanthera/VirtualSMC@a45e73b](https://github.com/acidanthera/VirtualSMC/commit/a45e73baa35b5a97a69bc95acb90561b51d2aa56)) to support macOS13.0 beta 1 (22A5266r)
  - Update `AppleALC` v1.7.3 (up to [acidanthera/AppleALC@2992c19](https://github.com/acidanthera/AppleALC/commit/2992c19b71faa0a4fc98e0431b38057e415e55b0)) to support macOS13.0 beta 1 (22A5266r)
  - Update `WhateverGreen` v1.6.0 (up to [acidanthera/WhateverGreen@ade6c98](https://github.com/acidanthera/WhateverGreen/commit/ade6c98fe12b62101e0a0c41f55dae43d0b78fae)) to support macOS13.0 beta 1 (22A5266r)
  - Update `HibernationFixup` v1.4.6 (up to [acidanthera/HibernationFixup@a4a1d52](https://github.com/acidanthera/HibernationFixup/commit/a4a1d52eec6ca437ad6909818d090696302b0723)) to support macOS13.0 beta 1 (22A5266r)
  - Update `RestrictEvents` v1.0.8 (up to [acidanthera/RestrictEvents@668c632](https://github.com/acidanthera/RestrictEvents/commit/668c632e152242f4e6b7db463eb597bc8b2715d3)) to support macOS13.0 beta 1 (22A5266r)
  - Update `BrcmPatchRAM` v2.6.3 (up to [acidanthera/BrcmPatchRAM@8c04849](https://github.com/acidanthera/BrcmPatchRAM/commit/8c048492a19d24905d0b0be2f10cf26e1cc0c27f)) to support macOS13.0 beta 1 (22A5266r)
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@66cf933](https://github.com/OpenIntelWireless/itlwm/commit/66cf9336052c783f54d27c5f58b39708863b7da1)) to support macOS13.0 beta 1 (22A5266r)


## [XiaoMi NoteBook Pro EFI v1.6.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.6)
## 2022-06-06
Supported macOS Version: 10.15, 11, 12
### Upgrade
  - Update `OpenCore` v0.8.1
  - Update `AppleALC` v1.7.2
  - Update `WhateverGreen` v1.5.9
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@5261172](https://github.com/OpenIntelWireless/itlwm/commit/52611728e09f547dca575c1410280b98494fe3fa))
  - Update `IntelBluetoothFirmware` v2.2.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@76949ee](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/76949ee63cb55777670ead07310f74acd8701dbe))

### Add
  - Add `IntelBTPatcher` to fix Intel Bluetooth on Big Sur, Catalina, Mojave, High Sierra, etc

### OC
  - Update config to support `OpenCore` v0.8.1
  - CML: Change `HibernateMode` to `None` to try to solve Not booting after running out of battery issue

### Clover
  - CML: Disable `HibernationFixup` to try to solve Not booting after running out of battery issue

### Change
  - ACPI: Modify `kUSBSleepPortCurrentLimit` and `kUSBWakePortCurrentLimit` in `SSDT-USB*` to 2100 based on [ACDT's SSDT-EC-USBX](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-EC-USBX.dsl)
  - Disable `ProvideCustomSlide` based on OC debug log
  - KBL: Enable MAT support by enabling `DevirtualiseMmio`, `ProtectUefiServices` & `RebuildAppleMemoryMap`; adding `MmioWhitelist` patch; and disabling `EnableWriteUnprotector`
  - CML: Enable `ProtectUefiServices` as part of MAT support
  - CML: Disable `HibernationFixup` to try to solve Not booting after running out of battery issue


## [XiaoMi NoteBook Pro EFI v1.6.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.5)
## 2022-04-18
Supported macOS Version: 10.15, 11, 12
### Upgrade
  - Update `OpenCore` v0.8.0
  - Update `Clover` r5146
  - Update `Lilu` v1.6.0
  - Update `VirtualSMC` v1.2.9
  - Update `AppleALC` v1.7.1
  - Update `WhateverGreen` v1.5.8
  - Update `RestrictEvents` v1.0.7
  - Update `VoodooPS2` v2.2.8
  - Update `VoodooI2C` v2.7
  - Update `AirportItlwm` v2.2.0 (up to [OpenIntelWireless/itlwm@f9de654](https://github.com/OpenIntelWireless/itlwm/commit/f9de654a4468774a76006de8a05da0df6a71c9cd))
  - Update `IntelBluetoothFirmware` v2.1.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@aaf4247](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/aaf42472824865f553eeb7e17c7fa1c024da1305))

### OC
  - Update config to support `OpenCore` v0.8.0
  - Change `SecureBootModel` back to `Disabled` to support more machines, but can not receive OEM update
    - Go to `App Store` and search `Monterey (or newer macOS)` to receive update instead


## [XiaoMi NoteBook Pro EFI v1.6.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.4)
## 2021-12-06
Supported macOS Version: 10.15, 11, 12
### Upgrade
  - Update `OpenCore` v0.7.6
  - Update `Clover` r5142
  - Update `Lilu` v1.5.8
  - Update `VirtualSMC` v1.2.8
  - Update `AppleALC` v1.6.7
  - Update `AirportItlwm` v2.1.0 (up to [OpenIntelWireless/itlwm@307f2c7](https://github.com/OpenIntelWireless/itlwm/commit/307f2c78609d498b4f9e3d5b6fce546cd1d29c6a))
  - Update `IntelBluetoothFirmware` v2.1.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@a9217e8](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/a9217e8883107c91011983857ac8ea2b09f0a19f))

### OC
  - Update config to support `OpenCore` v0.7.6

### Clover
  - Update config to support `Clover` r5143


## [XiaoMi NoteBook Pro EFI v1.6.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.3)
## 2021-11-02
Supported macOS Version: 10.15, 11, 12
### Upgrade
  - Update `OpenCore` v0.7.5
  - Update `Clover` r5141
  - Update `Lilu` v1.5.7
  - Update `AppleALC` v1.6.6
  - Update `WhateverGreen` v1.5.5
  - Update `HibernationFixup` v1.4.5
  - Update `VoodooPS2` v2.2.7
  - Update `VoodooI2C` v2.6.5 (up to [VoodooI2C/VoodooI2C@4d9670f](https://github.com/VoodooI2C/VoodooI2C/commit/4d9670f144c1cf5854d3e6894de1b52a32e21203))
  - Update `BlueToolFixup` v2.6.1 to fix Intel Bluetooth on macOS12.0
  - Update `AirportItlwm` v2.1.0 (up to [OpenIntelWireless/itlwm@bf320b3](https://github.com/OpenIntelWireless/itlwm/commit/bf320b3583df443491efa57a67dd6aa403b109d8))
  - Update `HfsPlus.efi` (up to [acidanthera/OcBinaryData@29b2391](https://github.com/acidanthera/OcBinaryData/commit/29b23910e5ebb6347fd287776fe79508cbbc1bfe))
  - CML: Update `SSDT-TPD0`

### Add
  - Add back `complete-modeset-framebuffers` property to fix HDMI

### Remove
  - Remove `SATA-unsupported` because it does not suppost macOS11+; manually add `CtlnaAHCIPort` for SATA SSDs if necessary

### OC
  - Update config to support `OpenCore` v0.7.5

### Clover
  - Update config to support `Clover` r5142


## [XiaoMi NoteBook Pro EFI v1.6.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.2)
## 2021-10-06
Supported macOS Version: 10.15, 11, 12
### Upgrade
  - Update `OpenCore` v0.7.4
  - Update `Clover` r5140
  - Update `AppleALC` v1.6.5
  - Update `WhateverGreen` v1.5.4
  - Update `HibernationFixup` v1.4.4
  - Update `AirportItlwm` v2.1.0 (up to [OpenIntelWireless/itlwm@2e06227](https://github.com/OpenIntelWireless/itlwm/commit/2e06227fe42b9f6250bd8c8a84998ac8c8dced82))
  - Update `IntelBluetoothFirmware` v2.0.1 (up to [OpenIntelWireless/IntelBluetoothFirmware@9b44388](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/9b4438849d2709b7597acafda6c0dc6a44a5223e))
  - Update `VoodooPS2` v2.2.6

### Add
  - Add back `RestrictEvents` to replace `EFICheckDisabler`

### Remove
  - Remove `rps-control` property to lower down GFX Request
  - Remove `complete-modeset-framebuffers` property because someone reported that it is no longer necessary

### Clover
  - Update config to support `Clover` r5140

### OC
  - Update config to support `OpenCore` v0.7.4


## [XiaoMi NoteBook Pro EFI v1.6.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.1)
## 2021-09-08
Supported macOS Version: 10.15, 11, 12.0 - 12.0 beta 7
### Upgrade
  - Update `VoodooI2C` v2.6.5 (up to [VoodooI2C/VoodooI2C@385c068](https://github.com/VoodooI2C/VoodooI2C/commit/385c0688e72817a58e22be35e4996cc1e88996c3))

### Remove
  - KBL: Remove `forceRenderStandby=0` boot-args because it slows down performance, enable it if necessary


## [XiaoMi NoteBook Pro EFI v1.6.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.6.0)
## 2021-09-07
Supported macOS Version: 10.15, 11, 12.0 - 12.0 beta 7
### Upgrade
  - Update `OpenCore` v0.7.3
  - Update `Clover` r5139
  - Update `Lilu` v1.5.6
  - Update `VirtualSMC` v1.2.7
  - Update `AppleALC` v1.6.4
  - Update `WhateverGreen` v1.5.3
  - Update `HibernationFixup` v1.4.3
  - Update `AirportItlwm` v2.1.0 (up to [OpenIntelWireless/itlwm@1e857b9](https://github.com/OpenIntelWireless/itlwm/commit/1e857b9a3b2a90d072324edd1819f6f0713b809e))
  - Update `IntelBluetoothFirmware` v2.0.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@06f9d25](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/06f9d255b28f6d16b471387b53fedcb410d412f4))
  - Update `VoodooPS2` v2.2.5
  - Update `SSDT-PNLF`

### Add
  - Add dummy `#enable-backlight-smoother` property that can adjust the panel brightness smoothly, feel free to enable this if delay is bearable
  - CML: Add `enable-backlight-registers-fix` to fix backlight registers
  - KBL: Add `forceRenderStandby=0` boot-args to disable RC6 Render Standby and fix [IGP causes NVMe Kernel Panic CSTS=0xffffffff](https://github.com/acidanthera/bugtracker/issues/1193) after sleep

### Remove
  - KBL: Remove `AirportItlwm` High Sierra & Mojave version

### Change
  - KBL: Change SMBIOS model to `MacBookPro15,4` for better power management, no support for macOS High Sierra & Mojave
  - KBL: Change `ig-platform-id` to `0x05001C59` for better graphics performance, no support for macOS High Sierra & Mojave

### OC
  - Update config to support `OpenCore` v0.7.3


## [XiaoMi NoteBook Pro EFI v1.5.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.9)
## 2021-08-04
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11, 12.0 - 12.0 beta 7  
  - CML: 10.15, 11, 12.0 - 12.0 beta 7
### Upgrade
  - Update `OpenCore` v0.7.2
  - Update `Clover` r5138
  - Update `Lilu` v1.5.5
  - Update `VirtualSMC` v1.2.6
  - Update `AppleALC` v1.6.3
  - Update `WhateverGreen` v1.5.2
  - Update `HibernationFixup` v1.4.2
  - Update `AirportItlwm` v2.0.0 (up to [OpenIntelWireless/itlwm@df328b2](https://github.com/OpenIntelWireless/itlwm/commit/df328b2b4c34cee52f7c087e58283539c6fce496))
  - Update `IntelBluetoothFirmware` v2.0.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@dbe8fcc](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/dbe8fcc6e9de7c1d7f790bf8e9f83309096fcd90))
  - Update `SSDT-PNLF`
  - Update `SSDT-RMNE` to use MAC Address with an OUI that corresponds to a real Apple, Inc. interface
  - Update `SSDT-USB*` to unblock SD Card port, users can add add [RealtekCardReader](https://github.com/0xFireWolf/RealtekCardReader) + [RealtekCardReaderFriend](https://github.com/0xFireWolf/RealtekCardReaderFriend) manually to drive Realtek SD Card Reader
  - Update `ROM` in config

### OC
  - Update config to support `OpenCore` v0.7.2


## [XiaoMi NoteBook Pro EFI v1.5.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.8)
## 2021-07-05
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11, 12.0 - 12.0 beta 7  
  - CML: 10.15, 11, 12.0 - 12.0 beta 7
### Upgrade
  - Update `OpenCore` v0.7.1
  - Update `Clover` r5137
  - Update `Lilu` v1.5.4
  - Update `AppleALC` v1.6.2
  - Update `VirtualSMC` v1.2.5
  - Update `WhateverGreen` v1.5.1
  - Update `HibernationFixup` v1.4.1
  - Update `AirportItlwm` v2.0.0 (up to [OpenIntelWireless/itlwm@22a83ab](https://github.com/OpenIntelWireless/itlwm/commit/22a83ab5e319d8e5a834697accf5069b8981bec7))
  - Update `IntelBluetoothFirmware` v2.0.0 (up to [OpenIntelWireless/IntelBluetoothFirmware@b864680](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/b8646803e7e113a2e9ab26f59ead3d7582794094))
  - Update `VoodooPS2` v2.2.4

### Add
  - Add back `EFICheckDisabler` to replace `RestrictEvents`

### Remove
  - Remove `RestrictEvents`

### OC
  - Update config to support `OpenCore` v0.7.1


## [XiaoMi NoteBook Pro EFI v1.5.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.7)
## 2021-06-16
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11, 12.0 - 12.0 beta 7  
  - CML: 10.15, 11, 12.0 - 12.0 beta 7
### Update
  - Update `OpenCore` v0.7.1 (up to [acidanthera/OpenCorePkg@ee0fb99](https://github.com/acidanthera/OpenCorePkg/commit/ee0fb99105a191c16926b8d6cd58ce2151eb7894))
  - Update `Lilu` v1.5.4 (up to [acidanthera/Lilu@0fd1b29](https://github.com/acidanthera/Lilu/commit/0fd1b2985f6a2a934c928b4594ba5179e202b31f))
  - Update `AppleALC` v1.6.2 (up to [acidanthera/AppleALC@42f74fb](https://github.com/acidanthera/AppleALC/commit/42f74fb430071995db96fd2a1b519dd135d592f4))
  - Update `VirtualSMC` v1.2.5 (up to [acidanthera/VirtualSMC@30a3fa2](https://github.com/acidanthera/VirtualSMC/commit/30a3fa2bd920a15e41ef1439585bcc19885b89e3))
  - Update `WhateverGreen` v1.5.1 (up to [acidanthera/WhateverGreen@a2b35e2](https://github.com/acidanthera/WhateverGreen/commit/a2b35e22c79fac3e03cb97903d16a4da6e74814a))
  - Update `HibernationFixup` v1.4.1 (up to [acidanthera/HibernationFixup@ea11e11](https://github.com/acidanthera/HibernationFixup/commit/ea11e11ea22183c5489f150e9d763d4a474848dd))
  - Update `AirportItlwm` v2.0.0 (up to [OpenIntelWireless/itlwm@5eb3a17](https://github.com/OpenIntelWireless/itlwm/commit/5eb3a17d34d2de27b31b57ccadbb4e630fd9a09d)) to support macOS12.0 beta1 (21A5248p)
  - Update `IntelBluetoothFirmware` v1.1.3 to support macOS12.0 beta1 (21A5248p)
  - Update `VoodooPS2` v2.2.4 (up to [acidanthera/VoodooPS2@f0c7fda](https://github.com/acidanthera/VoodooPS2/commit/f0c7fda3fec51150f77f3cbd9a1e452118a8e8d9))
  - Update `RestrictEvents` v1.0.3 (up to [acidanthera/RestrictEvents@36f6c5c](https://github.com/acidanthera/RestrictEvents/commit/36f6c5caff6d871ba7f2ccfaca59e1cc58b84d19))

### Add
  - Add `BlueToolFixup` to help drive Intel Bluetooth on macOS12.0 beta1 (21A5248p)

### OC
  - Update config to support `OpenCore` v0.7.1


## [XiaoMi NoteBook Pro EFI v1.5.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.6)
## 2021-06-08
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Update
  - Update `OpenCore` v0.7.0
  - Update `Clover` r5136
  - Update `Lilu` v1.5.4 (up to [acidanthera/Lilu@e22b892](https://github.com/acidanthera/Lilu/commit/e22b89297c15b8ad2074a87dffcb7c4b7bcec4c8)) to support macOS12.0 beta1 (21A5248p)
  - Update `AppleALC` v1.6.2 (up to [acidanthera/AppleALC@12bf428](https://github.com/acidanthera/AppleALC/commit/12bf428d03aceb43bbdc0a843fd4b2d4b2143e02)) to support macOS12.0 beta1 (21A5248p)
  - Update `VirtualSMC` v1.2.5 (up to [acidanthera/VirtualSMC@34676be](https://github.com/acidanthera/VirtualSMC/commit/34676be551fd0bbe1f543966d18d25bdf2bb44fa)) to support macOS12.0 beta1 (21A5248p)
  - Update `WhateverGreen` v1.5.1 (up to [acidanthera/WhateverGreen@714ad1a](https://github.com/acidanthera/WhateverGreen/commit/714ad1aaeaaedfc3f9ad7ae4f7f1d3ae2e68dd11)) to support macOS12.0 beta1 (21A5248p)
  - Update `HibernationFixup` v1.4.1 (up to [acidanthera/HibernationFixup@7d47165](https://github.com/acidanthera/HibernationFixup/commit/7d471652f1ca4f98b0cf353259841d808a438eb0)) to support macOS12.0 beta1 (21A5248p)
  - Update `AirportItlwm` v2.0.0 (up to [OpenIntelWireless/itlwm@ef139ef](https://github.com/OpenIntelWireless/itlwm/commit/ef139eff859cfad5aa403a1fe0d6fa911ea71600))
  - Update `IntelBluetoothFirmware` v1.1.3 (up to [OpenIntelWireless/IntelBluetoothFirmware@ed27c85](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/commit/ed27c858ce74ce3d49bbfc356f7e1ce35156a974))
  - Update `RestrictEvents` v1.0.3 (up to [acidanthera/RestrictEvents@3271f18](https://github.com/acidanthera/RestrictEvents/commit/3271f188dd4fd37ca7e10d01862e490071a18a1c)) to support macOS12.0 beta1 (21A5248p)
  - Update `ExFatDxe.efi` (up to [acidanthera/OcBinaryData@6dd2d92](https://github.com/acidanthera/OcBinaryData/commit/6dd2d92383edee522052ebbe2c634c92894b37e6))
  - Update `HfsPlus.efi` (up to [acidanthera/OcBinaryData@6dd2d92](https://github.com/acidanthera/OcBinaryData/commit/6dd2d92383edee522052ebbe2c634c92894b37e6))

### Clover
  - Update config to support `Clover` r5136

### OC
  - Update config to support `OpenCore` v0.7.0


## [XiaoMi NoteBook Pro EFI v1.5.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.5)
## 2021-05-03
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Update
  - Update `OpenCore` v0.6.9
  - Update `Clover` r5134
  - Update `Lilu` v1.5.3
  - Update `VirtualSMC` v1.2.3
  - Update `AppleALC` v1.6.0
  - Update `CodecCommander` v2.7.3
  - Update `VoodooPS2` v2.2.3
  - Update `AirportItlwm` v2.0.0 (up to [OpenIntelWireless/itlwm@c448fbd](https://github.com/OpenIntelWireless/itlwm/commit/c448fbdefa681f2f59394dbb800aca2a3a50e12e))
  - Update `RestrictEvents` v1.0.1

### OC
  - Update config to support `OpenCore` v0.6.9


## [XiaoMi NoteBook Pro EFI v1.5.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.4)
## 2021-04-05
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Update
  - Update `OpenCore` v0.6.8
  - Update `Clover` r5132
  - Update `Lilu` v1.5.2
  - Update `VirtualSMC` v1.2.2
  - Update `AppleALC` v1.5.9
  - Update `CodecCommander` v2.7.2
  - Update `WhateverGreen` v1.4.9
  - Update `HibernationFixup` v1.4.0
  - Update `AirportItlwm` v1.3.0 (up to [OpenIntelWireless/itlwm@68bc77c](https://github.com/OpenIntelWireless/itlwm/commit/68bc77c99a135819cbb3f660355336d1f6710caa))

### OC
  - Update config to support `OpenCore` v0.6.8


## [XiaoMi NoteBook Pro EFI v1.5.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.3)
## 2021-03-01
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Update
  - Update `OpenCore` v0.6.7
  - Update `Clover` r5131
  - Update `AppleALC` v1.5.8
  - Update `VirtualSMC` v1.2.1
  - Update `WhateverGreen` v1.4.8
  - Update `VoodooPS2` v2.2.2
  - Update `VoodooI2C` v2.6.5
  - Update `AirportItlwm` v1.3.0 (up to [OpenIntelWireless/itlwm@b5c4e52](https://github.com/OpenIntelWireless/itlwm/commit/b5c4e52f65cacf0b98849ad2cfb6ceb1644879b6))

### Add
  - Add `rps-control` property to enable RPS control patch and improves IGPU performance

### Remove
  - Remove `gfxrst=1` boot-args

### Change
  - Change the value of `csr-active-config` to `0x00000000` to fully enable SIP
  - CML: Change SMBIOS model back to `MacBookPro16,2` to unlock more frequency

### OC
  - Update config to support `OpenCore` v0.6.7


## [XiaoMi NoteBook Pro EFI v1.5.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.2)
## 2021-02-02
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Update
  - Update `OpenCore` v0.6.6
  - Update `Clover` r5129
  - Update `Lilu` v1.5.1
  - Update `AppleALC` v1.5.7
  - Update `WhateverGreen` v1.4.7
  - Update `VirtualSMC` v1.2.0
  - Update `VoodooPS2` v2.2.1
  - Update `AirportItlwm` v1.3.0 (up to [OpenIntelWireless/itlwm@ecf78fc](https://github.com/OpenIntelWireless/itlwm/commit/ecf78fcf28b985df1a7d669a3f2e558ff7ada3af))

### Add
  - Add back `force-online` property to fix HDMI on Big Sur
  - CML: Add `AAPL00,override-no-connect` property to inject EDID

### OC
  - Update config to support `OpenCore` v0.6.6


## [XiaoMi NoteBook Pro EFI v1.5.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.1)
## 2021-01-13
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Remove
  - Remove `force-online*` properties to fix HDMI

### OC
  - Disable loading `AudioDxe.efi` and `ExFatDxe.efi` because they slow down the boot speed dramatically


## [XiaoMi NoteBook Pro EFI v1.5.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.5.0)
## 2021-01-12
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11  
  - CML: 10.15, 11
### Update
  - Update `OpenCore` v0.6.5
  - Update `Clover` r5128
  - Update `WhateverGreen` v1.4.6
  - Update `AppleALC` v1.5.6
  - Update `HibernationFixup` v1.3.9
  - Update `VoodooPS2` v2.2.0
  - Update `VoodooI2C` v2.6.3
  - Update `AirportItlwm` v1.2.0

### Add
  - Add `RestrictEvents` to replace `EFICheckDisabler`

### Remove
  - Remove `EFICheckDisabler`

### Clover
  - Update config to support `Clover` r5128

### OC
  - Update config to support `OpenCore` v0.6.5


## [XiaoMi NoteBook Pro EFI v1.4.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.8)
## 2020-12-07
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11
### Update
  - Update `OpenCore` v0.6.4
  - Update `Clover` r5127 to support macOS11.0.1
  - Update `Lilu` v1.5.0
  - Update `VirtualSMC` v1.1.9
  - Update `AppleALC` v1.5.5
  - Update `WhateverGreen` v1.4.5
  - Update `HibernationFixup` v1.3.8
  - Update `VoodooPS2` v2.1.9
  - Update `VoodooI2C` v2.5.2 (up to [VoodooI2C/VoodooI2C@b5a11ce](https://github.com/VoodooI2C/VoodooI2C/commit/b5a11ce59d8b0e7e072c9efdf289d877898cb0c0))
  - Update `AirportItlwm` v1.2.0 (up to [OpenIntelWireless/itlwm@c2f2c51](https://github.com/OpenIntelWireless/itlwm/commit/c2f2c51683b39d9327299238b3fa61343ee7177d))
  - Update `SSDT-PNLF`
  - Update `SSDT-PS2K` as `VoodooPS2` v2.1.9 won't swap Command and Option in default
  - Update `SSDT-RMNE`

### Change
  - Change `csr-active-config` to `30000000`

### Clover
  - Update config to support `Clover` r5127
  - Add back Mouse properties to support mouse in BootPicker

### OC
  - Update config to support `OpenCore` v0.6.4
  - Re-enable `IntelBluetoothInjector.kext` on macOS11.0+


## [XiaoMi NoteBook Pro EFI v1.4.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.7)
## 2020-11-03
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11
### Remove
  - Remove `AAPL,slot-name` to support HEVC on macOS11

### Clover
  - Add `AirportItlwm` to support native Intel Wi-Fi


## [XiaoMi NoteBook Pro EFI v1.4.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.6)
## 2020-11-02
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11
### Update
  - Update `OpenCore` v0.6.3
  - Update `Lilu` v1.4.9
  - Update `VirtualSMC` v1.1.8
  - Update `AppleALC` v1.5.4
  - Update `WhateverGreen` v1.4.4
  - Update `HibernationFixup` v1.3.7
  - Update `VoodooPS2` v2.1.8
  - Update `VoodooI2C` v2.5.2

### Clover
  - Disable `RtcHibernateAware`, turn it on manually to improve hibernation

### OC
  - Update config to support `OpenCore` v0.6.3
  - Add `AirportItlwm` to support native Intel Wi-Fi


## [XiaoMi NoteBook Pro EFI v1.4.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.5)
## 2020-10-05
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11
### Update
  - Update `OpenCore` v0.6.2
  - Update `Lilu` v1.4.8
  - Update `VirtualSMC` v1.1.7
  - Update `AppleALC` v1.5.3
  - Update `WhateverGreen` v1.4.3
  - Update `HibernationFixup` v1.3.6
  - Update `VoodooInput` v1.0.8
  - Update `VoodooPS2` v2.1.7
  - Update `VoodooI2C` v2.5.1

### Remove
  - Remove `-shikioff` because `Shiki` is necessary to play DRM

### Clover
  - Add back `RtcHibernateAware` to improve hibernation

### OC
  - Update config to support `OpenCore` v0.6.2
  - Disable `IntelBluetoothInjector.kext` on macOS11.0+ to resume boot speed
  - Re-enable `Disable RTC wake scheduling` patch


## [XiaoMi NoteBook Pro EFI v1.4.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.4)
## 2020-09-08
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11
### Update
  - Update `Clover` r5122
  - Update `OpenCore` v0.6.1
  - Update `Lilu` v1.4.7
  - Update `VirtualSMC` v1.1.6
  - Update `AppleALC` v1.5.2
  - Update `WhateverGreen` v1.4.2
  - Update `HibernationFixup` v1.3.5
  - Update `VoodooI2C` v2.4.4 (up to [VoodooI2C/VoodooI2C@3527ec3](https://github.com/VoodooI2C/VoodooI2C/commit/3527ec36d2f5860253544f39bec6f0998a7044e2))
  - Update `SSDT-LGPAGTX`

### Add
  - Add `-shikioff` boot-args to disable `Shiki`

### Remove
  - Remove `NVMeFix` due to incompatibilities on some NVMe SSDs

### OC
  - Update config to support `OpenCore` v0.6.1
  - Disable `Disable RTC wake scheduling` patch since it may cause Intel Wi-Fi unresponding after wake


## [XiaoMi NoteBook Pro EFI v1.4.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.3)
## 2020-08-03
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11
### Update
  - Update `Clover` r5120
  - Update `OpenCore` v0.6.0
  - Update `Lilu` v1.4.6
  - Update `VirtualSMC` v1.1.5 to support macOS11.0 beta 3 (20A5323l)
  - Update `AppleALC` v1.5.1
  - Update `WhateverGreen` v1.4.1
  - Update `VoodooPS2` v2.1.6
  - Update `VoodooInput` v1.0.7
  - Update `NVMeFix` v1.0.3
  - Update `HibernationFixup` v1.3.4
  - Update `IntelBluetoothFirmware` v1.1.2
  - Update `SSDT-LGPA` to solve unexpected key press when wake up from sleep

### Clover
  - Update config to support `Clover` r5120
  - Remove `SetIntelBacklight` and `SetIntelMaxBacklight` becuase we use `SSDT-PNLF`

### OC
  - Update config to support `OpenCore` v0.6.0


## [XiaoMi NoteBook Pro EFI v1.4.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.2)
## 2020-07-16
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11.0 - 11.0 beta 2
### Update
  - Update `OpenCore` v0.6.0 (up to [acidanthera/OpenCorePkg@20e60b0](https://github.com/acidanthera/OpenCorePkg/commit/20e60b0cbb273ea91a567440f0b7e230ecae3ec8))
  - Update `Lilu` v1.4.6 (up to [acidanthera/Lilu@28122d0](https://github.com/acidanthera/Lilu/commit/28122d0084dc5fe1b486bd52945160cf5be64d49))
  - Update `VirtualSMC` v1.1.5 (up to [acidanthera/VirtualSMC@fab53dc](https://github.com/acidanthera/VirtualSMC/commit/fab53dc600eef3b559c9a99b6cfd598c5f24927e)) to show battery percentage on macOS11
  - Update `AppleALC` v1.5.1 (up to [acidanthera/AppleALC@f07c1f8](https://github.com/acidanthera/AppleALC/commit/f07c1f8c65270f58a50f96bac2588710d0ff7683))
  - Update `WhateverGreen` v1.4.1 (up to [acidanthera/WhateverGreen@b97c692](https://github.com/acidanthera/WhateverGreen/commit/b97c692aee9672786a181423dd476a05782ba7e9))
  - Update `VoodooPS2` v2.1.6 (up to [acidanthera/VoodooPS2@60a4566](https://github.com/acidanthera/VoodooPS2/commit/60a4566c237f9c39bf38122ec8c0910a388dbe9d))

### Clover
  - Remove `NoRomInfo` key

### OC
  - Update config


## [XiaoMi NoteBook Pro EFI v1.4.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.1)
## 2020-07-12
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15, 11.0 - 11.0 beta 2
### Update
  - Update `OpenCore` v0.6.0 (up to [acidanthera/OpenCorePkg@eee51ba](https://github.com/acidanthera/OpenCorePkg/commit/eee51bae932b5a366351e994ea2a1909c46c3ebf)) to support macOS11.0 beta 1 (20A4299v)
  - Update `Lilu` v1.4.6 (up to [acidanthera/Lilu@8a81e92](https://github.com/acidanthera/Lilu/commit/8a81e92f5641f9eee333d348d39add4ecaef0b37))
  - Update `AppleALC` v1.5.1 (up to [acidanthera/AppleALC@df23c40](https://github.com/acidanthera/AppleALC/commit/df23c409d832449867263d4a5eb32aaa570935f3))
  - Update `VirtualSMC` v1.1.5 (up to [acidanthera/VirtualSMC@90b1f45](https://github.com/acidanthera/VirtualSMC/commit/90b1f45475c82566fe6533c03f4938594f17bb49))
  - Update `WhateverGreen` v1.4.1 (up to [acidanthera/WhateverGreen@39e3b55](https://github.com/acidanthera/WhateverGreen/commit/39e3b557fb55dcb0e38e6ecd05d217c780ba8a2c))
  - Update `VoodooPS2` v2.1.6 (up to [acidanthera/VoodooPS2@071850a](https://github.com/acidanthera/VoodooPS2/commit/071850a089de027dad3b1d372b3a2a53f5813016))
  - Update `VoodooInput` v1.0.7 (up to [acidanthera/VoodooInput@46a01f9](https://github.com/acidanthera/VoodooInput/commit/46a01f90c4c81cc193b57d523156cc035321e8ea))
  - Update `VoodooI2C` v2.4.4 (up to [VoodooI2C/VoodooI2C@451739c](https://github.com/VoodooI2C/VoodooI2C/commit/451739ce4a736fa8afb591f73ef45f7fec240960))
  - Update `NVMeFix` v1.0.3 (up to [acidanthera/NVMeFix@48a0fda](https://github.com/acidanthera/NVMeFix/commit/48a0fda97650fd6a7563d65e479421524685bcee))
  - Update `HibernationFixup` v1.3.4 (up to [acidanthera/HibernationFixup@bb49d28](https://github.com/acidanthera/HibernationFixup/commit/bb49d28c7dd5d379f8729121c92bd9ad98509245))
  - Update `IntelBluetoothFirmware` v1.1.1
  - Update `SSDT-LGPA` and `SSDT-PS2K` to support native screenshot key, video mirror key, and mission control key; map PrtScn key to F11, Insert key to F12, and double-press Fn key to F13
    - Video mirror key and mission control key are only for MX150 BIOS version >= 0A07

### Change
  - Disable `FBEnableDynamicCDCLK` since it will cause black screen wake from hibernation; for people who want to enable HiDPI resolution > 1424x802, please change the value for `framebuffer-flags` to `CwfjAA==`

### Clover
  - Add `OcQuirks.efi`, `OpenRuntime.efi`, and `OcQuirks.plist` to replace `AptioMemoryFix.efi`
  - Add `NoRomInfo` to hide Apple ROM information

### OC
  - Update config to support `OpenCore` v0.6.0


## [XiaoMi NoteBook Pro EFI v1.4.1 beta 1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.1-beta1)
## 2020-06-14
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15
### Update
  - Update `Clover` r5119
  - Update `VoodooI2C` v2.4.3

### Clover
  - Update `setpowerstate_panic=0` kernel patch
  - Remove `AudioDxe.efi`

### OC
  - Update config


## [XiaoMi NoteBook Pro EFI v1.4.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.4.0)
## 2020-06-01
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15
### Update
  - Update `Clover` r5118
  - Update `OpenCore` v0.5.9
  - Update `Lilu` v1.4.5
  - Update `AppleALC` v1.5.0
  - Update `VirtualSMC` v1.1.4
  - Update `WhateverGreen` v1.4.0
  - Update `VoodooPS2` v2.1.5
  - Update `SSDT-TPD0`
  - Update `SSDT-PS2K`
  - Update `SSDT-XCPM`

### Change
  - Use `VoodooInput` bundled with `VoodooI2C`

### Clover
  - Remove `DropOEM_DSM` as `Clover` r5117 dropped it
  - Reverse back font.png in `Xiaomi` theme since `Clover` r5116 fixed the font problem

### OC
  - Update config to support `OpenCore` v0.5.9


## [XiaoMi NoteBook Pro EFI v1.3.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.9)
## 2020-05-04
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15
### Update
  - Update `Clover` r5115
  - Update `OpenCore` v0.5.8
  - Update `Lilu` v1.4.4
  - Update `AppleALC` v1.4.9
  - Update `WhateverGreen` v1.3.9
  - Update `HibernationFixup` v1.3.3
  - Update `VoodooInput` v1.0.5
  - Update `VoodooI2C` v2.4.2
  - Update `VoodooPS2` v2.1.4
  - Update `VirtualSMC` v1.1.3
  - Update `SSDT-USB`
  - Update `framebuffer-flags` property
  - Update PCI device properties

### Add
  - Add `_UPC -> XUPC` rename

### Remove
  - Remove `SSDT-DRP08` to unlock Intel Wi-Fi
  - Remove `USBInjectAll`

### Clover
  - Update font.png in `Xiaomi` theme to support `Clover` r5115

### OC
  - Update config to support `OpenCore` v0.5.8


## [XiaoMi NoteBook Pro EFI v1.3.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.8)
## 2020-04-10
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15
### Update
  - Update `Clover` r5109
  - Update `OpenCore` v0.5.7
  - Update `Lilu` v1.4.3
  - Update `AppleALC` v1.4.8
  - Update `VirtualSMC` v1.1.2
  - Update `WhateverGreen` v1.3.8
  - Update `NVMeFix` v1.0.2
  - Update `VoodooPS2` v2.1.3
  - Update `VoodooI2C` v2.4, support trackpad in Recovery mode, and no need to rebuild kextcache after system update
  - Update `IntelBluetoothFirmware` v1.0.3
  - Update `SSDT-TPD0`, based on [#365](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/365)
  - Update `SSDT-LGPA`

### Add
  - Add `VoodooInput`
  - Add `framebuffer-flags` property to support 1440x810 HiDPI resolution
  - Add `force-online` and `force-online-framebuffers` properties to fix HDMI on macOS10.15.4

### Remove
  - Remove `MATH._STA and LDR2._STA -> XSTA` rename
  - Remove `TPD0._INI -> XINI` and `TPD0._CRS -> XCRS` renames

### Clover
  - Update `setpowerstate_panic=0` kernel patch for macOS10.15.4

### OC
  - Update config to support `OpenCore` v0.5.7


## [XiaoMi NoteBook Pro EFI v1.3.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.7)
## 2020-03-25
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15
### Update
  - Update `Clover` r5107 to support macOS10.15.4
  - Update `USBInjectAll` v0.7.3 from [Sniki's fork](https://github.com/Sniki/OS-X-USB-Inject-All/releases)
    - The origin [Rehabman's fork](https://github.com/RehabMan/OS-X-USB-Inject-All) does not update a long time ago
  - Update `SSDT-USB`
    - Our type-c ports are with switch, so the `UsbConnector` should be `0x09`

### Clover
  - Update `Xiaomi` theme to support Clover r5105+
  - Add `setpowerstate_panic=0` kernel patch for macOS10.15 according to [Acidanthera/AppleALC#513](https://github.com/acidanthera/bugtracker/issues/513#issuecomment-542838126)
  - Remove MSR 0xE2 patch because Clover can automatically patch

### OC
  - Update config to better support `OpenCore` v0.5.6


## [XiaoMi NoteBook Pro EFI v1.3.6](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.6)
## 2020-03-10
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15.0 - 10.15.3
### Update
  - Update `Clover` r5104
  - Update `OpenCore` v0.5.6
  - Update `Lilu` v1.4.2
  - Update `AppleALC` v1.4.7
  - Update `WhateverGreen` v1.3.7
  - Update `HibernationFixup` v1.3.2
  - Update `VirtualSMC` v1.1.1
  - Update `VoodooPS2` v2.1.2
  - Update `AppleSupportPkg` v2.1.6
  - Update `VoodooI2C` v2.3
  - Update `SSDT-USB`
  - Update `SSDT-MCHC`

### Add
  - Add `IntelBluetoothFirmware` and `IntelBluetoothInjector` to support native Intel Bluetooth
  - Add `SSDT-DRP08` to disable Intel Wireless Card
  - Add `SSDT-PS2K` to customize `VoodooPS2Keyboard` instead of directly editing `info.plist`
  - Add `complete-modeset-framebuffers` property to improve HDMI
  - Add `EFICheckDisabler`
  - Add `NVMeFix`
  - Add back `SSDT-DDGPU` to disable discrete graphics card instead of using `disable-external-egpu`

### Remove
  - Remove AppleIntelLpssI2C patches because [alexandred/VoodooI2C@c6e3c27](https://github.com/alexandred/VoodooI2C/commit/c6e3c278cda84a26f400a77f5ea57d819df9e405) solved the race problem

### Change
  - Change layout-id back to 30

### Clover
  - Add `PanicNoKextDump` to replace panic kext logging patches

### OC
  - Update config to support `OpenCore` v0.5.6


## [XiaoMi NoteBook Pro EFI v1.3.5](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.5)
## 2019-07-17
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15.0 - 10.15.3
### Update
  - Update `Clover` r5018
  - Update `OpenCore` v0.0.4
  - Update `WhateverGreen` to improve HDMI
  - Update `SSDT-LGPA`
  - Update `SSDT-TPD0`

### Add
  - Add `TPD0._INI -> XINI` and `TPD0._CRS -> XCRS`, pair with `SSDT-TPD0`

### Remove
  - Remove `enable-hdmi-dividers-fix`

### OC
  - Update config to support `OpenCore` v0.0.4


## [XiaoMi NoteBook Pro EFI v1.3.4](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.4)
## 2019-07-10
Supported macOS Version:  
  - KBL: 10.13, 10.14, 10.15.0 - 10.15.3
### Update
  - Update `Clover` r4986
  - Update `Lilu` v1.3.7
  - Update `AppleALC` v1.3.9
  - Update `WhateverGreen` v1.3.1
  - Update `VirtualSMC` v1.0.6
  - Update and edit `VoodooPS2` v2.0.2 to avoid F11 disabling trackpad
  - Update `VoodooI2C`
  - Update Device Properties obtained by `Hackintool`
  - Update `SSDT-MEM2`
  - Update `SSDT-HPET`
  - Update comments in `config.plist` using `Hackintool` style

### Add
  - Add `OpenCore`
  - Add `SSDT-TPD0` to solve unworking trackpad after removing `SSDT-XOSI` and  `_OSI -> XOSI`
  - Add back `SSDT-ALS0` to ensure backlight can be preserved
  - Add back `HibernationFixup`
  - Add `enable-hdmi-dividers-fix` properties for HDMI

### Remove
  - Remove `GFX0 -> IGPU`, `HECI -> IMEI`, and `HDAS -> HDEF` according to [WhateverGreen FAQ.IntelHD.en.md](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#general-recommendations)
  - Remove `SSDT-XOSI` and  `_OSI -> XOSI` because as [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) says, "Avoid patching _OSI to support a higher level of feature sets unless absolutely required. Commonly this enables a number of hacks on APTIO firmwares, which result in the need to add more patches. Modern firmwares generally do not need it at all, and those that do are fine with much smaller patches."
  - Remove `_DSM -> XDSM` because as [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) says, "Try to avoid hacky changes like renaming _PRW or _DSM whenever possible."
  - Remove `SAT0 -> SATA`
  - Remove IRQ fixes due to [OpenCore discussion](https://www.insanelymac.com/forum/topic/338516-opencore-discussion/?do=findComment&comment=2675659), "...but be very careful about the IRQs, some people remove them, yet this is usually strongly undesired."
  - Remove `SSDT-DDGPU` because `disable-external-egpu` does the same thing
  - Remove `SSDT-PXSX` and move device properties to `config.plist`
  - Remove `Drop DRAM` and replace with `dart=0`
  - Remove `AppleKeyFeeder.efi` and `DataHubDxe-64.efi` which XiaoMi-Pro doesn't need
  - Remove `USBPorts.kext` and replace with `SSDT-USB`, according to [#197](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/197)


## [XiaoMi NoteBook Pro EFI v1.3.3](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.3)
## 2019-04-16
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4920
  - Update `AppleALC` v1.3.7
  - Update `WhateverGreen`
  - Update `VoodooPS2`
  - Update `VoodooI2C` v2.1.6

### Remove
  - Remove `SSDT-RTC` and replace with `Rtc8Allowed` and `FixRTC`


## [XiaoMi NoteBook Pro EFI v1.3.2](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.2)
## 2019-03-28
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4910
  - Update `AppleALC` v1.3.6
  - Update `WhateverGreen` v1.2.8
  - Update `Lilu` v1.3.5
  - Update `VoodooPS2`
  - Update `USBPorts` and merge `SSDT-USBX`

### Remove
  - Remove `SSDT-PTSWAK` because Xiaomi-Pro doesn't need it
  - Remove `SMCSuperIO.kext` because it failed to detect supported SuperIO chip

### Change
  - Edit hotpatches to fit ACPI 6.3 standard
  - Change `AppleRTC` back to true and `InjectKexts` mode to `Detect`


## [XiaoMi NoteBook Pro EFI v1.3.1](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.1)
## 2019-03-01
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4892
  - Update `USBPorts` to support more models

### Remove
  - Remove `SSDT-PNLF` and replace with `AddPNLF` argument as suggested in [WhateverGreen FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#adjusting-the-brightness-on-a-laptop)
  - Remove `RtcHibernateAware` and replace with `NeverHibernate`. Sleep will consume more battery. Only after unlocking CFG then `RtcHibernateAware` could work properly

### Change
  - Change `igfxrst=1` to `gfxrst=1` according to [WhateverGreen README](https://github.com/acidanthera/WhateverGreen/blob/master/README.md)


## [XiaoMi NoteBook Pro EFI v1.3.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.3.0)
## 2019-02-10
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4871
  - Update `Lilu` v1.3.1
  - Update `AppleALC` v1.3.5
  - Update `SSDT-PXSX`

 ### Add
  - Add `SSDT-RTC` to remove IRQFlags safely, `FixRTC` will shorten the IO length

### Remove
  - Remove `CPUFriend*` because different macOS version have different plists in `/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/`. Use [one-key-cpufriend](one-key-cpufriend/README.md) to customize kext is recommended
  - Remove `HibernationFixup` because it's not stable, `RtcHibernateAware` is may enough for device to hibernate
  - Remove `dart=0`
  - Remove `AddClockID`, because it doesn't make a difference in new macOS version

### Change
  - Change layout-id to 30


## [XiaoMi NoteBook Pro EFI v1.2.9](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.9)
## 2018-12-26
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4821
  - Update `VoodooPS2Controller` v1.9.2
  - Update `CodecCommander` v2.7.1
  - Update `Lilu` v1.2.9
  - Update `AppleALC` v1.3.4
  - Update `WhateverGreen` v1.2.6
  - Update `VirtualSMC` v1.0.2
  - Update `USBPower` to `USBPorts`
  - Update `SSDT-PNLF`, `SSDT-LGPA`, `SSDT-RMCF`, and `SSDT-PTSWAK`
  - Update `VoodooI2C` to the latest commit
  - Update `MATH._STA -> XSTA` rename to `MATH._STA and LDR2._STA -> XSTA` rename

### Add
  - Add back Trim patch to `config.plist`
  - Add argument `RtcHibernateAware` according to [Official Explanations](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?page=5)
  - Add `SATA-unsupported` to replace `SSDT-SATA`
  - Add `SSDT-HPET` to behave more like a real Mac
  - Add `SSDT-LGPAGTX` to let GTX version works better (GTX users need to replace `SSDT-LGPA` with `SSDT-LGPAGTX`)
  - Add IRQ fixes in `config.plist`

### Remove
  - Remove `SSDT-ALS0`
  - Remove `AppleBacklightInjector` because `WhateverGreen` includes it
  - Remove tgtbridge because it has problem
  - Remove `HighCurrent` argument

### Change
  - Move PCI Information from `SSDT-PCIList` to `config.plist`
  - Change layout-id's datatype
  - Clean up `config.plist`
  - Clean up SSDTs' formats


## [XiaoMi NoteBook Pro EFI v1.2.8](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.8)
## 2018-09-28
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Downgrade
  - Downgrade [`Clover` r4658.RM-4903.ca9576f3](https://github.com/RehabMan/Clover) because Rehabman's version is more reliable

### Update
  - Update `WhateverGreen`, `AppleALC`, `Lilu`, `CPUFriend`, and `HibernationFixup` by using official release
  - Update `AppleBacklightInjector` to support HD630
  - Update `SSDT-PNLF.aml` to support HD630
  - Update `VoodooI2C*` v2.1.4. (This driver is a patched version from [official release](https://github.com/alexandred/VoodooI2C/releases), the official one has scalling issue.)
  - Update `VoodooPS2Controller` v1.9.0 to stop trackpad when using keyboard
  - Update headers in hotpatch

### Add
  - Add `USBPower` to replace `USBInjectAll` and `SSDT-USB.aml`

### Remove
  - Remove `SSDT-MATH.aml`, replace with `MATH._STA -> XSTA` rename

### Change
  - Clean code in `config.plist`


## [XiaoMi NoteBook Pro EFI v1.2.7](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.2.7)
## 2018-09-15
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4671
  - Update  `WhateverGreen` v1.2.3
  - Update `AppleALC` v1.3.2
  - Update `CPUFriend` v1.1.5
  - Update `Lilu` v1.2.7
  - Update `USBInjectAll` v0.6.7
  - Update `SSDT-GPRW.aml` and `SSDT-RMCF.aml` from Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config
  - Update `SSDT-PCIList.aml` to add more Properties in PCI0 devices

### Add
  - Add `SSDT-DMAC.aml` , `SSDT-MATH.aml` , `SSDT-MEM2.aml` , and `SSDT-PMCR.aml` to enhace performance like a real Mac. Inspired by [syscl](https://github.com/syscl/XPS9350-macOS/tree/master/DSDT/patches)
  - Add `HibernationFixup` to enable time setting in `System Preferences - Energy Saver`
  - Add `VirtualSMC` to replace `FakeSMC`. You can get more CPU Core Information by using `iStat Menus`, and more SMC keys are added in nvram.

### Remove
  - Remove VRAM 2048MB patch in `config.plist`, the actual VRAM isn't affected by this patch

### Change
  - Drop useless ACPI tables in `config.plist`
  - Reverse AppleIntelFramebuffer@0's connertor-type to default value


## [XiaoMi NoteBook Pro EFI v1.2.6](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.6)
## 2018-08-13
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Change
  - Reverse back `CPUFriendProvider.kext` to the one in v1.2.2 because the one in v1.2.5 will cause KP in some devices in 10.13.3~10.13.5. If you want better CPU performance or better battery life, please read [#53](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/53)


## [XiaoMi NoteBook Pro EFI v1.2.5](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.5)
## 2018-08-09
Supported macOS Version:  
  - KBL: 10.13, 10.14
### Update
  - Update `Clover` r4641
  - Update `WhateverGreen` v1.2.1
  - Update `AppleALC`
  - Update `CPUFriendDataProvider` by using default EPP value to enhance performance
  - Update `Lilu`
  - Update `config.plist`, using AddProperties to replace minStolen Clover patch

### Change
  - Edit `config.plist` to increase VRAM from 1536MB to 2048MB
  - Change AppleIntelFramebuffer@0's connertor-type from LVDS to eDP because MiPro uses eDP pin
  - No injection of ig-platform-id 0x12345678 by using `config_install.plist` anymore, `WhateverGreen` can help do this.


## [XiaoMi NoteBook Pro EFI v1.2.4](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.4)
## 2018-07-27

### Update
  - Update `Clover` r4625
  - Update `AppleALC` v1.3.1
  - Update `Lilu` v1.2.6
  - Update `CPUFriendDataProvider` by using MBP15,2's PM template to enable native HWP
  - Update `VoodooI2C` v2.0.3
  - Update `USBInjectAll` v0.6.6
  - Update `CodecCommander` v2.6.3 by merging `SSDT-MiPro_ALC298.aml`

### Add
  - Add minStolen Clover patch
  - Add support for Mojave
  - Add `WhateverGreen` to replace `IntelGraphicsFixup`, `Shiki` and `IntelGraphicsDVMTFixup`
  - Add `VoodooPS2Controller` to replace `ApplePS2SmartTouchPad`

### Remove
  - Remove useless boot-args `igfxfw=1` and  `-disablegfxfirmware`

### Change
  - Edit `SSDT-PCIList.aml` to let `System Information.app` show more PCI devices


## [XiaoMi NoteBook Pro EFI v1.2.2](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.2.2)
## 2018-05-14

### Update
  - Update `Clover` r4458
  - Update `Lilu` v1.2.4
  - Update `CPUFriendDataProvider` to save power

### Add
  - Add `SSDT-EC.aml` and `SSDT-SMBUS.aml` to launch AppleBusPowerController and AppleSMBusPCI

### Remove
  - Remove some useless renames in config and incorrect boot-args `shikigva=1`
  - Remove `SSDT-ADBG.aml` since it's useless
  - Remove `SSDT-IMEI.aml` to avoid kernel error report(Graphics id is automatically injected by `IntelGraphicsFixup`)

### Change
  - Rename some SSDTs to fit with Rehabman's sample:https://github.com/RehabMan/OS-X-Clover-Laptop-Config. Also update `SSDT-GPRW.aml`, `SSDT-DDGPU.aml`, `SSDT-RMCF.aml` and `SSDT-XHC.aml`
  - Redo the USB Injection, now it supports type-c USB3.0
  - Edit `SSDT-PCIList.aml` to let System Information.app show correct information


## 2018-04-13

### Update
  - Update `Clover` r4438
  - Update `AppleALC` v1.2.7
  - Update `SSDT-IMEI.aml`, `SSDT-PTSWAK.aml`, `SSDT-SATA.aml`, `SSDT-XOSI.aml` from Rehabman's Github

### Change
  - Edit `SSDT-LPC.aml` to load native AppleLPC


## [XiaoMi NoteBook Pro EFI v1.1.1](https://github.com/stevezhengshiqi/XiaoMi-Pro/releases/tag/1.1.1)
## 2018-04-08

  - Support for 10.13.4 installation

### Update
  - Update `ACPIBatteryManager` v1.81.4
  - Update `AppleALC` v1.2.6
  - Update `FakeSMC` v6.26-344-g1cf53906.1787
  - Update `IntelGraphicsDVMTFixup` v1.2.1
  - Update `IntelGraphicsFixup` v1.2.7, no need kexts for faking Intel Graphics ID
  - Update `Lilu` v1.2.3
  - Update `Shiki` v2.2.6
  - Update `USBInjectAll` v0.6.4

### Add
  - Add `AppleBacklightInjector` to widen the range of brightness
  - Add `CPUFriend` and `CPUFriendDataProvider` to enable native XCPM and HWP power management
  - Add boot-args `shikigva=1`, `igfxrst=1` and `igfxfw=1` to make the Graphics card more powerful and fix strange secondary boot interface.
  - Add `SSDT-LGPA.aml`, support native brightness hotkey


## [XiaoMi NoteBook Pro EFI v1.0.0](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/tag/v1.0.0)
## 2018-01-25

  - Support for 10.13.x installation

### Update
  - Update `Lilu` v1.2.2
  - Update `AppleALC` v1.2.2 to support XiaoMi-Pro, layout-id: 99
  - Update `IntelGraphicsFixup` v1.2.3
  - Update `VoodooI2C` to version 2.0.1, supports multi-gestures, touchpad boot can be used normally, no drift, no wakeup

### Change
  - Fix the issue of percentage refreshes
  - Fix sound card sleep wake up soundless problem
  - Fix screen brightness can not be saved


## 2017-11-07

### Downgrade
  - Downgrade `Lilu` v1.2.0, because v1.2.1 is not stable at the moment and may fail to enter the system
  - Downgrade `AppleALC` v1.2.0


## 2017-11-05

### Update
  - Update `apfs.efi` to version 10.13.1

### Add
  - Add ALCPlugFix directory, please enter the ALCPlugFix directory after the installation is complete, double-click the `install.command` to automatically install. Command Install the headset plug-in state correction daemon

### Change
  - Integrate `AppleALC_ALC298_id13_id28.kext` driver to EFI
  - Fix Drivers64UEFI to solve the problem that can not be installed


## 2017-11-02

### Update
  - Update `Lilu` v1.2.0, support 10.13.2Beta
  - Update `AppleALC`, using the latest revision of Lilu co-compiler to solve 10.13.1 update can not be driven after the problem


## 2017-10-31

  - Update sound card driver, fix earphone problem
  - New driver to add layout-id: 13
  - Support four nodes to support the headset to switch freely, Mic / LineIn is working properly


## 2017-10-19

  - Graphics driver is normal
  - The touchpad turns on normally, multi-gestures are normal after waking up
  - normal sleep
  - Battery information is normal


## 2017-10-18

  - Beta graphics driver is not as good as the first version; now the graphics driver is restored to fake 0x19160000

### Remove
  - Remove `USBInjectAll`, replace with `SSDT-UIAC.aml` to customize USB device

### Change
  - Fix ACPI
  - Fix Drivers


## 2017-10-17

  - EFI update, fixed graphics driver

### Update
  - Update `Lilu` v1.2.0
  - Update `AppleALC` v1.2.1
  - Update `IntelGraphicsDVMTFixup` v1.2.0
  - Update `AirportBrcmFixup` v1.1.0

### Add
  - Add HDMI Audio output

### Change
  - Fix `IntelGraphicsFixup` v1.2.0


## 2017-10-14

  - EFI update, the trackpad is working
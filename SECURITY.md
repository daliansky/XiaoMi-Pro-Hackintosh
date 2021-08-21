# Security Policy

## Change PlatformInfo

XiaoMi NoteBook Pro EFI is for general hackintosh usage. However, it could be hazardous because multiple people would share the same serial numbers defined in `config.plist`. It's highly recommended to generate your own serial numbers to protect your device from potential privacy leaks.

- At first, download [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) and select option 1 to download MacSerial and next option 3. Then, defaultly, type `MacBookPro15,4 5` (KBL) or `MacBookPro16,2 5` (CML) to generate some new serials.

### For Clover Users
- Go to `/EFI/CLOVER/` and open `config.plist`
- In `SMBIOS`, add `BoardSerialNumber` with value `Board Serial` you got from [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), add `SerialNumber` with value `Serial` you got from [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), and add `SmUUID` with value `SmUUID` you got from [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)
- Restart and done

### For OC Users
- Go to `/EFI/OC/` and open `config.plist`
- In `PlatformInfo - Generic`, change `MLB` value to `Board Serial` you got from [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), change `SystemSerialNumber` value to `Serial` you got from [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), and change `SystemUUID` value to `SmUUID` you got from [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)
- Restart and done


## UEFI Security (OC Only)

Please read [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf) **UEFI Secure Boot** section. It includes security instructions about Apple Secure Boot, secure DMG loading, apfs drivers, sign all the third-party drivers, enable BIOS Secure Boot function, and so on.


## Reporting a Vulnerability

Feel free to report a security vulnerability in the [Issue Page](https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues) if you find any.

We will respond to security vulnerabilities as soon as possible. A gentle reminder that releases of this repository are in general collections of hackintosh kernel extensions and bootloaders. We may not be capable of fixing code-level security vulnerabilities unless the authors of responsible kernel extensions/bootloaders assist us in fixing them.


## Reference

Thanks to [dortania](https://github.com/dortania) for providing [Fixing iMessage and other services with OpenCore](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html).

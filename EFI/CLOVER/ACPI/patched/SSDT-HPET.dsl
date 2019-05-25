// NOT Necessary hotpatch
// Maintained by: stevezhengshiqi
// Disable HPET device by giving value 0 to _STA

DefinitionBlock ("", "SSDT", 2, "hack", "_HPET", 0x00000000)
{
    External (_SB_.PCI0.LPCB.HPET, DeviceObj)

    Scope (_SB.PCI0.LPCB.HPET)
    {
        Name (_STA, Zero)  // _STA: Status
    }
}


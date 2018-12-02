// Maintained by: stevezhengshiqi
// Disable HPET device by passing value 0 to HPTE

DefinitionBlock ("", "SSDT", 2, "hack", "_HPET", 0x00000000)
{
    External (_SB_.PCI0.LPCB.HPET, DeviceObj)

    Scope (_SB.PCI0.LPCB.HPET)
    {
        Name (HPTE, Zero)
    }
}


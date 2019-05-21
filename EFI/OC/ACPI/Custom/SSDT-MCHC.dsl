// NOT Necessary hotpatch
// Maintained by: stevezhengshiqi
// Adding missing MCHC Device

DefinitionBlock ("", "SSDT", 2, "hack", "_MCHC", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)

    Scope (_SB.PCI0)
    {
        Device (MCHC)
        {
            Name (_ADR, Zero)  // _ADR: Address
        }
    }
}


// NOT Necessary hotpatch
// Maintained by: stevezhengshiqi
// Reference: https://github.com/syscl/XPS9350-macOS/blob/master/DSDT/patches/syscl_PPMCnPMCR.txt by syscl
// PPMC and PMCR combine together for macOS to load LPCB correctly, mainly for Intel 100-series

DefinitionBlock ("", "SSDT", 2, "hack", "_PMCR", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)

    Scope (_SB.PCI0)
    {
        Device (PMCR)
        {
            Name (_ADR, 0x001F0002)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}
// Maintained by: stevezhengshiqi
// Reference: https://github.com/syscl/XPS9350-macOS/blob/master/DSDT/patches/syscl_PPMCnPMCR.txt by syscl
// PPMC and PMCR combine together for macOS to load LPCB correctly

DefinitionBlock ("", "SSDT", 2, "hack", "_PMCR", 0x00000000)
{
    Device (_SB.PCI0.PMCR)
    {
        Name (_ADR, 0x001F0002)  // _ADR: Address
    }
}


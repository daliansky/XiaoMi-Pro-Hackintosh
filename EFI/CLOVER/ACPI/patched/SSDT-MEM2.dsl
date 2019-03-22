// NOT Necessary hotpatch
// Maintained by: stevezhengshiqi
// Reference: https://github.com/syscl/XPS9350-macOS/blob/master/DSDT/patches/syscl_iGPU_MEM2.txt by syscl
// Add missing MEM2 device as macOS expects.

DefinitionBlock ("", "SSDT", 2, "hack", "_MEM2", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)

    Scope (_SB.PCI0)
    {
        Device (MEM2)
        {
            Name (_HID, EisaId ("PNP0C01") /* System Board */)  // _HID: Hardware ID
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_STA, 0x0F)  // _STA: Status
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20000000,         // Address Base
                    0x00200000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x40000000,         // Address Base
                    0x00200000,         // Address Length
                    )
            })
        }
    }
}


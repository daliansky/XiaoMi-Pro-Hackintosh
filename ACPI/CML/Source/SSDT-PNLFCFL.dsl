// Necessary hotpatch, pair with WhateverGreen.kext
// Maintained by: Acidanthera
// Reference: https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-PNLFCFL.dsl by Acidanthera
// WARN: This file is deprecated and left for compatibility reasons.
//       Please switch to SSDT-PNLF table if possible.
//
// Adding PNLF device for WhateverGreen.kext and others.
// This one is specific to CFL+
// Rename GFX0 to anything else if your IGPU name is different.
// Adding PNLF device for WhateverGreen.kext and others.
// This one is specific to CFL+
// Rename GFX0 to anything else if your IGPU name is different.

DefinitionBlock ("", "SSDT", 2, "ACDT", "_PNLFCFL", 0x00000000)
{
    External (_SB_.PCI0.GFX0, DeviceObj)

    Device (_SB.PCI0.GFX0.PNLF)
    {
     // Name (_ADR, Zero)  // _ADR: Address
        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
        Name (_CID, "backlight")  // _CID: Compatible ID
        Name (_UID, 0x13)  // _UID: Unique ID
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0B)
            }
            Else
            {
                Return (Zero)
            }
        }
    }
}
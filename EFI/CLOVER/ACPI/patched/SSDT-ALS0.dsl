// NOT Necessary hotpatch
// Maintained by: Rehabman
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-ALS0.dsl
// Fake ambient light sensor device, but causes error log issued by AppleSMCLMU if using VirtualSMC.

DefinitionBlock ("", "SSDT", 2, "hack", "_ALS0", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Device (ALS0)
        {
            Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
            Name (_CID, "smc-als")  // _CID: Compatible ID
            Name (_ALI, 0x012C)  // _ALI: Ambient Light Illuminance
            Name (_ALR, Package (0x01)  // _ALR: Ambient Light Response
            {
                Package (0x02)
                {
                    0x64, 
                    0x012C
                }
            })
        }
    }
}


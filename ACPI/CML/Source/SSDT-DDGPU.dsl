// Necessary hotpatch
// Maintained by: stevezhengshiqi
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-DDGPU.dsl by Rehabman
// For disabling the discrete GPU on Xiaomi-Pro CometLake

DefinitionBlock ("", "SSDT", 2, "hack", "_DDGPU", 0x00000000)
{
    External (_SB_.PCI0.RP05.PXSX._OFF, MethodObj)

    Device (RMD1)
    {
        Name (_HID, "RMD10000")  // _HID: Hardware ID
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            If (CondRefOf (\_SB.PCI0.RP05.PXSX._OFF))
            {
                \_SB.PCI0.RP05.PXSX._OFF ()
            }
        }

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
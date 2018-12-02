// Maintained by: Rehabman
// Reference: https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266 by Rehabman
// USB power properties via USBX device

DefinitionBlock ("", "SSDT", 2, "hack", "_USBX", 0x00000000)
{
    External (DTGP, MethodObj)    // 5 Arguments

    Device (_SB.USBX)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x04)
                {
                    "kUSBSleepPortCurrentLimit", 
                    0x0BB8, 
                    "kUSBWakePortCurrentLimit", 
                    0x0BB8
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}


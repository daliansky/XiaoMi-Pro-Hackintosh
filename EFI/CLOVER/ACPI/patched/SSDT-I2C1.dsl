// Maintained by: stevezhengshiqi
// Disable I2C1 device which has no real function

DefinitionBlock ("", "SSDT", 2, "hack", "_I2C1", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)

    Scope (_SB.PCI0.I2C1)
    {
        Name (_STA, Zero)  // _STA: Status
    }
}


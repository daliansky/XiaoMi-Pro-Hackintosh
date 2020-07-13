// NOT Necessary hotpatch
// Maintained by: daliansky
// Reference: https://github.com/daliansky/OC-little
// Disable Intel Wireless Card (RP08) to save power
// Users can change RP08 to whatever father PCI device that they want to disable

DefinitionBlock ("", "SSDT", 2, "hack", "_DRP08", 0x00000000)
{
    External (_SB_.PCI0.RP08, DeviceObj)

    Scope (_SB.PCI0.RP08)
    {
        OperationRegion (DE01, PCI_Config, 0x50, One)
        Field (DE01, AnyAcc, NoLock, Preserve)
        {
                ,   1, 
                ,   3, 
            DDDD,   1
        }
    }

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI0.RP08.DDDD = One
        }
    }
}
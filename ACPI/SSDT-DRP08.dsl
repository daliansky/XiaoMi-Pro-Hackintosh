// NOT Necessary hotpatch
// Maintained by: daliansky
// Reference: https://github.com/daliansky/OC-little
// Disable Intel Wireless Card (RP08) to save power
// Users can change RP08 to whatever father PCI device that they want to disable
//
// For XiaoMi-Pro (TM1701)
// RP01 -> MX150 Graphics Card
// RP05 -> Secondary SSD Slot
// RP08 -> Intel Wi-Fi
// RP09 -> Primary SSD Slot

DefinitionBlock ("", "SSDT", 2, "hack", "_DRP08", 0x00000000)
{
    External (_SB_.PCI0.RP08, DeviceObj)

    If (_OSI ("Darwin"))
    {
        Scope (_SB.PCI0.RP08)
        {
            OperationRegion (DE01, PCI_Config, 0x50, One)
            Field (DE01, AnyAcc, NoLock, Preserve)
            {
                    ,   4, 
                DDDD,   1
            }

            DDDD = One
        }
    }
}
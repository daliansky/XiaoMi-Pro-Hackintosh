// NOT Necessary hotpatch
// Maintained by: stevezhengshiqi
// Disable HPET device by giving value 0 to _STA

DefinitionBlock ("", "SSDT", 2, "hack", "_HPET", 0x00000000)
{
    External (_SB_.PCI0.LPCB.HPET, DeviceObj)
    External (HPTE, UnknownObj)

    Scope (_SB.PCI0.LPCB.HPET)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            ElseIf (HPTE)
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


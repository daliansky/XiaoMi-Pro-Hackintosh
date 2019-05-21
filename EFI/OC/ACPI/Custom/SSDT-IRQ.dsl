// NOT Necessary hotpatch
// Maintained by: stevezhengshiqi
// Remove IRQFlags in TIMR and RTC devices

DefinitionBlock ("", "SSDT", 2, "hack", "_IRQ", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.XIMR, DeviceObj)
    External (_SB_.PCI0.LPCB.XRTC, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Device (RTC)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x08,               // Length
                    )
            })
        }

        Device (TIMR)
        {
            Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0040,             // Range Minimum
                    0x0040,             // Range Maximum
                    0x01,               // Alignment
                    0x04,               // Length
                    )
                IO (Decode16,
                    0x0050,             // Range Minimum
                    0x0050,             // Range Maximum
                    0x10,               // Alignment
                    0x04,               // Length
                    )
            })
        }
    }

    Scope (_SB.PCI0.LPCB.XRTC)
    {
        Name (_STA, Zero)  // _STA: Status
    }

    Scope (_SB.PCI0.LPCB.XIMR)
    {
        Name (_STA, Zero)  // _STA: Status
    }
}


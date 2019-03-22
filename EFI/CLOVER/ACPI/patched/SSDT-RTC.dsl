// NOT Necessary hotpatch, pair with `change RTC to XRTC` rename patch
// Maintained by: stevezhengshiqi
// Remove IRQNoFlags {8} from RTC device. `FixRTC` in Clover would shorten the IO length.

DefinitionBlock ("", "SSDT", 2, "hack", "_RTC", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)
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
    }

    Scope (_SB.PCI0.LPCB.XRTC)
    {
        Name (_STA, Zero)  // _STA: Status
    }
}


// Maintained by: stevezhengshiqi
// Reference: https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266 by Rehabman
// Inject Fake EC device to load AppleBusPowerController, work with USBPorts.kext

DefinitionBlock ("", "SSDT", 2, "hack", "_EC", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Device (EC)
        {
            Name (_HID, "EC000000")  // _HID: Hardware ID
        }
    }
}


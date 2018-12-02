// Maintained by: stevezhengshiqi
// Reference: https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266 by Rehabman
// Inject Fake EC device to load AppleBusPowerController, work with SSDT-USBX.aml

DefinitionBlock ("", "SSDT", 2, "hack", "_EC", 0x00000000)
{
    Device (_SB.PCI0.LPCB.EC)
    {
        Name (_HID, "EC000000")  // _HID: Hardware ID
    }
}


// Maintained by: daliansky and stevezhengshiqi
// Reference: https://pci-ids.ucw.cz/read/PC
// Add device information, and can be seen in AppleLogo-AboutThisMac-SystemReport-PCI.

DefinitionBlock ("", "SSDT", 2, "hack", "_PXSX", 0x00000000)
{
    External (_SB_.PCI0.RP01.PXSX, DeviceObj)
    External (_SB_.PCI0.RP05.PXSX, DeviceObj)
    External (_SB_.PCI0.RP08.PXSX, DeviceObj)
    External (_SB_.PCI0.RP09.PXSX, DeviceObj)
    External (DTGP, MethodObj)    // 5 Arguments

    Scope (_SB.PCI0.RP01.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x04)
                {
                    "AAPL,slot-name", 
                    Buffer (0x0C)
                    {
                        "PCI-Express"
                    }, 

                    "model", 
                    Buffer (0x15)
                    {
                        "NVIDIA GeForce MX150"
                    }
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }

    Scope (_SB.PCI0.RP05.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x04)
                {
                    "AAPL,slot-name", 
                    Buffer (0x0A)
                    {
                        "M.2 key M"
                    }, 

                    "model", 
                    Buffer (0x30)
                    {
                        "Intel Sunrise Point-LP PCI Express Root Port #5"
                    }
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }

    Scope (_SB.PCI0.RP08.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x04)
                {
                    "AAPL,slot-name", 
                    Buffer (0x0C)
                    {
                        "PCI-Express"
                    }, 

                    "model", 
                    Buffer (0x14)
                    {
                        "Intel Wireless 8265"
                    }
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }

    Scope (_SB.PCI0.RP09.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x06)
                {
                    "AAPL,slot-name", 
                    Buffer (0x0A)
                    {
                        "M.2 key M"
                    }, 

                    "model", 
                    Buffer (0x30)
                    {
                        "Intel Sunrise Point-LP PCI Express Root Port #9"
                    }, 

                    "use-msi", 
                    One
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}


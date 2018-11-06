/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLYhbRih.aml, Tue Nov  6 13:43:20 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000002DD (733)
 *     Revision         0x02
 *     Checksum         0x8F
 *     OEM ID           "hack"
 *     OEM Table ID     "_PXSX"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_PXSX", 0x00000000)
{
    External (_SB_.PCI0.RP09.PXSX, DeviceObj)
    External (DTGP, MethodObj)    // 5 Arguments

    Method (_SB.PCI0.RP01.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (!Arg2)
        {
            Return (Buffer (One)
            {
                 0x03                                             // .
            })
        }

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

    Method (_SB.PCI0.RP05.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (!Arg2)
        {
            Return (Buffer (One)
            {
                 0x03                                             // .
            })
        }

        Local0 = Package (0x04)
            {
                "AAPL,slot-name", 
                Buffer (0x0A)
                {
                    "M.2 key B"
                }, 

                "model", 
                Buffer (0x2A)
                {
                    "Sunrise Point-LP PCI Express Root Port #5"
                }
            }
        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
        Return (Local0)
    }

    Method (_SB.PCI0.RP08.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (!Arg2)
        {
            Return (Buffer (One)
            {
                 0x03                                             // .
            })
        }

        Local0 = Package (0x04)
            {
                "AAPL,slot-name", 
                Buffer (0x0C)
                {
                    "PCI-Express"
                }, 

                "model", 
                Buffer (0x21)
                {
                    "Intel Dual Band Wireless-AC 8265"
                }
            }
        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
        Return (Local0)
    }

    Scope (_SB.PCI0.RP09.PXSX)
    {
        Name (NVME, One)
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((NVME == One))
            {
                Local0 = Package (0x08)
                    {
                        "AAPL,slot-name", 
                        Buffer (0x0A)
                        {
                            "M.2 key M"
                        }, 

                        "model", 
                        Buffer (0x2A)
                        {
                            "Sunrise Point-LP PCI Express Root Port #9"
                        }, 

                        "use-msi", 
                        One, 
                        "nvme-LPSR-during-S3-S4", 
                        One
                    }
            }
            Else
            {
                Local0 = Package (0x06)
                    {
                        "AAPL,slot-name", 
                        Buffer (0x0A)
                        {
                            "M.2 key M"
                        }, 

                        "model", 
                        Buffer (0x2A)
                        {
                            "Sunrise Point-LP PCI Express Root Port #9"
                        }, 

                        "use-msi", 
                        One
                    }
            }

            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}


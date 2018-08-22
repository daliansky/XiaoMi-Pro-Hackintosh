/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLVqaVMP.aml, Wed Aug 22 20:38:53 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000841 (2113)
 *     Revision         0x02
 *     Checksum         0xAD
 *     OEM ID           "hack"
 *     OEM Table ID     "PCIList"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "PCIList", 0x00000000)
{
    External (_SB_.PCI0._XHC, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.HDEF, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.IGPU, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.IMEI, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.PPMC, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP01, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP01.PXSX, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP05, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP05.PXSX, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP08, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP08.PXSX, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP09, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP09.PXSX, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SBUS, DeviceObj)    // (from opcode)

    Method (_SB.PCI0.HDEF._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x08)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "hda-gfx", 
            Buffer (0x0A)
            {
                "onboard-1"
            }, 

            "hda-idle-support", 
            Buffer (0x02)
            {
                "1"
            }, 

            "model", 
            Buffer (0x20)
            {
                "Realtek ALC298 Audio Controller"
            }
        })
    }

    Method (_SB.PCI0.I2C0._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x06)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "device_type", 
            Buffer (0x04)
            {
                "I2C"
            }, 

            "model", 
            Buffer (0x2D)
            {
                "Sunrise Point-LP Serial IO I2C Controller #0"
            }
        })
    }

    Method (_SB.PCI0.I2C1._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x06)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "device_type", 
            Buffer (0x04)
            {
                "I2C"
            }, 

            "model", 
            Buffer (0x2D)
            {
                "Sunrise Point-LP Serial IO I2C Controller #1"
            }
        })
    }

    Method (_SB.PCI0.IGPU._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "hda-gfx", 
            Buffer (0x0A)
            {
                "onboard-1"
            }
        })
    }

    Method (_SB.PCI0.IMEI._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x06)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "device_type", 
            Buffer (0x05)
            {
                "IMEI"
            }, 

            "model", 
            Buffer (0x1E)
            {
                "Sunrise Point-LP CSME HECI #1"
            }
        })
    }

    Method (_SB.PCI0.RP01._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x02)
        {
            "reg-ltrovr", 
            Buffer (0x08)
            {
                 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
            }
        })
    }

    Method (_SB.PCI0.RP01.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
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
        })
    }

    Method (_SB.PCI0.RP05._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x02)
        {
            "reg-ltrovr", 
            Buffer (0x08)
            {
                 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
            }
        })
    }

    Method (_SB.PCI0.RP05.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
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
        })
    }

    Method (_SB.PCI0.RP08._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x02)
        {
            "reg-ltrovr", 
            Buffer (0x08)
            {
                 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
            }
        })
    }

    Method (_SB.PCI0.RP08.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
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
        })
    }

    Method (_SB.PCI0.RP09._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x02)
        {
            "reg-ltrovr", 
            Buffer (0x08)
            {
                 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
            }
        })
    }

    Method (_SB.PCI0.RP09.PXSX._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
        {
            "AAPL,slot-name", 
            Buffer (0x0A)
            {
                "M.2 key M"
            }, 

            "model", 
            Buffer (0x1A)
            {
                "NVMe SSD Controller PM961"
            }
        })
    }

    Method (_SB.PCI0.PPMC._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x06)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "device_type", 
            Buffer (0x12)
            {
                "PCHPMC Controller"
            }, 

            "model", 
            Buffer (0x15)
            {
                "Sunrise Point-LP PMC"
            }
        })
    }

    Method (_SB.PCI0.SBUS._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
        {
            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "model", 
            Buffer (0x17)
            {
                "Sunrise Point-LP SMBus"
            }
        })
    }

    Method (_SB.PCI0.XHC._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x08)
        {
            "name", 
            Buffer (0x0D)
            {
                "pci8086,9d2f"
            }, 

            "AAPL,slot-name", 
            Buffer (0x0C)
            {
                "PCI-Express"
            }, 

            "model", 
            Buffer (0x29)
            {
                "Sunrise Point-LP USB 3.0 xHCI Controller"
            }, 

            "RM,pr2-force", 
            Buffer (0x04)
            {
                 0x00, 0x00, 0x00, 0x00                         
            }
        })
    }
}


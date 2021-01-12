// Optional hotpatch, pair with `Rename Method(_UPC,0,S) to XUPC` rename patch and SSDT-EC
// Maintained by: stevezhengshiqi
// Reference: https://github.com/daliansky/OC-little and https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266 by Rehabman
// USB power injection (work with SSDT-EC) and patch USB ports to enable fingerprint port (work with _UPC rename)

// HS01 -> HS USB3 near right
// HS02 -> WLAN_LTE, might only available on TM1701 (Disabled)
// HS03 -> HS USB3 near left
// HS04 -> HS USB3 far right
// HS05 -> bluetooth (Disabled)
// HS06 -> camera
// HS07 -> SD card reader (Disabled)
// HS08 -> fingerprint
// HS09 -> HS USB3 far left
// SS01 -> SS USB3 near right
// SS02 -> SS USB3 near left
// SS03 -> SS USB3 far left
// SS04 -> SS USB3 far right

DefinitionBlock ("", "SSDT", 2, "hack", "_USB", 0x00000000)
{
    External (_SB_.PCI0.XHC_.RHUB.HS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS01.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.HS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS03.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.HS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS04.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.HS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS06.WCAM, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS07, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS08, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS09, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS09.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.HS10, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS11, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS12, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS13, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS14, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS01.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.SS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS02.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.SS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS03.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.SS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS04.UPCN, PkgObj)
    External (_SB_.PCI0.XHC_.RHUB.SS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS07, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS08, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS09, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS10, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR1, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR2, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.UUNS, PkgObj)

    Device (_SB.USBX)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (!Arg2)
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x04)
            {
                "kUSBSleepPortCurrentLimit", 
                0x0BB8, 
                "kUSBWakePortCurrentLimit", 
                0x0BB8
            })
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS01)  // HS USB3 near right
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x09, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.HS01.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS02)  // WLAN_LTE
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS03)  // HS USB3 near left
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x03, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.HS03.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS04)  // HS USB3 far right
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x09, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.HS04.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS05)  // bluetooth
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS06)  // camera
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Name (UPCP, Package (0x04)
            {
                Zero, 
                0xFF, 
                Zero, 
                Zero
            })
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.HS06._UPC.UPCP */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS06.WCAM)  // camera
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Name (UPCP, Package (0x04)
            {
                Zero, 
                0xFF, 
                Zero, 
                Zero
            })
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.HS06.WCAM._UPC.UPCP */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS07)  // SD card reader
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS08)  // fingerprint
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS09)  // HS USB3 far left
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x03, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.HS09.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.HS10)
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.USR1)
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.USR2)
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.SS01)  // SS USB3 near right
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x09, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.SS01.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.SS02)  // SS USB3 near left
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x03, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.SS02.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.SS03)  // SS USB3 far left
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x03, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.SS03.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.SS04)  // SS USB3 far right
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package (0x04)
                {
                    0xFF, 
                    0x09, 
                    Zero, 
                    Zero
                })
            }
            Else
            {
                Return (\_SB.PCI0.XHC.RHUB.SS04.UPCN) /* External reference */
            }
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.SS05)
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    Scope (_SB.PCI0.XHC.RHUB.SS06)
    {
        Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
        {
            Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.HS11))
    {
        Scope (_SB.PCI0.XHC.RHUB.HS11)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.HS12))
    {
        Scope (_SB.PCI0.XHC.RHUB.HS12)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.HS13))
    {
        Scope (_SB.PCI0.XHC.RHUB.HS13)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.HS14))
    {
        Scope (_SB.PCI0.XHC.RHUB.HS14)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.SS07))
    {
        Scope (_SB.PCI0.XHC.RHUB.SS07)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.SS08))
    {
        Scope (_SB.PCI0.XHC.RHUB.SS08)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.SS09))
    {
        Scope (_SB.PCI0.XHC.RHUB.SS09)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.XHC.RHUB.SS10))
    {
        Scope (_SB.PCI0.XHC.RHUB.SS10)
        {
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (\_SB.PCI0.XHC.RHUB.UUNS) /* External reference */
            }
        }
    }
}
// Necessary hotpatch for CometLake with MX350, pair with `Rename Method(LGPA,1,S) to XGPA` rename patch and SSDT-PS2K
// Maintained by: stevezhengshiqi
// Reference: https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659 by Rehabman
// Let brightness key and screenshot key work with VoodooPS2Controller.kext (for XiaoMi-Pro CometLake with MX350), pair with LGPA rename and SSDT-PS2K

DefinitionBlock ("", "SSDT", 2, "hack", "_LGPA350", 0x00000000)
{
    External (_SB_.CPPC, IntObj)
    External (_SB_.PCI0.GFX0.DD1F, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.ACTL, FieldUnitObj)
    External (_SB_.PCI0.LPCB.CCI0, IntObj)
    External (_SB_.PCI0.LPCB.CCI1, IntObj)
    External (_SB_.PCI0.LPCB.CCI2, IntObj)
    External (_SB_.PCI0.LPCB.CCI3, IntObj)
    External (_SB_.PCI0.LPCB.CHPM, MethodObj)
    External (_SB_.PCI0.LPCB.CPCK, FieldUnitObj)
    External (_SB_.PCI0.LPCB.DCTL, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC92, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ED01, IntObj)
    External (_SB_.PCI0.LPCB.ED04, IntObj)
    External (_SB_.PCI0.LPCB.ED05, IntObj)
    External (_SB_.PCI0.LPCB.ED06, IntObj)
    External (_SB_.PCI0.LPCB.ED07, IntObj)
    External (_SB_.PCI0.LPCB.ED09, IntObj)
    External (_SB_.PCI0.LPCB.ED10, IntObj)
    External (_SB_.PCI0.LPCB.ED11, IntObj)
    External (_SB_.PCI0.LPCB.ED12, IntObj)
    External (_SB_.PCI0.LPCB.ED13, IntObj)
    External (_SB_.PCI0.LPCB.ED14, IntObj)
    External (_SB_.PCI0.LPCB.ED15, IntObj)
    External (_SB_.PCI0.LPCB.ED16, IntObj)
    External (_SB_.PCI0.LPCB.EF01, IntObj)
    External (_SB_.PCI0.LPCB.EF02, IntObj)
    External (_SB_.PCI0.LPCB.EF03, IntObj)
    External (_SB_.PCI0.LPCB.EF04, IntObj)
    External (_SB_.PCI0.LPCB.EF05, IntObj)
    External (_SB_.PCI0.LPCB.EF06, IntObj)
    External (_SB_.PCI0.LPCB.EF07, IntObj)
    External (_SB_.PCI0.LPCB.EF09, IntObj)
    External (_SB_.PCI0.LPCB.EF10, IntObj)
    External (_SB_.PCI0.LPCB.EF11, IntObj)
    External (_SB_.PCI0.LPCB.EF12, IntObj)
    External (_SB_.PCI0.LPCB.EF13, IntObj)
    External (_SB_.PCI0.LPCB.EF14, IntObj)
    External (_SB_.PCI0.LPCB.EF15, IntObj)
    External (_SB_.PCI0.LPCB.EF16, IntObj)
    External (_SB_.PCI0.LPCB.ET01, IntObj)
    External (_SB_.PCI0.LPCB.ET04, IntObj)
    External (_SB_.PCI0.LPCB.LID0, DeviceObj)
    External (_SB_.PCI0.LPCB.MGI0, IntObj)
    External (_SB_.PCI0.LPCB.MGI1, IntObj)
    External (_SB_.PCI0.LPCB.MGI2, IntObj)
    External (_SB_.PCI0.LPCB.MGI3, IntObj)
    External (_SB_.PCI0.LPCB.MGI4, IntObj)
    External (_SB_.PCI0.LPCB.MGI5, IntObj)
    External (_SB_.PCI0.LPCB.MGI6, IntObj)
    External (_SB_.PCI0.LPCB.MGI7, IntObj)
    External (_SB_.PCI0.LPCB.MGI8, IntObj)
    External (_SB_.PCI0.LPCB.MGI9, IntObj)
    External (_SB_.PCI0.LPCB.MGIA, IntObj)
    External (_SB_.PCI0.LPCB.MGIB, IntObj)
    External (_SB_.PCI0.LPCB.MGIC, IntObj)
    External (_SB_.PCI0.LPCB.MGID, IntObj)
    External (_SB_.PCI0.LPCB.MGIE, IntObj)
    External (_SB_.PCI0.LPCB.MGIF, IntObj)
    External (_SB_.PCI0.LPCB.OCPF, FieldUnitObj)
    External (_SB_.PCI0.LPCB.OSMI, MethodObj)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)
    External (_SB_.PCI0.LPCB.PWCG, MethodObj)
    External (_SB_.PCI0.RP05.PXSX, DeviceObj)
    External (_SB_.PCI0.WMIX, DeviceObj)
    External (_SB_.PCI0.WMIX.EV20, IntObj)
    External (_SB_.UBTC, DeviceObj)
    External (_SB_.UBTC.CCI0, IntObj)
    External (_SB_.UBTC.CCI1, IntObj)
    External (_SB_.UBTC.CCI2, IntObj)
    External (_SB_.UBTC.CCI3, IntObj)
    External (_SB_.UBTC.MGI0, IntObj)
    External (_SB_.UBTC.MGI1, IntObj)
    External (_SB_.UBTC.MGI2, IntObj)
    External (_SB_.UBTC.MGI3, IntObj)
    External (_SB_.UBTC.MGI4, IntObj)
    External (_SB_.UBTC.MGI5, IntObj)
    External (_SB_.UBTC.MGI6, IntObj)
    External (_SB_.UBTC.MGI7, IntObj)
    External (_SB_.UBTC.MGI8, IntObj)
    External (_SB_.UBTC.MGI9, IntObj)
    External (_SB_.UBTC.MGIA, IntObj)
    External (_SB_.UBTC.MGIB, IntObj)
    External (_SB_.UBTC.MGIC, IntObj)
    External (_SB_.UBTC.MGID, IntObj)
    External (_SB_.UBTC.MGIE, IntObj)
    External (_SB_.UBTC.MGIF, IntObj)
    External (OG00, FieldUnitObj)
    External (OPMD, FieldUnitObj)
    External (PNOT, MethodObj)
    External (SEN1, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Method (LGPA, 1, Serialized)
        {
            Switch (ToInteger (Arg0))
            {
                Case (Zero)
                {
                    Notify (LID0, 0x80) // Status Change
                }
                Case (One)
                {
                    CHPM ()
                    OSMI (0xF8)
                    CPPC = Zero
                    If ((OG00 > Zero))
                    {
                        Divide (OG00, 0x0A, Local0, Local1)
                        If ((Local0 > 0x05))
                        {
                            Local1++
                        }

                        While (Local1)
                        {
                            Local1--
                            Notify (^^GFX0.DD1F, 0x86) // Device-Specific
                            Sleep (0x32)
                        }

                        OG00 = Zero
                    }

                    PWCG ()
                    PNOT ()
                }
                Case (0x02)
                {
                    PWCG ()
                    PNOT ()
                }
                Case (0x03)
                {
                    // Brightness Down
                    If (_OSI ("Darwin"))
                    {
                        Notify (PS2K, 0x0405)
                    }
                    Else
                    {
                        Notify (^^GFX0.DD1F, 0x87) // Device-Specific
                    }

                    OG00 = Zero
                }
                Case (0x04)
                {
                    // Brightness Up
                    If (_OSI ("Darwin"))
                    {
                        Notify (PS2K, 0x0406)
                    }
                    Else
                    {
                        Notify (^^GFX0.DD1F, 0x86) // Device-Specific
                    }

                    OG00 = Zero
                }
                Case (0x05)
                {
                    ET01 = One
                    EF04 = 0x04
                    If ((ED04 == One))
                    {
                        ED04 = Zero
                    }
                    Else
                    {
                        ED04 = One
                    }

                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x06)
                {
                }
                Case (0x07)
                {
                    Notify (SEN1, 0x90) // Device-Specific
                }
                Case (0x08)
                {
                    Local0 = ((EC92 >> 0x03) & One)
                    If (Local0)
                    {
                        Switch (ToInteger (ACTL))
                        {
                            Case (Zero)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (One)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (0x02)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (0x03)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = 0x02
                                PNOT ()
                            }
                            Case (0x04)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = 0x06
                                PNOT ()
                            }
                            Case (0x05)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = 0x08
                                PNOT ()
                            }
                            Case (0x06)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = 0x0E
                                PNOT ()
                            }
                            Case (0x07)
                            {
                                Notify (^^RP05.PXSX, 0xD2) // Hardware-Specific
                                CPPC = 0x0E
                                PNOT ()
                            }
                            Case (0x08)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x0E
                                PNOT ()
                                If ((OG00 > Zero))
                                {
                                    Divide (OG00, 0x0A, Local0, Local1)
                                    If ((Local0 > 0x05))
                                    {
                                        Local1++
                                    }

                                    While (Local1)
                                    {
                                        Local1--
                                        Notify (^^GFX0.DD1F, 0x86) // Device-Specific
                                        Sleep (0x32)
                                    }

                                    OG00 = Zero
                                }
                            }
                            Default
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x0E
                                PNOT ()
                            }

                        }
                    }
                    Else
                    {
                        Switch (ToInteger (DCTL))
                        {
                            Case (Zero)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (One)
                            {
                                Notify (^^RP05.PXSX, 0xD1) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (0x02)
                            {
                                Notify (^^RP05.PXSX, 0xD2) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (0x03)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (0x04)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = Zero
                                PNOT ()
                            }
                            Case (0x05)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x02
                                PNOT ()
                            }
                            Case (0x06)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x06
                                PNOT ()
                            }
                            Case (0x07)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x08
                                PNOT ()
                            }
                            Case (0x08)
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x0E
                                PNOT ()
                            }
                            Default
                            {
                                Notify (^^RP05.PXSX, 0xD5) // Hardware-Specific
                                CPPC = 0x0E
                                PNOT ()
                            }

                        }
                    }
                }
                Case (0x09)
                {
                }
                Case (0x0A)
                {
                    ET01 = One
                    EF07 = 0x07
                    ED07 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x0B)
                {
                    ET01 = One
                    EF07 = 0x07
                    ED07 = Zero
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x0C)
                {
                    ET01 = One
                    EF06 = 0x06
                    ED06 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x0D)
                {
                    ET01 = One
                    EF06 = 0x06
                    ED06 = Zero
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x0E)
                {
                }
                Case (0x0F)
                {
                    ET01 = One
                    EF09 = 0x09
                    If ((CPCK == Zero))
                    {
                        ED09 = Zero
                    }
                    Else
                    {
                        ED09 = One
                    }

                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x10)
                {
                    ET01 = One
                    EF02 = 0x02
                    
                    // Screenshot
                    If (_OSI ("Darwin"))
                    {
                        Notify (PS2K, 0x0223) // Press Down e023
                        Notify (PS2K, 0x0225) // Press Down e025
                        Notify (PS2K, 0x0226) // Press Down e026
                        Notify (PS2K, 0x02A6) // Press Up e026
                        Notify (PS2K, 0x02A5) // Press Up e025
                        Notify (PS2K, 0x02A3) // Press Up e023
                        OG00 = Zero
                    }
                    
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x11)
                {
                }
                Case (0x12)
                {
                    ^^^UBTC.MGI0 = \_SB_.PCI0.LPCB.MGI0 /* External reference */
                    ^^^UBTC.MGI1 = \_SB_.PCI0.LPCB.MGI1 /* External reference */
                    ^^^UBTC.MGI2 = \_SB_.PCI0.LPCB.MGI2 /* External reference */
                    ^^^UBTC.MGI3 = \_SB_.PCI0.LPCB.MGI3 /* External reference */
                    ^^^UBTC.MGI4 = \_SB_.PCI0.LPCB.MGI4 /* External reference */
                    ^^^UBTC.MGI5 = \_SB_.PCI0.LPCB.MGI5 /* External reference */
                    ^^^UBTC.MGI6 = \_SB_.PCI0.LPCB.MGI6 /* External reference */
                    ^^^UBTC.MGI7 = \_SB_.PCI0.LPCB.MGI7 /* External reference */
                    ^^^UBTC.MGI8 = \_SB_.PCI0.LPCB.MGI8 /* External reference */
                    ^^^UBTC.MGI9 = \_SB_.PCI0.LPCB.MGI9 /* External reference */
                    ^^^UBTC.MGIA = \_SB_.PCI0.LPCB.MGIA /* External reference */
                    ^^^UBTC.MGIB = \_SB_.PCI0.LPCB.MGIB /* External reference */
                    ^^^UBTC.MGIC = \_SB_.PCI0.LPCB.MGIC /* External reference */
                    ^^^UBTC.MGID = \_SB_.PCI0.LPCB.MGID /* External reference */
                    ^^^UBTC.MGIE = \_SB_.PCI0.LPCB.MGIE /* External reference */
                    ^^^UBTC.MGIF = \_SB_.PCI0.LPCB.MGIF /* External reference */
                    ^^^UBTC.CCI0 = \_SB_.PCI0.LPCB.CCI0 /* External reference */
                    ^^^UBTC.CCI1 = \_SB_.PCI0.LPCB.CCI1 /* External reference */
                    ^^^UBTC.CCI2 = \_SB_.PCI0.LPCB.CCI2 /* External reference */
                    ^^^UBTC.CCI3 = \_SB_.PCI0.LPCB.CCI3 /* External reference */
                    Notify (UBTC, 0x80) // Status Change
                }
                Case (0x13)
                {
                    ET04 = 0x04
                    EF01 = One
                    ED01 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x14)
                {
                    OCPF = Zero
                    Notify (UBTC, One) // Device Check
                }
                Case (0x15)
                {
                    ET01 = One
                    EF01 = One
                    
                    // Video Mirror
                    If (_OSI ("Darwin"))
                    {
                        Notify (PS2K, 0x0225) // Press Down e025
                        Notify (PS2K, 0x022B) // Press Down e02b
                        Notify (PS2K, 0x02AB) // Press Up e02b
                        Notify (PS2K, 0x02A5) // Press Up e025
                        OG00 = Zero
                    }
                    
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x16)
                {
                    ET01 = One
                    EF03 = 0x03

                    // Mission Control
                    If (_OSI ("Darwin"))
                    {
                        Notify (PS2K, 0x022C) // Press Down e02c
                        Notify (PS2K, 0x022D) // Press Down e02d
                        Notify (PS2K, 0x02AD) // Press Up e02d
                        Notify (PS2K, 0x02AC) // Press Up e02c
                        OG00 = Zero
                    }

                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x17)
                {
                    ET01 = One
                    EF05 = 0x05
                    ED05 = Zero
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x18)
                {
                    ET01 = One
                    EF05 = 0x05
                    ED05 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x19)
                {
                    ET01 = One
                    EF10 = 0x10
                    ED10 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x1A)
                {
                    ET01 = One
                    EF16 = 0x16
                    If ((ED16 == 0x02))
                    {
                        ED16 = Zero
                    }
                    Else
                    {
                        ED16++
                    }

                    OPMD = ED16 /* \_SB_.PCI0.LPCB.ED16 */
                    CHPM ()
                    OSMI (0x54)
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x1B)
                {
                    ET01 = One
                    EF11 = 0x11
                    ED11 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x1C)
                {
                    ET01 = One
                    EF12 = 0x12
                    ED12 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x1D)
                {
                    ET01 = One
                    EF13 = 0x13
                    ED13 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x1E)
                {
                    ET01 = One
                    EF14 = 0x14
                    ED14 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x1F)
                {
                    ET01 = One
                    EF15 = 0x15
                    ED15 = One
                    If ((^^WMIX.EV20 != Zero))
                    {
                        Notify (WMIX, 0x9A) // Device-Specific
                    }
                }
                Case (0x20)
                {
                }
                Case (0x21)
                {
                    CHPM ()
                    OSMI (0xF8)
                }
                Case (0x22)
                {
                    OPMD = Zero
                    CHPM ()
                    OSMI (0x54)
                }
                Case (0x0100)
                {
                }
                Default
                {
                }

            }
        }
    }
}
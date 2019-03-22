// Necessary hotpatch for GTX
// Maintained by: stevezhengshiqi
// Reference: https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659 by Rehabman
// Let brightness key work with VoodooPS2Controller.kext(for XiaoMi-Pro GTX)

DefinitionBlock ("", "SSDT", 2, "hack", "_LGPAGTX", 0x00000000)
{
    External (_PR_.CPPC, IntObj)
    External (_SB_.PCI0.IGPU.CBLV, FieldUnitObj)
    External (_SB_.PCI0.IGPU.DD1F, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.ACTL, FieldUnitObj)
    External (_SB_.PCI0.LPCB.BSLF, IntObj)
    External (_SB_.PCI0.LPCB.CCI0, UnknownObj)
    External (_SB_.PCI0.LPCB.CCI1, UnknownObj)
    External (_SB_.PCI0.LPCB.CCI2, UnknownObj)
    External (_SB_.PCI0.LPCB.CCI3, UnknownObj)
    External (_SB_.PCI0.LPCB.DCTL, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC92, FieldUnitObj)
    External (_SB_.PCI0.LPCB.HIDD.HPEM, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.LID0, DeviceObj)
    External (_SB_.PCI0.LPCB.MDCS, FieldUnitObj)
    External (_SB_.PCI0.LPCB.MGI0, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI1, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI2, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI3, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI4, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI5, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI6, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI7, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI8, UnknownObj)
    External (_SB_.PCI0.LPCB.MGI9, UnknownObj)
    External (_SB_.PCI0.LPCB.MGIA, UnknownObj)
    External (_SB_.PCI0.LPCB.MGIB, UnknownObj)
    External (_SB_.PCI0.LPCB.MGIC, UnknownObj)
    External (_SB_.PCI0.LPCB.MGID, UnknownObj)
    External (_SB_.PCI0.LPCB.MGIE, UnknownObj)
    External (_SB_.PCI0.LPCB.MGIF, UnknownObj)
    External (_SB_.PCI0.LPCB.OCPF, FieldUnitObj)
    External (_SB_.PCI0.LPCB.OSMI, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)
    External (_SB_.PCI0.LPCB.PWCG, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.VGBI, DeviceObj)
    External (_SB_.PCI0.LPCB.VGBI.VBTN, UnknownObj)
    External (_SB_.PCI0.RP01.PXSX, DeviceObj)
    External (_SB_.PCI0.WMIE, DeviceObj)
    External (_SB_.PCI0.WMIE.EVT5, UnknownObj)
    External (_SB_.PCI0.WMIE.EVT6, UnknownObj)
    External (_SB_.PCI0.WMIE.EVT7, UnknownObj)
    External (_SB_.PCI0.WMIE.EVT8, UnknownObj)
    External (_SB_.PCI0.WMIE.EVT9, UnknownObj)
    External (_SB_.PCI0.WMIE.EVTA, UnknownObj)
    External (_SB_.PCI0.WMIE.EVTB, UnknownObj)
    External (_SB_.PCI0.WMIE.EVTC, UnknownObj)
    External (_SB_.PCI0.WMIE.EVTD, UnknownObj)
    External (_SB_.STXD, MethodObj)    // 2 Arguments
    External (_SB_.UBTC, UnknownObj)
    External (_SB_.UBTC.CCI0, UnknownObj)
    External (_SB_.UBTC.CCI1, UnknownObj)
    External (_SB_.UBTC.CCI2, UnknownObj)
    External (_SB_.UBTC.CCI3, UnknownObj)
    External (_SB_.UBTC.MGI0, UnknownObj)
    External (_SB_.UBTC.MGI1, UnknownObj)
    External (_SB_.UBTC.MGI2, UnknownObj)
    External (_SB_.UBTC.MGI3, UnknownObj)
    External (_SB_.UBTC.MGI4, UnknownObj)
    External (_SB_.UBTC.MGI5, UnknownObj)
    External (_SB_.UBTC.MGI6, UnknownObj)
    External (_SB_.UBTC.MGI7, UnknownObj)
    External (_SB_.UBTC.MGI8, UnknownObj)
    External (_SB_.UBTC.MGI9, UnknownObj)
    External (_SB_.UBTC.MGIA, UnknownObj)
    External (_SB_.UBTC.MGIB, UnknownObj)
    External (_SB_.UBTC.MGIC, UnknownObj)
    External (_SB_.UBTC.MGID, UnknownObj)
    External (_SB_.UBTC.MGIE, UnknownObj)
    External (_SB_.UBTC.MGIF, UnknownObj)
    External (BSLF, UnknownObj)
    External (CCI0, IntObj)
    External (CCI1, IntObj)
    External (CCI2, IntObj)
    External (CCI3, IntObj)
    External (GPDI, FieldUnitObj)
    External (MGI0, IntObj)
    External (MGI1, IntObj)
    External (MGI2, IntObj)
    External (MGI3, IntObj)
    External (MGI4, IntObj)
    External (MGI5, IntObj)
    External (MGI6, IntObj)
    External (MGI7, IntObj)
    External (MGI8, IntObj)
    External (MGI9, IntObj)
    External (MGIA, IntObj)
    External (MGIB, IntObj)
    External (MGIC, IntObj)
    External (MGID, IntObj)
    External (MGIE, IntObj)
    External (MGIF, IntObj)
    External (OG00, FieldUnitObj)
    External (PNOT, MethodObj)    // 0 Arguments
    External (SEN1, DeviceObj)
    External (UBTC, DeviceObj)

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
                    Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                    \_PR.CPPC = Zero
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
                            Notify (^^IGPU.DD1F, 0x86) // Device-Specific
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
                    Notify (PS2K, 0x0405)
                    OG00 = Zero
                }
                Case (0x04)
                {
                    Notify (PS2K, 0x0406)
                    OG00 = Zero
                }
                Case (0x05)
                {
                    ^HIDD.HPEM (0x08)
                }
                Case (0x06)
                {
                    If ((MDCS == One))
                    {
                        STXD (GPDI, One)
                    }
                    Else
                    {
                        STXD (GPDI, Zero)
                    }

                    If (BSLF)
                    {
                        If ((^VGBI.VBTN == One))
                        {
                            If ((MDCS == One))
                            {
                                Notify (VGBI, 0xCD) // Hardware-Specific
                            }

                            If ((MDCS == 0x03))
                            {
                                Notify (VGBI, 0xCC) // Hardware-Specific
                            }
                        }
                    }

                    BSLF = One
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
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (One)
                            {
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x02)
                            {
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x03)
                            {
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x04)
                            {
                                Notify (^^RP01.PXSX, 0xD2) // Hardware-Specific
                                \_PR.CPPC = 0x02
                                PNOT ()
                            }
                            Case (0x05)
                            {
                                Notify (^^RP01.PXSX, 0xD3) // Hardware-Specific
                                \_PR.CPPC = 0x06
                                PNOT ()
                            }
                            Case (0x06)
                            {
                                Notify (^^RP01.PXSX, 0xD4) // Hardware-Specific
                                \_PR.CPPC = 0x08
                                PNOT ()
                            }
                            Case (0x07)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
                                PNOT ()
                            }
                            Case (0x08)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
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
                                        Notify (^^IGPU.DD1F, 0x86) // Device-Specific
                                        Sleep (0x32)
                                    }

                                    OG00 = Zero
                                }
                            }
                            Case (0x09)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
                                PNOT ()
                                OG00 &= 0xFF
                                Notify (^^IGPU.DD1F, 0x88) // Device-Specific
                            }
                            Default
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
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
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (One)
                            {
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x02)
                            {
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x03)
                            {
                                Notify (^^RP01.PXSX, 0xD1) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x04)
                            {
                                Notify (^^RP01.PXSX, 0xD2) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x05)
                            {
                                Notify (^^RP01.PXSX, 0xD3) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x06)
                            {
                                Notify (^^RP01.PXSX, 0xD4) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x07)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = Zero
                                PNOT ()
                            }
                            Case (0x08)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x02
                                PNOT ()
                            }
                            Case (0x09)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x06
                                PNOT ()
                            }
                            Case (0x0A)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x08
                                PNOT ()
                            }
                            Case (0x0B)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
                                PNOT ()
                            }
                            Case (0x0C)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
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
                                        Notify (^^IGPU.DD1F, 0x86) // Device-Specific
                                        Sleep (0x32)
                                    }

                                    OG00 = Zero
                                }
                            }
                            Case (0x0D)
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
                                PNOT ()
                                OG00 &= 0xFF
                                Notify (^^IGPU.DD1F, 0x88) // Device-Specific
                            }
                            Default
                            {
                                Notify (^^RP01.PXSX, 0xD5) // Hardware-Specific
                                \_PR.CPPC = 0x0E
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
                    If ((^^WMIE.EVT8 != Zero))
                    {
                        Notify (WMIE, 0x88) // Device-Specific
                    }
                }
                Case (0x0B)
                {
                    If ((^^WMIE.EVT7 != Zero))
                    {
                        Notify (WMIE, 0x87) // Device-Specific
                    }
                }
                Case (0x0C)
                {
                    If ((^^WMIE.EVT5 != Zero))
                    {
                        Notify (WMIE, 0x85) // Device-Specific
                    }
                }
                Case (0x0D)
                {
                    If ((^^WMIE.EVT6 != Zero))
                    {
                        Notify (WMIE, 0x86) // Device-Specific
                    }
                }
                Case (0x0E)
                {
                    If ((^^WMIE.EVT9 != Zero))
                    {
                        Notify (WMIE, 0x89) // Device-Specific
                    }
                }
                Case (0x0F)
                {
                    If ((^^WMIE.EVTA != Zero))
                    {
                        Notify (WMIE, 0x8A) // Device-Specific
                    }
                }
                Case (0x10)
                {
                    If ((^^WMIE.EVTB != Zero))
                    {
                        Notify (WMIE, 0x8B) // Device-Specific
                    }
                }
                Case (0x11)
                {
                }
                Case (0x12)
                {
                    ^^^UBTC.MGI0 = MGI0 /* External reference */
                    ^^^UBTC.MGI1 = MGI1 /* External reference */
                    ^^^UBTC.MGI2 = MGI2 /* External reference */
                    ^^^UBTC.MGI3 = MGI3 /* External reference */
                    ^^^UBTC.MGI4 = MGI4 /* External reference */
                    ^^^UBTC.MGI5 = MGI5 /* External reference */
                    ^^^UBTC.MGI6 = MGI6 /* External reference */
                    ^^^UBTC.MGI7 = MGI7 /* External reference */
                    ^^^UBTC.MGI8 = MGI8 /* External reference */
                    ^^^UBTC.MGI9 = MGI9 /* External reference */
                    ^^^UBTC.MGIA = MGIA /* External reference */
                    ^^^UBTC.MGIB = MGIB /* External reference */
                    ^^^UBTC.MGIC = MGIC /* External reference */
                    ^^^UBTC.MGID = MGID /* External reference */
                    ^^^UBTC.MGIE = MGIE /* External reference */
                    ^^^UBTC.MGIF = MGIF /* External reference */
                    ^^^UBTC.CCI0 = CCI0 /* External reference */
                    ^^^UBTC.CCI1 = CCI1 /* External reference */
                    ^^^UBTC.CCI2 = CCI2 /* External reference */
                    ^^^UBTC.CCI3 = CCI3 /* External reference */
                    Notify (UBTC, 0x80) // Status Change
                }
                Case (0x13)
                {
                    If ((^^WMIE.EVTC != Zero))
                    {
                        Notify (WMIE, 0x8C) // Device-Specific
                    }
                }
                Case (0x14)
                {
                    OCPF = Zero
                    Notify (UBTC, One) // Device Check
                }
                Case (0x15)
                {
                    If ((^^WMIE.EVTD != Zero))
                    {
                        Notify (WMIE, 0x8D) // Device-Specific
                    }
                }
                Case (0x16)
                {
                    OSMI (0xF8)
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


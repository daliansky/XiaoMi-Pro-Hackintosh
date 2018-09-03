/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLAjMM9U.aml, Mon Sep  3 12:44:27 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000006F6 (1782)
 *     Revision         0x02
 *     Checksum         0xF9
 *     OEM ID           "hack"
 *     OEM Table ID     "SPI1"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "SPI1", 0x00000000)
{
    External (_SB_.GNUM, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.INUM, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.GETD, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.LCRS, MethodObj)    // 3 Arguments (from opcode)
    External (_SB_.PCI0.LHRV, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.LPD0, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.LPD3, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.SPI1, DeviceObj)    // (from opcode)
    External (_SB_.SHPO, MethodObj)    // 2 Arguments (from opcode)
    External (DTGP, MethodObj)    // 5 Arguments (from opcode)
    External (GFPI, FieldUnitObj)    // (from opcode)
    External (GFPS, FieldUnitObj)    // (from opcode)
    External (SB07, FieldUnitObj)    // (from opcode)
    External (SB17, FieldUnitObj)    // (from opcode)
    External (SDM7, FieldUnitObj)    // (from opcode)
    External (SDS7, FieldUnitObj)    // (from opcode)
    External (SIR7, FieldUnitObj)    // (from opcode)
    External (SMD7, FieldUnitObj)    // (from opcode)

    Device (_SB.PCI0.SPI1)
    {
        Name (_ADR, 0x001E0003)  // _ADR: Address
        Name (_UID, 0x02)  // _UID: Unique ID
        Name (CSST, 0x28)
        Name (CSHT, 0x0A)
        Method (_PSC, 0, NotSerialized)  // _PSC: Power State Current
        {
            Return (GETD (SB17))
        }

        Method (_PS0, 0, NotSerialized)  // _PS0: Power State 0
        {
            LPD0 (SB17)
        }

        Method (_PS3, 0, NotSerialized)  // _PS3: Power State 3
        {
            LPD3 (SB17)
        }

        Method (_HRV, 0, NotSerialized)  // _HRV: Hardware Revision
        {
            Return (LHRV (SB17))
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (LNot (Arg2))
            {
                Return (Buffer (One)
                {
                     0x03                                           
                })
            }

            Store (Package (0x0E)
                {
                    "gspi-channel-number", 
                    Buffer (0x08)
                    {
                         0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    "gspi-channels-count", 
                    Buffer (0x08)
                    {
                         0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    "gspi-sys-clock-period", 
                    Buffer (0x08)
                    {
                         0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    "gspi-pin-cs", 
                    Buffer (0x08)
                    {
                         0x57, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    "gspi-pin-clk", 
                    Buffer (0x08)
                    {
                         0x58, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    "gspi-pin-mosi", 
                    Buffer (0x08)
                    {
                         0x59, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }, 

                    "gspi-pin-miso", 
                    Buffer (0x08)
                    {
                         0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }
                }, Local0)
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }

        Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
        {
            Return (LCRS (SMD7, SB07, SIR7))
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }

        Device (SPIT)
        {
            Name (_HID, EisaId ("APP000D"))  // _HID: Hardware ID
            Name (_CID, "apple-spi-topcase")  // _CID: Compatible ID
            Name (_DDN, "apple-spi-topcase")  // _DDN: DOS Device Name
            Name (_GPE, 0x17)  // _GPE: General Purpose Events
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_ADR, Zero)  // _ADR: Address
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                SHPO (GFPI, One)
                SHPO (GFPS, One)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (BBUF, ResourceTemplate ()
                {
                    SpiSerialBusV2 (0x0000, PolarityLow, FourWireMode, 0x08,
                        ControllerInitiated, 0x00989680, ClockPolarityLow,
                        ClockPhaseFirst, "\\_SB.PCI0.SPI1",
                        0x00, ResourceConsumer, _Y00, Exclusive,
                        )
                    GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
                        "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0008
                        }
                })
                Name (IBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y01)
                    {
                        0x00000000,
                    }
                })
                Name (GBUF, ResourceTemplate ()
                {
                    GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                        "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, _Y02,
                        )
                        {   // Pin list
                            0x0000
                        }
                })
                Name (UBUF, ResourceTemplate ()
                {
                    GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionInputOnly,
                        "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0000
                        }
                })
                CreateDWordField (BBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y00._SPE, SPEX)  // _SPE: Speed
                CreateByteField (BBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y00._PHA, PHAX)  // _PHA: Clock Phase
                CreateWordField (BBUF, 0x3B, SPIN)
                CreateWordField (GBUF, 0x17, GPIN)
                CreateDWordField (IBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y01._INT, IPIN)  // _INT: Interrupts
                CreateBitField (IBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y01._LL, ILVL)  // _LL_: Low Level
                CreateBitField (IBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y01._HE, ITRG)  // _HE_: High-Edge
                CreateField (GBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y02._POL, 0x02, GLVL)  // _POL: Polarity
                CreateBitField (GBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y02._MOD, GTRG)  // _MOD: Mode
                CreateBitField (BBUF, \_SB.PCI0.SPI1.SPIT._CRS._Y00._DPL, SCSP)  // _DPL: Device Selection Polarity
                CreateWordField (UBUF, 0x17, UPIN)
                Store (GNUM (GFPS), SPIN)
                Store (GNUM (GFPI), GPIN)
                Store (INUM (GFPI), IPIN)
                Store (GNUM (GFPI), UPIN)
                If (LOr (LEqual (SDS7, 0x02), LEqual (SDS7, 0x06)))
                {
                    Store (Zero, ILVL)
                    Store (One, ITRG)
                    Store (Zero, GLVL)
                    Store (One, GTRG)
                }

                If (LEqual (SDS7, 0x04))
                {
                    Store (Zero, ILVL)
                    Store (One, ITRG)
                }

                Switch (ToInteger (SDS7))
                {
                    Case (One)
                    {
                        Store (0x00989680, SPEX)
                        Store (Zero, PHAX)
                    }
                    Case (0x02)
                    {
                        Store (0x002DC6C0, SPEX)
                        Store (Zero, PHAX)
                    }
                    Case (0x03)
                    {
                        Store (0x007A1200, SPEX)
                        Store (One, PHAX)
                    }
                    Case (0x04)
                    {
                        Store (0x007A1200, SPEX)
                        Store (Zero, PHAX)
                    }
                    Case (0x05)
                    {
                        Store (0x00F42400, SPEX)
                        Store (Zero, PHAX)
                    }
                    Case (0x06)
                    {
                        Store (0x002DC6C0, SPEX)
                        Store (Zero, PHAX)
                    }
                    Default
                    {
                    }

                }

                If (LEqual (SDS7, One))
                {
                    Return (BBUF)
                }

                If (LAnd (LEqual (SDS7, 0x04), LEqual (SDM7, Zero)))
                {
                    Return (ConcatenateResTemplate (BBUF, ConcatenateResTemplate (UBUF, GBUF)))
                }

                If (LAnd (LEqual (SDS7, 0x04), LNotEqual (SDM7, Zero)))
                {
                    Return (ConcatenateResTemplate (BBUF, ConcatenateResTemplate (UBUF, IBUF)))
                }

                If (LEqual (SDM7, Zero))
                {
                    Return (ConcatenateResTemplate (BBUF, GBUF))
                }

                Return (ConcatenateResTemplate (BBUF, IBUF))
            }

            Scope (\_GPE)
            {
                Method (_L17, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
                {
                    Notify (\_SB.PCI0.SPI1.SPIT, 0x02)
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (LNot (Arg2))
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Store (Package (0x10)
                    {
                        "spiSclkPeriod", 
                        Buffer (0x08)
                        {
                             0x7D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "spiWordSize", 
                        Buffer (0x08)
                        {
                             0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "spiBitOrder", 
                        Buffer (0x08)
                        {
                             0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "spiSPO", 
                        Buffer (0x08)
                        {
                             0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "spiSPH", 
                        Buffer (0x08)
                        {
                             0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "spiCSDelay", 
                        Buffer (0x08)
                        {
                             0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "resetA2RUsec", 
                        Buffer (0x08)
                        {
                             0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }, 

                        "resetRecUsec", 
                        Buffer (0x08)
                        {
                             0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                        }
                    }, Local0)
                DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                Return (Local0)
            }
        }
    }
}


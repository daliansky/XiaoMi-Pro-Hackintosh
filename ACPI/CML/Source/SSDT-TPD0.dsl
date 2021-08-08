// Necessary hotpatch, work with VoodooI2C.kext and VoodooI2CHID.kext
// Maintained by: htmambo and stevezhengshiqi
// Enable trackpad GPIO interrupt mode, work with VoodooI2C.kext and VoodooI2CHID.kext

DefinitionBlock ("", "SSDT", 2, "hack", "_TPD0", 0x00000000)
{
    External (_SB_.GNUM, MethodObj)
    External (_SB_.INUM, MethodObj)
    External (_SB_.PCI0.HIDD, MethodObj)
    External (_SB_.PCI0.HIDG, BuffObj)
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C0.I2CX, IntObj)
    External (_SB_.PCI0.I2CM, MethodObj)
    External (_SB_.PCI0.TP7D, MethodObj)
    External (_SB_.PCI0.TP7G, BuffObj)
    External (_SB_.SHPO, MethodObj)
    External (_SB_.SRXO, MethodObj)
    External (GPDI, FieldUnitObj)
    External (OSYS, IntObj)
    External (SDS0, FieldUnitObj)
    External (TPDM, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            SDS0 = Zero
        }
    }

    Scope (_SB.PCI0.I2C0)
    {
        Device (XTPD)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C0",
                    0x00, ResourceConsumer, _Y00, Exclusive,
                    )
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y01)
                {
                    0x00000000,
                }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C0.XTPD._Y00._ADR, BADR)  // _ADR: Address
            CreateDWordField (SBFB, \_SB.PCI0.I2C0.XTPD._Y00._SPE, SPED)  // _SPE: Speed
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C0.XTPD._Y01._INT, INT2)  // _INT: Interrupts
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                INT1 = GNUM (GPDI)
                INT2 = INUM (GPDI)
                If ((TPDM == Zero))
                {
                    SHPO (GPDI, One)
                }

                _HID = "ELAN2303"
                HID2 = One
                Return (Zero)
            }

            Name (_HID, "XXXX0000")  // _HID: Hardware ID
            Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                If ((Arg0 == TP7G))
                {
                    Return (TP7D (Arg0, Arg1, Arg2, Arg3, SBFB, SBFG))
                }

                Return (Buffer (One)
                {
                     0x00
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }

                Return (Zero)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                If (_OSI ("Darwin"))
                {
                    Return (ConcatenateResTemplate (SBFB, SBFG))
                }
                
                If ((OSYS < 0x07DC))
                {
                    Return (SBFI) /* \_SB_.PCI0.I2C0.XTPD.SBFI */
                }

                If ((TPDM == Zero))
                {
                    Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFG))
                }

                Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFI))
            }
        }
    }
}
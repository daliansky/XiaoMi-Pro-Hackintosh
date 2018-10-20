/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLqMFq6C.aml, Sat Oct 20 12:02:33 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000090 (144)
 *     Revision         0x02
 *     Checksum         0xD0
 *     OEM ID           "hack"
 *     OEM Table ID     "_HPET"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_HPET", 0x00000000)
{
    External (HPTB, FieldUnitObj)
    External (HPTE, FieldUnitObj)

    Device (_SB.PCI0.LPCB.HPET)
    {
        Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0C01") /* System Board */)  // _CID: Compatible ID
        Name (_STA, Zero)  // _STA: Status
        Name (BUF0, ResourceTemplate ()
        {
            IRQNoFlags ()
                {0}
            IRQNoFlags ()
                {8}
            Memory32Fixed (ReadWrite,
                0xFED00000,         // Address Base
                0x00000400,         // Address Length
                )
        })
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            Return (BUF0) /* \_SB_.PCI0.LPCB.HPET.BUF0 */
        }
    }
}


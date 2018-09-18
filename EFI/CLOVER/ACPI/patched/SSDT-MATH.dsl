/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLEvzle9.aml, Tue Sep 18 11:14:09 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000059 (89)
 *     Revision         0x02
 *     Checksum         0x4A
 *     OEM ID           "hack"
 *     OEM Table ID     "MATH"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_MATH", 0x00000000)
{
    Device (_SB.PCI0.LPCB.MATH)
    {
        Name (_HID, EisaId ("PNP0C04") /* x87-compatible Floating Point Processing Unit */)  // _HID: Hardware ID
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            IO (Decode16,
                0x00F0,             // Range Minimum
                0x00F0,             // Range Maximum
                0x01,               // Alignment
                0x01,               // Length
                )
            IRQNoFlags ()
                {13}
        })
    }
}


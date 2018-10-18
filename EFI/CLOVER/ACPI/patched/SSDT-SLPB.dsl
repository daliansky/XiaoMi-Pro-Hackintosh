/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLBwJ7Th.aml, Thu Oct 18 16:48:22 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000041 (65)
 *     Revision         0x02
 *     Checksum         0x50
 *     OEM ID           "hack"
 *     OEM Table ID     "_SLPB"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_SLPB", 0x00000000)
{
    Device (_SB.SLPB)
    {
        Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
        Name (_STA, 0x0B)  // _STA: Status
    }
}


/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLnwF5j4.aml, Thu Nov 29 02:26:40 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000048 (72)
 *     Revision         0x02
 *     Checksum         0x8A
 *     OEM ID           "hack"
 *     OEM Table ID     "_EC"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_EC", 0x00000000)
{
    Device (_SB.PCI0.LPCB.EC)
    {
        Name (_HID, "EC000000")  // _HID: Hardware ID
    }
}


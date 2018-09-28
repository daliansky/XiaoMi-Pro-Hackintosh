/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLuJr9t0.aml, Tue Sep 18 11:13:32 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000003F (63)
 *     Revision         0x02
 *     Checksum         0x1A
 *     OEM ID           "hack"
 *     OEM Table ID     "EC"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_EC", 0x00000000)
{
    Device (_SB.EC)
    {
        Name (_HID, "EC000000")  // _HID: Hardware ID
    }
}


/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLe7xJcH.aml, Tue Sep 18 11:15:04 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000003F (63)
 *     Revision         0x02
 *     Checksum         0xFA
 *     OEM ID           "hack"
 *     OEM Table ID     "PMCR"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_PMCR", 0x00000000)
{
    Device (_SB.PCI0.PMCR)
    {
        Name (_ADR, 0x001F0002)  // _ADR: Address
    }
}


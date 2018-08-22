/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLHBUSWh.aml, Wed Aug 22 20:40:40 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000AA (170)
 *     Revision         0x02
 *     Checksum         0xBB
 *     OEM ID           "hack"
 *     OEM Table ID     "PWRB"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "PWRB", 0x00000000)
{
    External (_SB_.PCI0.LPCB.PWRB, DeviceObj)    // (from opcode)

    Method (_SB.PCI0.LPCB.PWRB._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LEqual (Arg2, Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x04)
        {
            "power-button-usage", 
            Buffer (0x08)
            {
                 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
            }, 

            "power-button-usagepage", 
            Buffer (0x08)
            {
                 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
            }
        })
    }
}


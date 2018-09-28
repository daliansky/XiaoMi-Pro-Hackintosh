/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLltz4bF.aml, Sun Sep 23 22:03:26 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000009F (159)
 *     Revision         0x02
 *     Checksum         0x11
 *     OEM ID           "hack"
 *     OEM Table ID     "_USBX"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_USBX", 0x00000000)
{
    External (DTGP, MethodObj)    // 5 Arguments

    Device (_SB.USBX)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (!Arg2)
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Local0 = Package (0x04)
                {
                    "kUSBSleepPortCurrentLimit", 
                    0x0BB8, 
                    "kUSBWakePortCurrentLimit", 
                    0x0BB8
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}


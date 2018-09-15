/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLQFZhTd.aml, Fri Sep 14 10:38:04 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000086 (134)
 *     Revision         0x02
 *     Checksum         0x35
 *     OEM ID           "hack"
 *     OEM Table ID     "_GPRW"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_GPRW", 0x00000000)
{
    External (RMCF.DWOU, IntObj)
    External (XPRW, MethodObj)    // 2 Arguments

    Method (GPRW, 2, NotSerialized)
    {
        While (One)
        {
            If (CondRefOf (\RMCF.DWOU))
            {
                If (!\RMCF.DWOU)
                {
                    Break
                }
            }

            If ((0x6D == Arg0))
            {
                Return (Package (0x02)
                {
                    0x6D, 
                    Zero
                })
            }

            If ((0x0D == Arg0))
            {
                Return (Package (0x02)
                {
                    0x0D, 
                    Zero
                })
            }

            Break
        }

        Return (XPRW (Arg0, Arg1))
    }
}


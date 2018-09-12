/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLMDrn0B.aml, Thu Sep 13 03:02:23 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000005B (91)
 *     Revision         0x02
 *     Checksum         0x26
 *     OEM ID           "hack"
 *     OEM Table ID     "DIDLE"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "DIDLE", 0x00000000)
{
    Scope (\_SB)
    {
        Method (LPS0, 0, NotSerialized)
        {
            Return (One)
        }
    }

    Scope (\_GPE)
    {
        Method (LXEN, 0, NotSerialized)
        {
            Return (One)
        }
    }

    Scope (\)
    {
        Name (SLTP, Zero)
        Method (_TTS, 1, NotSerialized)  // _TTS: Transition To State
        {
            SLTP = Arg0
        }
    }
}


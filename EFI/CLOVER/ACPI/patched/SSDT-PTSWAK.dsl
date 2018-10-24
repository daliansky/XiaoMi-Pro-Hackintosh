/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (64-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLfqBhiJ.aml, Thu Oct 25 04:13:50 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000272 (626)
 *     Revision         0x02
 *     Checksum         0xE7
 *     OEM ID           "hack"
 *     OEM Table ID     "_PTSWAK"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180810 (538445840)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_PTSWAK", 0x00000000)
{
    External (_SB_.PCI0.RP01.PXSX._OFF, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.RP01.PXSX._ON_, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.XHC_.PMEE, FieldUnitObj)
    External (_SI_._SST, MethodObj)    // 1 Arguments
    External (RMCF.DPTS, IntObj)
    External (RMCF.SHUT, IntObj)
    External (RMCF.SSTF, IntObj)
    External (RMCF.XPEE, IntObj)
    External (ZPTS, MethodObj)    // 1 Arguments
    External (ZWAK, MethodObj)    // 1 Arguments

    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        If ((0x05 == Arg0))
        {
            If (CondRefOf (\RMCF.SHUT))
            {
                If ((\RMCF.SHUT & One))
                {
                    Return (Zero)
                }

                If ((\RMCF.SHUT & 0x02))
                {
                    OperationRegion (PMRS, SystemIO, 0x1830, One)
                    Field (PMRS, ByteAcc, NoLock, Preserve)
                    {
                            ,   4, 
                        SLPE,   1
                    }

                    SLPE = Zero
                    Sleep (0x10)
                }
            }
        }

        If (CondRefOf (\RMCF.DPTS))
        {
            If (\RMCF.DPTS)
            {
                If (CondRefOf (\_SB.PCI0.RP01.PXSX._ON))
                {
                    \_SB.PCI0.RP01.PXSX._ON ()
                }
            }
        }

        ZPTS (Arg0)
        If ((0x05 == Arg0))
        {
            If (CondRefOf (\RMCF.XPEE))
            {
                If ((\RMCF.XPEE && CondRefOf (\_SB.PCI0.XHC.PMEE)))
                {
                    \_SB.PCI0.XHC.PMEE = Zero
                }
            }
        }
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        If (((Arg0 < One) || (Arg0 > 0x05)))
        {
            Arg0 = 0x03
        }

        Local0 = ZWAK (Arg0)
        If (CondRefOf (\RMCF.DPTS))
        {
            If (\RMCF.DPTS)
            {
                If (CondRefOf (\_SB.PCI0.RP01.PXSX._OFF))
                {
                    \_SB.PCI0.RP01.PXSX._OFF ()
                }
            }
        }

        If (CondRefOf (\RMCF.SSTF))
        {
            If (\RMCF.SSTF)
            {
                If (((0x03 == Arg0) && CondRefOf (\_SI._SST)))
                {
                    \_SI._SST (One)
                }
            }
        }

        Return (Local0)
    }
}


// Maintained by: Rehabman
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-GPRW.dsl by Rehabman
// For solving instant wake by hooking GPRW

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


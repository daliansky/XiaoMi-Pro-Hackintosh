// Necessary hotpatch, pair with `change Method(GPRW,2,N) to XPRW` rename patch
// Maintained by: Rehabman
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-GPRW.dsl by Rehabman
// For solving instant wake by hooking GPRW

DefinitionBlock ("", "SSDT", 2, "hack", "_GPRW", 0x00000000)
{
    External (XPRW, MethodObj)    // 2 Arguments

    Method (GPRW, 2, NotSerialized)
    {
        If ((0x6D == Arg0))
        {
            Return (Package (0x02)
            {
                0x6D, 
                Zero
            })
        }

        Return (XPRW (Arg0, Arg1))
    }
}


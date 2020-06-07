// Necessary hotpatch
// Maintained by: Rehabman
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-XCPM.dsl by Rehabman
// Inject plugin-type=1 on _PR.PR00

DefinitionBlock ("", "SSDT", 2, "hack", "_XCPM", 0x00000000)
{
    External (_PR_.PR00, DeviceObj)

    Scope (\_PR.PR00)
    {
        If (_OSI ("Darwin"))
        {
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (!Arg2)
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x02)
                {
                    "plugin-type", 
                    One
                })
            }
        }
    }
}


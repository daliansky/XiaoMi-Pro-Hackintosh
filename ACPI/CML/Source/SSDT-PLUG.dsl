// Necessary hotpatch
// Maintained by: Acidanthera and Rehabman
// Reference: https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-PLUG.dsl
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-XCPM.dsl by Rehabman
// Simplified version to inject plugin-type=1 on \_SB.PR00

/*
 * XCPM power management compatibility table with Darwin method.
 *
 * Please note that this table is only a sample and may need to be
 * adapted to fit your board's ACPI stack. For instance, both scope
 * and device name may vary (e.g. _SB_.PR00 instead of _PR_.CPU0).
 *
 * While the table contains several examples of CPU paths, you should
 * remove all the ones irrelevant for your board.
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "CpuPlug", 0x00003000)
{
    External (_SB_.PR00, ProcessorObj)

    Method (PMPM, 4, NotSerialized) {
       If (LEqual (Arg2, Zero)) {
           Return (Buffer (One) { 0x03 })
       }

       Return (Package (0x02)
       {
           "plugin-type", 
           One
       })
    }

    Scope (\_SB.PR00) {
        If (_OSI ("Darwin")) {
            Method (_DSM, 4, NotSerialized)  
            {
                Return (PMPM (Arg0, Arg1, Arg2, Arg3))
            }
        }
    }
}
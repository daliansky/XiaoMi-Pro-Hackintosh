// Maintained by: Rehabman
// Edited by: stevezhengshiqi and daliansky
// Reference: https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl by Rehabman
// Configuration data for other SSDTs(SSDT-GPRW and SSDT-PTSWAK)

DefinitionBlock ("", "SSDT", 2, "hack", "_RMCF", 0x00000000)
{
    Device (RMCF)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Method (HELP, 0, NotSerialized)
        {
            Debug = "TYPE indicates type of the computer. 0: desktop, 1: laptop"
            Debug = "HIGH selects display type. 1: high resolution, 2: low resolution"
            Debug = "IGPI overrides ig-platform-id or snb-platform-id"
            Debug = "DPTS for laptops only. 1: enables/disables DGPU in _WAK/_PTS"
            Debug = "SHUT enables shutdown fix. bit 0: disables _PTS code when Arg0==5, bit 1: SLPE=0 when Arg0==5"
            Debug = "XPEE enables XHC.PMEE fix. 1: set XHC.PMEE to zero in _PTS when Arg0==5"
            Debug = "SSTF enables _SST LED fix. 1: enables _SI._SST in _WAK when Arg0 == 3"
            Debug = "AUDL indicates audio layout-id for patched AppleHDA. Ones: no injection"
            Debug = "BKLT indicates the type of backlight control. 0: IntelBacklight, 1: AppleBacklight"
            Debug = "LMAX indicates max for IGPU PWM backlight. Ones: Use default, other values must match framebuffer"
        }

        Name (TYPE, One)
        Name (HIGH, One)
        Name (IGPI, Ones)
        Name (DPTS, Zero)
        Name (SHUT, One)
        Name (XPEE, One)
        Name (SSTF, Zero)
        Name (AUDL, Ones)
        Name (DAUD, One)
        Name (BKLT, One)
        Name (LMAX, Ones)
        Name (LEVW, Ones)
        Name (GRAN, Zero)
        Name (FBTP, Zero)
        Name (DWOU, One)
    }
}


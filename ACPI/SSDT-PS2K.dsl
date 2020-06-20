// NOT Necessary hotpatch, pair with SSDT-LGPA and VoodooPS2Keyboard.kext
// Maintained by: stevezhengshiqi
// Reference: https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/SSDT-Swap-LeftControlCapsLock.dsl by Rehabman
// Customize VoodooPS2Keyboard.kext, pair with SSDT-LGPA

DefinitionBlock ("", "SSDT", 2, "hack", "_PS2K", 0x00000000)
{
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)

    Scope (_SB.PCI0.LPCB.PS2K)
    {
        If (_OSI ("Darwin"))
        {
            Name (RMCF, Package (0x02)
            {
                "Keyboard", 
                Package (0x04)
                {
                    "Custom PS2 Map", 
                    Package (0x05)
                    {
                        Package (0x00){}, 
                        "e025=2a", // e025=Shift
                        "e026=4", // e026=3
                        "e028=67", // e028=F16
                        "e037=64" // PrtScn=F13
                    },

                    "Swap command and option", 
                    ">n"
                }
            })
        }
    }
}


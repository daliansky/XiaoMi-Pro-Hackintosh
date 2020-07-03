// NOT Necessary hotpatch, pair with SSDT-LGPA and VoodooPS2Controller.kext
// Maintained by: stevezhengshiqi
// Reference: https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/SSDT-Swap-LeftControlCapsLock.dsl by Rehabman
// Customize VoodooPS2Controller.kext, pair with SSDT-LGPA

DefinitionBlock ("", "SSDT", 2, "hack", "_PS2K", 0x00000000)
{
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)

    Scope (_SB.PCI0.LPCB.PS2K)
    {
        If (_OSI ("Darwin"))
        {
            Name (RMCF, Package (0x0A)
            {
                "Keyboard", 
                Package (0x06)
                {
                    "Custom ADB Map", 
                    Package (0x07)
                    {
                        Package (0x00){},
                        "e023=38", // e023=Shift
                        "e025=37", // e025=Command
                        "e026=15", // e026=4
                        "e029=7a", // e029=F1
                        "e02b=3b", // e02b=Control
                        "e02c=7e" // e02c=Up Arrow
                    },
                    
                    "Custom PS2 Map", 
                    Package (0x03)
                    {
                        Package (0x00){}, 
                        "e028=64", // e028=F13
                        "e037=57" // PrtScn=F11
                    },

                    "Swap command and option", 
                    ">n"
                },

                "Mouse", 
                Package (0x02)
                {
                    "DisableDevice", 
                    ">y"
                }, 

                "ALPS GlidePoint", 
                Package (0x02)
                {
                    "DisableDevice", 
                    ">y"
                }, 

                "Sentelic FSP", 
                Package (0x02)
                {
                    "DisableDevice", 
                    ">y"
                }, 

                "Synaptics TouchPad", 
                Package (0x02)
                {
                    "DisableDevice", 
                    ">y"
                }
            })
        }
    }
}


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
                Package (0x04)
                {
                    "Custom ADB Map", 
                    Package (0x09)
                    {
                        Package (Zero){},
                        "e023=38", // e023=Shift
                        "e025=37", // e025=Command
                        "e026=17", // e026=5
                        "e029=69", // e029=F13
                        "e02b=7a", // e02b=F1
                        "e02c=3b", // e02c=Control
                        "e02d=7e", // e02d=Up Arrow
                        "e052=6f" // Insert=F12
                    },
                    
                    "Custom PS2 Map", 
                    Package (0x02)
                    {
                        Package (Zero){}, 
                        "e037=57" // PrtScn=F11
                    }
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
// This SSDT demonstrates a custom configuration with certain features
// disabled when using AppleALC.kext.
// AppleALC.kext has some extra patches for AppleHDA that interfere with these
// features breaking audio after wake from sleep.
//
// Customize to suit your needs.

DefinitionBlock ("", "SSDT", 1, "hack", "CC-ALC", 0)
{
    External(_SB.PCI0.HDEF, DeviceObj)
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Perform Reset", ">n",
            "Perform Reset on External Wake", ">n",
        },
    })
}
//EOF

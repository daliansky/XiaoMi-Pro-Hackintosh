$location = Get-Location
$bytes = [System.IO.File]::ReadAllBytes("$location\cpusetup_my.txt")
$text = [System.Text.Encoding]::Default.GetString($bytes)
$GUID_text = "B08F97FF-E6E8-4193-A997-5E9E9B0ADB32"
If($text.IndexOf($GUID_text) -eq -1){
Write-Warning "GUID of your BIOS not found! Now exit"
exit
}
$offset_bytes = 0x0A,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x3A
$offset_text = [System.Text.Encoding]::Default.GetString($offset_bytes)
If($text.IndexOf($offset_text) -eq -1){
Write-Warning "Your BIOS is not supported!!! Now exit"
exit
}
$offset = $text.IndexOf($offset_text) + 0x39
$bytes[$offset] = 0x31
[System.IO.File]::WriteAllBytes("$location\cpusetup_patched.txt", $bytes)
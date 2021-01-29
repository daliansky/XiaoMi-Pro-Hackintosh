$location = Get-Location
$bytes = [System.IO.File]::ReadAllBytes("$location\sasetup_my.txt")
$text = [System.Text.Encoding]::Default.GetString($bytes)
$GUID_text = "72C5E28C-7783-43A1-8767-FAD73FCCAFA4"
If($text.IndexOf($GUID_text) -eq -1){
Write-Warning "GUID of your BIOS not found! Now exit"
exit
}
$offset_bytes = 0x0A,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x30,0x30,0x30,0x30,0x30,0x44,0x30,0x3A
$offset_text = [System.Text.Encoding]::Default.GetString($offset_bytes)
If($text.IndexOf($offset_text) -eq -1){
Write-Warning "Your BIOS is not supported!!! Now exit"
exit
}
$offset = $text.IndexOf($offset_text) + 0x45
#$bytes[$offset] = 0x30 # 0mb
#$bytes[$offset] = 0x31 # 32mb
$bytes[$offset] = 0x32 # 64mb
#$bytes[$offset] = 0x33 # 96mb (???)
[System.IO.File]::WriteAllBytes("$location\sasetup_patched.txt", $bytes)
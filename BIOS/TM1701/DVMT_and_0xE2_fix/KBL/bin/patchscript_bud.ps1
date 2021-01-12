$location = Get-Location
$bytes = [System.IO.File]::ReadAllBytes("$location\pchsetup_my.txt")
$text = [System.Text.Encoding]::Default.GetString($bytes)
$GUID_text = "4570B7F1-ADE8-4943-8DC3-406472842384"
If($text.IndexOf($GUID_text) -eq -1){
Write-Warning "GUID of your BIOS not found! Now exit"
exit
}
$offset_bytes = 0x0A,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x30,0x30,0x30,0x30,0x30,0x31,0x30,0x3A
$offset_text = [System.Text.Encoding]::Default.GetString($offset_bytes)
If($text.IndexOf($offset_text) -eq -1){
Write-Warning "Your BIOS is not supported!!! Now exit"
exit
}
$offset = $text.IndexOf($offset_text) + 0x2D
$bytes[$offset] = 0x31
[System.IO.File]::WriteAllBytes("$location\pchsetup_patched.txt", $bytes)
By Steve

Because Xiaomi-Pro ${MODEL} has a slightly different DSDT from Xiaomi-Pro's, SSDT-LGPA needs to be modified to fit with Xiaomi-Pro ${MODEL}.

1. If you are using Windows or other OS, please ignore all the files start with ._

IF YOU ARE A CLOVER USER:
  2a. Open the EFI release pack, go to EFI/CLOVER/ACPI/patched/, and delete SSDT-LGPA.aml

  3a. Copy SSDT-LGPA${MODEL_PREFIX}.aml and paste it to the folder in the second step

IF YOU ARE A OC USER:
  2b. Open the EFI release pack, go to EFI/OC/ACPI/ and delete SSDT-LGPA.aml

  3b. Copy SSDT-LGPA${MODEL_PREFIX}.aml and paste it to the folder in the second step

  4. Open EFI/OC/config.plist of the release pack and find the following code:
  <dict>
  	<key>Comment</key>
	<string>Brightness key, pair with LGPA rename</string>
	<key>Enabled</key>
	<true/>
	<key>Path</key>
	<string>SSDT-LGPA.aml</string>
  </dict>
  <dict>
	<key>Comment</key>
	<string>Brightness key for ${MODEL}, pair with LGPA rename</string>
	<key>Enabled</key>
	<false/>
	<key>Path</key>
	<string>SSDT-LGPA${MODEL_PREFIX}.aml</string>
  </dict>

  Change to:

  <dict>
	<key>Comment</key>
	<string>Brightness key, pair with LGPA rename</string>
	<key>Enabled</key>
	<false/>
	<key>Path</key>
	<string>SSDT-LGPA.aml</string>
  </dict>
  <dict>
	<key>Comment</key>
	<string>Brightness key for ${MODEL}, pair with LGPA rename</string>
	<key>Enabled</key>
	<true/>
	<key>Path</key>
	<string>SSDT-LGPA${MODEL_PREFIX}.aml</string>
  </dict>


Done and enjoy your EFI folder for ${MODEL}!
By Steve

因为小米笔记本Pro ${MODEL}版的 DSDT 和小米笔记本Pro的不同, SSDT-LGPA 需要重新定制来适配小米笔记本Pro ${MODEL}版。

1. 如果您在用 Windows 或者其他系统, 请忽略所有 ._ 开头的文件。

如果你是 CLOVER 用户:
  2a. 打开 EFI 包, 前往 EFI/CLOVER/ACPI/patched/ 并删除 SSDT-LGPA.aml

  3a. 拷贝 SSDT-LGPA${MODEL_PREFIX}.aml 并粘贴到上一步的文件夹。

如果你是 OC 用户:
  2b. 打开 EFI 包, 前往 EFI/OC/ACPI/ 并删除 SSDT-LGPA.aml

  3b. 拷贝 SSDT-LGPA{MODEL_PREFIX}.aml 并粘贴到上一步的文件夹。

  4. 打开 EFI 包里的 EFI/OC/config.plist 并找到以下代码:
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
	<string>SSDT-LGPA{MODEL_PREFIX}.aml</string>
  </dict>

  替换为:

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


完成, 请使用您的 ${MODEL}版 EFI 包吧!
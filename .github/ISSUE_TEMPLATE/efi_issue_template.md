---
name: EFI_ISSUE_TEMPLATE
about: Create a detailed report to help us locate and solve the EFI problem
title: ''
labels: ''
assignees: ''

---

**Pre-requirement**
**前提条件**
Try to rebuild the kextcache and restart whenever you encounter a problem. It always works like a charm!
请在遇到任何问题时，先重建缓存并重启。它通常能修复99%的问题！
To rebuild the kextcache, run `sudo kextcache -i /` in `Terminal.app`.
在`终端.app`运行命令`sudo kextcache -i /`来重建缓存。

**State the model**
**阐述您的机型**
e.g. XiaoMi-Pro MX150, XiaoMi-Pro GTX,...

**State the version of the EFI
**阐述您的EFI版本**
e.g v1.3.4, v1.3.5,...

**Describe the bug**
**描述您遇到的问题**
A clear and concise description of what the bug is.
清晰并详细地描述问题所在。

**System log**
**系统报告**
If a windows "Your computer was restarted because of a problem" appears, click `Report` and attach the log to help find the problem.
如果出现窗口"您的电脑因为出现问题而重新启动"，点击`报告`并附上错误日志来帮助定位问题。

**Screenshots**
**截图**
If applicable, add screenshots to help explain your problem.
如果可用，请添加截图来帮助说明您遇到的问题。

**Attach your entire EFI folder**
**附上您的整个EFI文件夹**
Please attach your entire EFI folder to help solve your problem.
Erasing serial numbers in config.plist is required!
请附上整个EFI文件夹来方便解决问题。
附件里的config.plist请清除序列号！

**Attach system.log**
**附上system.log**
If applicable, please run `log show --predicate "processID == 0" --start YYYY-MM-DD --debug` in `Terminal.app` to help locate the problem.
如果可用，请在`终端.app`运行命令`log show --predicate "processID == 0" --start YYYY-MM-DD --debug`来帮助定位问题。

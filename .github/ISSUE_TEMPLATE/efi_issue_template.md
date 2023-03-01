---
name: EFI_ISSUE_TEMPLATE
about: Create a detailed report to help us locate and solve the EFI problem
title: ''
labels: ''
assignees: ''

---

**Pre-requirement**
- For macOS version < Big Sur, try to rebuild the kextcache (e.g. run `sudo kextcache -i /` in `Terminal.app`) and restart whenever you encounter a problem. It always works like a charm!
- If you are using OpenCore, also try to reset NVRAM. Press `Space` key when you are in OpenCore boot page and choose `Reset NVRAM`.

**State the model**
- e.g. XiaoMi-Pro MX150, XiaoMi-Pro 8th GTX,...

**State the version of the EFI**
- e.g v1.3.4, v1.3.5,...

**Describe the bug**
- A clear and concise description of what the bug is.

**System log**
- If a windows "Your computer was restarted because of a problem" appears, click `Report` and attach the log to help find the problem.

**Screenshots**
- If applicable, add screenshots to help explain your problem.

**Attach your entire EFI folder**
- Please attach your entire EFI folder to help solve your problem.
- Erasing serial numbers in config.plist is required!

**Attach system.log**
- If applicable, please run `log show --predicate "processID == 0" --last boot --debug | grep "ERR"` in `Terminal.app` to help locate the problem.

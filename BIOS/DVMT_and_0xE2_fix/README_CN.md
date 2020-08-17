# 动态显存 和 0xE2 修复

[English](README.md) | **中文**

## 简介

**仅支持 MX150！**

0. **非常重要! 只在 BIOS 0603 测试过该脚本。 @FallenChromium 和 Cyb 对任何损坏均不负责，虽然由他们制作脚本，但你需要个人承担风险。**
    - 经个人测试，0906 BIOS 依然有效

1. **重要 - 用 `backup.cmd` 制作备份，把生成的 `mybackup.bin` 保存在云端。这是个理论上可行但不稳定的恢复方案。**

2. 在进行任意操作之前，确保你的 Windows 设备允许运行 PowerShell 脚本。更多信息在[这里](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6)。我把所有的 policy (CurrentUser 和其他) 设成了 Unrestricted。做了这个操作后我的脚本才运行正常。

3. 在对 BIOS 做进一步修改之前运行 `bios_unlock.cmd`。

4. 运行 `DVMT_set.cmd` 让动态显存=64mb。你需要重启否则脚本将不会生效。你不能一股脑运行完所有脚本再重启，因为只有关机前最后一个脚本生效。

5. 运行 `CFG_unlock.cmd`，再次重启。

6. 运行 `bios_lock.cmd` 来给 BIOS 重新上锁，让电脑更安全。

7. 删除动态显存补丁并修改 `framebuffer-flags`。

- **如果你是 Clover 或 OC 用户：**
  - 打开 `/EFI/CLOVER (或者 OC)/config.plist`，删除以下代码：
```xml
<key>framebuffer-fbmem</key>
<data>AACQAA==</data>
<key>framebuffer-stolenmem</key>
<data>AAAwAQ==</data>
```

8. 删除 OC MSR 0xE2 补丁。

打开 `/EFI/OC/config.plist`，并找到以下代码：
```diff
  <key>AppleXcpmCfgLock</key>
- <true/>
+ <false/>
```


## 鸣谢

- 感谢 [FallenChromium](https://github.com/FallenChromium) 和 [Cyb](http://4pda.ru/forum/index.php?showuser=914121) 制作脚本和说明。

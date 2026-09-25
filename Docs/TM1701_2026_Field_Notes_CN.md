# TM1701 Sonoma 14.8.9 / OpenCore 1.0.7 实机补充测试（2026）

> 这是一份**单机实测补充说明**，用于给 TM1701 现有文档提供可复现的边界条件和 A/B 结果。它不建议直接替换上游默认 EFI，也不包含任何机器唯一的 SMBIOS/序列号/UUID/ROM 信息。

## 测试平台

- Xiaomi Mi Notebook Pro TM1701
- Intel UHD 620
- Intel Wireless-AC 8265
- macOS Sonoma 14.8.9 (23J631)
- OpenCore 1.0.7 RELEASE
- 5 GHz / 80 MHz WLAN
- VoodooI2C 2.8
- WhateverGreen 1.7.0

测试重点是：Wi‑Fi 控制面、普通睡眠与 true S4、HDMI 4K、USB-C、HiDPI/显示和生产收口。

## 1. Intel Wi‑Fi：建议文档区分“可见 SSID”和“隐藏 SSID”

现有 README 用“Intel Wi‑Fi 性能不佳”概括多个不同问题。实测表明，更准确的分类应当是：

### 可见 SSID：优先 AirportItlwm

在普通广播 SSID 上，AirportItlwm 的优势主要是原生 macOS Wi‑Fi 控制面和更简单的日常使用方式。

同机同 AP A/B：

- AirportItlwm 2.4.0：
  - LAN HTTP 5 次平均约 216.8 Mbps
  - 网关 ping 平均约 1.39 ms / 最大约 2.58 ms
  - 局域网另一主机 ping 平均约 1.62 ms / 最大约 2.69 ms
- itlwm 2.3.0（HeliPort 不常驻）：
  - 多组 LAN HTTP 约 200–250 Mbps，最终 5 次平均约 232 Mbps
  - 网关 ping 常见约 1.5–2.0 ms
  - 吞吐属于同一实际使用档位

因此不应简单表述为“AirportItlwm 更快”或“itlwm 更快”。对于可见 SSID，**AirportItlwm 的主要优势是原生体验和更少的额外组件**。

### 隐藏 SSID：AirportItlwm 在本机 AC8265 + Sonoma 14.8.9 失败

对两个隐藏 SSID 做手动加入测试时，AirportItlwm 原生 Wi‑Fi UI 均立即返回“network not found”。

相同网卡/密码/AP 下：

- Windows Intel 原生驱动正常；
- itlwm + HeliPort 能加入隐藏网络；
- AP 侧能观察到完整 authentication / association / WPA 4-way handshake / DHCP。

因此隐藏 SSID 是一个真实的分流条件，而不是密码/射频问题。

### HeliPort 不建议为了 AutoJoin/菜单栏图标长期常驻

在 itlwm 路线上，HeliPort 常驻时可稳定复现周期性延迟尖峰：

- 常见跳到几十毫秒；
- 一次短测试最大约 206.6 ms。

退出 HeliPort 但保持 itlwm 关联后：

- 网关平均约 1.47 ms / 最大约 2.64 ms；
- 局域网主机平均约 1.73 ms / 最大约 3.05 ms；
- 5 次 LAN HTTP 约 232–249 Mbps。

重新打开 HeliPort 后，延迟尖峰重新出现。

**建议文档增加一句：** HeliPort 可用于选网/保存网络，但如果用户对延迟敏感，可在连接完成后退出，不必长期后台运行。

隐藏 SSID 的自动加入可以由一次性 helper 完成：从 HeliPort 已保存的 Keychain 条目取凭据，只在内存中使用，然后调用 itlwm associate 接口，成功后立即退出。这个 workaround 不建议作为默认上游组件，但值得在 FAQ 中记录。

## 2. true S4 / hibernatemode=25：建议措辞更保守

本机对 true S4 做了大量重复测试。中间阶段曾多次成功，但最终仍可复现 fatal wake failure：

```text
Wake transition timed out after 180 seconds
failure code 0x27
IONVMeController
  -> IODMACommand::prepare
  -> IOGeneralMemoryDescriptor::dmaMap(IOMapper)
  -> IOPCIFamily
```

另有场景表现为：

- 物理内屏蓝/青/花屏；
- WindowServer screenshot 内容本身正常；
- 说明问题可能位于 eDP/scanout/firmware restore，而不是简单的 GUI render failure。

在普通日常睡眠方面，`hibernatemode=3` + Deep Idle 多次稳定通过。

因此建议上游对 KBL/TM1701 的 hibernation 支持说明采用类似措辞：

> ForceBooterSignature/HibernationFixup 等设置可能改善部分 hibernation 场景，但 true S4 在不同 BIOS、NVMe、IOMMU/DMAR 和显示恢复组合下仍可能不稳定；应与普通 sleep 分开验证。

不建议仅因为几次成功就把 true S4 视为无条件 production-safe。

## 3. HDMI 4K：建议明确 HDMI 1.4 物理上限

对一台 HDMI 2.0-class 4K 显示器测试时：

- macOS 能读取 EDID；
- 外屏挂在正确 HDMI framebuffer connector；
- 系统显示 Online；
- 3840×2160 @ 60 Hz 时外屏无图。

TM1701 的物理 HDMI 链路是 HDMI 1.4。WhateverGreen 的 max-pixel-clock override 可以影响模式校验，但不能把物理 HDMI 1.4 升级为 HDMI 2.0。

因此建议把“DVMT 64 MB 可开启 4K 外接显示屏”的说明补充为：

1. 先验证 3840×2160 @ 30 Hz；
2. 4K60 黑屏不能直接判为 framebuffer 映射错误；
3. max-pixel-clock override 不代表物理输出带宽已经支持 4K60。

## 4. USB-C：看到 480 Mb/s 不应立即归因于 USBMap

本机精确 USBMap 中两个 Type-C 口的 HS/SS pairing 都存在，SuperSpeed 端口对象也正常。

同一个 JMicron 设备/线材分别插两个物理 Type-C 口，都只协商到 480 Mb/s。

这类结果更适合先做：

- 已知 USB 3.x 设备；
- 已知全功能/高速 Type-C 线；
- 两面方向；
- 两个物理端口；

再决定是否改 USBMap。

建议 FAQ 明确“USB2 速度 ≠ 一定是 USBMap 缺 SS 端口”。

## 5. 亮度与“改善体验”项建议增加 A/B 提示

上游 README 建议启用 `enable-backlight-smoother`。

本机长期 A/B 后，最终反而选择更接近原生的背光路径，因为额外 backlight patch 在睡眠/显示收口过程中没有带来稳定净收益。

建议把这类项目从“通用推荐”改成“可选 A/B”：

> 如果当前亮度阶梯、睡眠恢复和黑屏行为已经正常，不必为了配置项看起来更完整而主动开启额外 backlight patch。

## 6. 与上游当前结论一致的项目

以下实测与现有仓库方向一致：

- 1424×802 HiDPI 是 TM1701 的实用档位；
- DVMT 64 MB 对高分辨率 HiDPI/核显配置有价值；
- VoodooI2C 2.9.1 在 TM1701 上不如 2.8 稳定；
- dGPU 应保持关闭；
- 不应为了单一理论收益盲目叠加 kext/quirk。

## 建议的文档改进清单

1. Intel Wi‑Fi 按“可见 SSID / 隐藏 SSID”拆分建议；
2. 增加 HeliPort 常驻扫描可能造成延迟抖动的提示；
3. hibernation 文档区分普通 sleep 与 true S4，并强调需要实机重复验证；
4. HDMI 4K 文档注明 HDMI 1.4 物理 4K30 上限和 4K60 模式选择风险；
5. USB-C FAQ 增加“先验证设备/线材，再改 USBMap”；
6. `enable-backlight-smoother` 等体验补丁改为可选 A/B，而不是默认必须项。

## 测试边界

这些结论来自一台真实 TM1701 的长期重复测试，因此适合作为**field note / troubleshooting evidence**，不应替代多机器统计。

特别是 BIOS/EC、NVMe 型号、显示器、Type-C 设备和无线 AP 都可能影响结果。建议上游把这份记录作为“已验证现象与排查顺序”，而不是新的强制默认配置。

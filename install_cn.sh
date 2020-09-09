#!/bin/bash
#set -x # for DEBUGGING

# stevezhengshiqi创建于2019年6月9日
# 鸣谢:
# https://github.com/black-dragon74/OSX-Debug/blob/master/gen_debug.sh by black-dragon74
# https://github.com/RehabMan/hack-tools/blob/master/mount_efi.sh by Rehabman
# https://github.com/syscl/Fix-usb-sleep/blob/master/fixUSB.sh by syscl
# https://github.com/xzhih/one-key-hidpi/blob/master/hidpi.sh by xzhih

# 仅支持小米笔记本Pro.

# 输出样式设置
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
OFF="\033[m"

pledit=/usr/libexec/PlistBuddy

RELEASE_Dir=""

# 退出如果网络异常
function networkWarn() {
  echo -e "[ ${RED}ERROR${OFF} ]: 从${repoURL}下载资源失败, 请检查您的网络连接!"
  clean
  exit 1
}

# 检查主板型号
function checkMainboard() {
  local MODEL_MX150="TM1701"
  local MODEL_GTX="TM1707"

  # 创建工程文件夹
  WORK_DIR="$HOME/Desktop/EFI_XIAOMI-PRO"
  [[ -d "${WORK_DIR}" ]] && rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}" || exit 1

  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/bdmesg"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x bdmesg

  MAINBOARD="$( "${WORK_DIR}/bdmesg" | grep Running | awk '{print $5}' | sed "s/\'//g" | tr -d "'" )"
  if [ "${MAINBOARD}" != "${MODEL_MX150}" ] && [ "${MAINBOARD}" != "${MODEL_GTX}" ]; then
    echo "您的主板型号是 ${MAINBOARD}"
    echo -e "[ ${RED}ERROR${OFF} ]:不是小米笔记本Pro, 请检查您的型号!"
    echo "此脚本仅限Clover用户!"
    # clean
    # exit 1
  fi
}

# 检查未签名的扩展，通过重建缓存的方式
function checkSystemIntegrity() {
  local KEXT_LIST
  local APPLE_KEXT
  local FakeSMC
  local VirtualSMC

  echo
  echo "正在重建缓存..."
  sudo kextcache -i / &> kextcache_log.txt
  echo -e "[ ${GREEN}OK${OFF} ]重建完成"

  # 检查kextcache_log.txt的总行数
  KEXT_LIST=$(cat "kextcache_log.txt" |wc -l)
  # 检查苹果原生驱动是否被修改
  APPLE_KEXT=$(grep 'com.apple' kextcache_log.txt)
  # 检查S/L/E和L/E的FakeSMC
  FakeSMC=$(grep 'FakeSMC' kextcache_log.txt)
  # 检查S/L/E和L/E的VirtualSMC
  VirtualSMC=$(grep 'VirtualSMC' kextcache_log.txt)

  if [[ -n ${APPLE_KEXT} ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]:苹果原生驱动被修改, 请确保S/L/E和L/E目录里的驱动未被修改!"
    # clean
    # exit 1
  elif [[ -n ${FakeSMC} ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]:在系统分区里检测到FakeSMC, CLOVER目录里的驱动将不工作!"
    clean
    exit 1
  elif [[ -n ${VirtualSMC} ]]; then
    echo -e "[ ${BLUE}WARNING${OFF} ]:在系统分区里检测到VirtualSMC, CLOVER目录里的驱动可能不工作!"
    echo "升级EFI前请把EFI备份到外置磁盘"
  elif [ "${KEXT_LIST}" -lt 1 ]; then
  # 如果总行数大于1, 说明原生驱动被修改, 或者未知的驱动装进了/L/E 或 /S/L/E
    echo -e "[ ${BLUE}WARNING${OFF} ]: 您的系统含有未签名的驱动扩展, 可能会导致严重的问题!"
    echo "升级EFI前请把EFI备份到外置磁盘"
  fi
}

# 挂载 EFI 通过 mount_efi.sh, credits Rehabman
function mountEFI() {
  local repoURL="https://raw.githubusercontent.com/RehabMan/hack-tools/master/mount_efi.sh"
  curl --silent -O "${repoURL}" || networkWarn
  echo
  echo "正在挂载EFI分区..."
  EFI_DIR="$(sh "mount_efi.sh")"

  # 检查EFI分区是否存在
  if [[ -z "${EFI_DIR}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: 未检测到EFI分区"
    unmountEFI
    returnMenu

  # 检查EFI/CLOVER是否存在
  elif [[ ! -e "${EFI_DIR}/EFI/CLOVER" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: 未检测到CLOVER文件夹"
    unmountEFI
    returnMenu
  fi

  echo -e "[ ${GREEN}OK${OFF} ]EFI分区已挂载到${EFI_DIR} (credits RehabMan)"
}

# 取消挂载EFI，因为安全因素
function unmountEFI() {
  echo
  echo "正在取消挂载EFI分区..."
  diskutil unmount "$EFI_DIR" &>/dev/null
  echo -e "[ ${GREEN}OK${OFF} ]取消挂载成功"
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/daliansky/XiaoMi-Pro-Hackintosh/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo
    echo -e "[ ${RED}ERROR${OFF} ]: 从${repoURL}获取最新release失败"
    returnMenu
  fi
}

# 下载 EFI 文件夹
function downloadEFI() {
  getGitHubLatestRelease

  echo
  echo '----------------------------------------------------------------------------------'
  echo '|* 正在下载EFI, 源于 https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases *|'
  echo '----------------------------------------------------------------------------------'

  # 下载 XiaoMi-Pro的 EFI
  local xmFileName="XiaoMi_Pro-${ver}.zip"
  local repoURL="https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/download/${ver}/${xmFileName}"
  # GitHub的CDN是被Amazon所拥有, 所以我们在这添加 -L 来支持重定向链接
  curl -# -L -O "${repoURL}" || networkWarn
  # 解压
  unzip -qu "${xmFileName}"

  RELEASE_Dir="XiaoMi_Pro-${ver}"

  # 移除不需要的文件
  rm -rf "${xmFileName}"
  echo -e "[ ${GREEN}OK${OFF} ]下载完成"
}

# 备份序列号, 主题, BOOT 和 CLOVER 文件夹
function backupEFI() {
  local DATE
  local DefaultVolume
  local Timeout
  local SerialNumber
  local BoardSerialNumber
  local SmUUID
  local ROM
  local MLB
  local CustomUUID
  local InjectSystemID
  local framebufferfbmem
  local framebufferstolenmem

  mountEFI

  # 创建备份文件夹
  echo
  echo "正在备份..."
  # 生成时间戳
  DATE="$(date "+%Y-%m-%d_%H-%M-%S")"
  BACKUP_DIR="$HOME/Desktop/backupEFI_${DATE}"
  [[ -d "${BACKUP_DIR}" ]] && rm -rf "${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"
  cp -rf "${EFI_DIR}/EFI/BOOT" "${BACKUP_DIR}" || cp -rf "${EFI_DIR}/EFI/Boot" "${BACKUP_DIR}" || cp -rf "${EFI_DIR}/EFI/boot" "${BACKUP_DIR}"
  cp -rf "${EFI_DIR}/EFI/CLOVER" "${BACKUP_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]备份完成"

  echo
  echo "正在恢复旧版配置到新CLOVER文件夹..."
  DefaultVolume="$($pledit -c 'Print Boot:DefaultVolume' "${BACKUP_DIR}/CLOVER/config.plist")"
  Timeout="$($pledit -c 'Print Boot:Timeout' "${BACKUP_DIR}/CLOVER/config.plist")"
  SerialNumber="$($pledit -c 'Print SMBIOS:SerialNumber' "${BACKUP_DIR}/CLOVER/config.plist")"
  BoardSerialNumber="$($pledit -c 'Print SMBIOS:BoardSerialNumber' "${BACKUP_DIR}/CLOVER/config.plist")"
  SmUUID="$($pledit -c 'Print SMBIOS:SmUUID' "${BACKUP_DIR}/CLOVER/config.plist")"
  ROM="$($pledit -c 'Print RtVariables:ROM' "${BACKUP_DIR}/CLOVER/config.plist")"
  MLB="$($pledit -c 'Print RtVariables:MLB' "${BACKUP_DIR}/CLOVER/config.plist")"
  CustomUUID="$($pledit -c 'Print SystemParameters:CustomUUID' "${BACKUP_DIR}/CLOVER/config.plist")"
  InjectSystemID="$($pledit -c 'Print SystemParameters:InjectSystemID' "${BACKUP_DIR}/CLOVER/config.plist")"
  framebufferfbmem="$($pledit -c 'Print Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-fbmem' "${BACKUP_DIR}/CLOVER/config.plist")"
  framebufferstolenmem="$($pledit -c 'Print Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-stolenmem' "${BACKUP_DIR}/CLOVER/config.plist")"

  # 检查默认启动宗卷和倒计时是否存在，如果存在则拷贝
  if [[ -n "${DefaultVolume}" ]]; then
    $pledit -c "Set Boot:DefaultVolume ${DefaultVolume}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${Timeout}" ]]; then
    $pledit -c "Set Boot:Timeout ${Timeout}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  # 检查序列号是否存在，如果存在则拷贝
  if [[ -n "${SerialNumber}" ]]; then
    $pledit -c "Add SMBIOS:SerialNumber string ${SerialNumber}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${BoardSerialNumber}" ]]; then
    $pledit -c "Add SMBIOS:BoardSerialNumber string ${BoardSerialNumber}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${SmUUID}" ]]; then
    $pledit -c "Add SMBIOS:SmUUID string ${SmUUID}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${ROM}" ]]; then
    $pledit -c "Set RtVariables:ROM ${ROM}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${MLB}" ]]; then
    $pledit -c "Add RtVariables:MLB string ${MLB}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${CustomUUID}" ]]; then
    $pledit -c "Add SystemParameters:CustomUUID string ${CustomUUID}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${InjectSystemID}" ]]; then
    $pledit -c "Set SystemParameters:InjectSystemID ${InjectSystemID}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  else
    $pledit -c "Set SystemParameters:InjectSystemID false" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -z "${framebufferfbmem}" ]]; then
    $pledit -c "delete Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-fbmem" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -z "${framebufferstolenmem}" ]]; then
    $pledit -c "delete Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-stolenmem" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  echo -e "[ ${GREEN}OK${OFF} ]拷贝完成"

  echo
  echo "正在拷贝主题到新CLOVER文件夹..."

  rm -rf "${BACKUP_DIR}/CLOVER/themes/Xiaomi"
  cp -rf "$RELEASE_Dir/EFI/CLOVER/themes/Xiaomi" "${BACKUP_DIR}/CLOVER/themes/"
  rm -rf "$RELEASE_Dir/EFI/CLOVER/themes"
  cp -rf "${BACKUP_DIR}/CLOVER/themes" "$RELEASE_Dir/EFI/CLOVER/"

  # 创建一个只含有GUI目录的config.plist
  # TODO: 用更有效的方式去保留原config.plist的GUI目录
  cp -rf "${BACKUP_DIR}/CLOVER/config.plist" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete ACPI" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete Boot" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete CPU" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete Devices" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete Graphics" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete KernelAndKextPatches" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete RtVariables" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete SMBIOS" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete SystemParameters" "${WORK_DIR}/GUI.plist"

  # 合并GUI.plist到config.plist来保存主题设置
  $pledit -c "Delete GUI" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  $pledit -c "Merge GUI.plist" "$RELEASE_Dir/EFI/CLOVER/config.plist"

  echo -e "[ ${GREEN}OK${OFF} ]拷贝完成"
}

# 检查${BACKUP_DIR}/CLOVER目录是否存在
function confirmBackup() {
  echo
  echo "正在检查备份..."
  if [[ ! -e "${BACKUP_DIR}/CLOVER" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: 备份CLOVER文件夹失败!"
    unmountEFI
    clean
    exit 1
  else
    echo -e "[ ${GREEN}OK${OFF} ]检查完成"
  fi
}

# 比较新旧CLOVER文件夹
function compareEFI() {
  echo
  echo "正在比较新旧EFI文件夹..."
  # 生成新CLOVER文件夹的树状图
  find "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> NewEFI_TREE.txt
  # 移除开头的一些字符串
  sed -i '' 's/^.................//' NewEFI_TREE.txt
  # 移除含有DS_Store的行
  sed -i '' '/DS_Store/d' NewEFI_TREE.txt

  # 生成旧CLOVER文件夹的树状图
  find "${BACKUP_DIR}/CLOVER" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> OldEFI_TREE.txt
  # 移除开头的一些字符串
  sed -i '' 's/^.............//' OldEFI_TREE.txt
  # 移除含有DS_Store的行
  sed -i '' '/DS_Store/d' OldEFI_TREE.txt

  diff NewEFI_TREE.txt OldEFI_TREE.txt

  echo -e "${BOLD}你想继续吗? (y/n)${OFF}"
  read -rp ":" cp_selection
  case ${cp_selection} in
    y)
    ;;

    n)
    unmountEFI
    returnMenu
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误"
    unmountEFI
    returnMenu
    ;;
  esac

}

# 根据配置修改EFI
function editEFI() {

  # 如果是GTX, SSDT-LGPA 需要替换成 SSDT-LGPAGTX
  if [ "${MAINBOARD}" == "TM1707" ]; then
    rm -f "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-LGPA.aml"
    cp -rf "${WORK_DIR}/$RELEASE_Dir/GTX/SSDT-LGPAGTX.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
  fi

  echo
  echo "--------------------------------------------"
  echo "|************** 选择蓝牙模式 **************|"
  echo "--------------------------------------------"
  echo "(1) 原厂英特尔蓝牙 (默认)"
  echo "(2) USB蓝牙 / 屏蔽自带蓝牙 / 飞线蓝牙到摄像头"
  echo "(3) 飞线蓝牙到WLAN_LTE接口"
  echo "(4) 飞线蓝牙到指纹接口"
  echo -e "${BOLD}您想选择哪个模式? (1/2/3/4)${OFF}"
  read -rp ":" bt_selection
  case ${bt_selection} in
    1)
    # 保持默认
    ;;

    2)
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1
    cp -rf "${WORK_DIR}/$RELEASE_Dir/Bluetooth/SSDT-USB-USBBT.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
    ;;

    3)
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1
    cp -rf "${WORK_DIR}/$RELEASE_Dir/Bluetooth/SSDT-USB-WLAN_LTEBT.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
    ;;

    4)
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1
    cp -rf "${WORK_DIR}/$RELEASE_Dir/Bluetooth/SSDT-USB-FingerBT.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误"
    unmountEFI
    returnMenu
    ;;
  esac

  echo -e "[ ${GREEN}OK${OFF} ]修改完成"
}

function restoreEFI() {
  echo -e "[ ${RED}ERROR${OFF} ]: 更新EFI失败"
  echo
  echo "正在从备份中恢复EFI..."
  cp -rf "${BACKUP_DIR}/BOOT" "${EFI_DIR}/EFI/" || cp -rf "${BACKUP_DIR}/Boot" "${EFI_DIR}/EFI/" || cp -rf "${BACKUP_DIR}/boot" "${EFI_DIR}/EFI/" || echo -e "[ ${RED}ERROR${OFF} ]: 恢复BOOT文件夹失败, 请在关机前手动更新EFI"
  cp -rf "${BACKUP_DIR}/CLOVER" "${EFI_DIR}/EFI/" || echo -e "[ ${RED}ERROR${OFF} ]: 恢复CLOVER文件夹失败, 请在关机前手动更新EFI"
  echo -e "[ ${GREEN}OK${OFF} ]恢复完成"
  clean
  exit 1
}

# 更新 BOOT 和 CLOVER 文件夹
function replaceEFI() {
  echo
  echo "正在更新EFI文件夹..."
  rm -rf "${EFI_DIR}/EFI/CLOVER" && rm -rf "${EFI_DIR}/EFI/BOOT"
  cp -rf "${WORK_DIR}/$RELEASE_Dir/EFI/BOOT" "${EFI_DIR}/EFI/" || restoreEFI
  cp -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER" "${EFI_DIR}/EFI/"  || restoreEFI
  echo -e "[ ${GREEN}OK${OFF} ]更新完成"
}

function updateEFI() {
  if [[ $1 == "--LOCAL_RELEASE" ]]; then
    checkSystemIntegrity
    mv "build/XiaoMi_Pro-local" "./"
    RELEASE_Dir="XiaoMi_Pro-local"
    backupEFI
    confirmBackup
    compareEFI
    editEFI
    replaceEFI
    unmountEFI
  else
    checkSystemIntegrity
    downloadEFI
    backupEFI
    confirmBackup
    compareEFI
    editEFI
    replaceEFI
    unmountEFI
  fi
}

# 删除之前的蓝牙配置文件(SSDT-USB, SSDT-USB-USBBT, SSDT-SolderBT(更改为SSDT-USB-WLAN_LTEBT), SSDT-USB-WLAN_LTEBT, 和 SSDT-USB-FingerBT)
function deleteBT() {
  mountEFI
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-USBBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-SolderBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-WLAN_LTEBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-FingerBT.aml" >/dev/null 2>&1
  
  rm -rf "${EFI_DIR}/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1

# 运行此方法后需要运行unmountEFI方法
}

function changeBT() {
  echo
  echo "--------------------------------------------"
  echo "|************** 选择蓝牙模式 **************|"
  echo "--------------------------------------------"
  echo "(1) 原生Intel蓝牙 (默认)"
  echo "(2) USB蓝牙 / 屏蔽自带蓝牙 / 飞线蓝牙到摄像头"
  echo "(3) 飞线蓝牙到WLAN_LTE接口"
  echo "(4) 飞线蓝牙到指纹接口"
  echo -e "${BOLD}您想选择哪个模式? (1/2/3/4)${OFF}"
  read -rp ":" bt_selection_new
  case ${bt_selection_new} in
    1)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ACPI/SSDT-USB.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
    ;;

    2)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ACPI/SSDT-USB-USBBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB-USBBT.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"

    echo
    echo "如果您使用的是博通USB蓝牙，您可能需要下载安装https://bitbucket.org/RehabMan/os-x-brcmpatchram/downloads 里的驱动"
    unmountEFI
    ;;

    3)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ACPI/SSDT-USB-WLAN_LTEBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB-WLAN_LTEBT.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
    ;;

    4)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ACPI/SSDT-USB-FingerBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB-FingerBT.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误"
    returnMenu
    ;;
  esac
  echo -e "[ ${GREEN}OK${OFF} ]修改完成"
}

function fixWindows() {
  echo
  echo "确保能通过F12启动Windows"
  echo "正在修复Windows启动..."
  local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/AptioMemoryFix.efi"
  curl --silent -O "${repoURL}" || networkWarn

  mountEFI
  if [[ -f "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/AptioMemoryFix.efi" ]]; then
    cp -rf "AptioMemoryFix.efi" "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/"
  elif [[ -f "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OcQuirks.efi" ]]; then
    rm -rf "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OcQuirks.efi"
    rm -rf "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OpenRuntime.efi"
    cp -rf "AptioMemoryFix.efi" "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/"
  fi
  echo -e "[ ${GREEN}OK${OFF} ]修复完成"

  unmountEFI
}

function fixAppleService() {
  echo
  echo "正在修复AppStore..."
  echo "如果您正在注册新的苹果账号, 请使用非黑苹果设备来注册"

  # 让以太网在en0端口, 根据 https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990 by Rehabman
  # 备份NetworkInterfaces.plist到NetworkInterfaces_backup.plist
  sudo cp -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist /Library/Preferences/SystemConfiguration/NetworkInterfaces_backup.plist
  # 删除NetworkInterfaces.plist来让系统重新生成
  sudo rm -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist

  defaults delete com.apple.appstore.commerce Storefront

  # 替换为随机MAC地址来解决一些苹果服务问题
  # 想法来源: https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/193#issuecomment-510689917

  # 生成随机MAC地址
  MAC_ADDRESS="0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1)"

  local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ACPI/SSDT-RMNE.dsl"
  curl --silent -O "${repoURL}" || networkWarn

  # 更改SSDT-RMNE.dsl的 11:22:33:44:55:66 为 ${MAC_ADDRESS}
  /usr/bin/sed -i "" "s:0x11, 0x22, 0x33, 0x44, 0x55, 0x66:${MAC_ADDRESS}:g" "${WORK_DIR}/SSDT-RMNE.dsl"

  # 编译 SSDT-RMNE.dsl 为 SSDT-RMNE.aml
  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/iasl63"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x iasl63
  "${WORK_DIR}/iasl63" -l "${WORK_DIR}/SSDT-RMNE.dsl"

  mountEFI
  cp -rf "${WORK_DIR}/SSDT-RMNE.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
  unmountEFI

  echo -e "[ ${GREEN}OK${OFF} ]修复完成"
  echo "请重启您的设备!"
}

# 报告问题并生成错误信息通过使用 gen_debug.sh @black-dragon74
# 此方法还没有被测试因为它太花时间
function reportProblem() {
  echo
  echo "正在收集错误信息通过运行gen_debug.sh @black-dragon74..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/black-dragon74/OSX-Debug/master/gen_debug.sh)"
  echo -e "[ ${GREEN}OK${OFF} ]收集完成"

  # 打开 Safari
  open -a "/Applications/Safari.app" https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues
  echo -e "${BOLD}请注明您的型号并完整上传gen_debug.sh生成的错误信息${OFF}"
}

function returnMenu() {
  echo
  read -rp "请按任何键返回主菜单..."
  main
}

function clean() {
  rm -rf "$HOME/Desktop/EFI_XIAOMI-PRO"
}

function main() {

  printf '\e[8;40;90t'

  checkMainboard

  clear

  # 界面 (参考: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=X%20i%20a%20o%20M%20i%20-%20P%20r%20o)
  echo
  echo ' __  __  _                   __  __   _          ____                 '
  echo ' \ \/ / (_)   __ _    ___   |  \/  | (_)        |  _ \   _ __    ___  '
  echo '  \  /  | |  / _` |  / _ \  | |\/| | | |  ____  | |_) | |  __|  / _ \ '
  echo '  /  \  | | | (_| | | (_) | | |  | | | | |____| |  __/  | |    | (_) |'
  echo ' /_/\_\ |_|  \__,_|  \___/  |_|  |_| |_|        |_|     |_|     \___/ '
  echo
  echo "您的主板型号是 ${MAINBOARD}"
  echo '====================================================================='
  echo -e "${BOLD}(1) 更新EFI${OFF}"
  echo "(2) 构建最新测试版EFI"
  echo "(3) 构建并更新最新测试版EFI"
  echo "(4) 更改蓝牙模式 (仅支持最新release)"
  echo "(5) 通用声卡修复 (credits Menchen)"
  echo "(6) 添加色彩文件"
  echo "(7) 更新变频管理"
  echo "(8) 更改TDP和CPU电压 (credits Pasi-Studio)"
  echo "(9) 开启HiDPI"
  echo "(10) 修复Windows启动 (仅支持最新release)"
  echo "(11) 修复Apple服务"
  echo "(12) 反馈问题"
  echo "(13) 退出"
  echo -e "${BOLD}您想选择哪个选项? (1/2/3/4/5/6/7/8/9/10/11/12/13)${OFF}"
  read -rp ":" xm_selection
  case ${xm_selection} in
    1)
    updateEFI
    returnMenu
    ;;

    2)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/makefile.sh)"
    returnMenu
    ;;

    3)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/makefile.sh)" && updateEFI "--LOCAL_RELEASE"
    returnMenu
    ;;

    4)
    changeBT
    returnMenu
    ;;

    5)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/one-key-alcplugfix_cn.sh)"
    returnMenu
    ;;

    6)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile/one-key-colorprofile_cn.sh)"
    returnMenu
    ;;

    7)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/stevezhengshiqi/one-key-cpufriend/master/one-key-cpufriend_cn.sh)"
    returnMenu
    ;;

    8)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Pasi-Studio/mpcpu/master/mpcpu.sh)"
    returnMenu
    ;;

    9)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"
    returnMenu
    ;;

    10)
    fixWindows
    returnMenu
    ;;

    11)
    fixAppleService
    returnMenu
    ;;

    12)
    reportProblem
    returnMenu
    ;;

    13)
    clean
    echo
    echo "祝您有开心的一天! 再见"
    exit 0
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误"
    returnMenu
    ;;
  esac
}

main

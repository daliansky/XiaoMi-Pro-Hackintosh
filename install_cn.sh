#!/bin/bash
#set -x # for DEBUGGING

# stevezhengshiqi创建于9 Jun, 2019, 基于 Rehabman 和 black-dragon74 的脚本.
# 仅支持小米笔记本Pro.

# 输出样式设置
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
OFF="\033[m"

# 退出如果网络异常
function networkWarn() {
  echo -e "[ ${RED}ERROR${OFF} ]: 从${repoURL}下载资源失败, 请检查您的网络连接!"
  exit 1
}

# 检查主板型号
function checkMainboard() {
  local MODEL_MX150="TM1701"
  local MODEL_GTX="TM1707"

  # 创建工程文件夹
  WORK_DIR="/Users/`users`/Desktop/EFI_XIAOMI-PRO"
  [[ -d "${WORK_DIR}" ]] && rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}"

  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/bdmesg"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x bdmesg

  MAINBOARD="$( "${WORK_DIR}/bdmesg" | grep Running | awk '{print $5}' | sed "s/\'//g")"
  if [ "${MAINBOARD}" != "${MODEL_MX150}" ] && [ "${MAINBOARD}" != "${MODEL_GTX}" ]; then
    echo "您的主板型号是 ${MAINBOARD}"
    echo -e "[ ${RED}ERROR${OFF} ]:不是小米笔记本Pro, 请检查您的型号!"
    clean
    exit 1
  fi
}

# 检查未签名的扩展，通过重建缓存的方式
function checkSystemIntegrity() {
  echo
  echo "正在重建缓存..."
  sudo kextcache -i / &> kextcache_log.txt
  echo -e "[ ${GREEN}OK${OFF} ]重建完成"

  # 检查kextcache_log.txt的总行数
  local KEXT_LIST=$(cat "kextcache_log.txt" |wc -l)
  if [ ${KEXT_LIST} != 1 ]; then
    # 如果总行数大于1, 说明原生驱动被修改, 或者未知的驱动装进了/L/E 或 /S/L/E
    echo -e "[ ${BOLD}WARNING${OFF} ]: 您的系统含有未签名的驱动扩展, 可能会导致严重的问题!"
    echo "升级EFI前请把EFI备份到外置磁盘"
  fi
}

# 挂载 EFI 通过 mount_efi.sh, credits Rehabman
function mountEFI() {
  local repoURL="https://raw.githubusercontent.com/RehabMan/hack-tools/master/mount_efi.sh"
  curl --silent -O "${repoURL}" || networkWarn
  echo
  echo "正在挂载EFI分区..."
  EFI_ADR="$(sh "mount_efi.sh")"

  # 检查EFI分区是否存在
  if [[ -z "${EFI_ADR}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: 未检测到EFI分区, 此脚本将退出.
    exit 1

  # 检查EFI/CLOVER是否存在
  elif [[ ! -e "${EFI_ADR}/EFI/CLOVER" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: 未检测到CLOVER文件夹, 此脚本将退出.
    exit 1
  fi

  echo -e "[ ${GREEN}OK${OFF} ]EFI分区已挂载到${EFI_ADR} (credits RehabMan)"
}

# Unmount EFI for safety
function unmountEFI() {
  echo
  echo "Unmounting EFI partition..."
  diskutil unmount $EFI_ADR &>/dev/null
  echo -e "[ ${GREEN}OK${OFF} ]Unmount complete"
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/daliansky/XiaoMi-Pro-Hackintosh/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo
    echo -e "[ ${RED}ERROR${OFF} ]: 从${repoURL}获取最新release失败."
    exit 1
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
  # 移除不需要的文件
  rm -rf "${xmFileName}"
  echo -e "[ ${GREEN}OK${OFF} ]下载完成"
}

# 备份序列号, BOOT 和 CLOVER 文件夹
function backupEFI() {
  mountEFI

  # 创建备份文件夹
  echo
  echo "正在备份..."
  # 生成时间戳
  local DATE="$(date "+%Y-%m-%d_%H-%M-%S")"
  BACKUP_DIR="/Users/`users`/Desktop/backupEFI_${DATE}"
  [[ -d "${BACKUP_DIR}" ]] && rm -rf "${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"
  cp -rf "${EFI_ADR}/EFI/CLOVER" "${BACKUP_DIR}" && cp -rf "${EFI_ADR}/EFI/BOOT" "${BACKUP_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]备份完成"

  echo
  echo "正在拷贝序列号到新CLOVER文件夹..."
  local pledit=/usr/libexec/PlistBuddy
  local SerialNumber="$($pledit -c 'Print SMBIOS:SerialNumber' ${BACKUP_DIR}/CLOVER/config.plist)"
  local BoardSerialNumber="$($pledit -c 'Print SMBIOS:BoardSerialNumber' ${BACKUP_DIR}/CLOVER/config.plist)"
  local SmUUID="$($pledit -c 'Print SMBIOS:SmUUID' ${BACKUP_DIR}/CLOVER/config.plist)"
  local ROM="$($pledit -c 'Print RtVariables:ROM' ${BACKUP_DIR}/CLOVER/config.plist)"
  local MLB="$($pledit -c 'Print RtVariables:MLB' ${BACKUP_DIR}/CLOVER/config.plist)"
  local CustomUUID="$($pledit -c 'Print :SystemParameters:CustomUUID' ${BACKUP_DIR}/CLOVER/config.plist)"

  # 检查序列号是否存在，如果存在则拷贝
  if [[ -z "${SerialNumber}" ]]; then
    $pledit -c "Add SMBIOS:SerialNumber string ${SerialNumber}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  if [[ ! -z "${BoardSerialNumber}" ]]; then
    $pledit -c "Add SMBIOS:BoardSerialNumber string ${BoardSerialNumber}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  if [[ ! -z "${SmUUID}" ]]; then
    $pledit -c "Add SMBIOS:SmUUID string ${SmUUID}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  if [[ ! -z "${ROM}" ]]; then
    $pledit -c "Set RtVariables:ROM ${ROM}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  if [[ ! -z "${MLB}" ]]; then
    $pledit -c "Add RtVariables:MLB string ${MLB}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  if [[ ! -z "${CustomUUID}" ]]; then
    $pledit -c "Add SystemParameters:CustomUUID string ${CustomUUID}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  echo -e "[ ${GREEN}OK${OFF} ]拷贝完成"
}

# 比较新旧CLOVER文件夹
function compareEFI() {
  echo
  echo "正在比较新旧EFI文件夹..."
  # 生成新CLOVER文件夹的树状图
  find ${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> NewEFI_TREE.txt
  # 移除开头的一些字符串
  sed -i '' 's/^.................//' NewEFI_TREE.txt
  # 移除含有DS_Store的行
  sed -i '' '/DS_Store/d' NewEFI_TREE.txt

  # 生成旧CLOVER文件夹的树状图
  find ${BACKUP_DIR}/CLOVER -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> OldEFI_TREE.txt
  # 移除开头的一些字符串
  sed -i '' 's/^.............//' OldEFI_TREE.txt
  # 移除含有DS_Store的行
  sed -i '' '/DS_Store/d' OldEFI_TREE.txt

  diff NewEFI_TREE.txt OldEFI_TREE.txt

  echo -e "${BOLD}你想继续吗? (y/n)${OFF}"
  read -p ":" cp_selection
  case ${cp_selection} in
    y)
    ;;

    n)
    exit 0
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误, 脚本将退出"
    exit 1
    ;;
  esac


}

# 根据配置修改EFI
function editEFI() {

  # 如果是GTX, SSDT-LGPA 需要替换成 SSDT-LGPAGTX
  if [ "${MAINBOARD}" == "TM1707" ]; then
    rm -f "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/SSDT-LGPA.aml"
    cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/GTX_Users_Read_This/SSDT-LGPAGTX.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
  fi

  echo
  echo "--------------------------------------------"
  echo "|************** 选择蓝牙模式 **************|"
  echo "--------------------------------------------"
  echo "(1) 原厂英特尔蓝牙 (默认)"
  echo "(2) USB蓝牙 / 屏蔽自带蓝牙 / 飞线蓝牙到摄像头"
  echo "(3) 飞线蓝牙到WLAN_LTE接口"
  echo -e "${BOLD}您想选择哪个模式? (1/2/3)${OFF}"
  read -p ":" bt_selection
  case ${bt_selection} in
    1)
    # 保持默认
    ;;

    2)
    rm -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/kexts/Other/USBPorts.kext"
    cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/USBPorts-USBBT.kext" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/kexts/Other/"
    ;;

    3)
    rm -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/kexts/Other/USBPorts.kext"
    cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/USBPorts-SolderBT.kext" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/kexts/Other/"
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误, 脚本将退出"
    exit 1
    ;;
  esac
  echo -e "[ ${GREEN}OK${OFF} ]修改完成"
}

# 更新 BOOT 和 CLOVER 文件夹
function replaceEFI() {
  echo
  echo "正在更新EFI文件夹..."
  rm -rf "${EFI_ADR}/EFI/CLOVER" && rm -rf "${EFI_ADR}/EFI/BOOT"
  cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/BOOT" "${EFI_ADR}/EFI/" && cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER" "${EFI_ADR}/EFI/"
  echo -e "[ ${GREEN}OK${OFF} ]更新完成"
}

function updateEFI() {
  checkSystemIntegrity
  downloadEFI
  backupEFI
  compareEFI
  editEFI
  replaceEFI
}

function changeBT() {
  echo
  echo "--------------------------------------------"
  echo "|************** 选择蓝牙模式 **************|"
  echo "--------------------------------------------"
  echo "(1) 保持默认"
  echo "(2) USB蓝牙 / 屏蔽自带蓝牙 / 飞线蓝牙到摄像头"
  echo "(3) 飞线蓝牙到WLAN_LTE接口"
  echo -e "${BOLD}您想选择哪个模式? (1/2/3)${OFF}"
  read -p ":" bt_selection_new
  case ${bt_selection_new} in
    1)
    # 保持默认
    ;;

    2)
    mountEFI
    rm -rf "${EFI_ADR}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/ACPI/patched/SSDT-USB-USBBT.aml" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/ACPI/patched/SSDT-USB-SolderBT.aml" >/dev/null 2>&1

    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/SSDT-USB-USBBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    cp -rf "SSDT-USB-USBBT.aml" "${EFI_ADR}/EFI/CLOVER/ACPI/patched/"

    echo "如果您使用的是博通USB蓝牙，您可能需要下载安装https://bitbucket.org/RehabMan/os-x-brcmpatchram/downloads 里的驱动"
    ;;

    3)
    mountEFI
    rm -rf "${EFI_ADR}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/ACPI/patched/SSDT-USB-USBBT.aml" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/ACPI/patched/SSDT-USB-SolderBT.aml" >/dev/null 2>&1

    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/SSDT-USB-SolderBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    cp -rf "SSDT-USB-SolderBT.aml" "${EFI_ADR}/EFI/CLOVER/ACPI/patched/"
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误, 脚本将退出"
    exit 1
    ;;
  esac
  echo -e "[ ${GREEN}OK${OFF} ]修改完成"
}

function fixWindows() {
  echo
  echo "确保能通过F12启动Windows"
  echo "正在修复Windows启动..."
  local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/AptioMemoryFix-64.efi"
  curl --silent -O "${repoURL}" || networkWarn

  mountEFI
  cp -rf "AptioMemoryFix-64.efi" "${EFI_ADR}/EFI/CLOVER/drivers64UEFI/"
  echo -e "[ ${GREEN}OK${OFF} ]修复完成"

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

function clean() {
  rm -rf "/Users/`users`/Desktop/EFI_XIAOMI-PRO"
}

function main() {

  printf '\e[8;40;90t'

  checkMainboard

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
  echo "(2) 更改蓝牙模式"
  echo "(3) 通用声卡修复"
  echo "(4) 添加色彩文件"
  echo "(5) 更新变频管理"
  echo "(6) 开启HiDPI"
  echo "(7) 修复Windows启动"
  echo "(8) 反馈问题"
  echo "(9) 退出"
  echo -e "${BOLD}您想选择哪个选项? (1/2/3/4/5/6/7/8/9)${OFF}"
  read -p ":" xm_selection
  case ${xm_selection} in
    1)
    updateEFI
    main
    ;;

    2)
    changeBT
    main
    ;;

    3)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/one-key-alcplugfix_cn.sh)"
    main
    ;;

    4)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile/one-key-colorprofile_cn.sh)"
    main
    ;;

    5)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-cpufriend/one-key-cpufriend_cn.sh)"
    main
    ;;

    6)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-hidpi/one-key-hidpi_cn.sh)"
    main
    ;;

    7)
    fixWindows
    main
    ;;

    8)
    reportProblem
    main
    ;;

    9)
    clean
    unmountEFI
    echo
    echo "祝您有开心的一天! 再见"
    exit 0
    ;;

  esac
}

main

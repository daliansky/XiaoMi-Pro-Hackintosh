#!/bin/bash
#set -x # for DEBUGGING

# stevezhengshiqi 创建于2019年2月8日。
# 只支持大部分8代U。
# 此脚本很依赖于 CPUFriend(https://github.com/acidanthera/CPUFriend), 感谢PMHeart。

# 当前的board-id
BOARD_ID="Mac-53FDB3D8DB8CA971" # MacBookPro15,4

# 输出样式设置
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
OFF="\033[m"

# 对应的plist
X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"

function printHeader() {
  printf '\e[8;40;90t'

  # 界面 (参考: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
  echo '  ____   ____    _   _   _____   ____    ___   _____   _   _   ____ '
  echo ' / ___| |  _ \  | | | | |  ___| |  _ \  |_ _| | ____| | \ | | |  _ \ '
  echo '| |     | |_) | | | | | | |_    | |_) |  | |  |  _|   |  \| | | | | | '
  echo '| |___  |  __/  | |_| | |  _|   |  _ <   | |  | |___  | |\  | | |_| | '
  echo ' \____| |_|      \___/  |_|     |_| \_\ |___| |_____| |_| \_| |____/ '
  echo
  echo '====================================================================='
}

# 检查board-id, 只有系统版本>=10.14.6(18G87)(?)才支持Mac-53FDB3D8DB8CA971.plist(MBP15,4)
function checkPlist() {
  if [[ ! -f "${X86_PLIST}" ]]; then
    # 使用MBP15,2的plist, 如果没有Mac-53FDB3D8DB8CA971.plist
    BOARD_ID="Mac-827FB448E656EC26" # MacBookPro15,2
    X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"

    # 检查board-id, 只有系统版本>=10.13.6(17G2112)才支持Mac-827FB448E656EC26.plist(MBP15,2)
    if [[ ! -f "${X86_PLIST}" ]]; then
      # 使用MBP14,1的plist, 如果没有Mac-827FB448E656EC26.plist
      BOARD_ID="Mac-B4831CEBD52A0C4C" # MacBookPro14,1
      X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"
    fi
  fi
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/acidanthera/CPUFriend/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: 无法从${repoURL}获取最新release。"
    exit 1
  fi
}

# 如果网络异常，退出
function networkWarn() {
  echo -e "[ ${RED}ERROR${OFF} ]: 下载CPUFriend失败, 请检查网络状态!"
  clean
  exit 1
}

# 下载CPUFriend仓库并解压最新release
function downloadKext() {
  getGitHubLatestRelease

  # 新建工程文件夹
  WORK_DIR="/Users/`users`/Desktop/one-key-cpufriend"
  [[ -d "${WORK_DIR}" ]] && sudo rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}"

  echo
  echo '----------------------------------------------------------------------'
  echo '|* 正在下载CPUFriend，源自github.com/acidanthera/CPUFriend @PMHeart *|'
  echo '----------------------------------------------------------------------'

  # 下载ResourceConverter.sh
  local rcURL='https://raw.githubusercontent.com/acidanthera/CPUFriend/master/ResourceConverter/ResourceConverter.sh'
  curl --silent -O "${rcURL}" && chmod +x ./ResourceConverter.sh || networkWarn

  # 下载CPUFriend.kext
  local cfVER="${ver}"
  local cfFileName="CPUFriend-${cfVER}-RELEASE.zip"
  local cfURL="https://github.com/acidanthera/CPUFriend/releases/download/${cfVER}/${cfFileName}"
  # GitHub的CDN是被Amazon所拥有, 所以我们在这添加 -L 来支持重置链接
  curl -# -L -O "${cfURL}" || networkWarn
  # 解压
  unzip -qu "${cfFileName}"
  # 移除不需要的文件
  rm -rf "${cfFileName}" 'CPUFriend.kext.dSYM'
  echo -e "[ ${GREEN}OK${OFF} ]下载完成"
}

# 拷贝目标plist
function copyPlist() {
  if [[ ! -f "${X86_PLIST}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]ERROR: 未找到${X86_PLIST}"
    clean
    exit 1
  fi

  cp "${X86_PLIST}" .
}

# 修改LFM值来调整最低频率
# 重新考虑这个方法是否必要, 因为LFM看起来不会影响性能表现
function changeLFM(){
  echo
  echo "------------------------------"
  echo "|****** 选择低频率模式 ******|"
  echo "------------------------------"
  echo "(1) 保持不变 (1200/1300mhz)"
  echo "(2) 800mhz (低负载下更省电)"
  echo "(3) 自定义"
  echo -e "${BOLD}你想选择哪个选项? (1/2/3)${OFF}"
  read -p ":" lfm_selection
  case ${lfm_selection} in
    1)
    # 保持不变
    ;;

    2)
    # 把 1200/1300 改成 800

    # 修改 020000000d000000 成 0200000008000000
    /usr/bin/sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" $BOARD_ID.plist

    # 修改 020000000c000000 成 0200000008000000
    /usr/bin/sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" $BOARD_ID.plist
    ;;

    3)
    # 自定义LFM
    customizeLFM
    ;;

    *)
    echo "ERROR: 输入有误, 脚本将退出"
    clean
    exit 1
    ;;
  esac
}

# 自定义LFM
function customizeLFM
{
  local Count=0
  local gLFM_RAW=""

  # 检查循环次数和输入值
  while  [ ${Count} -lt 3 ] && [[ ${gLFM_RAW} != 0 ]];
  do
    echo
    echo -e "${BOLD}请输入最低频率, 单位是mhz (例如 1300, 2700), 输入0来退出${OFF}"
    echo "有效值应该在800和3500之间, 离谱的值可能会导致硬件故障!"
    read -p ": " gLFM_RAW
    if [ ${gLFM_RAW} == 0 ]; then
      # 如果用户输入0, 回到主程序
      return

    # 检查gLFM_RAW是否为整数
    elif [[ ${gLFM_RAW} =~ ^[0-9]*$ ]]; then

      # 可接受的LFM应该在400~4000之间
      if [ ${gLFM_RAW} -ge 400 ] && [ ${gLFM_RAW} -le 4000 ]; then
        # 从输入值获取4位十进制数字, 例如 800 -> 0800
        gLFM_RAW=$(printf '%04d' ${gLFM_RAW})
        # 提取开头两位数字
        gLFM_RAW=$(echo ${gLFM_RAW} | cut -c -2)
        # 移除开头的0, 因为比如08, bash会判断它为八进制数字
        gLFM_RAW=$(echo ${gLFM_RAW} | sed 's/0*//')
        # 转换gLFM_RAW到十六进制, 并把它插入到LFM字段
        gLFM_VAL=$(printf '02000000%02x000000' ${gLFM_RAW})
        # 转换gLFM_VAL到base64
        gLFM_ENCODE=$(printf ${gLFM_VAL} | xxd -r -p | base64)
        # 提取开头11位数字
        gLFM_ENCODE=$(echo ${gLFM_ENCODE} | cut -c -11)

        # 修改 020000000d000000 成 02000000{自定义值}000000
        /usr/bin/sed -i "" "s:AgAAAA0AAAA:${gLFM_ENCODE}:g" $BOARD_ID.plist
        # 修改 020000000c000000 成 02000000{自定义值}000000
        /usr/bin/sed -i "" "s:AgAAAAwAAAA:${gLFM_ENCODE}:g" $BOARD_ID.plist
        return

      else
        # 非有效值, 给3次机会重新输入
        echo
        echo -e "[ ${BOLD}WARNING${OFF} ]: 请输入有效值 (400~4000)!"
        Count=$(($Count+1))
      fi

    else
      # 非有效值, 给3次机会重新输入
      echo
      echo -e "[ ${BOLD}WARNING${OFF} ]: 请输入有效值 (400~4000)!"
      Count=$(($Count+1))
    fi
  done

  if [ ${Count} > 2 ]; then
    # 如果3次机会后输入值仍然非有效值, 退出
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误, 脚本将退出"
    clean
    exit 1
  fi
}

# 修改EPP值来调节性能模式 (参考: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
# TO DO: 用更好的方式来修改变频参数, 见 https://github.com/Piker-Alpha/freqVectorsEdit.sh
function changeEPP(){
  echo
  echo "----------------------------"
  echo "|****** 选择性能模式 ******|"
  echo "----------------------------"
  echo "(1) 最省电模式"
  echo "(2) 平衡电量模式 (默认)"
  echo "(3) 平衡性能模式"
  echo "(4) 高性能模式"
  echo -e "${BOLD}你想选择哪个模式? (1/2/3/4)${OFF}"
  read -p ":" epp_selection
  case ${epp_selection} in
    1)
    # 把 80/90/92 改成 C0, 最省电模式

    # 修改 657070000000000000000000000000000000000080 成 6570700000000000000000000000000000000000c0
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist

    # 修改 657070000000000000000000000000000000000090 成 6570700000000000000000000000000000000000c0
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    ;;

    2)
    # 保持默认值 80/90/92, 平衡电量模式
    # 如果LFM也没有改变, 退出脚本
    if [ ${lfm_selection} == 1 ]; then
      echo "不忘初心，方得始终。下次再见。"
      clean
      exit 0
    fi
    ;;

    3)
    # 把 80/90/92 改成 40, 平衡性能模式

    # 修改 657070000000000000000000000000000000000080 成 657070000000000000000000000000000000000040
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist

    # 修改 657070000000000000000000000000000000000090 成 657070000000000000000000000000000000000040
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    ;;

    4)
    # 把 80/90/92 改成 00, 高性能模式

    # 修改 657070000000000000000000000000000000000080 成 657070000000000000000000000000000000000000
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist

    # 修改 657070000000000000000000000000000000000090 成 657070000000000000000000000000000000000000
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: 输入有误, 脚本将退出"
    clean
    exit 1
    ;;
  esac
}

# 生成 CPUFriendDataProvider.kext 并复制到桌面
function generateKext(){
  echo
  echo "正在生成CPUFriendDataProvider.kext"
  ./ResourceConverter.sh --kext $BOARD_ID.plist
  cp -r CPUFriendDataProvider.kext /Users/`users`/Desktop/

  # 拷贝CPUFriend.kext到桌面
  cp -r CPUFriend.kext /Users/`users`/Desktop/

  echo -e "[ ${GREEN}OK${OFF} ]生成完成"
}

# 清理临时文件夹文件夹并结束
function clean(){
  echo
  echo "正在清理临时文件"
  sudo rm -rf "${WORK_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]清理完成"
  echo
}

# 主程序
function main(){
  printHeader
  checkPlist
  downloadKext
  copyPlist
  changeLFM
  changeEPP
  generateKext
  clean
  echo -e "[ ${GREEN}OK${OFF} ]脚本运行结束, 请把桌面上的CPUFriend和CPUFriendDataProvider"
  echo "放入/CLOVER/kexts/Other/(或者L/E/)下"
  exit 0
}

main

#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 9 Jun, 2019, based on Rehabman and black-dragon74's work.
# Only support Xiaomi NoteBook Pro.

# Display style setting
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
OFF="\033[m"

# Exit in case of network failure
function networkWarn() {
  echo -e "[ ${RED}ERROR${OFF} ]: Fail to download resources from ${repoURL}, please check your connection!"
  exit 1
}

# Check Mainboard
function checkMainboard() {
  local MODEL_MX150="TM1701"
  local MODEL_GTX="TM1707"

  # new folder for work
  WORK_DIR="/Users/`users`/Desktop/EFI_XIAOMI-PRO"
  [[ -d "${WORK_DIR}" ]] && rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}"

  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/bdmesg"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x bdmesg

  MAINBOARD="$( "${WORK_DIR}/bdmesg" | grep Running | awk '{print $5}' | sed "s/\'//g")"
  if [ "${MAINBOARD}" != "${MODEL_MX150}" ] && [ "${MAINBOARD}" != "${MODEL_GTX}" ]; then
    echo "Your mainboard is ${MAINBOARD}"
    echo -e "[ ${RED}ERROR${OFF} ]:Not a XiaoMi-Pro, please check your model!"
    clean
    exit 1
  fi
}

# Check kexts with invalid signature by rebuilding kextcache
function checkSystemIntegrity() {
  echo
  echo "Rebuilding kextcache..."
  sudo kextcache -i / &> kextcache_log.txt
  echo -e "[ ${GREEN}OK${OFF} ]Rebuild complete"

  # check total line number of kextcache_log.txt
  local KEXT_LIST=$(cat "kextcache_log.txt" |wc -l)
  if [ ${KEXT_LIST} != 1 ]; then
    # if larger than one, means that native kexts may be modified, or unknown kexts are installed in /L/E or /S/L/E
    echo -e "[ ${BOLD}WARNING${OFF} ]: Your system has kext(s) with invalid signature, which may cause serious trouble!"
    echo "Please backup EFI folder to an external device before updating EFI"
  fi
}

# mount EFI by using mount_efi.sh, credits Rehabman
function mountEFI() {
  local repoURL="https://raw.githubusercontent.com/RehabMan/hack-tools/master/mount_efi.sh"
  curl --silent -O "${repoURL}" || networkWarn
  echo
  echo "Mounting EFI partition..."
  EFI_ADR="$(sh "mount_efi.sh")"

  # check whether EFI partition exists
  if [[ -z "${EFI_ADR}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to detect EFI partition, this script will end.
    exit 1
  # check whether EFI/CLOVER exists
  elif [[ ! -e "${EFI_ADR}/EFI/CLOVER" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: CLOVER folder undetected, this script will end.
    exit 1
  fi

  echo -e "[ ${GREEN}OK${OFF} ]Mounted EFI at ${EFI_ADR} (credits RehabMan)"
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/daliansky/XiaoMi-Pro-Hackintosh/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to retrieve latest release from ${repoURL}."
    exit 1
  fi
}

# Download EFI folder
function downloadEFI() {
  getGitHubLatestRelease

  echo
  echo '--------------------------------------------------------------------------------------'
  echo '|* Downloading EFI from https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases *|'
  echo '--------------------------------------------------------------------------------------'

  # download XiaoMi-Pro's EFI
  local xmFileName="XiaoMi_Pro-${ver}.zip"
  local repoURL="https://github.com/daliansky/XiaoMi-Pro-Hackintosh/releases/download/${ver}/${xmFileName}"
  # GitHub's CDN is hosted on Amazon, so here we add -L for redirection support
  curl -# -L -O "${repoURL}" || networkWarn
  # decompress it
  unzip -qu "${xmFileName}"
  # remove stuffs we do not need
  rm -rf "${xmFileName}"
  echo -e "[ ${GREEN}OK${OFF} ]Download complete"
}

# Backup Serial Numbers, BOOT and CLOVER folder
function backupEFI() {
  mountEFI

  # new folder for backup
  echo
  echo "Creating backup..."
  # generate time stamp
  local DATE="$(date "+%Y-%m-%d_%H-%M-%S")"
  BACKUP_DIR="/Users/`users`/Desktop/backupEFI_${DATE}"
  [[ -d "${BACKUP_DIR}" ]] && rm -rf "${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"
  cp -rf "${EFI_ADR}/EFI/CLOVER" "${BACKUP_DIR}" && cp -rf "${EFI_ADR}/EFI/BOOT" "${BACKUP_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]Backup complete"

  echo
  echo "Copying serial numbers to new CLOVER..."
  local pledit=/usr/libexec/PlistBuddy
  local SerialNumber="$($pledit -c 'Print SMBIOS:SerialNumber' ${BACKUP_DIR}/CLOVER/config.plist)"
  local BoardSerialNumber="$($pledit -c 'Print SMBIOS:BoardSerialNumber' ${BACKUP_DIR}/CLOVER/config.plist)"
  local SmUUID="$($pledit -c 'Print SMBIOS:SmUUID' ${BACKUP_DIR}/CLOVER/config.plist)"
  local ROM="$($pledit -c 'Print RtVariables:ROM' ${BACKUP_DIR}/CLOVER/config.plist)"
  local MLB="$($pledit -c 'Print RtVariables:MLB' ${BACKUP_DIR}/CLOVER/config.plist)"
  local CustomUUID="$($pledit -c 'Print :SystemParameters:CustomUUID' ${BACKUP_DIR}/CLOVER/config.plist)"

  # check whether serial numbers exist, copy if yes
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

  echo -e "[ ${GREEN}OK${OFF} ]Copy complete"
}

# Compare new and old CLOVER folders
function compareEFI() {
  echo
  echo "Comparing old and new EFI folder..."
  # generate tree diagram of new CLOVER folder
  find ${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> NewEFI_TREE.txt
  # remove first few strings
  sed -i '' 's/^.................//' NewEFI_TREE.txt
  # remove lines which have DS_Store
  sed -i '' '/DS_Store/d' NewEFI_TREE.txt

  # generate tree diagram of old CLOVER folder
  find ${BACKUP_DIR}/CLOVER -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> OldEFI_TREE.txt
  # remove first few strings
  sed -i '' 's/^.............//' OldEFI_TREE.txt
  # remove lines which have DS_Store
  sed -i '' '/DS_Store/d' OldEFI_TREE.txt

  diff NewEFI_TREE.txt OldEFI_TREE.txt

  echo -e "${BOLD}Do you want to continue? (y/n)${OFF}"
  read -p ":" cp_selection
  case ${cp_selection} in
    y)
    ;;

    n)
    exit 0
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input, closing the script"
    exit 1
    ;;
  esac


}

# EFI modifications according to unique setup
function editEFI() {

  # if GTX, SSDT-LGPA need to be replaced with SSDT-LGPAGTX
  if [ "${MAINBOARD}" == "TM1707" ]; then
    rm -f "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/SSDT-LGPA.aml"
    cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/GTX_Users_Read_This/SSDT-LGPAGTX.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
  fi

  echo
  echo "---------------------------------------------------------"
  echo "|************** Choose the Bluetooth Mode **************|"
  echo "---------------------------------------------------------"
  echo "(1) Native Intel BT (Default)"
  echo "(2) USB BT / Disable native BT / Solder BT on camera port"
  echo "(3) Solder BT on WLAN_LTE port"
  echo -e "${BOLD}Which option you want to choose? (1/2/3)${OFF}"
  read -p ":" bt_selection
  case ${bt_selection} in
    1)
    # Keep default
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
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input, closing the script"
    exit 1
    ;;
  esac
  echo -e "[ ${GREEN}OK${OFF} ]Change complete"
}

# Update BOOT and CLOVER folder
function replaceEFI() {
  echo
  echo "Updating EFI folder..."
  rm -rf "${EFI_ADR}/EFI/CLOVER" && rm -rf "${EFI_ADR}/EFI/BOOT"
  cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/BOOT" "${EFI_ADR}/EFI/" && cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER" "${EFI_ADR}/EFI/"
  echo -e "[ ${GREEN}OK${OFF} ]Update complete"
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
  downloadEFI
  echo
  echo "---------------------------------------------------------"
  echo "|************** Choose the Bluetooth Mode **************|"
  echo "---------------------------------------------------------"
  echo "(1) Remain the same"
  echo "(2) USB BT / Disable native BT / Solder BT on camera port"
  echo "(3) Solder BT on WLAN_LTE port"
  echo -e "${BOLD}Which option you want to choose? (1/2/3)${OFF}"
  read -p ":" bt_selection_new
  case ${bt_selection_new} in
    1)
    # Keep default
    ;;

    2)
    mountEFI
    rm -rf "${EFI_ADR}/EFI/CLOVER/kexts/Other/USBPorts.kext" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/kexts/Other/USBPorts-USBBT.kext" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/kexts/Other/USBPorts-SolderBT.kext" >/dev/null 2>&1
    cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/USBPorts-USBBT.kext" "${EFI_ADR}/EFI/CLOVER/kexts/Other/"
    ;;

    3)
    mountEFI
    rm -rf "${EFI_ADR}/EFI/CLOVER/kexts/Other/USBPorts.kext" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/kexts/Other/USBPorts-USBBT.kext" >/dev/null 2>&1
    rm -rf "${EFI_ADR}/EFI/CLOVER/kexts/Other/USBPorts-SolderBT.kext" >/dev/null 2>&1
    cp -r "${WORK_DIR}/XiaoMi_Pro-${ver}/USBPorts-SolderBT.kext" "${EFI_ADR}/EFI/CLOVER/kexts/Other/"
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input, closing the script"
    exit 1
    ;;
  esac
  echo -e "[ ${GREEN}OK${OFF} ]Change complete"
}

function fixWindows() {
  echo
  echo "Make sure you can boot Windows with F12"
  echo "Fixing Windows boot..."
  local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/AptioMemoryFix-64.efi"
  curl --silent -O "${repoURL}" || networkWarn

  mountEFI
  cp -rf "AptioMemoryFix-64.efi" "${EFI_ADR}/EFI/CLOVER/drivers64UEFI/"
  echo -e "[ ${GREEN}OK${OFF} ]Fix complete"

}

# Report problem and generate problem shooting by using gen_debug.sh @black-dragon74
# This function hasn't been tested yet because it takes time
function reportProblem() {
  echo
  echo "Collecting problem shooting file by using gen_debug.sh @black-dragon74..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/black-dragon74/OSX-Debug/master/gen_debug.sh)"
  echo -e "[ ${GREEN}OK${OFF} ]Collect complete"

  # open Safari
  open -a "/Applications/Safari.app" https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues
  echo -e "${BOLD}Please write down your model and attach full problem shooting file generated by gen_debug.sh${OFF}"
}

function clean() {
  rm -rf "/Users/`users`/Desktop/EFI_XIAOMI-PRO"
}

function main() {

  printf '\e[8;40;90t'

  checkMainboard

  # Interface (ref: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=X%20i%20a%20o%20M%20i%20-%20P%20r%20o)
  echo
  echo ' __  __  _                   __  __   _          ____                 '
  echo ' \ \/ / (_)   __ _    ___   |  \/  | (_)        |  _ \   _ __    ___  '
  echo '  \  /  | |  / _` |  / _ \  | |\/| | | |  ____  | |_) | |  __|  / _ \ '
  echo '  /  \  | | | (_| | | (_) | | |  | | | | |____| |  __/  | |    | (_) |'
  echo ' /_/\_\ |_|  \__,_|  \___/  |_|  |_| |_|        |_|     |_|     \___/ '
  echo
  echo "Your mainboard is ${MAINBOARD}"
  echo '====================================================================='
  echo -e "${BOLD}(1) Update EFI${OFF}"
  echo "(2) Change Bluetooth mode"
  echo "(3) General audio fix"
  echo "(4) Add color profile"
  echo "(5) Update power management"
  echo "(6) Enable HiDPI"
  echo "(7) Fix Windows boot"
  echo "(8) Problem report"
  echo "(9) Exit"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4/5/6/7/8/9)${OFF}"
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/one-key-alcplugfix.sh)"
    main
    ;;

    4)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile/one-key-colorprofile.sh)"
    main
    ;;

    5)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-cpufriend/one-key-cpufriend.sh)"
    main
    ;;

    6)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-hidpi/one-key-hidpi.sh)"
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
    echo
    echo "Wish you have a good day! Bye"
    exit 0
    ;;

  esac
}

main

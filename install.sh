#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 9 Jun, 2019
# Reference:
# https://github.com/black-dragon74/OSX-Debug/blob/master/gen_debug.sh by black-dragon74
# https://github.com/RehabMan/hack-tools/blob/master/mount_efi.sh by Rehabman
# https://github.com/syscl/Fix-usb-sleep/blob/master/fixUSB.sh by syscl
# https://github.com/xzhih/one-key-hidpi/blob/master/hidpi.sh by xzhih

# Only support Xiaomi NoteBook Pro.

# Display style setting
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
OFF="\033[m"

pledit=/usr/libexec/PlistBuddy

# Exit in case of network failure
function networkWarn() {
  echo -e "[ ${RED}ERROR${OFF} ]: Fail to download resources from ${repoURL}, please check your connection!"
  clean
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

  MAINBOARD="$( "${WORK_DIR}/bdmesg" | grep Running | awk '{print $5}' | sed "s/\'//g" | tr -d "''")"
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
  # check if apple kexts have been modified
  local APPLE_KEXT=$(grep 'com.apple' kextcache_log.txt)
  # check FakeSMC in S/L/E and L/E
  local FakeSMC=$(grep 'FakeSMC' kextcache_log.txt)
  # check VirtualSMC in S/L/E and L/E
  local VirtualSMC=$(grep 'VirtualSMC' kextcache_log.txt)

  if [[ ! -z ${APPLE_KEXT} ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]:Native apple kexts have been modified, please keep S/L/E and L/E untouched!"
    clean
    exit 1
  elif [[ ! -z ${FakeSMC} ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]:Detected FakeSMC in system partition, kexts in CLOVER folder will not work!"
    clean
    exit 1
  elif [[ ! -z ${VirtualSMC} ]]; then
    echo -e "[ ${BLUE}WARNING${OFF} ]:Detected VirtualSMC in system partition, kexts in CLOVER folder may not work!"
    echo "Please backup EFI folder to an external device before updating EFI"
  elif [ ${KEXT_LIST} -lt 1 ]; then
  # if larger than one, means that native kexts may be modified, or unknown kexts are installed in /L/E or /S/L/E
    echo -e "[ ${BLUE}WARNING${OFF} ]: Your system has kext(s) with invalid signature, which may cause serious trouble!"
    echo "Please backup EFI folder to an external device before updating EFI"
  fi
}

# Mount EFI by using mount_efi.sh, credits Rehabman
function mountEFI() {
  local repoURL="https://raw.githubusercontent.com/RehabMan/hack-tools/master/mount_efi.sh"
  curl --silent -O "${repoURL}" || networkWarn
  echo
  echo "Mounting EFI partition..."
  EFI_DIR="$(sh "mount_efi.sh")"

  # check whether EFI partition exists
  if [[ -z "${EFI_DIR}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to detect EFI partition"
    unmountEFI
    returnMenu

  # check whether EFI/CLOVER exists
  elif [[ ! -e "${EFI_DIR}/EFI/CLOVER" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to detect CLOVER folder"
    unmountEFI
    returnMenu
  fi

  echo -e "[ ${GREEN}OK${OFF} ]Mounted EFI at ${EFI_DIR} (credits RehabMan)"
}

# Unmount EFI for safety
function unmountEFI() {
  echo
  echo "Unmounting EFI partition..."
  diskutil unmount $EFI_DIR &>/dev/null
  echo -e "[ ${GREEN}OK${OFF} ]Unmount complete"
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/daliansky/XiaoMi-Pro-Hackintosh/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to retrieve latest release from ${repoURL}"
    returnMenu
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

# Backup DefaultVolume, Timeout, Serial Numbers, theme, BOOT and CLOVER folder
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
  cp -rf "${EFI_DIR}/EFI/BOOT" "${BACKUP_DIR}" || cp -rf "${EFI_DIR}/EFI/Boot" "${BACKUP_DIR}" || cp -rf "${EFI_DIR}/EFI/boot" "${BACKUP_DIR}"
  cp -rf "${EFI_DIR}/EFI/CLOVER" "${BACKUP_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]Backup complete"

  echo
  echo "Copying serial numbers to new CLOVER..."
  local DefaultVolume="$($pledit -c 'Print Boot:DefaultVolume' ${BACKUP_DIR}/CLOVER/config.plist)"
  local Timeout="$($pledit -c 'Print Boot:Timeout' ${BACKUP_DIR}/CLOVER/config.plist)"
  local SerialNumber="$($pledit -c 'Print SMBIOS:SerialNumber' ${BACKUP_DIR}/CLOVER/config.plist)"
  local BoardSerialNumber="$($pledit -c 'Print SMBIOS:BoardSerialNumber' ${BACKUP_DIR}/CLOVER/config.plist)"
  local SmUUID="$($pledit -c 'Print SMBIOS:SmUUID' ${BACKUP_DIR}/CLOVER/config.plist)"
  local ROM="$($pledit -c 'Print RtVariables:ROM' ${BACKUP_DIR}/CLOVER/config.plist)"
  local MLB="$($pledit -c 'Print RtVariables:MLB' ${BACKUP_DIR}/CLOVER/config.plist)"
  local CustomUUID="$($pledit -c 'Print SystemParameters:CustomUUID' ${BACKUP_DIR}/CLOVER/config.plist)"
  local InjectSystemID="$($pledit -c 'Print SystemParameters:InjectSystemID' ${BACKUP_DIR}/CLOVER/config.plist)"

  # check whether DefaultVolume and Timeout exist, copy if yes
  if [[ ! -z "${DefaultVolume}" ]]; then
    $pledit -c "Set Boot:DefaultVolume ${DefaultVolume}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  if [[ ! -z "${Timeout}" ]]; then
    $pledit -c "Set Boot:Timeout ${Timeout}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  # check whether serial numbers exist, copy if yes
  if [[ ! -z "${SerialNumber}" ]]; then
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

  if [[ ! -z "${InjectSystemID}" ]]; then
    $pledit -c "Set SystemParameters:InjectSystemID ${InjectSystemID}" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  else
    $pledit -c "Set SystemParameters:InjectSystemID false" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  fi

  echo -e "[ ${GREEN}OK${OFF} ]Copy complete"

  echo
  echo "Copying theme to new CLOVER..."

  rm -rf "XiaoMi_Pro-${ver}/EFI/CLOVER/themes"
  cp -rf "${BACKUP_DIR}/CLOVER/themes" "XiaoMi_Pro-${ver}/EFI/CLOVER/"

  # create a config.plist with only GUI directory inside
  # TODO: use a more efficient way to copy GUI directory
  cp -rf "${BACKUP_DIR}/CLOVER/config.plist" "${WORK_DIR}/GUI.plist"
  $pledit -c "Delete ACPI" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete Boot" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete CPU" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete Devices" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete Graphics" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete KernelAndKextPatches" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete RtVariables" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete SMBIOS" ${WORK_DIR}/GUI.plist
  $pledit -c "Delete SystemParameters" ${WORK_DIR}/GUI.plist

  # merge GUI.plist to config.plist to save theme settings
  $pledit -c "Delete GUI" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
  $pledit -c "Merge GUI.plist" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist

  echo -e "[ ${GREEN}OK${OFF} ]Copy complete"
}

# Check whether ${BACKUP_DIR}/CLOVER exists or not
function confirmBackup() {
  echo
  echo "Confirming backup..."
  if [[ ! -e "${BACKUP_DIR}/CLOVER" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to backup CLOVER folder!"
    unmountEFI
    clean
    exit 1
  else
    echo -e "[ ${GREEN}OK${OFF} ]Confirm complete"
  fi
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
    unmountEFI
    returnMenu
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input"
    unmountEFI
    returnMenu
    ;;
  esac

}

# EFI modifications according to unique setup
function editEFI() {

  # if GTX, SSDT-LGPA need to be replaced with SSDT-LGPAGTX
  if [ "${MAINBOARD}" == "TM1707" ]; then
    rm -f "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/SSDT-LGPA.aml"
    cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/GTX_Users_Read_This/SSDT-LGPAGTX.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
  fi

  echo
  echo "---------------------------------------------------------"
  echo "|************** Choose the Bluetooth Mode **************|"
  echo "---------------------------------------------------------"
  echo "(1) Native Intel BT (Default)"
  echo "(2) USB BT / Disable native BT / Solder BT on camera port"
  echo "(3) Solder BT on WLAN_LTE port"
  echo "(4) Solder BT on fingerprint port"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4)${OFF}"
  read -p ":" bt_selection
  case ${bt_selection} in
    1)
    # Keep default
    ;;

    2)
    rm -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/SSDT-USB-USBBT.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
    ;;

    3)
    rm -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/SSDT-USB-WLAN_LTEBT.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
    ;;

    4)
    rm -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/SSDT-USB-FingerBT.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input"
    unmountEFI
    returnMenu
    ;;
  esac

  echo
  echo "---------------------------------------------------------"
  echo "|**************** Choose Clover patches ****************|"
  echo "---------------------------------------------------------"
  echo -e "(1) 0xE2 MSR patch & DVMT to 64mb (${GREEN}Default${OFF}, choose this if you don't know what it mean)"
  echo -e "(2) 0xE2 MSR patch only (${RED}Advanced user only${OFF}, use this only if you have already unlocked 0xE2 with bios patch)"
  echo -e "(3) DVMT to 64m only(${RED}Advanced user only${OFF}, use this obly if you have already set DVMT to 64m in bios)"
  echo -e "(4) No special patch(${RED}Advanced user only${OFF}, this option will ${BOLD}delete${OFF} both DVMT & 0xE2 patches)"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4)${OFF}"
  read -p ":" cloverpatch_selection
  case ${cloverpatch_selection} in
    1)
    # Keep default
    ;;

	2)
    $pledit -c "delete KernelAndKextPatches:KernelToPatch:0" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
	;;

	3)
    $pledit -c "delete Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-fbmem" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
    $pledit -c "delete Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-stolenmem" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
	;;

	4)
    $pledit -c "delete KernelAndKextPatches:KernelToPatch:0" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
    $pledit -c "delete Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-fbmem" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
    $pledit -c "delete Devices:Properties:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-stolenmem" XiaoMi_Pro-${ver}/EFI/CLOVER/config.plist
	;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input"
    unmountEFI
    returnMenu
    ;;
  esac

  echo -e "[ ${GREEN}OK${OFF} ]Change complete"
}

function restoreEFI() {
  echo -e "[ ${RED}ERROR${OFF} ]: Failed to update EFI folder"
  echo
  echo "Restoring the EFI folder from backup..."
  cp -rf "${BACKUP_DIR}/BOOT" "${EFI_DIR}/EFI/" || cp -rf "${BACKUP_DIR}/Boot" "${EFI_DIR}/EFI/" || cp -rf "${BACKUP_DIR}/boot" "${EFI_DIR}/EFI/" || echo -e "[ ${RED}ERROR${OFF} ]: Failed to restore BOOT folder, please update EFI manually before shutting down"
  cp -rf "${BACKUP_DIR}/CLOVER" "${EFI_DIR}/EFI/" || echo -e "[ ${RED}ERROR${OFF} ]: Failed to restore CLOVER folder, please update EFI manually before shutting down"
  echo -e "[ ${GREEN}OK${OFF} ]Restore complete"
  clean
  exit 1
}

# Update BOOT and CLOVER folder
function replaceEFI() {
  echo
  echo "Updating EFI folder..."
  rm -rf "${EFI_DIR}/EFI/CLOVER" && rm -rf "${EFI_DIR}/EFI/BOOT"
  cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/BOOT" "${EFI_DIR}/EFI/" || restoreEFI
  cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER" "${EFI_DIR}/EFI/"  || restoreEFI
  echo -e "[ ${GREEN}OK${OFF} ]Update complete"
}

function updateEFI() {
  checkSystemIntegrity
  downloadEFI
  backupEFI
  confirmBackup
  compareEFI
  editEFI
  replaceEFI
  unmountEFI
}

# Delete previous Bluetooth configurations(SSDT-USB, SSDT-USB-USBBT, SSDT-SolderBT(changed to SSDT-USB-WLAN_LTEBT), SSDT-USB-WLAN_LTEBT, and SSDT-USB-FingerBT)
function deleteBT() {
  mountEFI
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-USBBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-SolderBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-WLAN_LTEBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-FingerBT.aml" >/dev/null 2>&1

  # need unmountEFI after calling this function
}

function changeBT() {
  echo
  echo "---------------------------------------------------------"
  echo "|************** Choose the Bluetooth Mode **************|"
  echo "---------------------------------------------------------"
  echo "(1) Remain the same"
  echo "(2) USB BT / Disable native BT / Solder BT on camera port"
  echo "(3) Solder BT on WLAN_LTE port"
  echo "(4) Solder BT on fingerprint port"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4)${OFF}"
  read -p ":" bt_selection_new
  case ${bt_selection_new} in
    1)
    # Keep default
    ;;

    2)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/SSDT-USB-USBBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB-USBBT.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"

    echo
    echo "If you are using Broadcom USB BT, you may need to download & install kexts from https://bitbucket.org/RehabMan/os-x-brcmpatchram/downloads"
    unmountEFI
    ;;

    3)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/SSDT-USB-WLAN_LTEBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB-WLAN_LTEBT.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
    ;;

    4)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/SSDT-USB-FingerBT.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "${WORK_DIR}/XiaoMi_Pro-${ver}/SSDT-USB-FingerBT.aml" "${WORK_DIR}/XiaoMi_Pro-${ver}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input"
    unmountEFI
    returnMenu
    ;;
  esac
  echo -e "[ ${GREEN}OK${OFF} ]Change complete"
}

function fixWindows() {
  echo
  echo "Make sure you can boot Windows with F12"
  echo "Fixing Windows boot..."
  local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/wiki/AptioMemoryFix.efi"
  curl --silent -O "${repoURL}" || networkWarn

  mountEFI
  cp -rf "AptioMemoryFix.efi" "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/"
  echo -e "[ ${GREEN}OK${OFF} ]Fix complete"

  unmountEFI
}

function fixAppleService() {
  echo
  echo "Fixing AppStore..."
  echo "If you are signing up a new Apple account, please use another device except hackintosh"

  # make Ethernet at en0, according to https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990 by Rehabman
  # backup NetworkInterfaces.plist to NetworkInterfaces_backup.plist
  sudo cp -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist /Library/Preferences/SystemConfiguration/NetworkInterfaces_backup.plist
  # delete NetworkInterfaces.plist and let system to re-generate it
  sudo rm -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist

  defaults delete com.apple.appstore.commerce Storefront

  # Replace with random MAC address to solve some Apple services
  # Idea comes from: https://github.com/daliansky/XiaoMi-Pro-Hackintosh/issues/193#issuecomment-510689917

  # generate random MAC address
  MAC_ADDRESS="0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1), 0x$(openssl rand -hex 1)"

  local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/EFI/CLOVER/ACPI/patched/SSDT-RMNE.dsl"
  curl --silent -O "${repoURL}" || networkWarn

  # change 11:22:33:44:55:66 to ${MAC_ADDRESS} in SSDT-RMNE.dsl
  /usr/bin/sed -i "" "s:0x11, 0x22, 0x33, 0x44, 0x55, 0x66:${MAC_ADDRESS}:g" ${WORK_DIR}/SSDT-RMNE.dsl

  # compile SSDT-RMNE.dsl to SSDT-RMNE.aml
  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/iasl63"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x iasl63
  ${WORK_DIR}/iasl63 -l ${WORK_DIR}/SSDT-RMNE.dsl

  mountEFI
  cp -rf "${WORK_DIR}/SSDT-RMNE.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
  unmountEFI

  echo -e "[ ${GREEN}OK${OFF} ]Fix complete"
  echo "Please restart your device!"
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

function returnMenu() {
  echo
  read -p "Press any key to return to the main menu..."
  main
}

function clean() {
  rm -rf "/Users/`users`/Desktop/EFI_XIAOMI-PRO"
}

function main() {

  printf '\e[8;40;90t'

  checkMainboard

  clear

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
  echo "(2) Change Bluetooth mode (Only support the latest release)"
  echo "(3) General audio fix (credits Menchen)"
  echo "(4) Add color profile"
  echo "(5) Update power management"
  echo "(6) Modify TDP and CPU voltage (credits Pasi-Studio)"
  echo "(7) Enable HiDPI"
  echo "(8) Fix Windows boot (Only support the latest release)"
  echo "(9) Fix Apple services"
  echo "(10) Problem report"
  echo "(11) Exit"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4/5/6/7/8/9/10/11)${OFF}"
  read -p ":" xm_selection
  case ${xm_selection} in
    1)
    updateEFI
    returnMenu
    ;;

    2)
    changeBT
    returnMenu
    ;;

    3)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/one-key-alcplugfix.sh)"
    returnMenu
    ;;

    4)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile/one-key-colorprofile.sh)"
    returnMenu
    ;;

    5)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-cpufriend/one-key-cpufriend.sh)"
    returnMenu
    ;;

    6)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Pasi-Studio/mpcpu/master/mpcpu.sh)"
    returnMenu
    ;;

    7)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-hidpi/one-key-hidpi.sh)"
    returnMenu
    ;;

    8)
    fixWindows
    returnMenu
    ;;

    9)
    fixAppleService
    returnMenu
    ;;

    10)
    reportProblem
    returnMenu
    ;;

    11)
    clean
    echo
    echo "Wish you have a good day! Bye"
    exit 0
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input"
    returnMenu
    ;;
  esac
}

main

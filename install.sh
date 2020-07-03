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

RELEASE_Dir=""

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
  WORK_DIR="$HOME/Desktop/EFI_XIAOMI-PRO"
  [[ -d "${WORK_DIR}" ]] && rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}" || exit 1

  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/bdmesg"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x bdmesg

  MAINBOARD="$( "${WORK_DIR}/bdmesg" | grep Running | awk '{print $5}' | sed "s/\'//g" | tr -d "''")"
  if [ "${MAINBOARD}" != "${MODEL_MX150}" ] && [ "${MAINBOARD}" != "${MODEL_GTX}" ]; then
    echo "Your mainboard is ${MAINBOARD}"
    echo -e "[ ${RED}ERROR${OFF} ]:Not a XiaoMi-Pro, please check your model!"
    echo "This script is only for Clover user!"
    # clean
    # exit 1
  fi
}

# Check kexts with invalid signature by rebuilding kextcache
function checkSystemIntegrity() {
  local KEXT_LIST
  local APPLE_KEXT
  local FakeSMC
  local VirtualSMC

  echo
  echo "Rebuilding kextcache..."
  sudo kextcache -i / &> kextcache_log.txt
  echo -e "[ ${GREEN}OK${OFF} ]Rebuild complete"

  # check total line number of kextcache_log.txt
  KEXT_LIST=$(cat "kextcache_log.txt" |wc -l)
  # check if apple kexts have been modified
  APPLE_KEXT=$(grep 'com.apple' kextcache_log.txt)
  # check FakeSMC in S/L/E and L/E
  FakeSMC=$(grep 'FakeSMC' kextcache_log.txt)
  # check VirtualSMC in S/L/E and L/E
  VirtualSMC=$(grep 'VirtualSMC' kextcache_log.txt)

  if [[ -n ${APPLE_KEXT} ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]:Native apple kexts have been modified, please keep S/L/E and L/E untouched!"
    # clean
    # exit 1
  elif [[ -n ${FakeSMC} ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]:Detected FakeSMC in system partition, kexts in CLOVER folder will not work!"
    clean
    exit 1
  elif [[ -n ${VirtualSMC} ]]; then
    echo -e "[ ${BLUE}WARNING${OFF} ]:Detected VirtualSMC in system partition, kexts in CLOVER folder may not work!"
    echo "Please backup EFI folder to an external device before updating EFI"
  elif [ "${KEXT_LIST}" -lt 1 ]; then
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
  diskutil unmount "$EFI_DIR" &>/dev/null
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

  RELEASE_Dir="XiaoMi_Pro-${ver}"

  # remove stuffs we do not need
  rm -rf "${xmFileName}"
  echo -e "[ ${GREEN}OK${OFF} ]Download complete"
}

# Backup DefaultVolume, Timeout, Serial Numbers, theme, BOOT and CLOVER folder
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

  # new folder for backup
  echo
  echo "Creating backup..."
  # generate time stamp
  DATE="$(date "+%Y-%m-%d_%H-%M-%S")"
  BACKUP_DIR="$HOME/Desktop/backupEFI_${DATE}"
  [[ -d "${BACKUP_DIR}" ]] && rm -rf "${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"
  cp -rf "${EFI_DIR}/EFI/BOOT" "${BACKUP_DIR}" || cp -rf "${EFI_DIR}/EFI/Boot" "${BACKUP_DIR}" || cp -rf "${EFI_DIR}/EFI/boot" "${BACKUP_DIR}"
  cp -rf "${EFI_DIR}/EFI/CLOVER" "${BACKUP_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]Backup complete"

  echo
  echo "Copying previous settings to new CLOVER..."
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

  # check whether DefaultVolume and Timeout exist, copy if yes
  if [[ -n "${DefaultVolume}" ]]; then
    $pledit -c "Set Boot:DefaultVolume ${DefaultVolume}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  if [[ -n "${Timeout}" ]]; then
    $pledit -c "Set Boot:Timeout ${Timeout}" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  fi

  # check whether serial numbers exist, copy if yes
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

  echo -e "[ ${GREEN}OK${OFF} ]Copy complete"

  echo
  echo "Copying theme to new CLOVER..."

  rm -rf "${BACKUP_DIR}/CLOVER/themes/Xiaomi"
  cp -rf "$RELEASE_Dir/EFI/CLOVER/themes/Xiaomi" "${BACKUP_DIR}/CLOVER/themes/"
  rm -rf "$RELEASE_Dir/EFI/CLOVER/themes"
  cp -rf "${BACKUP_DIR}/CLOVER/themes" "$RELEASE_Dir/EFI/CLOVER/"

  # create a config.plist with only GUI directory inside
  # TODO: use a more efficient way to copy GUI directory
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

  # merge GUI.plist to config.plist to save theme settings
  $pledit -c "Delete GUI" "$RELEASE_Dir/EFI/CLOVER/config.plist"
  $pledit -c "Merge GUI.plist" "$RELEASE_Dir/EFI/CLOVER/config.plist"

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
  find "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> NewEFI_TREE.txt
  # remove first few strings
  sed -i '' 's/^.................//' NewEFI_TREE.txt
  # remove lines which have DS_Store
  sed -i '' '/DS_Store/d' NewEFI_TREE.txt

  # generate tree diagram of old CLOVER folder
  find "${BACKUP_DIR}/CLOVER" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' &> OldEFI_TREE.txt
  # remove first few strings
  sed -i '' 's/^.............//' OldEFI_TREE.txt
  # remove lines which have DS_Store
  sed -i '' '/DS_Store/d' OldEFI_TREE.txt

  diff NewEFI_TREE.txt OldEFI_TREE.txt

  echo -e "${BOLD}Do you want to continue? (y/n)${OFF}"
  read -rp ":" cp_selection
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
    rm -f "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-LGPA.aml"
    cp -rf "${WORK_DIR}/$RELEASE_Dir/GTX_Users_Read_This/SSDT-LGPAGTX.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
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
  read -rp ":" bt_selection
  case ${bt_selection} in
    1)
    # Keep default
    ;;

    2)
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1
    cp -rf "${WORK_DIR}/$RELEASE_Dir/SSDT-USB-USBBT.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
    ;;

    3)
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1
    cp -rf "${WORK_DIR}/$RELEASE_Dir/SSDT-USB-WLAN_LTEBT.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
    ;;

    4)
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
    rm -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1
    cp -rf "${WORK_DIR}/$RELEASE_Dir/SSDT-USB-FingerBT.aml" "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER/ACPI/patched/"
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
  cp -rf "${WORK_DIR}/$RELEASE_Dir/EFI/BOOT" "${EFI_DIR}/EFI/" || restoreEFI
  cp -rf "${WORK_DIR}/$RELEASE_Dir/EFI/CLOVER" "${EFI_DIR}/EFI/"  || restoreEFI
  echo -e "[ ${GREEN}OK${OFF} ]Update complete"
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

# Delete previous Bluetooth configurations(SSDT-USB, SSDT-USB-USBBT, SSDT-SolderBT(changed to SSDT-USB-WLAN_LTEBT), SSDT-USB-WLAN_LTEBT, and SSDT-USB-FingerBT)
function deleteBT() {
  mountEFI
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-USBBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-SolderBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-WLAN_LTEBT.aml" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/ACPI/patched/SSDT-USB-FingerBT.aml" >/dev/null 2>&1
  
  rm -rf "${EFI_DIR}/EFI/CLOVER/kexts/Other/IntelBluetoothFirmware.kext" >/dev/null 2>&1
  rm -rf "${EFI_DIR}/EFI/CLOVER/kexts/Other/IntelBluetoothInjector.kext" >/dev/null 2>&1

  # need unmountEFI after calling this function
}

function changeBT() {
  echo
  echo "---------------------------------------------------------"
  echo "|************** Choose the Bluetooth Mode **************|"
  echo "---------------------------------------------------------"
  echo "(1) Native Intel BT (Default)"
  echo "(2) USB BT / Disable native BT / Solder BT on camera port"
  echo "(3) Solder BT on WLAN_LTE port"
  echo "(4) Solder BT on fingerprint port"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4)${OFF}"
  read -rp ":" bt_selection_new
  case ${bt_selection_new} in
    1)
    local repoURL="https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/EFI/CLOVER/ACPI/patched/SSDT-USB.aml"
    curl --silent -O "${repoURL}" || networkWarn

    deleteBT

    cp -rf "SSDT-USB.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
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

    cp -rf "SSDT-USB-FingerBT.aml" "${EFI_DIR}/EFI/CLOVER/ACPI/patched/"
    unmountEFI
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input"
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
  if [[ -f "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/AptioMemoryFix.efi" ]]; then
    cp -rf "AptioMemoryFix.efi" "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/"
  elif [[ -f "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OcQuirks.efi" ]]; then
    rm -rf "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OcQuirks.efi"
    rm -rf "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OpenRuntime.efi"
    rm -rf "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/OcQuirks.plist"
    cp -rf "AptioMemoryFix.efi" "${EFI_DIR}/EFI/CLOVER/drivers/UEFI/"
  fi
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
  /usr/bin/sed -i "" "s:0x11, 0x22, 0x33, 0x44, 0x55, 0x66:${MAC_ADDRESS}:g" "${WORK_DIR}/SSDT-RMNE.dsl"

  # compile SSDT-RMNE.dsl to SSDT-RMNE.aml
  local repoURL="https://raw.githubusercontent.com/daliansky/Hackintosh/master/Tools/iasl63"
  curl --silent -O "${repoURL}" || networkWarn
  sudo chmod +x iasl63
  "${WORK_DIR}/iasl63" -l "${WORK_DIR}/SSDT-RMNE.dsl"

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
  read -rp "Press any key to return to the main menu..."
  main
}

function clean() {
  rm -rf "$HOME/Desktop/EFI_XIAOMI-PRO"
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
  echo '========================================================================='
  echo -e "${BOLD}(1) Update EFI${OFF}"
  echo "(2) Build beta EFI"
  echo "(3) Build and update beta EFI"
  echo "(4) Change Bluetooth mode (Only support the latest release)"
  echo "(5) General audio fix (credits Menchen)"
  echo "(6) Add color profile"
  echo "(7) Update power management"
  echo "(8) Modify TDP and CPU voltage (credits Pasi-Studio)"
  echo "(9) Enable HiDPI"
  echo "(10) Fix Windows boot (Only support the latest release)"
  echo "(11) Fix Apple services"
  echo "(12) Problem report"
  echo "(13) Exit"
  echo -e "${BOLD}Which option you want to choose? (1/2/3/4/5/6/7/8/9/10/11/12/13)${OFF}"
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/one-key-alcplugfix.sh)"
    returnMenu
    ;;

    6)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile/one-key-colorprofile.sh)"
    returnMenu
    ;;

    7)
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/one-key-cpufriend/one-key-cpufriend.sh)"
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

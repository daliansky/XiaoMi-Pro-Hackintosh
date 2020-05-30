#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 17 April, 2020
#
# Build XiaoMi-Pro EFI release
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# WorkSpaceDir
WSDir="$( cd "$(dirname "$0")" || exit; pwd -P )/build"
OUTDir="XiaoMi_Pro-local"
OUTDir_OC="XiaoMi_Pro-OC-local"

# Vars
CLEAN_UP=True
ERR_NO_EXIT=False
GH_API=True
OC_DPR=False
REMOTE=True

# Args
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --IGNORE_ERR)
    ERR_NO_EXIT=True
    shift # past argument
    ;;
    --NO_GH_API)
    GH_API=False
    shift # past argument
    ;;
    --NO_CLEAN_UP)
    CLEAN_UP=False
    shift # past argument
    ;;
    --OC_PRE_RELEASE)
    OC_DPR=True
    shift # past argument
    ;;
    *)
    shift
    ;;
  esac
done

# Colors
if [[ -z ${GITHUB_ACTIONS+x} ]]; then
  black=$(tput setaf 0)
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 4)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
  white=$(tput setaf 7)
  reset=$(tput sgr0)
  bold=$(tput bold)
fi

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from ${1}, please check your connection!"
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
}

# Exit on Copy Issue
function copyErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to copy resources!"
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
}

# Clean Up
function Cleanup() {
  if [[ ${CLEAN_UP} == True ]]; then
    rm -rf "${WSDir}"
  fi
}

# Workaround for Release Binaries that don't include "RELEASE" in their file names (head or grep)
function H_or_G() {
  if [[ "$1" == "VoodooI2C" ]]; then
    HG="head -n 1"
  elif [[ "$1" == "CloverBootloader" ]]; then
    HG="grep -m 1 CloverV2"
  elif [[ "$1" == "IntelBluetoothFirmware" ]]; then
    HG="grep -m 1 IntelBluetooth"
  elif [[ "$1" == "OpenCore-Factory" ]]; then
    HG="grep -m 2 RELEASE | tail +2"
  else
    HG="grep -m 1 RELEASE"
  fi
}

# Download GitHub Release
function DGR() {
  H_or_G "$2"
  local rawURL
  local URL

  if [[ -n ${3+x} ]]; then
    if [[ "$3" == "PreRelease" ]]; then
      tag=""
    elif [[ "$3" == "NULL" ]]; then
      tag="/latest"
    else
      if [[ -n ${GITHUB_ACTIONS+x} || $GH_API == False ]]; then
        tag="/tag/2.0.9"
      else
        # only release_id is supported
        tag="/$3"
      fi
    fi
  else
    tag="/latest"
  fi

  if [[ -n ${GITHUB_ACTIONS+x} || ${GH_API} == False ]]; then
    rawURL="https://github.com/$1/$2/releases$tag"
    URL="https://github.com$(local one=${"$(curl -L --silent "${rawURL}" | grep '/download/' | eval "${HG}" )"#*href=\"} && local two=${one%\"\ rel*} && echo ${two})"
  else
    rawURL="https://api.github.com/repos/$1/$2/releases$tag"
    URL="$(curl --silent "${rawURL}" | grep 'browser_download_url' | eval "${HG}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')"
  fi

  if [[ -z ${URL} || ${URL} == "https://github.com" ]]; then
    networkErr "$2"
  fi

  echo "${green}[${reset}${blue}${bold} Downloading ${URL##*\/} ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./"$4" || exit 1
  curl -# -L -O "${URL}" || networkErr "$2"
  cd - >/dev/null 2>&1 || exit 1
  echo "${reset}"
}

# Download GitHub Source Code
function DGS() {
  local URL="https://github.com/$1/$2/archive/master.zip"
  echo "${green}[${reset}${blue}${bold} Downloading $2.zip ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./"$3" || exit 1
  curl -# -L -o "$2.zip" "${URL}"|| networkErr "$2"
  cd - >/dev/null 2>&1 || exit 1
  echo "${reset}"
}

# Download Bitbucket Release
function DBR() {
  local Count=0
  local rawURL="https://api.bitbucket.org/2.0/repositories/$1/$2/downloads/"
  local URL
  while  [ ${Count} -lt 3 ];
  do
    URL="$(curl --silent "${rawURL}" | json_pp | grep 'href' | head -n 1 | tr -d '"' | tr -d ' ' | sed -e 's/href://')"
    if [ "${URL:(-4)}" == ".zip" ]; then
      echo "${green}[${reset}${blue}${bold} Downloading ${URL##*\/} ${reset}${green}]${reset}"
      echo "${cyan}"
      curl -# -L -O "${URL}" || networkErr "$2"
      echo "${reset}"
      return
    else
      Count=$((Count+1))
      echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Failed to download $2, ${Count} Attempt!"
      echo
    fi
  done

  if [ ${Count} -gt 2 ]; then
    # if 3 times is over and still fail to download, exit
    networkErr "$2"
  fi
}

# Download Pre-Built Binaries
function DPB() {
  local URL="https://raw.githubusercontent.com/$1/$2/master/$3"
  echo "${green}[${reset}${blue}${bold} Downloading ${3##*\/} ${reset}${green}]${reset}"
  echo "${cyan}"
  curl -# -L -O "${URL}" || networkErr "${3##*\/}"
  echo "${reset}"
}

# Exclude Trash
function CTrash() {
  if [[ ${CLEAN_UP} == True ]]; then
    find . -maxdepth 1 ! -path "./${OUTDir}" ! -path "./${OUTDir_OC}" -exec rm -rf {} +
  fi
}

# Extract files for Clover
function ExtractClover() {
  # From CloverV2 and AppleSupportPkg v2.0.9
  unzip -d "Clover" "Clover/*.zip" >/dev/null 2>&1
  cp -R "Clover/CloverV2/EFI/BOOT" "${OUTDir}/EFI/" || copyErr
  cp -R "Clover/CloverV2/EFI/CLOVER/CLOVERX64.efi" "${OUTDir}/EFI/CLOVER/" || copyErr
  cp -R "Clover/CloverV2/EFI/CLOVER/tools" "${OUTDir}/EFI/CLOVER/" || copyErr
  cp -R {Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/FileSystem/ApfsDriverLoader.efi,Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix/AptioMemoryFix.efi,Clover/CloverV2/EFI/CLOVER/drivers/UEFI/AudioDxe.efi,Clover/CloverV2/EFI/CLOVER/drivers/UEFI/FSInject.efi} "${OUTDir}/EFI/Clover/drivers/UEFI/" || copyErr
  cp -R {Clover/Drivers/AppleGenericInput.efi,Clover/Drivers/AppleUiSupport.efi} "${OUTDir}/EFI/Clover/drivers/UEFI/" || copyErr
}

# Extract files from OpenCore
function ExtractOC() {
  mkdir -p "${OUTDir_OC}/EFI/OC/Tools"
  unzip -d "OpenCore" "OpenCore/*.zip" >/dev/null 2>&1
  cp -R OpenCore/EFI/BOOT "${OUTDir_OC}/EFI/" || copyErr
  cp -R OpenCore/EFI/OC/OpenCore.efi "${OUTDir_OC}/EFI/OC/" || copyErr
  cp -R OpenCore/EFI/OC/Bootstrap "${OUTDir_OC}/EFI/OC/" || copyErr
  cp -R {OpenCore/EFI/OC/Drivers/AudioDxe.efi,OpenCore/EFI/OC/Drivers/OpenCanopy.efi,OpenCore/EFI/OC/Drivers/OpenRuntime.efi} "${OUTDir_OC}/EFI/OC/Drivers/" || copyErr
  cp -R {OpenCore/EFI/OC/Tools/CleanNvram.efi,OpenCore/EFI/OC/Tools/OpenShell.efi} "${OUTDir_OC}/EFI/OC/Tools/" || copyErr
}

# Unpack
function Unpack() {
  echo "${green}[${reset}${yellow}${bold} Unpacking ${reset}${green}]${reset}"
  echo ""
  unzip -qq "*.zip" >/dev/null 2>&1
}

# Install
function Install() {
  # Kexts
  mkdir -p "${OUTDir}/EFI/CLOVER/kexts/Other/"
  mkdir -p "${OUTDir_OC}/EFI/OC/Kexts/"

  for Kextdir in "${OUTDir}/EFI/CLOVER/kexts/Other/" "${OUTDir_OC}/EFI/OC/Kexts/"; do
    cp -R {AppleALC.kext,HibernationFixup.kext,IntelBluetoothFirmware.kext,IntelBluetoothInjector.kext,Lilu.kext,NVMeFix.kext,VoodooI2C.kext,VoodooI2CHID.kext,VoodooPS2Controller.kext,WhateverGreen.kext,hack-tools-master/kexts/EFICheckDisabler.kext,hack-tools-master/kexts/SATA-unsupported.kext,Kexts/SMCBatteryManager.kext,Kexts/SMCLightSensor.kext,Kexts/SMCProcessor.kext,Kexts/VirtualSMC.kext,Release/CodecCommander.kext,Release/NullEthernet.kext} "${Kextdir}" || copyErr
  done

  # Drivers
  mkdir -p "${OUTDir}/EFI/CLOVER/drivers/UEFI/"
  mkdir -p "${OUTDir_OC}/EFI/OC/Drivers/"

  for Driverdir in "${OUTDir}/EFI/CLOVER/drivers/UEFI/" "${OUTDir_OC}/EFI/OC/Drivers/"; do
    cp -R "OcBinaryData-master/Drivers/HfsPlus.efi" "${Driverdir}" || copyErr
  done

  cp -R VirtualSmc.efi "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr

  if [[ ${REMOTE} == True ]]; then
    cp -R XiaoMi-Pro-Hackintosh-master/wiki/AptioMemoryFix.efi "${OUTDir}" || copyErr
  else
    cp -R ../wiki/AptioMemoryFix.efi "${OUTDir}" || copyErr
  fi

  # ACPI
  mkdir -p "${OUTDir}/EFI/CLOVER/ACPI/patched/"
  mkdir -p "${OUTDir_OC}/EFI/OC/ACPI/"
  mkdir "${OUTDir}/GTX_Users_Read_This/"
  mkdir "${OUTDir_OC}/GTX_Users_Read_This/"

  for ACPIdir in "${OUTDir}/GTX_Users_Read_This/" "${OUTDir_OC}/GTX_Users_Read_This/"; do
    if [[ ${REMOTE} == True ]]; then
      cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/ACPI/patched/SSDT-LGPAGTX.aml "${ACPIdir}" || copyErr
    else
      cp -R ../EFI/CLOVER/ACPI/patched/SSDT-LGPAGTX.aml "${ACPIdir}" || copyErr
    fi
  done

  for ACPIdir in "${OUTDir}/EFI/CLOVER/ACPI/patched/" "${OUTDir_OC}/EFI/OC/ACPI/"; do
    if [[ ${REMOTE} == True ]]; then
      cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/ACPI/patched/*.aml "${ACPIdir}" || copyErr
      rm -rf "${ACPIdir}"SSDT-LGPAGTX.aml
    else
      cp -R ../EFI/CLOVER/ACPI/patched/*.aml "${ACPIdir}" || copyErr
      rm -rf "${ACPIdir}"SSDT-LGPAGTX.aml
    fi
  done

  for ACPIdir in "${OUTDir}" "${OUTDir_OC}"; do
    if [[ ${REMOTE} == True ]]; then
      cp -R XiaoMi-Pro-Hackintosh-master/wiki/*.aml "${ACPIdir}" || copyErr
    else
      cp -R ../wiki/*.aml "${ACPIdir}" || copyErr
    fi
  done

  # Theme
  if [[ ${REMOTE} == True ]]; then
    cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/themes "${OUTDir}/EFI/CLOVER/" || copyErr
  else
    cp -R ../EFI/CLOVER/themes "${OUTDir}/EFI/CLOVER/" || copyErr
  fi

  cp -R OcBinaryData-master/Resources "${OUTDir_OC}/EFI/OC/" || copyErr

  # config & README
  if [[ ${REMOTE} == True ]]; then
    cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/config.plist "${OUTDir}/EFI/CLOVER/" || copyErr
    cp -R XiaoMi-Pro-Hackintosh-master/EFI/OC/config.plist "${OUTDir_OC}/EFI/OC/" || copyErr
    cp -R {XiaoMi-Pro-Hackintosh-master/README.md,XiaoMi-Pro-Hackintosh-master/README_CN.md} "${OUTDir}" || copyErr
    cp -R {XiaoMi-Pro-Hackintosh-master/README.md,XiaoMi-Pro-Hackintosh-master/README_CN.md} "${OUTDir_OC}" || copyErr
  else
    cp -R ../EFI/CLOVER/config.plist "${OUTDir}/EFI/CLOVER/" || copyErr
    cp -R ../EFI/OC/config.plist "${OUTDir_OC}/EFI/OC/" || copyErr
    cp -R {../README.md,../README_CN.md} "${OUTDir}" || copyErr
    cp -R {../README.md,../README_CN.md} "${OUTDir_OC}" || copyErr
  fi
}

# Patch
function Patch() {
  rm -rf "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature" "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM" "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext" "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext" "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"

  cd "OcBinaryData-master/Resources/Audio/" && find . -maxdepth 1 -not -name "OCEFIAudio_VoiceOver_Boot.wav" -delete && cd "${WSDir}" || exit 1
}

# Enjoy
function Enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo ""
  open ./
}

function DL() {
  ACDT="Acidanthera"

  # Clover
  DGR CloverHackyColor CloverBootloader NULL "Clover"

  # OpenCore
  if [[ ${OC_DPR} == True ]]; then
    DGR williambj1 OpenCore-Factory PreRelease "OpenCore"
  else
    DGR ${ACDT} OpenCorePkg NULL "OpenCore"
  fi

  # Kexts
  DBR Rehabman os-x-null-ethernet
  DBR Rehabman os-x-eapd-codec-commander

  DGR ${ACDT} Lilu
  DGR ${ACDT} VirtualSMC
  DGR ${ACDT} WhateverGreen
  DGR ${ACDT} AppleALC
  DGR ${ACDT} HibernationFixup
  DGR ${ACDT} NVMeFix
  # DGR ${ACDT} VoodooInput
  DGR ${ACDT} VoodooPS2
  DGR VoodooI2C VoodooI2C
  DGR zxystd IntelBluetoothFirmware

  DGS RehabMan hack-tools

  # UEFI drivers
  DGR ${ACDT} AppleSupportPkg 19214108 "Clover"

  # UEFI
  # DPB ${ACDT} OcBinaryData Drivers/HfsPlus.efi
  DPB ${ACDT} VirtualSMC EfiDriver/VirtualSmc.efi

  # HfsPlus.efi & OC Resources
  DGS ${ACDT} OcBinaryData

  # XiaoMi-Pro ACPI patch
  if [[ ${REMOTE} == True ]]; then
    DGS daliansky XiaoMi-Pro-Hackintosh
  fi
}

function Init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  if [[ -d ${WSDir} ]]; then
    rm -rf "${WSDir}"
  fi
  mkdir "${WSDir}"
  cd "${WSDir}" || exit 1

  mkdir "${OUTDir}"
  mkdir "${OUTDir_OC}"
  mkdir "XiaoMi-Pro-Hackintosh-master"
  mkdir "Clover"
  mkdir "OpenCore"

  if [[ "$(dirname "$PWD")" =~ "XiaoMi-Pro-Hackintosh" ]]; then
    REMOTE=False;
  fi
}

function main() {
  Init
  DL
  Unpack
  Patch

  # Installation
  Install
  ExtractClover
  ExtractOC

  # Clean up
  CTrash

  # Enjoy
  Enjoy
}

main

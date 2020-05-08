#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 17 April, 2020
#
# Build XiaoMi-Pro EFI release
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# WorkSpaceDir
WSDir="$( cd "$(dirname "$0")" ; pwd -P )/build"
OUTDir="XiaoMi_Pro-local"
OUTDir_OC="XiaoMi_Pro-OC-local"

# Vars
GH_API=True
CLEAN_UP=True
REMOTE=True

# Args
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --NO_GH_API)
    GH_API=False
    shift # past argument
    ;;
    --NO_CLEAN_UP)
    CLEAN_UP=False
    shift # past argument
    ;;
    *)
    shift
    ;;
  esac
done

# Colors
if [[ -z ${GITHUB_ACTIONS+x} ]]; then
  black=`tput setaf 0`
  red=`tput setaf 1`
  green=`tput setaf 2`
  yellow=`tput setaf 3`
  blue=`tput setaf 4`
  magenta=`tput setaf 5`
  cyan=`tput setaf 6`
  white=`tput setaf 7`
  reset=`tput sgr0`
  bold=`tput bold`
fi

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from ${1}, please check your connection!"
  Cleanup
  exit 1
}

# Clean Up
function Cleanup() {
  if [[ $NO_CLEAN_UP == False ]]; then
    rm -rf $WSDir
  fi
}

# Workaround for Release Binaries that don't include "RELEASE" in their file names (head or grep)
function H_or_G() {
  if [[ "$1" == "VoodooI2C" ]]; then
    HG="head -n 1"
  elif [[ "$1" == "CloverBootloader" ]]; then
    HG="grep -m 1 CloverISO"
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
  H_or_G $2

  if [[ ! -z ${3+x} ]]; then
    if [[ "$3" == "PreRelease" ]]; then
      tag=""
    elif [[ "$3" == "NULL" ]]; then
      tag="/latest"
    else
      if [[ ! -z ${GITHUB_ACTIONS+x} || $GH_API == False ]]; then
        tag="/tag/2.0.9"
      else
        # only release_id is supported
        tag="/$3"
      fi
    fi
  else
    tag="/latest"
  fi

  if [[ ! -z ${GITHUB_ACTIONS+x} || $GH_API == False ]]; then
    local rawURL="https://github.com/$1/$2/releases$tag"
    local URL="https://github.com$(local one=${"$(curl -L --silent "${rawURL}" | grep '/download/' | eval $HG )"#*href=\"} && local two=${one%\"\ rel*} && echo $two)"
  else
    local rawURL="https://api.github.com/repos/$1/$2/releases$tag"
    local URL="$(curl --silent "${rawURL}" | grep 'browser_download_url' | eval $HG | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')"
  fi

  if [[ -z $URL || $URL == "https://github.com" ]]; then
    networkErr $2
  fi

  echo "${green}[${reset}${blue}${bold} Downloading $(echo ${URL##*\/}) ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./$4
  curl -# -L -O "${URL}" || networkErr $2
  cd - >/dev/null 2>&1
  echo "${reset}"
}

# Download GitHub Source Code
function DGS() {
  local URL="https://github.com/$1/$2/archive/master.zip"
  echo "${green}[${reset}${blue}${bold} Downloading $2.zip ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./$3
  curl -# -L -o "$2.zip" "${URL}"|| networkErr $2
  cd - >/dev/null 2>&1
  echo "${reset}"
}

# Download Bitbucket Release
function DBR() {
  local Count=0
  local rawURL="https://api.bitbucket.org/2.0/repositories/$1/$2/downloads/"
  while  [ ${Count} -lt 3 ];
  do
    local URL="$(curl --silent "${rawURL}" | json_pp | grep 'href' | head -n 1 | tr -d '"' | tr -d ' ' | sed -e 's/href://')"
    if [ ${URL:(-4)} == ".zip" ]; then
      echo "${green}[${reset}${blue}${bold} Downloading $(echo ${URL##*\/}) ${reset}${green}]${reset}"
      echo "${cyan}"
      curl -# -L -O "${URL}" || networkErr $2
      echo "${reset}"
      return
    else
      Count=$((Count+1))
      echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Failed to download ${2}, ${Count} Attempt!"
      echo
    fi
  done

  if [ ${Count} -gt 2 ]; then
    # if 3 times is over and still fail to download, exit
    networkErr $2
  fi
}

# Download Pre-Built Binaries
function DPB() {
  local URL="https://raw.githubusercontent.com/$1/$2/master/$3"
  echo "${green}[${reset}${blue}${bold} Downloading $(echo ${3##*\/}) ${reset}${green}]${reset}"
  echo "${cyan}"
  curl -# -L -O "${URL}" || networkErr ${3##*\/}
  echo "${reset}"
}

# Exclude Trash
function CTrash() {
  ls | grep -v "$OUTDir\|$OUTDir_OC" | xargs rm -rf
}

# Extract files for Clover
function ExtractClover() {
  mkdir -p "$OUTDir/EFI/BOOT/"
  mkdir -p "$OUTDir/EFI/Clover/tools/"
  # From CloverISO
  tar --lzma -xvf Clover/CloverISO*.tar.lzma >/dev/null 2>&1
  hdiutil mount Clover-*.iso >/dev/null 2>&1
  ImageMountDir="$(dirname /Volumes/Clover-*/EFI/CLOVER)/CLOVER"
  cp -R "$ImageMountDir"/../BOOT/BOOTX64.efi "$OUTDir/EFI/BOOT/"
  cp -R "$ImageMountDir"/CLOVERX64.efi "$OUTDir/EFI/Clover/"
  cp -R "$ImageMountDir"/tools/*.efi "$OUTDir/EFI/Clover/tools/"

  for CLOVERdotEFIdrv in ApfsDriverLoader AptioMemoryFix; do
    cp -R "$ImageMountDir"/drivers/off/${CLOVERdotEFIdrv}.efi "$OUTDir/EFI/Clover/drivers/UEFI/"
  done

  for CLOVERdotEFIdrv in AudioDxe FSInject; do
    cp -R "$ImageMountDir"/drivers/UEFI/${CLOVERdotEFIdrv}.efi "$OUTDir/EFI/Clover/drivers/UEFI/"
  done

  hdiutil unmount "$(dirname /Volumes/Clover-*/EFI)" >/dev/null 2>&1

  # From AppleSupportPkg 2.0.9
  unzip -d "Clover" "Clover/*.zip" >/dev/null 2>&1

  for CLOVERdotEFIdrvASPKG in AppleGenericInput AppleUiSupport; do
    cp -R Clover/Drivers/${CLOVERdotEFIdrvASPKG}.efi "$OUTDir/EFI/Clover/drivers/UEFI"
  done
}

# Extract files from OpenCore
function ExtractOC() {
  mkdir -p "$OUTDir_OC/EFI/OC/Tools"
  unzip -d "OpenCore" "OpenCore/*.zip" >/dev/null 2>&1
  cp -R OpenCore/EFI/BOOT "$OUTDir_OC/EFI/"
  cp -R OpenCore/EFI/OC/OpenCore.efi "$OUTDir_OC/EFI/OC/"
  cp -R OpenCore/EFI/OC/Bootstrap "$OUTDir_OC/EFI/OC/"
  cp -R {OpenCore/EFI/OC/Drivers/OpenRuntime.efi,OpenCore/EFI/OC/Drivers/OpenCanopy.efi,OpenCore/Drivers/AudioDxe.efi} "$OUTDir_OC/EFI/OC/Drivers/"
  cp -R {OpenCore/EFI/OC/Tools/CleanNvram.efi,OpenCore/EFI/OC/Tools/OpenShell.efi} "$OUTDir_OC/EFI/OC/Tools/"
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
  mkdir -p "$OUTDir/EFI/CLOVER/kexts/Other/"
  mkdir -p "$OUTDir_OC/EFI/OC/Kexts/"

  for Kextdir in "$OUTDir/EFI/CLOVER/kexts/Other/" "$OUTDir_OC/EFI/OC/Kexts/"; do
    cp -R {AppleALC.kext,HibernationFixup.kext,IntelBluetoothFirmware.kext,IntelBluetoothInjector.kext,Lilu.kext,NVMeFix.kext,VoodooI2C.kext,VoodooI2CHID.kext,VoodooPS2Controller.kext,WhateverGreen.kext,hack-tools-master/kexts/EFICheckDisabler.kext,hack-tools-master/kexts/SATA-unsupported.kext,Kexts/SMCBatteryManager.kext,Kexts/SMCLightSensor.kext,Kexts/SMCProcessor.kext,Kexts/VirtualSMC.kext,Release/CodecCommander.kext,Release/NullEthernet.kext} "$Kextdir"
  done

  # Drivers
  mkdir -p "$OUTDir/EFI/CLOVER/drivers/UEFI/"
  mkdir -p "$OUTDir_OC/EFI/OC/Drivers/"

  for Driverdir in "$OUTDir/EFI/CLOVER/drivers/UEFI/" "$OUTDir_OC/EFI/OC/Drivers/"; do
    cp -R "OcBinaryData-master/Drivers/HfsPlus.efi" "$Driverdir"
  done

  cp -R VirtualSmc.efi "$OUTDir/EFI/CLOVER/drivers/UEFI/"

  if [[ $REMOTE == True ]]; then
    cp -R XiaoMi-Pro-Hackintosh-master/wiki/AptioMemoryFix.efi "$OUTDir/"
  else
    cp -R ../wiki/AptioMemoryFix.efi "$OUTDir/"
  fi

  # ACPI
  mkdir -p "$OUTDir/EFI/CLOVER/ACPI/patched/"
  mkdir -p "$OUTDir_OC/EFI/OC/ACPI/"
  mkdir "$OUTDir/GTX_Users_Read_This/"
  mkdir "$OUTDir_OC/GTX_Users_Read_This/"

  for ACPIdir in "$OUTDir/GTX_Users_Read_This/" "$OUTDir_OC/GTX_Users_Read_This/"; do
    if [[ $REMOTE == True ]]; then
      cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/ACPI/patched/SSDT-LGPAGTX.aml "$ACPIdir"
    else
      cp -R ../EFI/CLOVER/ACPI/patched/SSDT-LGPAGTX.aml "$ACPIdir"
    fi
  done

  for ACPIdir in "$OUTDir/EFI/CLOVER/ACPI/patched/" "$OUTDir_OC/EFI/OC/ACPI/"; do
    if [[ $REMOTE == True ]]; then
      cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/ACPI/patched/*.aml "$ACPIdir"
      rm -rf "$ACPIdir"SSDT-LGPAGTX.aml
    else
      cp -R ../EFI/CLOVER/ACPI/patched/*.aml "$ACPIdir"
      rm -rf "$ACPIdir"SSDT-LGPAGTX.aml
    fi
  done

  for ACPIdir in "$OUTDir/" "$OUTDir_OC/"; do
    if [[ $REMOTE == True ]]; then
      cp -R XiaoMi-Pro-Hackintosh-master/wiki/*.aml "$ACPIdir"
    else
      cp -R ../wiki/*.aml "$ACPIdir"
    fi
  done

  # Theme
  if [[ $REMOTE == True ]]; then
    cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/themes "$OUTDir/EFI/CLOVER/"
  else
    cp -R ../EFI/CLOVER/themes "$OUTDir/EFI/CLOVER/"
  fi

  cp -R OcBinaryData-master/Resources "$OUTDir_OC/EFI/OC/"

  # config & README
  if [[ $REMOTE == True ]]; then
    cp -R XiaoMi-Pro-Hackintosh-master/EFI/CLOVER/config.plist "$OUTDir/EFI/CLOVER/"
    cp -R XiaoMi-Pro-Hackintosh-master/EFI/OC/config.plist "$OUTDir_OC/EFI/OC/"
    cp -R {XiaoMi-Pro-Hackintosh-master/README.md,XiaoMi-Pro-Hackintosh-master/README_CN.md} "$OUTDir/"
    cp -R {XiaoMi-Pro-Hackintosh-master/README.md,XiaoMi-Pro-Hackintosh-master/README_CN.md} "$OUTDir_OC/"
  else
    cp -R ../EFI/CLOVER/config.plist "$OUTDir/EFI/CLOVER/"
    cp -R ../EFI/OC/config.plist "$OUTDir_OC/EFI/OC/"
    cp -R {../README.md,../README_CN.md} "$OUTDir/"
    cp -R {../README.md,../README_CN.md} "$OUTDir_OC/"
  fi
}

# Patch
function Patch() {
  rm -rf "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature" "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM" "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext" "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext" "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"

  cd "OcBinaryData-master/Resources/Audio/" && ls | grep -v "OCEFIAudio_VoiceOver_Boot.wav" | xargs rm && cd $WSDir
}

# Enjoy
function Enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo ""
  open ./
}

function DL() {
  ACDT="Acidanthera"

  # Kexts
  DGR $ACDT Lilu
  DGR $ACDT VirtualSMC
  DGR $ACDT WhateverGreen
  DGR $ACDT AppleALC
  DGR $ACDT HibernationFixup
  DGR $ACDT NVMeFix
  # DGR $ACDT VoodooInput
  DGR $ACDT VoodooPS2
  DGR alexandred VoodooI2C
  DGR zxystd IntelBluetoothFirmware

  DBR Rehabman os-x-null-ethernet
  DBR Rehabman os-x-eapd-codec-commander

  DGS RehabMan hack-tools

  # UEFI drivers
  DGR $ACDT AppleSupportPkg NULL "OpenCore"
  DGR $ACDT AppleSupportPkg 19214108 "Clover"

  # Clover
  DGR CloverHackyColor CloverBootloader NULL "Clover"

  # OpenCore
  # DGR williambj1 OpenCore-Factory PreRelease "OpenCore"
  DGR $ACDT OpenCorePkg NULL "OpenCore"

  # UEFI
  # DPB $ACDT OcBinaryData Drivers/HfsPlus.efi
  DPB $ACDT VirtualSMC EfiDriver/VirtualSmc.efi

  # HfsPlus.efi & OC Resources
  DGS $ACDT OcBinaryData

  # XiaoMi-Pro ACPI patch
  if [[ $REMOTE == True ]]; then
    DGS daliansky XiaoMi-Pro-Hackintosh
  fi
}

function Init() {
  if [[ $OSTYPE != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  if [[ -d $WSDir ]]; then
    rm -rf $WSDir
  fi
  mkdir $WSDir
  cd $WSDir

  mkdir $OUTDir
  mkdir $OUTDir_OC
  mkdir "XiaoMi-Pro-Hackintosh-master"
  mkdir "Clover"
  mkdir "OpenCore"

  if [[ $(echo $(dirname "$PWD")) =~ "XiaoMi-Pro-Hackintosh" ]]; then
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

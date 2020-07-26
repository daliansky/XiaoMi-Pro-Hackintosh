#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 6 Jun, 2020
#
# Download kexts for XiaoMi-Pro EFI
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# Vars
ACDT="Acidanthera"

# Colors
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

# WorkSpaceDir
WSDir="$( cd "$(dirname "$0")" || exit 1; pwd -P )/download"

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from ${1}, please check your connection!"
  exit 1
}

# Exit on Copy Issue
function copyErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to copy resources!"
  cd ../ || exit 1
  find . -maxdepth 1 -name "*.kext" -exec rm -rf {} + >/dev/null 2>&1
  rm -rf "download"
  exit 1
}

function init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  if [[ -d ${WSDir} ]]; then
    rm -rf "${WSDir}"
  fi
  mkdir "${WSDir}" || exit 1
  cd "${WSDir}" || exit 1
}

# Workaround for Release Binaries that don't include "RELEASE" in their file names (head or grep)
function H_or_G() {
  if [[ "$1" == "VoodooI2C" ]]; then
    HG="head -n 1"
  elif [[ "$1" == "CloverBootloader" ]]; then
    HG="grep -m 1 CloverV2"
  elif [[ "$1" == "IntelBluetoothFirmware" ]]; then
    HG="grep -m 1 IntelBluetooth"
  else
    HG="grep -m 1 RELEASE"
  fi
}

# Download GitHub Release
function DGR() {
  local rawURL
  local URL

  H_or_G "$2"

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
    URL="https://github.com$(curl -L --silent "${rawURL}" | grep '/download/' | eval "${HG}" | sed 's/^[^"]*"\([^"]*\)".*/\1/')"
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

function DL() {
  local rmKexts=(
    os-x-eapd-codec-commander
    os-x-null-ethernet
  )

  local acdtKexts=(
    VirtualSMC
    WhateverGreen
    AppleALC
    HibernationFixup
    NVMeFix
    VoodooPS2
    Lilu
  )

  for rmKext in "${rmKexts[@]}"; do
    DBR Rehabman "${rmKext}"
  done

  for acdtKext in "${acdtKexts[@]}"; do
    DGR ${ACDT} "${acdtKext}"
  done

  DGR VoodooI2C VoodooI2C
  DGR OpenIntelWireless IntelBluetoothFirmware

  DGS RehabMan hack-tools
}

# Unpack
function Unpack() {
  echo "${green}[${reset}${yellow}${bold} Unpacking ${reset}${green}]${reset}"
  echo
  unzip -qq "*.zip" >/dev/null 2>&1
}

# Patch
function Patch() {
  local unusedItems=(
    "IntelBluetoothInjector.kext/Contents/_CodeSignature"
    "Release/CodecCommander.kext/Contents/Resources"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"
  )
  for unusedItem in "${unusedItems[@]}"; do
    rm -rf "${unusedItem}" >/dev/null 2>&1
  done
}

# Install
function Install() {
  find ../ -maxdepth 1 -name "*.kext" -exec rm -rf {} + >/dev/null 2>&1

  local kextItems=(
    "AppleALC.kext"
    "HibernationFixup.kext"
    "IntelBluetoothFirmware.kext"
    "IntelBluetoothInjector.kext"
    "Lilu.kext"
    "NVMeFix.kext"
    "VoodooI2C.kext"
    "VoodooI2CHID.kext"
    "VoodooPS2Controller.kext"
    "WhateverGreen.kext"
    "hack-tools-master/kexts/EFICheckDisabler.kext"
    "hack-tools-master/kexts/SATA-unsupported.kext"
    "Kexts/SMCBatteryManager.kext"
    "Kexts/SMCLightSensor.kext"
    "Kexts/SMCProcessor.kext"
    "Kexts/VirtualSMC.kext"
    "Release/CodecCommander.kext"
    "Release/NullEthernet.kext"
  )

  for kextItem in "${kextItems[@]}"; do
    cp -R "${kextItem}" "../" || copyErr
  done
}

# Exclude Trash
function CTrash() {
  cd ../ || exit 1
  rm -rf "download"
}

function enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
  open ./
}

function main() {
  init
  DL
  Unpack
  Patch
  Install
  CTrash
  enjoy
}

main

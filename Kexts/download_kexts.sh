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
FRWF="0xFireWolf"
OIW="OpenIntelWireless"
RETRY_MAX=5

download_mode="RELEASE"
gh_api=false

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
OUTDir="download"
OUTDir_TMP="tmp"
WSDir="$( cd "$(dirname "$0")" || exit 1; pwd -P )/${OUTDir}"

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from ${1}, please check your connection!"
  exit 1
}

# Exit on Copy Issue
function copyErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to copy resources!"
  cd ../../ || exit 1
  rm -rf "${OUTDir}"
  exit 1
}

function init() {
  local dirs=(
    "Big Sur"
    "Catalina"
    "Monterey"
    "Sonoma"
    "Ventura"
  )

  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  if [[ -d ${WSDir} ]]; then
    rm -rf "${WSDir}"
  fi
  mkdir "${WSDir}" || exit 1
  cd "${WSDir}" || exit 1

  if [[ -d ${OUTDir_TMP} ]]; then
    rm -rf "${OUTDir_TMP}"
  fi
  mkdir "${OUTDir_TMP}" || exit 1

  for dir in "${dirs[@]}"; do
    mkdir -p "${OUTDir_TMP}/${dir}" || exit 1
  done
}

# Workaround for Release Binaries that don't include "RELEASE" in their file names (head or grep)
function h_or_g() {
  if [[ "$1" == "VoodooI2C" ]]; then
    hgs=( "head -n 1" )
  elif [[ "$1" == "EAPD-Codec-Commander" ]]; then
    hgs=( "grep -m 2 CodecCommander | grep -m 1 ${download_mode}" )
  elif [[ "$1" == "IntelBluetoothFirmware" ]]; then
    hgs=( "grep -m 1 IntelBluetooth" )
  elif [[ "$1" == "itlwm" ]]; then
    hgs=( "grep -m 1 BigSur"
          "grep -m 1 Catalina"
          "grep -m 1 Monterey"
          "grep -m 1 Sonoma14.0"
          "grep -m 1 Sonoma14.4"
          "grep -m 1 Ventura"
        )
  elif [[ "$1" == "NoTouchID" ]]; then
    hgs=( "grep -m 1 RELEASE" )
  else
    hgs=( "grep -m 1 ${download_mode}" )
  fi
}

# Download GitHub Release
function dGR() {
  local rawURL
  local urls=()

  h_or_g "$2"

  if [[ -n ${3+x} ]]; then
    if [[ "$3" == "PreRelease" ]]; then
    # FIXME: New GitHub lazy load makes it hard to extract pre-release, and I have not figured it out
      tag=""
    elif [[ "$3" == "NULL" ]]; then
      tag="/latest"
    else
      # only release_id is supported
      tag="/$3"
    fi
  else
    tag="/latest"
  fi

  if [[ -n ${GITHUB_ACTIONS+x} || ${gh_api} == false ]]; then
    rawURL="https://github.com/$1/$2/releases$tag"
    for hg in "${hgs[@]}"; do
      rawURL=$(curl -Ls -o /dev/null -w "%{url_effective}" "${rawURL}" | sed 's/releases\/tag/releases\/expanded_assets/')
      urls+=( "https://github.com$(curl -L --silent "${rawURL}" | grep '/download/' | eval "${hg}" | sed 's/^[^"]*"\([^"]*\)".*/\1/')" )
    done
  else
    rawURL="https://api.github.com/repos/$1/$2/releases$tag"
    for hg in "${hgs[@]}"; do
      urls+=( "$(curl --silent "${rawURL}" | grep 'browser_download_url' | eval "${hg}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')" )
    done
  fi

  for url in "${urls[@]}"; do
    if [[ -z ${url} || ${url} == "https://github.com" ]]; then
      networkErr "$2"
    fi
    echo "${green}[${reset}${blue}${bold} Downloading ${url##*\/} ${reset}${green}]${reset}"
    echo "${cyan}"
    cd ./"$4" || exit 1
    curl -# -L -O "${url}" || networkErr "$2"
    cd - > /dev/null 2>&1 || exit 1
    echo "${reset}"
  done
}

# Download GitHub Source Code
function dGS() {
  local url="https://github.com/$1/$2/archive/master.zip"
  echo "${green}[${reset}${blue}${bold} Downloading $2.zip ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./"$3" || exit 1
  curl -# -L -o "$2.zip" "${url}"|| networkErr "$2"
  cd - > /dev/null 2>&1 || exit 1
  echo "${reset}"
}

# Download Bitbucket Release
function dBR() {
  local count=0
  local rawURL="https://api.bitbucket.org/2.0/repositories/$1/$2/downloads/"
  local url

  while [ ${count} -lt ${RETRY_MAX} ];
  do
    url="$(curl --silent "${rawURL}" | json_pp | grep 'href' | head -n 1 | tr -d '"' | tr -d ' ' | sed -e 's/href://')"
    if [ "${url:(-4)}" == ".zip" ]; then
      echo "${green}[${reset}${blue}${bold} Downloading ${url##*\/} ${reset}${green}]${reset}"
      echo "${cyan}"
      cd ./"$3" || exit 1
      curl -# -L -O "${url}" || networkErr "$2"
      cd - > /dev/null 2>&1 || exit 1
      echo "${reset}"
      return
    else
      count=$((count+1))
      echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Failed to download $2, ${count} Attempt!"
      echo
    fi
  done

  if [ ${count} -ge ${RETRY_MAX} ]; then
    # if ${RETRY_MAX} times are over and still fail to download, exit
    networkErr "$2"
  fi
}

function download() {
  local acdtKexts=(
    VirtualSMC
    WhateverGreen
    AppleALC
    HibernationFixup
    RestrictEvents
    VoodooPS2
    BrcmPatchRAM
    Lilu
  )

  local frwfKexts=(
    RealtekCardReader
    RealtekCardReaderFriend
  )

  local oiwKexts=(
    IntelBluetoothFirmware
    itlwm
  )

  dBR Rehabman os-x-null-ethernet "${OUTDir_TMP}"

  for acdtKext in "${acdtKexts[@]}"; do
    dGR ${ACDT} "${acdtKext}" NULL "${OUTDir_TMP}"
  done

# for frwfKext in "${frwfKexts[@]}"; do
#   dGR ${FRWF} "${frwfKext}" NULL "${OUTDir_TMP}"
# done

  for oiwKext in "${oiwKexts[@]}"; do
    dGR ${OIW} "${oiwKext}" NULL "${OUTDir_TMP}"
  done

  dGR Sniki EAPD-Codec-Commander NULL "${OUTDir_TMP}"

  dGR VoodooI2C VoodooI2C NULL "${OUTDir_TMP}"

  dGR al3xtjames NoTouchID NULL "${OUTDir_TMP}"
}

# Unpack
function unpack() {
  echo "${green}[${reset}${yellow}${bold} Unpacking ${reset}${green}]${reset}"
  # Unzip non-standard AirportItlwm release packages
  (cd "${OUTDir_TMP}" && unzip -qq -d "Big Sur" "*BigSur*.zip" && rm -- *BigSur*.zip || echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: AirportItlwm has non-standard packages location!")
  (cd "${OUTDir_TMP}" && unzip -qq -d "Catalina" "*Catalina*.zip" && rm -- *Catalina*.zip || echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: AirportItlwm has non-standard packages location!")
  (cd "${OUTDir_TMP}" && unzip -qq -d "Monterey" "*Monterey*.zip" && rm -- *Monterey*.zip || echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: AirportItlwm has non-standard packages location!")
  (cd "${OUTDir_TMP}" && unzip -qq -d "Sonoma14.0" "*Sonoma14.0*.zip" && rm -- *Sonoma14.0*.zip || echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: AirportItlwm has non-standard packages location!")
  (cd "${OUTDir_TMP}" && unzip -qq -d "Sonoma14.4" "*Sonoma14.4*.zip" && rm -- *Sonoma14.4*.zip || echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: AirportItlwm has non-standard packages location!")
  (cd "${OUTDir_TMP}" && unzip -qq -d "Ventura" "*Ventura*.zip" && rm -- *Ventura*.zip || echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: AirportItlwm has non-standard packages location!")

  eval "$(cd ${OUTDir_TMP} && unzip -qq "*.zip" || exit 1)"
  echo
}

# Patch
function patch() {
  local unusedItems=(
    "BlueToolFixup.kext/Contents/_CodeSignature"
    "CodecCommander.kext/Contents/Resources"
    "HibernationFixup.kext/Contents/_CodeSignature"
    "Kexts/SMCBatteryManager.kext/Contents/Resources"
  # "RealtekCardReader.kext/Contents/_CodeSignature"
  # "RealtekCardReader.kext/Contents/Resources"
  # "RealtekCardReaderFriend.kext/Contents/_CodeSignature"
  # "RealtekCardReaderFriend.kext/Contents/Resources"
    "RestrictEvents.kext/Contents/_CodeSignature"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"
    "WhateverGreen.kext/Contents/_CodeSignature"
  )
  for unusedItem in "${unusedItems[@]}"; do
    rm -rf "${unusedItem}" > /dev/null 2>&1
  done

  # Rename AirportItlwm.kexts based on different versions
  mv "${OUTDir_TMP}/Big Sur/AirportItlwm.kext" "${OUTDir_TMP}/Big Sur/AirportItlwm_Big_Sur.kext" || exit 1
  mv "${OUTDir_TMP}/Catalina/AirportItlwm.kext" "${OUTDir_TMP}/Catalina/AirportItlwm_Catalina.kext" || exit 1
  mv "${OUTDir_TMP}/Monterey/AirportItlwm.kext" "${OUTDir_TMP}/Monterey/AirportItlwm_Monterey.kext" || exit 1
  mv "${OUTDir_TMP}/Sonoma14.0/AirportItlwm.kext" "${OUTDir_TMP}/Sonoma14.0/AirportItlwm_Sonoma140.kext" || exit 1
  mv "${OUTDir_TMP}/Sonoma14.4/AirportItlwm.kext" "${OUTDir_TMP}/Sonoma14.4/AirportItlwm_Sonoma144.kext" || exit 1
  mv "${OUTDir_TMP}/Ventura/AirportItlwm.kext" "${OUTDir_TMP}/Ventura/AirportItlwm_Ventura.kext" || exit 1
}

# Install
function install() {
  local kextItems=(
    "AppleALC.kext"
    "BlueToolFixup.kext"
    "CodecCommander.kext"
    "HibernationFixup.kext"
    "IntelBluetoothFirmware.kext"
    "IntelBluetoothInjector.kext"
    "IntelBTPatcher.kext"
    "Kexts/SMCBatteryManager.kext"
    "Kexts/SMCLightSensor.kext"
    "Kexts/SMCProcessor.kext"
    "Kexts/VirtualSMC.kext"
    "Lilu.kext"
    "NoTouchID.kext"
  # "RealtekCardReader.kext"
  # "RealtekCardReaderFriend.kext"
    "Release/NullEthernet.kext"
    "RestrictEvents.kext"
    "VoodooI2C.kext"
    "VoodooI2CHID.kext"
    "VoodooPS2Controller.kext"
    "WhateverGreen.kext"
    "Big Sur/AirportItlwm_Big_Sur.kext"
    "Catalina/AirportItlwm_Catalina.kext"
    "Monterey/AirportItlwm_Monterey.kext"
    "Sonoma14.0/AirportItlwm_Sonoma140.kext"
    "Sonoma14.4/AirportItlwm_Sonoma144.kext"
    "Ventura/AirportItlwm_Ventura.kext"
  )

  for kextItem in "${kextItems[@]}"; do
    cp -R "${OUTDir_TMP}/${kextItem}" . || copyErr
  done
}

# Exclude Trash
function cTrash() {
  rm -rf "${OUTDir_TMP}"
}

function enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
  open ./
}

function main() {
  init
  download
  unpack
  patch
  install
  cTrash
  enjoy
}

main

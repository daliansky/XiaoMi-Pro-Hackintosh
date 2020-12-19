#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 17 April, 2020
#
# Build XiaoMi-Pro EFI release
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# Expected repository structure
# .{REPO_NAME}
# |____ACPI
# | |____SSDT-ALS0.aml
# | |____SSDT-DDGPU.aml
# | |____SSDT-DMAC.aml
# | |____SSDT-EC.aml
# | |____SSDT-GPRW.aml
# | |____SSDT-HPET.aml
# | |____SSDT-LGPA.aml
# | |____SSDT-LGPAGTX.aml
# | |____SSDT-MCHC.aml
# | |____SSDT-MEM2.aml
# | |____SSDT-PMC.aml
# | |____SSDT-PNLF.aml
# | |____SSDT-PS2K.aml
# | |____SSDT-RMNE.aml
# | |____SSDT-TPD0.aml
# | |____SSDT-USB-ALL.aml
# | |____SSDT-USB-FingerBT.aml
# | |____SSDT-USB-USBBT.aml
# | |____SSDT-USB-WLAN_LTEBT.aml
# | |____SSDT-USB.aml
# | |____SSDT-XCPM.aml
# |____ALCPlugFix
# | |____ALCPlugFix
# | | |____alc_fix
# | | | |____good.win.ALCPlugFix.plist
# | | | |____hda-verb
# | | | |____install.sh
# | | |____build
# | | | |____Release
# | | | | |____ALCPlugFix
# | | |____README.MD
# |____CLOVER
# | |____themes
# | |____config.plist
# |____Docs
# | |____Drive-Native-Intel-Wireless-Card.pdf
# | |____FAQ.pdf
# | |____README_CN_GTX.txt
# | |____README_GTX.txt
# | |____Set-DVMT-to-64mb.pdf
# | |____Unlock-0xE2-MSR.pdf
# | |____Work-Around-with-Bluetooth.pdf
# |____OC
# | |____config.plist
# |____Changelog.md
# |____LICENSE
# |____README.md
# |____README_CN.md
# |____makefile.sh *

# Vars
ACDT="Acidanthera"
CLEAN_UP=True
ERR_NO_EXIT=False
GH_API=True
LANGUAGE="EN"
NO_XCODE=False
OIW="OpenIntelWireless"
PRE_RELEASE=""
REMOTE=True
REPO_NAME="XiaoMi-Pro-Hackintosh"
REPO_BRANCH="main"
REPO_NAME_BRANCH="${REPO_NAME}-${REPO_BRANCH}"
RETRY_MAX=5
VERSION="local"

# Env
if [ "$(which xcodebuild)" = "" ] || [ "$(which git)" = "" ]; then
  NO_XCODE=True
fi

if [[ "${DEVELOPER_DIR}" = "" ]]; then
  DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

# Args
while [[ $# -gt 0 ]]; do
  key="$1"

  case "${key}" in
    --IGNORE_ERR)
    ERR_NO_EXIT=True
    shift # past argument
    ;;
    --LANG=CN)
    LANGUAGE="CN"
    shift # past argument
    ;;
    --NO_CLEAN_UP)
    CLEAN_UP=False
    shift # past argument
    ;;
    --NO_GH_API)
    GH_API=False
    shift # past argument
    ;;
    *)
    if [[ "${key}" =~ "--VERSION=" ]]; then
      VERSION="${key##*=}"
      shift
    elif [[ "${key}" =~ "--PRE_RELEASE=" ]]; then
      PRE_RELEASE+="${key##*=}"
      shift
    else
      shift
    fi
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

# WorkSpaceDir
WSDir="$( cd "$(dirname "$0")" || exit 1; pwd -P )/build"
OUTDir="XiaoMi_Pro-${VERSION}"
OUTDir_OC="XiaoMi_Pro-OC-${VERSION}"

# Kexts
rmKexts=(
  os-x-eapd-codec-commander
  os-x-null-ethernet
)

# Require Lilu to be the last for BKext()
acdtKexts=(
  VirtualSMC
  WhateverGreen
  AppleALC
  HibernationFixup
  RestrictEvents
  VoodooPS2
  Lilu
)

oiwKexts=(
  IntelBluetoothFirmware
  itlwm
)

# Clean Up
function Cleanup() {
  if [[ ${CLEAN_UP} == True ]]; then
    rm -rf "${WSDir}"
  fi
}

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from $1, please check your connection!"
  echo
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
}

# Exit on Copy Issue
function copyErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to copy resources!"
  echo
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
}

# Exit on Build Issue
function buildErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to build $1!"
  echo
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
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
  mkdir "${WSDir}" || exit 1
  cd "${WSDir}" || exit 1

  local dirs=(
    "${OUTDir}"
    "${OUTDir_OC}"
    "Clover"
    "Clover/AppleSupportPkg_209"
    "Clover/AppleSupportPkg_216"
    "OpenCore"
  )
  for dir in "${dirs[@]}"; do
    mkdir -p "${dir}" || exit 1
  done
  if [[ ${REMOTE} == True ]]; then
    mkdir -p "${REPO_NAME_BRANCH}" || exit 1
  fi

  if [[ "$(dirname "$PWD")" =~ ${REPO_NAME} ]]; then
    REMOTE=False;
  fi
}

# Workaround for Release Binaries that don't include "RELEASE" in their file names (head or grep)
function H_or_G() {
  if [[ "$1" == "VoodooI2C" ]]; then
    HGs=( "head -n 1" )
  elif [[ "$1" == "CloverBootloader" ]]; then
    HGs=( "grep -m 1 CloverV2" )
  elif [[ "$1" == "IntelBluetoothFirmware" ]]; then
    HGs=( "grep -m 1 IntelBluetooth" )
  elif [[ "$1" == "itlwm" ]]; then
    HGs=( "grep -m 1 AirportItlwm-Big_Sur"
          "grep -m 1 AirportItlwm-Catalina"
          "grep -m 1 AirportItlwm-High_Sierra"
          "grep -m 1 AirportItlwm-Mojave"
        )
  else
    HGs=( "grep -m 1 RELEASE" )
  fi
}

# Download GitHub Release
function DGR() {
  local rawURL
  local URLs=()

  H_or_G "$2"

  if [[ -n ${3+x} ]]; then
    if [[ "$3" == "PreRelease" ]]; then
      tag=""
    elif [[ "$3" == "NULL" ]]; then
      tag="/latest"
    else
      if [[ -n ${GITHUB_ACTIONS+x} || $GH_API == False ]]; then
        if [[ "$2" == "AppleSupportPkg_209" ]]; then
          tag="/tag/2.0.9"
        elif [[ "$2" == "AppleSupportPkg_216" ]]; then
          tag="/tag/2.1.6"
        fi
      else
        # only release_id is supported
        tag="/$3"
      fi
    fi
  else
    tag="/latest"
  fi

  if [[ -n ${GITHUB_ACTIONS+x} || ${GH_API} == False ]]; then
    if [[ "$2" == "AppleSupportPkg_209" || "$2" == "AppleSupportPkg_216" ]]; then
      rawURL="https://github.com/$1/AppleSupportPkg/releases$tag"
    else
      rawURL="https://github.com/$1/$2/releases$tag"
    fi
    for HG in "${HGs[@]}"; do
      URLs+=( "https://github.com$(curl -L --silent "${rawURL}" | grep '/download/' | eval "${HG}" | sed 's/^[^"]*"\([^"]*\)".*/\1/')" )
    done
  else
    if [[ "$2" == "AppleSupportPkg_209" || "$2" == "AppleSupportPkg_216" ]]; then
      rawURL="https://api.github.com/repos/$1/AppleSupportPkg/releases$tag"
    else
      rawURL="https://api.github.com/repos/$1/$2/releases$tag"
    fi
    for HG in "${HGs[@]}"; do
      URLs+=( "$(curl --silent "${rawURL}" | grep 'browser_download_url' | eval "${HG}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')" )
    done
  fi

  for URL in "${URLs[@]}"; do
    if [[ -z ${URL} || ${URL} == "https://github.com" ]]; then
      networkErr "$2"
    fi
    echo "${green}[${reset}${blue}${bold} Downloading ${URL##*\/} ${reset}${green}]${reset}"
    echo "${cyan}"
    cd ./"$4" || exit 1
    curl -# -L -O "${URL}" || networkErr "$2"
    cd - >/dev/null 2>&1 || exit 1
    echo "${reset}"
  done
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

  while [ ${Count} -lt ${RETRY_MAX} ];
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

  if [ ${Count} -ge ${RETRY_MAX} ]; then
    # if ${RETRY_MAX} times are over and still fail to download, exit
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

# Build Pre-release Kexts
function BKextHelper() {
  local liluPlugins="AppleALC HibernationFixup WhateverGreen RestrictEvents VirtualSMC"
  local voodooinputPlugins="VoodooI2C VoodooPS2"
  local PATH_TO_DBG_BIG="Build/Products/Debug/"
  local PATH_TO_REL="build/Release/"
  local PATH_TO_REL_BIG="Build/Products/Release/"
  local PATH_TO_REL_SMA="build/Products/Release/"
  local lineNum

  echo "${green}[${reset}${blue}${bold} Building $2 ${reset}${green}]${reset}"
  echo
  git clone --depth=1 https://github.com/"$1"/"$2".git >/dev/null 2>&1
  cd "$2" || exit 1
  if [[ ${liluPlugins} =~ $2 ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    cp -R "../Lilu.kext" "./" || copyErr
    if [[ "$2" == "VirtualSMC" ]]; then
      xcodebuild -jobs 1 -target Package -configuration Release >/dev/null 2>&1 || buildErr "$2"
      mkdir ../Kexts
      cp -R ${PATH_TO_REL}*.kext "../Kexts/" || copyErr
    else
      xcodebuild -jobs 1 -configuration Release >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../" || copyErr
    fi
  elif [[ ${voodooinputPlugins} =~ $2 ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    if [[ "$2" == "VoodooI2C" ]]; then
      cp -R "../VoodooInput" "./Dependencies/" || copyErr
      git submodule init >/dev/null 2>&1 && git submodule update >/dev/null 2>&1

      # Delete Linting & Generate Documentation in Build Phase to avoid installing cpplint & cldoc
      lineNum=$(grep -n "Linting" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj) && lineNum=${lineNum%%:*}
      sed -i '' "${lineNum}d" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj
      lineNum=$(grep -n "Generate Documentation" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj) && lineNum=${lineNum%%:*}
      sed -i '' "${lineNum}d" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj

      xcodebuild -workspace "VoodooI2C.xcworkspace" -scheme "VoodooI2C" -derivedDataPath . -arch x86_64 clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL_BIG}*.kext "../" || copyErr
    else
      cp -R "../VoodooInput" "./" || copyErr
      xcodebuild -jobs 1 -configuration Release >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL_SMA}*.kext "../" || copyErr
    fi
  elif [[ "$2" == "Lilu" ]]; then
    rm -rf ../Lilu.kext
    cp -R "../MacKernelSDK" "./" || copyErr
    xcodebuild -jobs 1 -configuration Release >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  elif [[ "$2" == "IntelBluetoothFirmware" ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr

    # Delete unrelated firmware and only keep ibt-12*.sfi for Intel Wireless 8265
    cd "IntelBluetoothFirmware/fw/" && find . -maxdepth 1 -not -name "ibt-12*" -delete && cd "../../" || exit 1

    xcodebuild -alltargets -configuration Release >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  elif [[ "$2" == "itlwm" ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr

    # Delete unrelated firmware and only keep iwm-8265* for Intel Wireless 8265
    cd "itlwm/firmware/" && find . -maxdepth 1 -not -name "iwm-8265*" -delete && cd "../../" || exit 1

    # Pass print syntax to support Python3
    /usr/bin/sed -i "" "s:print compress(\"test\"):pass:g" "scripts/zlib_compress_fw.py"

    xcodebuild -scheme "AirportItlwm (all)" -configuration Debug -derivedDataPath . >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_DBG_BIG}* "../" || copyErr
  fi
  cd ../ || exit 1
}

function BKext() {
  local sdkVer=""

  if [[ ${NO_XCODE} == True ]]; then
    echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Missing Xcode tools, won't build kexts!"
    exit 1
  fi

  git clone https://github.com/acidanthera/MacKernelSDK >/dev/null 2>&1
  src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/Lilu/master/Lilu/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
  src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/VoodooInput/master/VoodooInput/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
  for acdtKext in "${acdtKexts[@]}"; do
    BKextHelper ${ACDT} "${acdtKext}"
  done
  for oiwKext in "${oiwKexts[@]}"; do
    BKextHelper ${OIW} "${oiwKext}"
  done
  BKextHelper VoodooI2C VoodooI2C
  echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Please clean Xcode cache in ~/Library/Developer/Xcode/DerivedData!"
  echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Some kexts only work on current macOS SDK build!"
  echo
}

function DL() {
  # Clover
  DGR CloverHackyColor CloverBootloader NULL "Clover"

  # OpenCore
  if [[ ${PRE_RELEASE} =~ "OC" ]]; then
    DGR williambj1 OpenCore-Factory PreRelease "OpenCore"
  else
    DGR ${ACDT} OpenCorePkg NULL "OpenCore"
  fi

  # Kexts
  for rmKext in "${rmKexts[@]}"; do
    DBR Rehabman "${rmKext}"
  done

  if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
    BKext
  else
    for acdtKext in "${acdtKexts[@]}"; do
      DGR ${ACDT} "${acdtKext}"
    done
    for oiwKext in "${oiwKexts[@]}"; do
      DGR ${OIW} "${oiwKext}" PreRelease
    done
    DGR VoodooI2C VoodooI2C
  fi

  DGS RehabMan hack-tools

  # UEFI drivers
  # AppleSupportPkg v2.0.9
  DGR ${ACDT} AppleSupportPkg_209 19214108 "Clover/AppleSupportPkg_209"
  # AppleSupportPkg v2.1.6
  DGR ${ACDT} AppleSupportPkg_216 24123335 "Clover/AppleSupportPkg_216"

  # UEFI
  # DPB ${ACDT} OcBinaryData Drivers/HfsPlus.efi
  DPB ${ACDT} VirtualSMC EfiDriver/VirtualSmc.efi

  # HfsPlus.efi & OC Resources
  DGS ${ACDT} OcBinaryData

  # XiaoMi-Pro ACPI patch
  if [[ ${REMOTE} == True ]]; then
    DGS daliansky ${REPO_NAME}
  fi

  # Menchen's ALCPlugFix
  if [[ ${REMOTE} == True ]]; then
    DGS Menchen ALCPlugFix
  fi
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
    "HibernationFixup.kext/Contents/_CodeSignature"
    "Kexts/SMCBatteryManager.kext/Contents/Resources"
    "Release/CodecCommander.kext/Contents/Resources"
    "RestrictEvents.kext/Contents/_CodeSignature"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"
    "WhateverGreen.kext/Contents/_CodeSignature"
  )
  echo "${green}[${reset}${blue}${bold} Patching Resources ${reset}${green}]${reset}"
  echo
  for unusedItem in "${unusedItems[@]}"; do
    rm -rf "${unusedItem}" >/dev/null 2>&1
  done

  # Only keep OCEFIAudio_VoiceOver_Boot.wav in OcBinaryData/Resources/Audio
  cd "OcBinaryData-master/Resources/Audio/" && find . -maxdepth 1 -not -name "OCEFIAudio_VoiceOver_Boot.wav" -delete && cd "${WSDir}" || exit 1

  # Rename AirportItlwm.kexts to distinguish different versions
  mv "Big Sur/AirportItlwm.kext" "Big Sur/AirportItlwm_Big_Sur.kext" || exit 1
  mv "Catalina/AirportItlwm.kext" "Catalina/AirportItlwm_Catalina.kext" || exit 1
  mv "High Sierra/AirportItlwm.kext" "High Sierra/AirportItlwm_High_Sierra.kext" || exit 1
  mv "Mojave/AirportItlwm.kext" "Mojave/AirportItlwm_Mojave.kext" || exit 1
}

# Install
function Install() {
  local acpiItems
  local alcfixItems
  local btItems
  local gtxItems
  local kextItems
  local wikiItems

  # Kexts
  kextItems=(
    "AppleALC.kext"
    "HibernationFixup.kext"
    "IntelBluetoothFirmware.kext"
    "IntelBluetoothInjector.kext"
    "Lilu.kext"
    "VoodooI2C.kext"
    "VoodooI2CHID.kext"
    "VoodooPS2Controller.kext"
    "WhateverGreen.kext"
    "RestrictEvents.kext"
    "hack-tools-master/kexts/SATA-unsupported.kext"
    "Kexts/SMCBatteryManager.kext"
    "Kexts/SMCLightSensor.kext"
    "Kexts/SMCProcessor.kext"
    "Kexts/VirtualSMC.kext"
    "Release/CodecCommander.kext"
    "Release/NullEthernet.kext"
  )

  wifiKextItems=(
    "Big Sur/AirportItlwm_Big_Sur.kext"
    "Catalina/AirportItlwm_Catalina.kext"
    "High Sierra/AirportItlwm_High_Sierra.kext"
    "Mojave/AirportItlwm_Mojave.kext"
  )

  cloverKextFolders=(
    "10.13"
    "10.14"
    "10.15"
    "11"
  )

  echo "${green}[${reset}${blue}${bold} Installing Kexts ${reset}${green}]${reset}"
  echo
  for Kextdir in "${OUTDir}/EFI/CLOVER/kexts/Other/" "${OUTDir_OC}/EFI/OC/Kexts/"; do
    mkdir -p "${Kextdir}" || exit 1
    for kextItem in "${kextItems[@]}"; do
      cp -R "${kextItem}" "${Kextdir}" || copyErr
    done
  done

  for cloverKextFolder in "${cloverKextFolders[@]}"; do
    mkdir -p "${OUTDir}/EFI/CLOVER/kexts/${cloverKextFolder}" || exit 1
  done

  cp -R "Big Sur/AirportItlwm_Big_Sur.kext" "${OUTDir}/EFI/CLOVER/kexts/11" || copyErr
  cp -R "Catalina/AirportItlwm_Catalina.kext" "${OUTDir}/EFI/CLOVER/kexts/10.15" || copyErr
  cp -R "High Sierra/AirportItlwm_High_Sierra.kext" "${OUTDir}/EFI/CLOVER/kexts/10.13" || copyErr
  cp -R "Mojave/AirportItlwm_Mojave.kext" "${OUTDir}/EFI/CLOVER/kexts/10.14" || copyErr

  for kextItem in "${wifiKextItems[@]}"; do
    cp -R "${kextItem}" "${OUTDir_OC}/EFI/OC/Kexts/" || copyErr
  done

  # Drivers
  echo "${green}[${reset}${blue}${bold} Installing Drivers ${reset}${green}]${reset}"
  echo
  for Driverdir in "${OUTDir}/EFI/CLOVER/drivers/UEFI/" "${OUTDir_OC}/EFI/OC/Drivers/"; do
    mkdir -p "${Driverdir}" || exit 1
    cp -R "OcBinaryData-master/Drivers/HfsPlus.efi" "${Driverdir}" || copyErr
  done
  cp -R "OcBinaryData-master/Drivers/ExFatDxe.efi" "${OUTDir_OC}/EFI/OC/Drivers/" || copyErr
  cp -R "VirtualSmc.efi" "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr

  # ACPI
  acpiItems=(
    "${REPO_NAME_BRANCH}/ACPI/SSDT-ALS0.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-DDGPU.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-DMAC.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-EC.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-GPRW.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-HPET.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-LGPA.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-MCHC.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-MEM2.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-PMC.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-PNLF.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-PS2K.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-RMNE.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-TPD0.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-USB.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-XCPM.aml"
  )
  if [[ ${REMOTE} == False ]]; then
    acpiItems=("${acpiItems[@]/${REPO_NAME_BRANCH}/..}")
  fi

  echo "${green}[${reset}${blue}${bold} Installing ACPIs ${reset}${green}]${reset}"
  echo
  for ACPIdir in "${OUTDir}/EFI/CLOVER/ACPI/patched/" "${OUTDir_OC}/EFI/OC/ACPI/"; do
    mkdir -p "${ACPIdir}" || exit 1
    for acpiItem in "${acpiItems[@]}"; do
      cp -R "${acpiItem}" "${ACPIdir}" || copyErr
    done
  done

  # Theme
  echo "${green}[${reset}${blue}${bold} Installing Themes ${reset}${green}]${reset}"
  echo
  if [[ ${REMOTE} == True ]]; then
    cp -R "${REPO_NAME_BRANCH}/CLOVER/themes" "${OUTDir}/EFI/CLOVER/" || copyErr
  else
    cp -R "../CLOVER/themes" "${OUTDir}/EFI/CLOVER/" || copyErr
  fi

  cp -R "OcBinaryData-master/Resources" "${OUTDir_OC}/EFI/OC/" || copyErr

  # config & README & LICENSE
  echo "${green}[${reset}${blue}${bold} Installing config & README & LICENSE ${reset}${green}]${reset}"
  echo
  if [[ ${REMOTE} == True ]]; then
    cp -R "${REPO_NAME_BRANCH}/CLOVER/config.plist" "${OUTDir}/EFI/CLOVER/" || copyErr
    cp -R "${REPO_NAME_BRANCH}/OC/config.plist" "${OUTDir_OC}/EFI/OC/" || copyErr
    for READMEdir in "${OUTDir}" "${OUTDir_OC}"; do
      if [[ ${LANGUAGE} == "EN" ]]; then
        cp -R "${REPO_NAME_BRANCH}/README.md" "${READMEdir}" || copyErr
      elif [[ ${LANGUAGE} == "CN" ]]; then
        cp -R "${REPO_NAME_BRANCH}/README_CN.md" "${READMEdir}" || copyErr
      fi
      cp -R "${REPO_NAME_BRANCH}/LICENSE" "${READMEdir}" || copyErr
    done
  else
    cp -R "../CLOVER/config.plist" "${OUTDir}/EFI/CLOVER/" || copyErr
    cp -R "../OC/config.plist" "${OUTDir_OC}/EFI/OC/" || copyErr
    for READMEdir in "${OUTDir}" "${OUTDir_OC}"; do
      if [[ ${LANGUAGE} == "EN" ]]; then
        cp -R "../README.md" "${READMEdir}" || copyErr
      elif [[ ${LANGUAGE} == "CN" ]]; then
        cp -R "../README_CN.md" "${READMEdir}" || copyErr
      fi
      cp -R "../LICENSE" "${READMEdir}" || copyErr
    done
  fi

  # Bluetooth & GTX & wiki
  btItems=(
    "${REPO_NAME_BRANCH}/ACPI/SSDT-USB-ALL.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-USB-FingerBT.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-USB-USBBT.aml"
    "${REPO_NAME_BRANCH}/ACPI/SSDT-USB-WLAN_LTEBT.aml"
    "${REPO_NAME_BRANCH}/Docs/Work-Around-with-Bluetooth.pdf"
  )
  if [[ ${REMOTE} == False ]]; then
    btItems=("${btItems[@]/${REPO_NAME_BRANCH}/..}")
  fi

  echo "${green}[${reset}${blue}${bold} Installing Docs About Bluetooth & GTX & wiki ${reset}${green}]${reset}"
  echo
  for BTdir in "${OUTDir}/Bluetooth" "${OUTDir_OC}/Bluetooth"; do
    mkdir -p "${BTdir}" || exit 1
    for btItem in "${btItems[@]}"; do
      cp -R "${btItem}" "${BTdir}" || copyErr
    done
  done

  gtxItems=( "${REPO_NAME_BRANCH}/ACPI/SSDT-LGPAGTX.aml" )
  if [[ ${LANGUAGE} == "EN" ]]; then
    gtxItems+=( "${REPO_NAME_BRANCH}/Docs/README_GTX.txt" )
  elif [[ ${LANGUAGE} == "CN" ]]; then
    gtxItems+=( "${REPO_NAME_BRANCH}/Docs/README_CN_GTX.txt" )
  fi
  if [[ ${REMOTE} == False ]]; then
    gtxItems=("${gtxItems[@]/${REPO_NAME_BRANCH}/..}")
  fi

  for GTXdir in "${OUTDir}/GTX" "${OUTDir_OC}/GTX"; do
    mkdir -p "${GTXdir}" || exit 1
    for gtxItem in "${gtxItems[@]}"; do
      cp -R "${gtxItem}" "${GTXdir}" || copyErr
    done
  done

  wikiItems=(
    "${REPO_NAME_BRANCH}/Docs/FAQ.pdf"
    "${REPO_NAME_BRANCH}/Docs/Set-DVMT-to-64mb.pdf"
    "${REPO_NAME_BRANCH}/Docs/Unlock-0xE2-MSR.pdf"
  )
  if [[ ${REMOTE} == False ]]; then
    wikiItems=("${wikiItems[@]/${REPO_NAME_BRANCH}/..}")
  fi

  for WIKIdir in "${OUTDir}/Docs" "${OUTDir_OC}/Docs"; do
    mkdir -p "${WIKIdir}" || exit 1
    for wikiItem in "${wikiItems[@]}"; do
      cp -R "${wikiItem}" "${WIKIdir}" || copyErr
    done
  done

  # ALCPlugFix
  alcfixItems=(
    "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix/alc_fix"
    "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix/build"
    "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix/README.MD"
  )
  if [[ ${REMOTE} == True ]]; then
    cp -R ALCPlugFix-master/* "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix/" || copyErr
  else
    alcfixItems=("${alcfixItems[@]/${REPO_NAME_BRANCH}/..}")
    cd "../" || exit 1
    git submodule init && git submodule update --remote && cd "${WSDir}" || exit 1
  fi

  echo "${green}[${reset}${blue}${bold} Installing ALCPlugFix ${reset}${green}]${reset}"
  echo
  for ALCPFdir in "${OUTDir}/ALCPlugFix" "${OUTDir_OC}/ALCPlugFix"; do
    mkdir -p "${ALCPFdir}" || exit 1
    for alcfixItem in "${alcfixItems[@]}"; do
      cp -R "${alcfixItem}" "${ALCPFdir}" || copyErr
    done
  done
}

# Extract files for Clover
function ExtractClover() {
  echo "${green}[${reset}${blue}${bold} Extracting Clover ${reset}${green}]${reset}"
  echo
  # From CloverV2, AppleSupportPkg v2.0.9, and AppleSupportPkg v2.1.6
  unzip -d "Clover" "Clover/*.zip" >/dev/null 2>&1
  unzip -d "Clover/AppleSupportPkg_209" "Clover/AppleSupportPkg_209/*.zip" >/dev/null 2>&1
  unzip -d "Clover/AppleSupportPkg_216" "Clover/AppleSupportPkg_216/*.zip" >/dev/null 2>&1
  cp -R "Clover/CloverV2/EFI/BOOT" "${OUTDir}/EFI/" || copyErr
  cp -R "Clover/CloverV2/EFI/CLOVER/CLOVERX64.efi" "${OUTDir}/EFI/CLOVER/" || copyErr
  cp -R "Clover/CloverV2/EFI/CLOVER/tools" "${OUTDir}/EFI/CLOVER/" || copyErr
  local driverItems=(
    "Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix/OpenRuntime.efi"
    "Clover/AppleSupportPkg_209/Drivers/AppleGenericInput.efi"
    "Clover/AppleSupportPkg_209/Drivers/AppleUiSupport.efi"
    "Clover/AppleSupportPkg_216/Drivers/ApfsDriverLoader.efi"
  )
  for driverItem in "${driverItems[@]}"; do
    cp -R "${driverItem}" "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr
  done
}

# Extract files from OpenCore
function ExtractOC() {
  echo "${green}[${reset}${blue}${bold} Extracting OpenCore ${reset}${green}]${reset}"
  echo
  mkdir -p "${OUTDir_OC}/EFI/OC/Tools" || exit 1
  unzip -d "OpenCore" "OpenCore/*.zip" >/dev/null 2>&1
  cp -R "OpenCore/X64/EFI/BOOT" "${OUTDir_OC}/EFI/" || copyErr
  cp -R "OpenCore/X64/EFI/OC/OpenCore.efi" "${OUTDir_OC}/EFI/OC/" || copyErr
  cp -R "OpenCore/X64/EFI/OC/Bootstrap" "${OUTDir_OC}/EFI/OC/" || copyErr
  local driverItems=(
    "OpenCore/X64/EFI/OC/Drivers/AudioDxe.efi"
    "OpenCore/X64/EFI/OC/Drivers/OpenCanopy.efi"
    "OpenCore/X64/EFI/OC/Drivers/OpenRuntime.efi"
  )
  local toolItems=(
    "OpenCore/X64/EFI/OC/Tools/OpenShell.efi"
  )
  for driverItem in "${driverItems[@]}"; do
    cp -R "${driverItem}" "${OUTDir_OC}/EFI/OC/Drivers/" || copyErr
  done
  for toolItem in "${toolItems[@]}"; do
    cp -R "${toolItem}" "${OUTDir_OC}/EFI/OC/Tools/" || copyErr
  done
}

# Generate Release Note
function GenNote() {
  local printVersion
  local lineStart
  local lineEnd
  local changelogPath

  changelogPath="${REPO_NAME_BRANCH}/Changelog.md"
  if [[ ${REMOTE} == False ]]; then
    changelogPath="${changelogPath/${REPO_NAME_BRANCH}/..}"
  fi

  echo "${green}[${reset}${blue}${bold} Generating Release Notes ${reset}${green}]${reset}"
  echo
  printVersion=$(echo "${VERSION}" | sed 's/-/\ /g' | sed 's/beta/beta\ /g')
  printf "## XiaoMi NoteBook Pro EFI %s\n" "${printVersion}" >> ReleaseNotes.md

  lineStart=$(grep -n "XiaoMi NoteBook Pro EFI v" ${changelogPath}) && lineStart=${lineStart%%:*} && lineStart=$((lineStart+1))
  lineEnd=$(grep -n -m2 "XiaoMi NoteBook Pro EFI v" ${changelogPath} | tail -n1)
  lineEnd=${lineEnd%%:*} && lineEnd=$((lineEnd-3))
  sed -n "${lineStart},${lineEnd}p" ${changelogPath} >> ReleaseNotes.md
  for RNotedir in "${OUTDir}" "${OUTDir_OC}"; do
    cp -R "ReleaseNotes.md" "${RNotedir}" || copyErr
  done
}

# Exclude Trash
function CTrash() {
  echo "${green}[${reset}${blue}${bold} Cleaning Trash Files ${reset}${green}]${reset}"
  echo
  if [[ ${CLEAN_UP} == True ]]; then
    find . -maxdepth 1 ! -path "./${OUTDir}" ! -path "./${OUTDir_OC}" -exec rm -rf {} + >/dev/null 2>&1
  fi
}

# Enjoy
function Enjoy() {
  for BUILDdir in "${OUTDir}" "${OUTDir_OC}"; do
    zip -qr "${BUILDdir}.zip" "${BUILDdir}"
  done
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
  open ./
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

  # Generate Release Notes
  GenNote

  # Clean up
  CTrash

  # Enjoy
  Enjoy
}

main

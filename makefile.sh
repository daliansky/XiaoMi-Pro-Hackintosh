#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 17 April, 2020
#
# Build XiaoMi-Pro EFI release
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1


# Vars
ACDT="Acidanthera"
CLEAN_UP=True
ERR_NO_EXIT=False
GH_API=True
LANGUAGE="EN"
NO_WIKI=True
NO_XCODE=False
PRE_RELEASE=""
REMOTE=True
VERSION="local"

# Env
if [ "$(which xcodebuild)" = "" ] || [ "$(which git)" = "" ]; then
  NO_XCODE=True
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

acdtKexts=(
  VirtualSMC
  WhateverGreen
  AppleALC
  HibernationFixup
  NVMeFix
  VoodooPS2
  Lilu
)

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
  elif [[ "$1" == "OcQuirks" ]]; then
    HG="grep -m 1 OcQuirks"
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

# Download GitHub Wiki
function DGW() {
  if [[ ${NO_XCODE} == True ]]; then
    echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Missing Xcode tools, won't download wiki!"
  else
    local URL="https://github.com/$1/$2.wiki.git"
    echo "${green}[${reset}${blue}${bold} Downloading $2.wiki ${reset}${green}]${reset}"
    echo "${cyan}"
    git clone "${URL}" >/dev/null 2>&1 || networkErr "$2.wiki"
    echo "${reset}"
  fi
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
    find . -maxdepth 1 ! -path "./${OUTDir}" ! -path "./${OUTDir_OC}" -exec rm -rf {} + >/dev/null 2>&1
  fi
}

# Build Pre-release Kexts
function BKextHelper() {
  local PATH_TO_REL="build/Build/Products/Release/"
  local PATH_TO_REL_PS2="build/Products/Release/"

  echo "${green}[${reset}${blue}${bold} Building $2 ${reset}${green}]${reset}"
  echo
  git clone --depth=1 https://github.com/"$1"/"$2".git >/dev/null 2>&1
  cd "$2" || exit 1
  if [[ "$2" == "VoodooPS2" ]]; then
    cp -R "../VoodooInput" "./" || copyErr
    xcodebuild -scheme VoodooPS2Controller -configuration Release -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL_PS2}*.kext "../" || copyErr
  elif [ "$2" == "VirtualSMC" ]; then
    cp -R "../Lilu.kext" "./" || copyErr
    xcodebuild -scheme Package -configuration Release -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    mkdir ../Kexts
    cp -R ${PATH_TO_REL}*.kext "../Kexts/" || copyErr
  elif [ "$2" == "WhateverGreen" ] || [ "$2" == "AppleALC" ] || [ "$2" == "HibernationFixup" ] || [ "$2" == "NVMeFix" ]; then
    cp -R "../Lilu.kext" "./" || copyErr
    xcodebuild -scheme "$2" -configuration Release -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  elif [[ "$2" == "VoodooI2C" ]]; then
    cp -R "../VoodooInput" "./Dependencies/" || copyErr
    git submodule init >/dev/null 2>&1 && git submodule update >/dev/null 2>&1

    # Delete Linting & Generate Documentation in Build Phase to avoid installing cpplint & cldoc
    local lineNum
    lineNum=$(grep -n "Linting" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj) && lineNum=${lineNum%%:*}
    sed -i '' "${lineNum}d" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj
    lineNum=$(grep -n "Generate Documentation" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj) && lineNum=${lineNum%%:*}
    sed -i '' "${lineNum}d" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj

    xcodebuild -scheme "$2" -configuration Release -sdk macosx10.12 -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  elif [[ "$2" == "Lilu" ]]; then
    rm -rf ../Lilu.kext
    xcodebuild -scheme "$2" -configuration Release -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  elif [[ "$2" == "IntelBluetoothFirmware" ]]; then
    xcodebuild -scheme "$2" -configuration Release -sdk macosx10.12 -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    xcodebuild -scheme IntelBluetoothInjector -configuration Release -sdk macosx10.12 -derivedDataPath build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  fi
  cd ../ || exit 1
}

# Extract files for Clover
function ExtractClover() {
  # From CloverV2 and AppleSupportPkg v2.0.9
  unzip -d "Clover" "Clover/*.zip" >/dev/null 2>&1
  cp -R "Clover/CloverV2/EFI/BOOT" "${OUTDir}/EFI/" || copyErr
  cp -R "Clover/CloverV2/EFI/CLOVER/CLOVERX64.efi" "${OUTDir}/EFI/CLOVER/" || copyErr
  cp -R "Clover/CloverV2/EFI/CLOVER/tools" "${OUTDir}/EFI/CLOVER/" || copyErr
  local driverItems=(
    "Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/FileSystem/ApfsDriverLoader.efi"
    "Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix/OcQuirks.efi"
    "Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix/OpenRuntime.efi"
    "Clover/CloverV2/EFI/CLOVER/drivers/UEFI/FSInject.efi"
    "Clover/Drivers/AppleGenericInput.efi"
    "Clover/Drivers/AppleUiSupport.efi"
  )
  for driverItem in "${driverItems[@]}"; do
    cp -R "${driverItem}" "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr
  done
}

# Extract files from OpenCore
function ExtractOC() {
  mkdir -p "${OUTDir_OC}/EFI/OC/Tools" || exit 1
  unzip -d "OpenCore" "OpenCore/*.zip" >/dev/null 2>&1
  cp -R OpenCore/EFI/BOOT "${OUTDir_OC}/EFI/" || copyErr
  cp -R OpenCore/EFI/OC/OpenCore.efi "${OUTDir_OC}/EFI/OC/" || copyErr
  cp -R OpenCore/EFI/OC/Bootstrap "${OUTDir_OC}/EFI/OC/" || copyErr
  local driverItems=(
    "OpenCore/EFI/OC/Drivers/AudioDxe.efi"
    "OpenCore/EFI/OC/Drivers/OpenCanopy.efi"
    "OpenCore/EFI/OC/Drivers/OpenRuntime.efi"
  )
  local toolItems=(
    "OpenCore/EFI/OC/Tools/OpenShell.efi"
  )
  for driverItem in "${driverItems[@]}"; do
    cp -R "${driverItem}" "${OUTDir_OC}/EFI/OC/Drivers/" || copyErr
  done
  for toolItem in "${toolItems[@]}"; do
    cp -R "${toolItem}" "${OUTDir_OC}/EFI/OC/Tools/" || copyErr
  done
}

# Unpack
function Unpack() {
  echo "${green}[${reset}${yellow}${bold} Unpacking ${reset}${green}]${reset}"
  echo
  unzip -qq "*.zip" >/dev/null 2>&1
}

# Install
function Install() {
  local acpiItems
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

  for Kextdir in "${OUTDir}/EFI/CLOVER/kexts/Other/" "${OUTDir_OC}/EFI/OC/Kexts/"; do
    mkdir -p "${Kextdir}" || exit 1
    for kextItem in "${kextItems[@]}"; do
      cp -R "${kextItem}" "${Kextdir}" || copyErr
    done
  done

  # Drivers
  for Driverdir in "${OUTDir}/EFI/CLOVER/drivers/UEFI/" "${OUTDir_OC}/EFI/OC/Drivers/"; do
    mkdir -p "${Driverdir}" || exit 1
    cp -R "OcBinaryData-master/Drivers/HfsPlus.efi" "${Driverdir}" || copyErr
  done

  cp -R "VirtualSmc.efi" "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr

  if [[ ${REMOTE} == True ]]; then
    cp -R "XiaoMi-Pro-Hackintosh-master/CLOVER/drivers/UEFI/OcQuirks.plist" "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr
    cp -R "XiaoMi-Pro-Hackintosh-master/Docs/Drivers/AptioMemoryFix.efi" "${OUTDir}" || copyErr
  else
    cp -R "../CLOVER/drivers/UEFI/OcQuirks.plist" "${OUTDir}/EFI/CLOVER/drivers/UEFI/" || copyErr
    cp -R "../Docs/Drivers/AptioMemoryFix.efi" "${OUTDir}" || copyErr
  fi

  # ACPI
  if [[ ${REMOTE} == True ]]; then
    acpiItems=(
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-ALS0.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-DDGPU.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-DMAC.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-EC.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-GPRW.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-HPET.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-LGPA.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-MCHC.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-MEM2.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-PMC.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-PNLF.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-PS2K.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-RMNE.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-TPD0.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-USB.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-XCPM.aml"
    )
  else
    acpiItems=(
      "../ACPI/SSDT-ALS0.aml"
      "../ACPI/SSDT-DDGPU.aml"
      "../ACPI/SSDT-DMAC.aml"
      "../ACPI/SSDT-EC.aml"
      "../ACPI/SSDT-GPRW.aml"
      "../ACPI/SSDT-HPET.aml"
      "../ACPI/SSDT-LGPA.aml"
      "../ACPI/SSDT-MCHC.aml"
      "../ACPI/SSDT-MEM2.aml"
      "../ACPI/SSDT-PMC.aml"
      "../ACPI/SSDT-PNLF.aml"
      "../ACPI/SSDT-PS2K.aml"
      "../ACPI/SSDT-RMNE.aml"
      "../ACPI/SSDT-TPD0.aml"
      "../ACPI/SSDT-USB.aml"
      "../ACPI/SSDT-XCPM.aml"
    )
  fi

  for ACPIdir in "${OUTDir}/EFI/CLOVER/ACPI/patched/" "${OUTDir_OC}/EFI/OC/ACPI/"; do
    mkdir -p "${ACPIdir}" || exit 1
    for acpiItem in "${acpiItems[@]}"; do
      cp -R "${acpiItem}" "${ACPIdir}" || copyErr
    done
  done

  # Theme
  if [[ ${REMOTE} == True ]]; then
    cp -R "XiaoMi-Pro-Hackintosh-master/CLOVER/themes" "${OUTDir}/EFI/CLOVER/" || copyErr
  else
    cp -R "../CLOVER/themes" "${OUTDir}/EFI/CLOVER/" || copyErr
  fi

  cp -R "OcBinaryData-master/Resources" "${OUTDir_OC}/EFI/OC/" || copyErr

  # config & README
  if [[ ${REMOTE} == True ]]; then
    cp -R "XiaoMi-Pro-Hackintosh-master/CLOVER/config.plist" "${OUTDir}/EFI/CLOVER/" || copyErr
    cp -R "XiaoMi-Pro-Hackintosh-master/OC/config.plist" "${OUTDir_OC}/EFI/OC/" || copyErr
    for READMEdir in "${OUTDir}" "${OUTDir_OC}"; do
      if [[ ${LANGUAGE} == "EN" ]]; then
        cp -R "XiaoMi-Pro-Hackintosh-master/README.md" "${READMEdir}" || copyErr
      elif [[ ${LANGUAGE} == "CN" ]]; then
        cp -R "XiaoMi-Pro-Hackintosh-master/README_CN.md" "${READMEdir}" || copyErr
      fi
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
    done
  fi

  # Bluetooth & GTX & wiki
  if [[ -d "XiaoMi-Pro-Hackintosh.wiki" ]]; then
    NO_WIKI=False
  fi

  if [[ ${NO_WIKI} == False ]]; then
    if [[ ${LANGUAGE} == "EN" ]]; then
      btItems=( "XiaoMi-Pro-Hackintosh.wiki/Work-Around-with-Bluetooth.md" )
    elif [[ ${LANGUAGE} == "CN" ]]; then
      btItems=( "XiaoMi-Pro-Hackintosh.wiki/蓝牙解决方案.md" )
    fi
  fi

  if [[ ${REMOTE} == True ]]; then
    btItems+=(
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-USB-ALL.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-USB-FingerBT.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-USB-USBBT.aml"
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-USB-WLAN_LTEBT.aml"
    )
  else
    btItems+=(
      "../ACPI/SSDT-USB-ALL.aml"
      "../ACPI/SSDT-USB-FingerBT.aml"
      "../ACPI/SSDT-USB-USBBT.aml"
      "../ACPI/SSDT-USB-WLAN_LTEBT.aml"
    )
  fi

  for BTdir in "${OUTDir}/Bluetooth" "${OUTDir_OC}/Bluetooth"; do
    mkdir -p "${BTdir}" || exit 1
    for btItem in "${btItems[@]}"; do
      cp -R "${btItem}" "${BTdir}" || copyErr
    done
  done

  if [[ ${REMOTE} == True ]]; then
    gtxItems=(
      "XiaoMi-Pro-Hackintosh-master/ACPI/SSDT-LGPAGTX.aml"
    )
    if [[ ${LANGUAGE} == "EN" ]]; then
      gtxItems+=( "XiaoMi-Pro-Hackintosh-master/Docs/README_GTX.txt" )
    elif [[ ${LANGUAGE} == "CN" ]]; then
      gtxItems+=( "XiaoMi-Pro-Hackintosh-master/Docs/README_CN_GTX.txt" )
    fi
  else
    gtxItems=(
      "../ACPI/SSDT-LGPAGTX.aml"
    )
    if [[ ${LANGUAGE} == "EN" ]]; then
      gtxItems+=( "../Docs/README_GTX.txt" )
    elif [[ ${LANGUAGE} == "CN" ]]; then
      gtxItems+=( "../Docs/README_CN_GTX.txt" )
    fi
  fi

  for GTXdir in "${OUTDir}/GTX" "${OUTDir_OC}/GTX"; do
    mkdir -p "${GTXdir}" || exit 1
    for gtxItem in "${gtxItems[@]}"; do
      cp -R "${gtxItem}" "${GTXdir}" || copyErr
    done
  done

  if [[ ${NO_WIKI} == False ]]; then
    if [[ ${LANGUAGE} == "EN" ]]; then
      wikiItems=(
        "XiaoMi-Pro-Hackintosh.wiki/FAQ.md"
        "XiaoMi-Pro-Hackintosh.wiki/Set-DVMT-to-64mb.md"
      )
    elif [[ ${LANGUAGE} == "CN" ]]; then
      wikiItems=(
        "XiaoMi-Pro-Hackintosh.wiki/常见问题解答.md"
        "XiaoMi-Pro-Hackintosh.wiki/设置64mb动态显存.md"
      )
    fi

    for WIKIdir in "${OUTDir}" "${OUTDir_OC}"; do
      for wikiItem in "${wikiItems[@]}"; do
        cp -R "${wikiItem}" "${WIKIdir}" || copyErr
      done
    done
  fi
}

# Generate Release Note
function GenNote() {
  local printVersion
  local lineStart
  local lineEnd
  local changelogPath

  if [[ ${REMOTE} == True ]]; then
    changelogPath="XiaoMi-Pro-Hackintosh-master/Changelog.md"
  else
    changelogPath="../Changelog.md"
  fi

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

# Patch
function Patch() {
  local unusedItems=(
    "IntelBluetoothInjector.kext/Contents/_CodeSignature"
    "IntelBluetoothInjector.kext/Contents/MacOS"
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

  cd "OcBinaryData-master/Resources/Audio/" && find . -maxdepth 1 -not -name "OCEFIAudio_VoiceOver_Boot.wav" -delete && cd "${WSDir}" || exit 1
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

function BKext() {
  local TRAVIS_TAG=""

  if [[ ${NO_XCODE} == True ]]; then
    echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Missing Xcode tools, won't build kexts!"
    exit 1
  fi
  if [[ ! -d "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk" ]]; then
    echo "${green}[${reset}${blue}${bold} Downloading MacOSX10.12.sdk ${reset}${green}]${reset}"
    echo "${cyan}"
    curl -# -L -O https://github.com/alexey-lysiuk/macos-sdk/releases/download/10.12/MacOSX10.12.tar.bz2 || networkErr "MacOSX10.12.sdk" && tar -xjf MacOSX10.12.tar.bz2
    echo "${reset}"
    sudo cp -R "MacOSX10.12.sdk" "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/" || copyErr
  fi

  src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/Lilu/master/Lilu/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
  src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/VoodooInput/master/VoodooInput/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
  for acdtKext in "${acdtKexts[@]}"; do
    BKextHelper ${ACDT} "${acdtKext}"
  done
  BKextHelper VoodooI2C VoodooI2C
  BKextHelper OpenIntelWireless IntelBluetoothFirmware
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
    DGR VoodooI2C VoodooI2C
    DGR OpenIntelWireless IntelBluetoothFirmware
  fi

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

  # wiki, require git installed
  DGW daliansky XiaoMi-Pro-Hackintosh
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
    "XiaoMi-Pro-Hackintosh-master"
    "Clover"
    "OpenCore"
  )
  for dir in "${dirs[@]}"; do
    mkdir -p "${dir}" || exit 1
  done

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
  GenNote
  ExtractClover
  ExtractOC

  # Clean up
  CTrash

  # Enjoy
  Enjoy
}

main

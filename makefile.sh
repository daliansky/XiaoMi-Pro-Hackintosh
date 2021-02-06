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
CFURL="https://hackintosh.stevezheng.workers.dev"
CLEAN_UP=True
ERR_NO_EXIT=False
GH_API=True
LANGUAGE="en_US"
MODEL=""
MODEL_LIST=( )
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
elif [[ "${DEVELOPER_DIR}" = "" ]]; then
  DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
  xcodebuild -version && echo
else
  xcodebuild -version && echo
fi

# Language detect
LANGUAGE=$(locale | grep LANG | sed s/'LANG='// | tr -d '"' | cut -d "." -f 1)
if [[ ${LANGUAGE} != "zh_CN" ]]; then
  LANGUAGE="en_US"
fi

# Args
while [[ $# -gt 0 ]]; do
  key="$1"

  case "${key}" in
    --IGNORE_ERR)
    ERR_NO_EXIT=True
    shift # past argument
    ;;
    --LANG=zh_CN)
    LANGUAGE="zh_CN"
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
    elif [[ "${key}" =~ "--MODEL=" ]]; then
      MODEL+="${key##*=}"
      shift
    else
      shift
    fi
    ;;
  esac
done

if [[ "${MODEL}" =~ "KBL" ]]; then
  MODEL_LIST+=( "KBL" )
fi
if [[ "${MODEL}" =~ "CML" ]]; then
  MODEL_LIST+=( "CML" )
fi

# Assign KBL when no MODEL is entered
if [[ ${#MODEL_LIST[@]} -eq 0 ]]; then
  MODEL="KBL"
  MODEL_LIST=( "KBL" )
fi

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
OUTDir_KBL_CLOVER="XiaoMi_Pro-KBL-Clover-${VERSION}"
OUTDir_KBL_OC="XiaoMi_Pro-KBL-OC-${VERSION}"
OUTDir_CML_CLOVER="XiaoMi_Pro-CML-Clover-${VERSION}"
OUTDir_CML_OC="XiaoMi_Pro-CML-OC-${VERSION}"

# Kexts
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
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
  echo
}

# Exit on Copy Issue
function copyErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to copy resources!"
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
  echo
}

# Exit on Build Issue
function buildErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to build $1!"
  if [[ ${ERR_NO_EXIT} == False ]]; then
    Cleanup
    exit 1
  fi
  echo
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
    "Clover"
    "Clover/AppleSupportPkg_209"
    "Clover/AppleSupportPkg_216"
    "OpenCore"
  )
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    dirs+=(
      "${!OUTDir_MODEL_CLOVER}"
      "${!OUTDir_MODEL_OC}"
      "${model}"
    )
  done
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
  elif [[ "$1" == "build-repo" ]]; then
    HGs=( "grep -A 2 OpenCorePkg | grep -m 1 RELEASE" )
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
    elif [[ "$2" == "build-repo" ]]; then
      rawURL="https://github.com/$1/$2/tags"
      rawURL="https://github.com$(curl -L --silent "${rawURL}" | grep -m 1 'OpenCorePkg' | tr -d '"' | tr -d ' ' | tr -d '>' | sed -e 's/<ahref=//')"
    else
      rawURL="https://github.com/$1/$2/releases$tag"
    fi
    for HG in "${HGs[@]}"; do
      if [[ ${LANGUAGE} == "zh_CN" ]]; then
        rawURL=${rawURL/#/${CFURL}/}
      fi
      URLs+=( "https://github.com$(curl -L --silent "${rawURL}" | grep '/download/' | eval "${HG}" | sed 's/^[^"]*"\([^"]*\)".*/\1/')" )
    done
  else
    if [[ "$2" == "AppleSupportPkg_209" || "$2" == "AppleSupportPkg_216" ]]; then
      rawURL="https://api.github.com/repos/$1/AppleSupportPkg/releases$tag"
    elif [[ "$2" == "build-repo" ]]; then
      rawURL="https://api.github.com/repos/$1/$2/releases"
    else
      rawURL="https://api.github.com/repos/$1/$2/releases$tag"
    fi
    for HG in "${HGs[@]}"; do
      if [[ "$2" == "build-repo" ]]; then
        URLs+=( "$(curl --silent "${rawURL}" | grep -A 100 'OpenCorePkg' | grep 'browser_download_url' | eval "${HG}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')" )
      else
        URLs+=( "$(curl --silent "${rawURL}" | grep 'browser_download_url' | eval "${HG}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')" )
      fi
    done
  fi

  if [[ ${LANGUAGE} == "zh_CN" ]]; then
    URLs=("${URLs[@]/#/${CFURL}/}")
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
  local URL="https://github.com/$1/$2/archive/$3.zip"
  if [[ ${LANGUAGE} == "zh_CN" ]]; then
    URL=${URL/#/${CFURL}/}
  fi
  echo "${green}[${reset}${blue}${bold} Downloading $2.zip ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./"$4" || exit 1
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
      cd ./"$3" || exit 1
      curl -# -L -O "${URL}" || networkErr "$2"
      cd - >/dev/null 2>&1 || exit 1
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
  if [[ ${LANGUAGE} == "zh_CN" ]]; then
    URL=${URL/#/${CFURL}/}
  fi
  echo "${green}[${reset}${blue}${bold} Downloading ${3##*\/} ${reset}${green}]${reset}"
  echo "${cyan}"
  curl -# -L -O "${URL}" || networkErr "${3##*\/}"
  echo "${reset}"
}

# Build Pre-release Kexts
function BKextHelper() {
  local liluPlugins
  local voodooinputPlugins="VoodooI2C VoodooPS2"
  local PATH_TO_DBG_BIG="Build/Products/Debug/"
  local PATH_TO_REL="build/Release/"
  local PATH_TO_REL_BIG="Build/Products/Release/"
  local PATH_TO_REL_SMA="build/Products/Release/"
  local lineNum

  if [[ ${MODEL} =~ "CML" ]]; then
    liluPlugins="AppleALC HibernationFixup WhateverGreen RestrictEvents VirtualSMC NoTouchID"
  elif [[ ${MODEL} =~ "KBL" ]]; then
    liluPlugins="AppleALC HibernationFixup WhateverGreen RestrictEvents VirtualSMC"
  fi

  echo "${green}[${reset}${blue}${bold} Building $2 ${reset}${green}]${reset}"
  if [[ ${LANGUAGE} != "zh_CN" ]]; then
    git clone --depth=1 https://github.com/"$1"/"$2".git >/dev/null 2>&1
  else
    git clone --depth=1 ${CFURL}/https://github.com/"$1"/"$2".git >/dev/null 2>&1
  fi
  cd "$2" || exit 1
  if [[ ${liluPlugins} =~ $2 ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    cp -R "../Lilu.kext" "./" || copyErr
    if [[ "$2" == "VirtualSMC" ]]; then
      xcodebuild -jobs 1 -target Package -configuration Release >/dev/null 2>&1 || buildErr "$2"
      mkdir ../Kexts
      cp -R ${PATH_TO_REL}*.kext "../Kexts/" || copyErr
    elif [[ "$2" == "AppleALC" ]]; then
      mkdir -p "tmp" || exit 1
      cp -R "Resources/ALC256" "tmp" || copyErr
      (cd "tmp/ALC256" && find . -maxdepth 1 ! -path "./Info.plist" ! -path "./layout69.xml" ! -path "./Platforms69.xml" -exec rm -rf {} + >/dev/null 2>&1 || exit 1)
      cp -R "Resources/ALC298" "tmp" || copyErr
      (cd "tmp/ALC298" && find . -maxdepth 1 ! -path "./Info.plist" ! -path "./layout30.xml" ! -path "./Platforms30.xml" ! -path "./layout99.xml" ! -path "./Platforms99.xml" -exec rm -rf {} + >/dev/null 2>&1 || exit 1)
      if [[ "${MODEL}" =~ "CML" ]]; then
        # Delete unrelated layout resources in AppleALC
        (cd "Resources" && find . -type d -maxdepth 1 ! -path "./PinConfigs.kext" -exec rm -rf {} + >/dev/null 2>&1 || exit 1)
        cp -R "tmp/ALC256" "Resources" || copyErr
        xcodebuild clean >/dev/null 2>&1 || buildErr "$2"
        xcodebuild -jobs 1 -configuration Release >/dev/null 2>&1 || buildErr "$2"
        cp -R ${PATH_TO_REL}*.kext "../CML" || copyErr
      fi
      if [[ "${MODEL}" =~ "KBL" ]]; then
        # Delete unrelated layout resources in AppleALC
        (cd "Resources" && find . -type d -maxdepth 1 ! -path "./PinConfigs.kext" -exec rm -rf {} + >/dev/null 2>&1 || exit 1)
        cp -R "tmp/ALC298" "Resources" || copyErr
        xcodebuild clean >/dev/null 2>&1 || buildErr "$2"
        xcodebuild -jobs 1 -configuration Release >/dev/null 2>&1 || buildErr "$2"
        cp -R ${PATH_TO_REL}*.kext "../KBL" || copyErr
      fi
    elif [[ "$2" == "NoTouchID" ]]; then
      xcodebuild -jobs 1 -configuration Release -arch x86_64 CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../CML" || copyErr
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

      xcodebuild -workspace "VoodooI2C.xcworkspace" -scheme "VoodooI2C" -derivedDataPath . clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO >/dev/null 2>&1 || buildErr "$2"
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
    mkdir -p "tmp" || exit 1
    cp -R IntelBluetoothFirmware/fw/ibt-12* "tmp" || copyErr
    cp -R IntelBluetoothFirmware/fw/ibt-19-0* "tmp" || copyErr

    if [[ "${MODEL}" =~ "CML" ]]; then
      # Delete unrelated firmware and only keep ibt-19-0*.sfi for Intel Wireless 9560
      rm -rf "IntelBluetoothFirmware/FwBinary.cpp" || exit 1
      rm -rf IntelBluetoothFirmware/fw/* >/dev/null 2>&1
      cp -R tmp/ibt-19-0* "IntelBluetoothFirmware/fw/" || copyErr
      xcodebuild -alltargets clean >/dev/null 2>&1 || buildErr "$2"
      xcodebuild -alltargets -configuration Release >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../CML" || copyErr
    fi
    if [[ "${MODEL}" =~ "KBL" ]]; then
      # Delete unrelated firmware and only keep ibt-12*.sfi for Intel Wireless 8265
      rm -rf "IntelBluetoothFirmware/FwBinary.cpp" || exit 1
      rm -rf IntelBluetoothFirmware/fw/* >/dev/null 2>&1
      cp -R tmp/ibt-12* "IntelBluetoothFirmware/fw/" || copyErr
      xcodebuild -alltargets clean >/dev/null 2>&1 || buildErr "$2"
      xcodebuild -alltargets -configuration Release >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../KBL" || copyErr
    fi
  elif [[ "$2" == "itlwm" ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    # Pass print syntax to support Python3
    /usr/bin/sed -i "" "s:print compress(\"test\"):pass:g" "scripts/zlib_compress_fw.py"

    mkdir -p "tmp" || exit 1
    cp -R itlwm/firmware/iwlwifi-QuZ* "tmp" || copyErr
    cp -R itlwm/firmware/iwm-8265* "tmp" || copyErr
    if [[ "${MODEL}" =~ "CML" ]]; then
      # Delete unrelated firmware and only keep iwlwifi-QuZ* for Intel Wireless 9560
      rm -rf "include/FwBinary.cpp" >/dev/null 2>&1
      rm -rf itlwm/firmware/* || exit 1
      cp -R tmp/iwlwifi-QuZ* "itlwm/firmware/" || copyErr

      xcodebuild -scheme "AirportItlwm (all)" clean >/dev/null 2>&1 || buildErr "$2"
      xcodebuild -scheme "AirportItlwm (all)" -configuration Debug -derivedDataPath . >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_DBG_BIG}* "../CML" || copyErr
    fi
    if [[ "${MODEL}" =~ "KBL" ]]; then
      # Delete unrelated firmware and only keep iwm-8265* for Intel Wireless 8265
      rm -rf "include/FwBinary.cpp" >/dev/null 2>&1
      rm -rf itlwm/firmware/* || exit 1
      cp -R tmp/iwm-8265* "itlwm/firmware/" || copyErr

      xcodebuild -scheme "AirportItlwm (all)" clean >/dev/null 2>&1 || buildErr "$2"
      xcodebuild -scheme "AirportItlwm (all)" -configuration Debug -derivedDataPath . >/dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_DBG_BIG}* "../KBL" || copyErr
    fi
  fi
  cd ../ || exit 1
  echo
}

function BKext() {
  local GITHUB_REF=""

  if [[ ${NO_XCODE} == True ]]; then
    echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Missing Xcode tools, won't build kexts!"
    exit 1
  fi

  if [[ ${LANGUAGE} != "zh_CN" ]]; then
    git clone https://github.com/acidanthera/MacKernelSDK >/dev/null 2>&1
    src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/Lilu/master/Lilu/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
    src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/VoodooInput/master/VoodooInput/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
  else
    git clone ${CFURL}/https://github.com/acidanthera/MacKernelSDK >/dev/null 2>&1
    src=$(/usr/bin/curl -Lfs ${CFURL}/https://raw.githubusercontent.com/acidanthera/Lilu/master/Lilu/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
    src=$(/usr/bin/curl -Lfs ${CFURL}/https://raw.githubusercontent.com/acidanthera/VoodooInput/master/VoodooInput/Scripts/bootstrap.sh) && eval "$src" >/dev/null 2>&1 || exit 1
  fi
  if [[ ${MODEL} =~ "CML" ]]; then
    BKextHelper al3xtjames NoTouchID
  fi
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
    # williambj1's OpenCore-Factory repository has been archived
    # DGR williambj1 OpenCore-Factory PreRelease "OpenCore"
    DGR dortania build-repo NULL "OpenCore"
  else
    DGR ${ACDT} OpenCorePkg NULL "OpenCore"
  fi

  # Kexts
  DBR Rehabman os-x-null-ethernet

  if [[ ${MODEL} =~ "KBL" ]]; then
    DBR Rehabman os-x-eapd-codec-commander "KBL"
  fi

  if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
    BKext
  else
    for acdtKext in "${acdtKexts[@]}"; do
      DGR ${ACDT} "${acdtKext}"
    done
    for oiwKext in "${oiwKexts[@]}"; do
      DGR ${OIW} "${oiwKext}" PreRelease
    done
    if [[ ${MODEL} =~ "CML" ]]; then
      DGR al3xtjames NoTouchID NULL "CML"
    fi
    DGR VoodooI2C VoodooI2C
  fi

  DGS RehabMan hack-tools master

  # UEFI drivers
  # AppleSupportPkg v2.0.9
  DGR ${ACDT} AppleSupportPkg_209 19214108 "Clover/AppleSupportPkg_209"
  # AppleSupportPkg v2.1.6
  DGR ${ACDT} AppleSupportPkg_216 24123335 "Clover/AppleSupportPkg_216"

  # UEFI
  # DPB ${ACDT} OcBinaryData Drivers/HfsPlus.efi
  DPB ${ACDT} VirtualSMC EfiDriver/VirtualSmc.efi

  # HfsPlus.efi & OC Resources
  DGS ${ACDT} OcBinaryData master

  # XiaoMi-Pro ACPI patch
  if [[ ${REMOTE} == True ]]; then
    DGS daliansky ${REPO_NAME} ${REPO_BRANCH}
  fi

  # Menchen's ALCPlugFix
  if [[ ${REMOTE} == True ]]; then
    DGS Menchen ALCPlugFix master
  fi
}

# Unpack
function Unpack() {
  echo "${green}[${reset}${yellow}${bold} Unpacking ${reset}${green}]${reset}"
  unzip -qq "*.zip" || exit 1
  if [[ "${MODEL}" =~ "CML" ]] && [[ ${PRE_RELEASE} != *Kext* ]]; then
    (cd "CML" && unzip -qq ./*.zip || exit 1)
  fi
  if [[ "${MODEL}" =~ "KBL" ]]; then
    (cd "KBL" && unzip -qq ./*.zip || exit 1)
  fi
  echo
}

# Patch
function Patch() {
  local unusedItems=(
    "HibernationFixup.kext/Contents/_CodeSignature"
    "Kexts/SMCBatteryManager.kext/Contents/Resources"
    "KBL/Release/CodecCommander.kext/Contents/Resources"
    "RestrictEvents.kext/Contents/_CodeSignature"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"
    "WhateverGreen.kext/Contents/_CodeSignature"
  )
  echo "${green}[${reset}${blue}${bold} Patching Resources ${reset}${green}]${reset}"
  for unusedItem in "${unusedItems[@]}"; do
    rm -rf "${unusedItem}" >/dev/null 2>&1
  done

  # Only keep OCEFIAudio_VoiceOver_Boot in OcBinaryData/Resources/Audio
  (cd "OcBinaryData-master/Resources/Audio/" && find . -maxdepth 1 -not -name "OCEFIAudio_VoiceOver_Boot*" -delete || exit 1)

  # Rename AirportItlwm.kexts to distinguish different versions
  if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
    for model in "${MODEL_LIST[@]}"; do
      mv "${model}/Big Sur/AirportItlwm.kext" "${model}/Big Sur/AirportItlwm_Big_Sur.kext" || exit 1
      mv "${model}/Catalina/AirportItlwm.kext" "${model}/Catalina/AirportItlwm_Catalina.kext" || exit 1
      mv "${model}/High Sierra/AirportItlwm.kext" "${model}/High Sierra/AirportItlwm_High_Sierra.kext" || exit 1
      mv "${model}/Mojave/AirportItlwm.kext" "${model}/Mojave/AirportItlwm_Mojave.kext" || exit 1
    done
  else
    mv "Big Sur/AirportItlwm.kext" "Big Sur/AirportItlwm_Big_Sur.kext" || exit 1
    mv "Catalina/AirportItlwm.kext" "Catalina/AirportItlwm_Catalina.kext" || exit 1
    mv "High Sierra/AirportItlwm.kext" "High Sierra/AirportItlwm_High_Sierra.kext" || exit 1
    mv "Mojave/AirportItlwm.kext" "Mojave/AirportItlwm_Mojave.kext" || exit 1
  fi
  echo
}

# Install
function Install() {
  # Kexts
  local sharedKextItems=(
    "HibernationFixup.kext"
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
    "Release/NullEthernet.kext"
  )
  if [[ "${MODEL}" =~ "CML" ]]; then
    local cmlKextItems=(
      "AppleALC.kext"
      "IntelBluetoothFirmware.kext"
      "IntelBluetoothInjector.kext"
    )
    if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
      cmlKextItems=("${cmlKextItems[@]/#/CML/}")
    fi
    cmlKextItems+=(
      "${sharedKextItems[@]}"
      "CML/NoTouchID.kext"
    )
    local cmlWifiKextItems=(
      "Big Sur/AirportItlwm_Big_Sur.kext"
      "Catalina/AirportItlwm_Catalina.kext"
    )
    if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
      cmlWifiKextItems=("${cmlWifiKextItems[@]/#/CML/}")
    fi
    local cmlCloverKextFolders=(
      "10.15"
      "11"
    )
  fi
  if [[ "${MODEL}" =~ "KBL" ]]; then
    local kblKextItems=(
      "AppleALC.kext"
      "IntelBluetoothFirmware.kext"
      "IntelBluetoothInjector.kext"
    )
    if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
      kblKextItems=("${kblKextItems[@]/#/KBL/}")
    fi
    kblKextItems+=(
      "${sharedKextItems[@]}"
      "KBL/Release/CodecCommander.kext"
    )
    local kblWifiKextItems=(
      "Big Sur/AirportItlwm_Big_Sur.kext"
      "Catalina/AirportItlwm_Catalina.kext"
      "High Sierra/AirportItlwm_High_Sierra.kext"
      "Mojave/AirportItlwm_Mojave.kext"
    )
    if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
      kblWifiKextItems=("${kblWifiKextItems[@]/#/KBL/}")
    fi
    local kblCloverKextFolders=(
      "10.13"
      "10.14"
      "10.15"
      "11"
    )
  fi

  echo "${green}[${reset}${blue}${bold} Installing Kexts ${reset}${green}]${reset}"
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_Prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    MODEL_KextItems="${model_Prefix}KextItems"
    MODEL_WifiKextItems="${model_Prefix}WifiKextItems"
    MODEL_CloverKextFolders="${model_Prefix}CloverKextFolders"
    kextItems="${MODEL_KextItems}[@]"
    for Kextdir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/Other/" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/"; do
      mkdir -p "${Kextdir}" || exit 1
      for kextItem in "${!kextItems}"; do
        cp -R "${kextItem}" "${Kextdir}" || copyErr
      done
    done

    cloverKextFolder="${MODEL_CloverKextFolders}[@]"
    for cloverKextFolder in "${!cloverKextFolder}"; do
      mkdir -p "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/${cloverKextFolder}" || exit 1
    done

    if [[ ${model} == "CML" ]]; then
      cp -R "CML/NoTouchID.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.15" || copyErr
    fi
    if [[ ${PRE_RELEASE} =~ "Kext" ]]; then
      cp -R "${model}/Big Sur/AirportItlwm_Big_Sur.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/11" || copyErr
      cp -R "${model}/Catalina/AirportItlwm_Catalina.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.15" || copyErr
      if [[ ${model} == "KBL" ]]; then
        cp -R "${model}/High Sierra/AirportItlwm_High_Sierra.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.13" || copyErr
        cp -R "${model}/Mojave/AirportItlwm_Mojave.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.14" || copyErr
      fi
    else
      cp -R "Big Sur/AirportItlwm_Big_Sur.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/11" || copyErr
      cp -R "Catalina/AirportItlwm_Catalina.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.15" || copyErr
      if [[ ${model} == "KBL" ]]; then
        cp -R "High Sierra/AirportItlwm_High_Sierra.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.13" || copyErr
        cp -R "Mojave/AirportItlwm_Mojave.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.14" || copyErr
      fi
    fi

    kextItems="${MODEL_WifiKextItems}[@]"
    for kextItem in "${!kextItems}"; do
      cp -R "${kextItem}" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/" || copyErr
    done
  done
  echo

  # Drivers
  local driverItems=(
    "OcBinaryData-master/Drivers/ExFatDxe.efi"
    "OcBinaryData-master/Drivers/HfsPlus.efi"
  )

  echo "${green}[${reset}${blue}${bold} Installing Drivers ${reset}${green}]${reset}"
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    for Driverdir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/drivers/UEFI/" "${!OUTDir_MODEL_OC}/EFI/OC/Drivers/"; do
      mkdir -p "${Driverdir}" || exit 1
      for driverItem in "${driverItems[@]}"; do
        cp "${driverItem}" "${Driverdir}" || copyErr
      done
    done
    cp "VirtualSmc.efi" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/drivers/UEFI/" || copyErr
  done
  echo

  # ACPI
  local sharedAcpiItems=(
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-ALS0.aml"
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-DMAC.aml"
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-EC.aml"
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-GPRW.aml"
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-HPET.aml"
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-MCHC.aml"
    "${REPO_NAME_BRANCH}/ACPI/Shared/SSDT-RMNE.aml"
  )
  if [[ "${MODEL}" =~ "KBL" ]]; then
    local kblAcpiItems=( "${sharedAcpiItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-DDGPU.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-LGPA.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-MEM2.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-PMC.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-PNLF.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-PS2K.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-TPD0.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-XCPM.aml"
    )
    if [[ ${REMOTE} == False ]]; then
      kblAcpiItems=("${kblAcpiItems[@]/${REPO_NAME_BRANCH}/..}")
    fi
  fi
  if [[ "${MODEL}" =~ "CML" ]]; then
    local cmlAcpiItems=( "${sharedAcpiItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-AWAC.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-DDGPU.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-LGPA.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-PMC.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-PNLFCFL.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-PS2K.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-TPD0.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-XCPM.aml"
    )
    if [[ ${REMOTE} == False ]]; then
      cmlAcpiItems=("${cmlAcpiItems[@]/${REPO_NAME_BRANCH}/..}")
    fi
  fi

  echo "${green}[${reset}${blue}${bold} Installing ACPIs ${reset}${green}]${reset}"
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_Prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    MODEL_AcpiItems="${model_Prefix}AcpiItems"
    acpiItems="${MODEL_AcpiItems}[@]"
    for ACPIdir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/ACPI/patched/" "${!OUTDir_MODEL_OC}/EFI/OC/ACPI/"; do
      mkdir -p "${ACPIdir}" || exit 1
      for acpiItem in "${!acpiItems}"; do
        cp "${acpiItem}" "${ACPIdir}" || copyErr
      done
    done
  done
  echo

  # Theme
  echo "${green}[${reset}${blue}${bold} Installing Themes ${reset}${green}]${reset}"
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    if [[ ${REMOTE} == True ]]; then
      cp -R "${REPO_NAME_BRANCH}/CLOVER/themes" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/" || copyErr
    else
      cp -R "../CLOVER/themes" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/" || copyErr
    fi

    cp -R "OcBinaryData-master/Resources" "${!OUTDir_MODEL_OC}/EFI/OC/" || copyErr
  done
  echo

  # config & README & LICENSE
  echo "${green}[${reset}${blue}${bold} Installing config & README & LICENSE ${reset}${green}]${reset}"
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_Prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    MODEL_Config="config_${model_Prefix}.plist"
    if [[ ${REMOTE} == True ]]; then
      cp "${REPO_NAME_BRANCH}/CLOVER/${MODEL_Config}" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/config.plist" || copyErr
      cp "${REPO_NAME_BRANCH}/OC/${MODEL_Config}" "${!OUTDir_MODEL_OC}/EFI/OC/config.plist" || copyErr
      for READMEdir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
        if [[ ${LANGUAGE} == "en_US" ]]; then
          cp "${REPO_NAME_BRANCH}/README.md" "${READMEdir}" || copyErr
        elif [[ ${LANGUAGE} == "zh_CN" ]]; then
          cp "${REPO_NAME_BRANCH}/README_CN.md" "${READMEdir}" || copyErr
        fi
        cp "${REPO_NAME_BRANCH}/LICENSE" "${READMEdir}" || copyErr
      done
    else
      cp "../CLOVER/${MODEL_Config}" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/config.plist" || copyErr
      cp "../OC/${MODEL_Config}" "${!OUTDir_MODEL_OC}/EFI/OC/config.plist" || copyErr
      for READMEdir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
        if [[ ${LANGUAGE} == "en_US" ]]; then
          cp "../README.md" "${READMEdir}" || copyErr
        elif [[ ${LANGUAGE} == "zh_CN" ]]; then
          cp "../README_CN.md" "${READMEdir}" || copyErr
        fi
        cp "../LICENSE" "${READMEdir}" || copyErr
      done
    fi
  done
  echo

  # Bluetooth & GTX/MX350 & wiki
  local lgpaDir

  if [[ ${LANGUAGE} == "en_US" ]]; then
    local sharedBtItems=( "${REPO_NAME_BRANCH}/Docs/Work-Around-with-Bluetooth.pdf" )
  elif [[ ${LANGUAGE} == "zh_CN" ]]; then
    local sharedBtItems=( "${REPO_NAME_BRANCH}/Docs/蓝牙解决方案.pdf" )
  fi
  if [[ "${MODEL}" =~ "CML" ]]; then
    local cmlBtItems=( "${sharedBtItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB-ALL.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB-FingerBT.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB-USBBT.aml"
    )
    if [[ ${REMOTE} == False ]]; then
      cmlBtItems=("${cmlBtItems[@]/${REPO_NAME_BRANCH}/..}")
    fi
  fi
  if [[ "${MODEL}" =~ "KBL" ]]; then
    local kblBtItems=( "${sharedBtItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-ALL.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-FingerBT.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-USBBT.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-WLAN_LTEBT.aml"
    )
    if [[ ${REMOTE} == False ]]; then
      kblBtItems=("${kblBtItems[@]/${REPO_NAME_BRANCH}/..}")
    fi
  fi

  echo "${green}[${reset}${blue}${bold} Installing Docs About Bluetooth & GTX/MX350 & wiki ${reset}${green}]${reset}"
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_Prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    MODEL_BtItems="${model_Prefix}BtItems"
    btItems="${MODEL_BtItems}[@]"
    for BTdir in "${!OUTDir_MODEL_CLOVER}/Bluetooth" "${!OUTDir_MODEL_OC}/Bluetooth"; do
      mkdir -p "${BTdir}" || exit 1
      for btItem in "${!btItems}"; do
        cp "${btItem}" "${BTdir}" || copyErr
      done
    done

    if [[ "${MODEL}" =~ "KBL" ]]; then
      local kblLgpaItems=( "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-LGPAGTX.aml" )
      if [[ ${LANGUAGE} == "en_US" ]]; then
        if [[ ${REMOTE} == False ]]; then
          cp "../Docs/README_\${MODEL}.txt" "README_GTX.txt"
          kblLgpaItems=("${kblLgpaItems[@]/${REPO_NAME_BRANCH}/..}")
        else
          cp "${REPO_NAME_BRANCH}/Docs/README_\${MODEL}.txt" "README_GTX.txt"
        fi
        /usr/bin/sed -i "" "s:\${MODEL}:GTX:g" "README_GTX.txt"
        /usr/bin/sed -i "" "s:\${MODEL_PREFIX}:GTX:g" "README_GTX.txt"
        kblLgpaItems+=( "README_GTX.txt" )
      elif [[ ${LANGUAGE} == "zh_CN" ]]; then
        if [[ ${REMOTE} == False ]]; then
          cp "../Docs/README_CN_\${MODEL}.txt" "README_CN_GTX.txt"
          kblLgpaItems=("${kblLgpaItems[@]/${REPO_NAME_BRANCH}/..}")
        else
          cp "${REPO_NAME_BRANCH}/Docs/README_CN_\${MODEL}.txt" "README_CN_GTX.txt"
        fi
        /usr/bin/sed -i "" "s:\${MODEL}:GTX:g" "README_CN_GTX.txt"
        /usr/bin/sed -i "" "s:\${MODEL_PREFIX}:GTX:g" "README_GTX.txt"
        kblLgpaItems=( "README_CN_GTX.txt" )
      fi
    fi
    if [[ "${MODEL}" =~ "CML" ]]; then
      local cmlLgpaItems=( "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-LGPA350.aml" )
      if [[ ${LANGUAGE} == "en_US" ]]; then
        if [[ ${REMOTE} == False ]]; then
          cp "../Docs/README_\${MODEL}.txt" "README_MX350.txt"
          cmlLgpaItems=("${cmlLgpaItems[@]/${REPO_NAME_BRANCH}/..}")
        else
          cp "${REPO_NAME_BRANCH}/Docs/README_\${MODEL}.txt" "README_MX350.txt"
        fi
        /usr/bin/sed -i "" "s:\${MODEL}:MX350:g" "README_MX350.txt"
        /usr/bin/sed -i "" "s:\${MODEL_PREFIX}:350:g" "README_MX350.txt"
        cmlLgpaItems+=( "README_MX350.txt" )
      elif [[ ${LANGUAGE} == "zh_CN" ]]; then
        if [[ ${REMOTE} == False ]]; then
          cp "../Docs/README_CN_\${MODEL}.txt" "README_CN_MX350.txt"
          cmlLgpaItems=("${cmlLgpaItems[@]/${REPO_NAME_BRANCH}/..}")
        else
          cp "${REPO_NAME_BRANCH}/Docs/README_CN_\${MODEL}.txt" "README_CN_MX350.txt"
        fi
        /usr/bin/sed -i "" "s:\${MODEL}:MX350:g" "README_CN_MX350.txt"
        /usr/bin/sed -i "" "s:\${MODEL_PREFIX}:350:g" "README_CN_MX350.txt"
        cmlLgpaItems=( "README_CN_MX350.txt" )
      fi
    fi

    MODEL_LgpaItems="${model_Prefix}LgpaItems"
    lgpaItems="${MODEL_LgpaItems}[@]"
    if [[ ${model} == "KBL" ]]; then
      lgpaDir="GTX"
    elif [[ ${model} == "CML" ]]; then
      lgpaDir="MX350"
    fi
    for LGPAdir in "${!OUTDir_MODEL_CLOVER}/${lgpaDir}" "${!OUTDir_MODEL_OC}/${lgpaDir}"; do
      mkdir -p "${LGPAdir}" || exit 1
      for lgpaItem in "${!lgpaItems}"; do
        cp "${lgpaItem}" "${LGPAdir}" || copyErr
      done
    done

    if [[ ${LANGUAGE} == "en_US" ]]; then
      local wikiItems=(
        "${REPO_NAME_BRANCH}/Docs/FAQ.pdf"
        "${REPO_NAME_BRANCH}/Docs/Set-DVMT-to-64mb.pdf"
        "${REPO_NAME_BRANCH}/Docs/Unlock-0xE2-MSR.pdf"
      )
    elif [[ ${LANGUAGE} == "zh_CN" ]]; then
      local wikiItems=(
        "${REPO_NAME_BRANCH}/Docs/常见问题解答.pdf"
        "${REPO_NAME_BRANCH}/Docs/设置64mb动态显存.pdf"
        "${REPO_NAME_BRANCH}/Docs/解锁0xE2寄存器.pdf"
      )
    fi
    if [[ ${REMOTE} == False ]]; then
      wikiItems=("${wikiItems[@]/${REPO_NAME_BRANCH}/..}")
    fi

    for WIKIdir in "${!OUTDir_MODEL_CLOVER}/Docs" "${!OUTDir_MODEL_OC}/Docs"; do
      mkdir -p "${WIKIdir}" || exit 1
      for wikiItem in "${wikiItems[@]}"; do
        cp "${wikiItem}" "${WIKIdir}" || copyErr
      done
    done
  done
  echo

  # ALCPlugFix
  if [[ "${MODEL}" =~ "KBL" ]]; then
    kblAlcfixItems=(
      "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/alc_fix"
      "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/build"
      "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/README.MD"
    )
  fi

  if [[ ${MODEL} =~ "KBL" ]]; then
    local OUTDir_MODEL_CLOVER="OUTDir_KBL_CLOVER"
    local OUTDir_MODEL_OC="OUTDir_KBL_OC"
    if [[ ${REMOTE} == True ]]; then
      cp -R ALCPlugFix-master/* "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/" || copyErr
    else
      kblAlcfixItems=("${kblAlcfixItems[@]/${REPO_NAME_BRANCH}/..}")
      cd "../" || exit 1
      git submodule init >/dev/null 2>&1 && git submodule update --remote >/dev/null 2>&1 && cd "${WSDir}" || exit 1
    fi

    echo "${green}[${reset}${blue}${bold} Installing ALCPlugFix ${reset}${green}]${reset}"
    for ALCPFdir in "${!OUTDir_MODEL_CLOVER}/ALCPlugFix" "${!OUTDir_MODEL_OC}/ALCPlugFix"; do
      mkdir -p "${ALCPFdir}" || exit 1
      for alcfixItem in "${kblAlcfixItems[@]}"; do
        cp -R "${alcfixItem}" "${ALCPFdir}" || copyErr
      done
    done
    echo
  fi
}

# Extract files for Clover
function ExtractClover() {
  local driverItems=(
    "Clover/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix/OpenRuntime.efi"
    "Clover/AppleSupportPkg_209/Drivers/AppleGenericInput.efi"
    "Clover/AppleSupportPkg_209/Drivers/AppleUiSupport.efi"
    "Clover/AppleSupportPkg_216/Drivers/ApfsDriverLoader.efi"
  )

  echo "${green}[${reset}${blue}${bold} Extracting Clover ${reset}${green}]${reset}"
  # From CloverV2, AppleSupportPkg v2.0.9, and AppleSupportPkg v2.1.6
  unzip -qq -d "Clover" "Clover/*.zip" || exit 1
  unzip -qq -d "Clover/AppleSupportPkg_209" "Clover/AppleSupportPkg_209/*.zip" || exit 1
  unzip -qq -d "Clover/AppleSupportPkg_216" "Clover/AppleSupportPkg_216/*.zip" || exit 1
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    cp -R "Clover/CloverV2/EFI/BOOT" "${!OUTDir_MODEL_CLOVER}/EFI/" || copyErr
    cp "Clover/CloverV2/EFI/CLOVER/CLOVERX64.efi" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/" || copyErr
    cp -R "Clover/CloverV2/EFI/CLOVER/tools" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/" || copyErr
    for driverItem in "${driverItems[@]}"; do
      cp "${driverItem}" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/drivers/UEFI/" || copyErr
    done
  done
  echo
}

# Extract files from OpenCore
function ExtractOC() {
  local driverItems=(
    "OpenCore/X64/EFI/OC/Drivers/AudioDxe.efi"
    "OpenCore/X64/EFI/OC/Drivers/OpenCanopy.efi"
    "OpenCore/X64/EFI/OC/Drivers/OpenRuntime.efi"
  )
  local toolItems=(
    "OpenCore/X64/EFI/OC/Tools/OpenShell.efi"
  )

  echo "${green}[${reset}${blue}${bold} Extracting OpenCore ${reset}${green}]${reset}"
  unzip -qq -d "OpenCore" "OpenCore/*.zip" || exit 1
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    mkdir -p "${!OUTDir_MODEL_OC}/EFI/OC/Tools" || exit 1
    cp -R "OpenCore/X64/EFI/BOOT" "${!OUTDir_MODEL_OC}/EFI/" || copyErr
    cp "OpenCore/X64/EFI/OC/OpenCore.efi" "${!OUTDir_MODEL_OC}/EFI/OC/" || copyErr
    for driverItem in "${driverItems[@]}"; do
      cp "${driverItem}" "${!OUTDir_MODEL_OC}/EFI/OC/Drivers/" || copyErr
    done
    for toolItem in "${toolItems[@]}"; do
      cp "${toolItem}" "${!OUTDir_MODEL_OC}/EFI/OC/Tools/" || copyErr
    done
    cp "OpenCore/Docs/Configuration.pdf" "${!OUTDir_MODEL_OC}/Docs/OC Configuration.pdf" || copyErr
  done
  echo
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
  printVersion=$(echo "${VERSION}" | sed 's/-/\ /g' | sed 's/beta/beta\ /g')
  printf "## XiaoMi NoteBook Pro EFI %s\n" "${printVersion}" >> ReleaseNotes.md
  # Release warning
  echo "#### OC Recommendation: A NVRAM reset is highly suggested when upgrading from OpenCore v0.6.3 if \`BootProtect\` was set. Visit [acidanthera/bugtracker#1222 (comment)](https://github.com/acidanthera/bugtracker/issues/1222#issuecomment-739241310) for more information." >> ReleaseNotes.md

  lineStart=$(grep -n "XiaoMi NoteBook Pro EFI v" ${changelogPath}) && lineStart=${lineStart%%:*} && lineStart=$((lineStart+1))
  lineEnd=$(grep -n -m2 "XiaoMi NoteBook Pro EFI v" ${changelogPath} | tail -n1)
  lineEnd=${lineEnd%%:*} && lineEnd=$((lineEnd-3))
  sed -n "${lineStart},${lineEnd}p" ${changelogPath} >> ReleaseNotes.md

  # Generate Cloudflare links when publish EFI release
  if [[ "${GITHUB_REF}" = refs/tags/* ]]; then
    echo "-----" >> ReleaseNotes.md
    printf "#### 国内加速下载链接：\nDownload link for China:\n" >> ReleaseNotes.md
    for model in "${MODEL_LIST[@]}"; do
      OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
      OUTDir_MODEL_OC="OUTDir_${model}_OC"
      echo "- [${!OUTDir_MODEL_CLOVER}.zip](${CFURL}/https://github.com/daliansky/${REPO_NAME}/releases/download/${CUR_TAG}/${!OUTDir_MODEL_CLOVER}.zip)" >> ReleaseNotes.md
      echo "- [${!OUTDir_MODEL_OC}.zip](${CFURL}/https://github.com/daliansky/${REPO_NAME}/releases/download/${CUR_TAG}/${!OUTDir_MODEL_OC}.zip)" >> ReleaseNotes.md
    done
  fi

  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    for RNotedir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
      cp "ReleaseNotes.md" "${RNotedir}" || copyErr
    done
  done
  echo
}

# Exclude Trash
function CTrash() {
  echo "${green}[${reset}${blue}${bold} Cleaning Trash Files ${reset}${green}]${reset}"
  if [[ ${CLEAN_UP} == True ]]; then
    find . -maxdepth 1 ! -path "./${OUTDir_KBL_CLOVER}" ! -path "./${OUTDir_KBL_OC}" ! -path "./${OUTDir_CML_CLOVER}" ! -path "./${OUTDir_CML_OC}" -exec rm -rf {} + >/dev/null 2>&1
  fi
  echo
}

# Enjoy
function Enjoy() {
  for model in "${MODEL_LIST[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    for BUILDdir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
      zip -qr "${BUILDdir}.zip" "${BUILDdir}"
    done
  done
  echo "${green}[${reset}${blue}${bold} Done! Enjoy! ${reset}${green}]${reset}"
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

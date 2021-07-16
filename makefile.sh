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
CFURL_1="https\://hackintosh.stevezheng.workers.dev"
FRWF="0xFireWolf"
OIW="OpenIntelWireless"
REPO_NAME="XiaoMi-Pro-Hackintosh"
REPO_BRANCH="main"
REPO_NAME_BRANCH="${REPO_NAME}-${REPO_BRANCH}"
RETRY_MAX=5

clean_up=true
err_no_exit=false
fail_flag=false
gh_api=false
language="en_US"
model_input=""
model_list=( )
no_xcode=false
pre_release=""
publish_efi=false
remote=true
version="local"

# Env
if [ "$(which xcodebuild)" = "" ] || [ "$(which git)" = "" ]; then
  no_xcode=true
elif [[ "${DEVELOPER_DIR}" = "" ]]; then
  DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
  xcodebuild -version && echo
else
  xcodebuild -version && echo
fi

# Language detect
language=$(locale | grep LANG | sed s/'LANG='// | tr -d '"' | cut -d "." -f 1)
if [[ ${language} != "zh_CN" ]]; then
  language="en_US"
fi

# Detect GitHub Action Tag
if [[ "${GITHUB_REF}" = refs/tags/* ]]; then
  publish_efi=true
fi

# Args
while [[ $# -gt 0 ]]; do
  key="$1"

  case "${key}" in
    --IGNORE_ERR)
    err_no_exit=true
    shift # past argument
    ;;
    --LANG=zh_CN)
    language="zh_CN"
    shift # past argument
    ;;
    --NO_CLEAN_UP)
    clean_up=false
    shift # past argument
    ;;
    --GH_API)
    gh_api=true
    shift # past argument
    ;;
    *)
    if [[ "${key}" =~ "--VERSION=" ]]; then
      version="${key##*=}"
      shift
    elif [[ "${key}" =~ "--PRE_RELEASE=" ]]; then
      pre_release+="${key##*=}"
      shift
    elif [[ "${key}" =~ "--MODEL=" ]]; then
      model_input+="${key##*=}"
      shift
    else
      shift
    fi
    ;;
  esac
done

if [[ "${model_input}" =~ "CML" ]]; then
  model_list+=( "CML" )
fi
if [[ "${model_input}" =~ "KBL" ]]; then
  model_list+=( "KBL" )
fi

# Assign KBL when no MODEL is entered
if [[ ${#model_list[@]} -eq 0 ]]; then
  model_input="KBL"
  model_list=( "KBL" )
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
OUTDir_KBL_CLOVER="XiaoMi_Pro-KBL-Clover-${version}"
OUTDir_KBL_OC="XiaoMi_Pro-KBL-OC-${version}"
OUTDir_CML_CLOVER="XiaoMi_Pro-CML-Clover-${version}"
OUTDir_CML_OC="XiaoMi_Pro-CML-OC-${version}"

# Kexts
# Require Lilu to be the last for bKext()
acdtKexts=(
  VirtualSMC
  WhateverGreen
  AppleALC
  HibernationFixup
  VoodooPS2
  BrcmPatchRAM
  Lilu
)

frwfKexts=(
  RealtekCardReader
  RealtekCardReaderFriend
)

oiwKexts=(
  IntelBluetoothFirmware
  itlwm
)

# Clean Up
function cleanUp() {
  if [[ ${clean_up} == true ]]; then
    rm -rf "${WSDir}"
  fi
}

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from $1, please check your connection!"
  if [[ "$2" == "skip" ]]; then
    echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Skip $1!"
    fail_flag=true
  elif [[ ${err_no_exit} == false ]]; then
    cleanUp
    exit 1
  fi
  echo
}

# Exit on Copy Issue
function copyErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to copy resources!"
  if [[ ${err_no_exit} == false ]]; then
    cleanUp
    exit 1
  fi
  echo
}

# Exit on Build Issue
function buildErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to build $1!"
  if [[ ${err_no_exit} == false ]]; then
    cleanUp
    exit 1
  fi
  echo
}

function init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  if [[ -d "${WSDir}" ]]; then
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
  for model in "${model_list[@]}"; do
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

  if [[ "$(dirname "$PWD")" =~ ${REPO_NAME} ]]; then
    remote=false
  else
    mkdir -p "${REPO_NAME_BRANCH}" || exit 1
  fi
}

# Workaround for Release Binaries that don't include "RELEASE" in their file names (head or grep)
function h_or_g() {
  if [[ "$1" == "VoodooI2C" ]]; then
    hgs=( "head -n 1" )
  elif [[ "$1" == "CloverBootloader" ]]; then
    hgs=( "grep -m 1 CloverV2" )
  elif [[ "$1" == "build-repo" ]]; then
    hgs=( "grep -A 2 OpenCorePkg | grep -m 1 RELEASE" )
  elif [[ "$1" == "EAPD-Codec-Commander" ]]; then
    hgs=( "grep -m 2 CodecCommander | grep -m 1 RELEASE" )
  elif [[ "$1" == "IntelBluetoothFirmware" ]]; then
    hgs=( "grep -m 1 IntelBluetooth" )
  elif [[ "$1" == "itlwm" ]]; then
    hgs=( "grep -m 1 AirportItlwm-Big_Sur"
          "grep -m 1 AirportItlwm-Catalina"
          "grep -m 1 AirportItlwm-High_Sierra"
          "grep -m 1 AirportItlwm-Mojave"
          "grep -m 1 AirportItlwm-Monterey"
        )
  else
    hgs=( "grep -m 1 RELEASE" )
  fi
}

# Download GitHub Release
function dGR() {
  local rawURL
  local urls=( )

  h_or_g "$2"

  if [[ -n ${3+x} ]]; then
    if [[ "$3" == "PreRelease" ]]; then
      tag=""
    elif [[ "$3" == "NULL" ]]; then
      tag="/latest"
    else
      if [[ -n ${GITHUB_ACTIONS+x} || ${gh_api} == false ]]; then
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

  if [[ -n ${GITHUB_ACTIONS+x} || ${gh_api} == false ]]; then
    if [[ "$2" == "AppleSupportPkg_209" || "$2" == "AppleSupportPkg_216" ]]; then
      rawURL="https://github.com/$1/AppleSupportPkg/releases$tag"
    elif [[ "$2" == "build-repo" ]]; then
      rawURL="https://github.com/$1/$2/tags"
      rawURL="https://github.com$(curl -L --silent "${rawURL}" | grep -m 1 'OpenCorePkg' | tr -d '"' | tr -d ' ' | tr -d '>' | sed -e 's/<ahref=//')"
    else
      rawURL="https://github.com/$1/$2/releases$tag"
    fi
    for hg in "${hgs[@]}"; do
      if [[ ${language} == "zh_CN" ]]; then
        rawURL=${rawURL/#/${CFURL}/}
      fi
      urls+=( "https://github.com$(curl -L --silent "${rawURL}" | grep '/download/' | eval "${hg}" | sed 's/^[^"]*"\([^"]*\)".*/\1/')" )
    done
  else
    if [[ "$2" == "AppleSupportPkg_209" || "$2" == "AppleSupportPkg_216" ]]; then
      rawURL="https://api.github.com/repos/$1/AppleSupportPkg/releases$tag"
    elif [[ "$2" == "build-repo" ]]; then
      rawURL="https://api.github.com/repos/$1/$2/releases"
    else
      rawURL="https://api.github.com/repos/$1/$2/releases$tag"
    fi
    for hg in "${hgs[@]}"; do
      if [[ "$2" == "build-repo" ]]; then
        urls+=( "$(curl --silent "${rawURL}" | grep -A 100 'OpenCorePkg' | grep 'browser_download_url' | eval "${hg}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')" )
      else
        urls+=( "$(curl --silent "${rawURL}" | grep 'browser_download_url' | eval "${hg}" | tr -d '"' | tr -d ' ' | sed -e 's/browser_download_url://')" )
      fi
    done
  fi

  if [[ ${language} == "zh_CN" ]]; then
    urls=("${urls[@]/#/${CFURL}/}")
  fi

  for url in "${urls[@]}"; do
    if [[ -z ${url} || ${url} == "https://github.com" ]]; then
      networkErr "$2" "$5"
    fi
    echo "${green}[${reset}${blue}${bold} Downloading ${url##*\/} ${reset}${green}]${reset}"
    echo "${cyan}"
    cd ./"$4" || exit 1
    curl -# -L -O "${url}" || networkErr "$2" "$5"
    cd - > /dev/null 2>&1 || exit 1
    echo "${reset}"
    if [[ ${fail_flag} == true ]]; then
      fail_flag=false
      return 1
    fi
  done
}

# Download GitHub Source Code
function dGS() {
  local url="https://github.com/$1/$2/archive/$3.zip"
  if [[ ${language} == "zh_CN" ]]; then
    url=${url/#/${CFURL}/}
  fi
  echo "${green}[${reset}${blue}${bold} Downloading $2.zip ${reset}${green}]${reset}"
  echo "${cyan}"
  cd ./"$4" || exit 1
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

# Download Pre-Built Binaries
function dPB() {
  local url="https://raw.githubusercontent.com/$1/$2/master/$3"
  if [[ ${language} == "zh_CN" ]]; then
    url=${url/#/${CFURL}/}
  fi
  echo "${green}[${reset}${blue}${bold} Downloading ${3##*\/} ${reset}${green}]${reset}"
  echo "${cyan}"
  curl -# -L -O "${url}" || networkErr "${3##*\/}"
  echo "${reset}"
}

# Build Pre-release Kexts
function bKextHelper() {
  local liluPlugins
  local voodooinputPlugins="VoodooI2C VoodooPS2"
  local PATH_TO_DBG_BIG="Build/Products/Debug/"
  local PATH_TO_REL="build/Release/"
  local PATH_TO_REL_BIG="Build/Products/Release/"
  local PATH_TO_REL_SMA="build/Products/Release/"
  local lineNum

  if [[ "${model_input}" =~ "CML" ]]; then
    liluPlugins="AppleALC BrcmPatchRAM HibernationFixup RealtekCardReaderFriend VirtualSMC WhateverGreen NoTouchID"
  elif [[ "${model_input}" =~ "KBL" ]]; then
    liluPlugins="AppleALC BrcmPatchRAM HibernationFixup RealtekCardReaderFriend VirtualSMC WhateverGreen"
  fi

  echo "${green}[${reset}${blue}${bold} Building $2 ${reset}${green}]${reset}"
  if [[ ${language} != "zh_CN" ]]; then
    git clone --depth=1 -q https://github.com/"$1"/"$2".git || networkErr "$2"
  else
    git clone --depth=1 -q ${CFURL}/https://github.com/"$1"/"$2".git || networkErr "$2"
  fi
  cd "$2" || exit 1
  if [[ ${liluPlugins} =~ $2 ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    cp -R "../Lilu.kext" "./" || copyErr
    if [[ "$2" == "VirtualSMC" ]]; then
      xcodebuild -jobs 1 -target Package -configuration Release > /dev/null 2>&1 || buildErr "$2"
      mkdir ../Kexts
      cp -R ${PATH_TO_REL}*.kext "../Kexts/" || copyErr
    elif [[ "$2" == "AppleALC" ]]; then
      mkdir -p "tmp" || exit 1
      cp -R "Resources/ALC256" "tmp" || copyErr
      (cd "tmp/ALC256" && find . -maxdepth 1 ! -path "./Info.plist" ! -path "./layout69.xml" ! -path "./Platforms69.xml" -exec rm -rf {} + > /dev/null 2>&1 || exit 1)
      cp -R "Resources/ALC298" "tmp" || copyErr
      (cd "tmp/ALC298" && find . -maxdepth 1 ! -path "./Info.plist" ! -path "./layout30.xml" ! -path "./Platforms30.xml" ! -path "./layout99.xml" ! -path "./Platforms99.xml" -exec rm -rf {} + > /dev/null 2>&1 || exit 1)
      if [[ "${model_input}" =~ "CML" ]]; then
        # Delete unrelated layout resources in AppleALC
        (cd "Resources" && find . -type d -maxdepth 1 ! -path "./PinConfigs.kext" -exec rm -rf {} + > /dev/null 2>&1 || exit 1)
        cp -R "tmp/ALC256" "Resources" || copyErr
        xcodebuild -jobs 1 -configuration Release > /dev/null 2>&1 || buildErr "$2"
        cp -R ${PATH_TO_REL}*.kext "../CML" || copyErr
        xcodebuild clean > /dev/null 2>&1 || buildErr "$2"
      fi
      if [[ "${model_input}" =~ "KBL" ]]; then
        # Delete unrelated layout resources in AppleALC
        (cd "Resources" && find . -type d -maxdepth 1 ! -path "./PinConfigs.kext" -exec rm -rf {} + > /dev/null 2>&1 || exit 1)
        cp -R "tmp/ALC298" "Resources" || copyErr
        xcodebuild -jobs 1 -configuration Release > /dev/null 2>&1 || buildErr "$2"
        cp -R ${PATH_TO_REL}*.kext "../KBL" || copyErr
      fi
    elif [[ "$2" == "NoTouchID" ]]; then
      xcodebuild -jobs 1 -configuration Release -arch x86_64 CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../CML" || copyErr
    elif [[ "$2" == "BrcmPatchRAM" ]]; then
      xcodebuild -jobs 1 -target Package -configuration Release > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL_SMA}*.kext "../" || copyErr
    else
      xcodebuild -jobs 1 -configuration Release > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../" || copyErr
    fi
  elif [[ ${voodooinputPlugins} =~ $2 ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    if [[ "$2" == "VoodooI2C" ]]; then
      cp -R "../VoodooInput" "./Dependencies/" || copyErr

      # Add Cloudflare redirect to gitmodules for Chinese users
      if [[ ${language} == "zh_CN" ]]; then
        /usr/bin/sed -i "" "s:https:${CFURL_1}/https:g" ".gitmodules"
      fi
      git submodule init -q && git submodule update -q || networkErr "VoodooI2C Satellites"

      if [[ -z ${GITHUB_ACTIONS+x} ]]; then
        # Delete Linting & Generate Documentation in Build Phase to avoid installing cpplint & cldoc
        lineNum=$(grep -n "Linting" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj) && lineNum=${lineNum%%:*}
        /usr/bin/sed -i '' "${lineNum}d" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj
        lineNum=$(grep -n "Generate Documentation" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj) && lineNum=${lineNum%%:*}
        /usr/bin/sed -i '' "${lineNum}d" VoodooI2C/VoodooI2C.xcodeproj/project.pbxproj
      else
        # Install cpplint & cldoc when using GitHub Action
        pip3 install -q cpplint || exit 1
        pip3 install -q git+https://github.com/VoodooI2C/cldoc.git || exit 1
      fi

      xcodebuild -workspace "VoodooI2C.xcworkspace" -scheme "VoodooI2C" -derivedDataPath . clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL_BIG}*.kext "../" || copyErr
    else
      cp -R "../VoodooInput" "./" || copyErr
      xcodebuild -jobs 1 -configuration Release > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL_SMA}*.kext "../" || copyErr
    fi
  elif [[ "$2" == "Lilu" ]]; then
    rm -rf ../Lilu.kext
    cp -R "../MacKernelSDK" "./" || copyErr
    xcodebuild -jobs 1 -configuration Release > /dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL}*.kext "../" || copyErr
  elif [[ "$2" == "EAPD-Codec-Commander" ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    xcodebuild -scheme CodecCommander -derivedDataPath . -configuration Release > /dev/null 2>&1 || buildErr "$2"
    cp -R ${PATH_TO_REL_BIG}*.kext "../KBL" || copyErr
  elif [[ "$2" == "IntelBluetoothFirmware" ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    mkdir -p "tmp" || exit 1
    cp -R IntelBluetoothFirmware/fw/ibt-12* "tmp" || copyErr
    cp -R IntelBluetoothFirmware/fw/ibt-19-0* "tmp" || copyErr

    if [[ "${model_input}" =~ "CML" ]]; then
      # Delete unrelated firmware and only keep ibt-19-0*.sfi for Intel Wireless 9462
      rm -rf "IntelBluetoothFirmware/FwBinary.cpp" || exit 1
      rm -rf IntelBluetoothFirmware/fw/* || exit 1
      cp -R tmp/ibt-19-0* "IntelBluetoothFirmware/fw/" || copyErr
      xcodebuild -alltargets -configuration Release > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../CML" || copyErr
      xcodebuild -alltargets clean > /dev/null 2>&1 || buildErr "$2"
    fi
    if [[ "${model_input}" =~ "KBL" ]]; then
      # Delete unrelated firmware and only keep ibt-12*.sfi for Intel Wireless 8265
      rm -rf "IntelBluetoothFirmware/FwBinary.cpp" || exit 1
      rm -rf IntelBluetoothFirmware/fw/* || exit 1
      cp -R tmp/ibt-12* "IntelBluetoothFirmware/fw/" || copyErr
      xcodebuild -alltargets -configuration Release > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_REL}*.kext "../KBL" || copyErr
    fi
  elif [[ "$2" == "itlwm" ]]; then
    cp -R "../MacKernelSDK" "./" || copyErr
    # Pass print syntax to support Python3
    /usr/bin/sed -i "" "s:print compress(\"test\"):pass:g" "scripts/zlib_compress_fw.py"

    mkdir -p "tmp" || exit 1
    cp -R itlwm/firmware/iwlwifi-QuZ* "tmp" || copyErr
    cp -R itlwm/firmware/iwm-8265* "tmp" || copyErr
    if [[ "${model_input}" =~ "CML" ]]; then
      # Delete unrelated firmware and only keep iwlwifi-QuZ* for Intel Wireless 9462
      rm -rf "include/FwBinary.cpp" || exit 1
      rm -rf itlwm/firmware/* || exit 1
      cp -R tmp/iwlwifi-QuZ* "itlwm/firmware/" || copyErr

      xcodebuild -scheme "AirportItlwm (all)" -configuration Debug -derivedDataPath . > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_DBG_BIG}* "../CML" || copyErr
      xcodebuild -scheme "AirportItlwm (all)" clean > /dev/null 2>&1 || buildErr "$2"
    fi
    if [[ "${model_input}" =~ "KBL" ]]; then
      # Delete unrelated firmware and only keep iwm-8265* for Intel Wireless 8265
      rm -rf "include/FwBinary.cpp" || exit 1
      rm -rf itlwm/firmware/* || exit 1
      cp -R tmp/iwm-8265* "itlwm/firmware/" || copyErr

      xcodebuild -scheme "AirportItlwm (all)" -configuration Debug -derivedDataPath . > /dev/null 2>&1 || buildErr "$2"
      cp -R ${PATH_TO_DBG_BIG}* "../KBL" || copyErr
    fi
  fi
  cd ../ || exit 1
  echo
}

function bKext() {
  if [[ "${publish_efi}" = true ]]; then
    # Force to call install_compiled_sdk in Lilu's bootstrap.sh
    local GITHUB_REF=""
  fi

  if [[ ${no_xcode} == true ]]; then
    echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Missing Xcode tools, won't build kexts!"
    exit 1
  fi

  if [[ ${language} != "zh_CN" ]]; then
    git clone -q https://github.com/acidanthera/MacKernelSDK || networkErr "MacKernelSDK"
    src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/Lilu/master/Lilu/Scripts/bootstrap.sh) && eval "$src" > /dev/null 2>&1 || networkErr "Lilu"
    src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/VoodooInput/master/VoodooInput/Scripts/bootstrap.sh) && eval "$src" > /dev/null 2>&1 || networkErr "VoodooInput"
  else
    git clone -q ${CFURL}/https://github.com/acidanthera/MacKernelSDK || networkErr "MacKernelSDK"
    src=$(/usr/bin/curl -Lfs ${CFURL}/https://raw.githubusercontent.com/acidanthera/Lilu/master/Lilu/Scripts/bootstrap.sh) && eval "$src" > /dev/null 2>&1 || networkErr "Lilu"
    src=$(/usr/bin/curl -Lfs ${CFURL}/https://raw.githubusercontent.com/acidanthera/VoodooInput/master/VoodooInput/Scripts/bootstrap.sh) && eval "$src" > /dev/null 2>&1 || networkErr "VoodooInput"
  fi
  if [[ ${model_input} =~ "CML" ]]; then
    bKextHelper al3xtjames NoTouchID
  fi
  if [[ ${model_input} =~ "KBL" ]]; then
    bKextHelper Sniki EAPD-Codec-Commander
  fi
  for acdtKext in "${acdtKexts[@]}"; do
    bKextHelper ${ACDT} "${acdtKext}"
  done
  for frwfKext in "${frwfKexts[@]}"; do
    bKextHelper ${FRWF} "${frwfKext}"
  done
  for oiwKext in "${oiwKexts[@]}"; do
    bKextHelper ${OIW} "${oiwKext}"
  done
  bKextHelper VoodooI2C VoodooI2C
  echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Please clean Xcode cache in ~/Library/Developer/Xcode/DerivedData!"
  echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: Some kexts only work on current macOS SDK build!"
  echo
}

function download() {
  # Clover
  dGR CloverHackyColor CloverBootloader NULL "Clover"

  # OpenCore
  if [[ "${pre_release}" =~ "OC" ]]; then
    # williambj1's OpenCore-Factory repository has been archived
    # dGR williambj1 OpenCore-Factory PreRelease "OpenCore"
    dGR dortania build-repo NULL "OpenCore" "skip" || dGR ${ACDT} OpenCorePkg NULL "OpenCore"
  else
    dGR ${ACDT} OpenCorePkg NULL "OpenCore"
  fi

  # Kexts
  dBR Rehabman os-x-null-ethernet

  if [[ "${pre_release}" =~ "Kext" ]]; then
    bKext
  else
    for acdtKext in "${acdtKexts[@]}"; do
      dGR ${ACDT} "${acdtKext}"
    done
    for frwfKext in "${frwfKexts[@]}"; do
      dGR ${FRWF} "${frwfKext}"
    done
    for oiwKext in "${oiwKexts[@]}"; do
      dGR ${OIW} "${oiwKext}" PreRelease
    done
    if [[ "${model_input}" =~ "CML" ]]; then
      dGR al3xtjames NoTouchID NULL "CML"
    fi
    if [[ "${model_input}" =~ "KBL" ]]; then
      dGR Sniki EAPD-Codec-Commander NULL "KBL"
    fi
    dGR VoodooI2C VoodooI2C
  fi

  dGS RehabMan hack-tools master

  # UEFI drivers
  # AppleSupportPkg v2.0.9
  dGR ${ACDT} AppleSupportPkg_209 19214108 "Clover/AppleSupportPkg_209"
  # AppleSupportPkg v2.1.6
  dGR ${ACDT} AppleSupportPkg_216 24123335 "Clover/AppleSupportPkg_216"

  # UEFI
  # dPB ${ACDT} OcBinaryData Drivers/HfsPlus.efi
  dPB ${ACDT} VirtualSMC EfiDriver/VirtualSmc.efi

  # HfsPlus.efi & OC Resources
  dGS ${ACDT} OcBinaryData master

  # XiaoMi-Pro ACPI patch
  if [[ ${remote} == true ]]; then
    dGS daliansky ${REPO_NAME} ${REPO_BRANCH}
  fi

  # Menchen's ALCPlugFix
  if [[ ${remote} == true ]]; then
    dGS Menchen ALCPlugFix master
  fi
}

# Unpack
function unpack() {
  echo "${green}[${reset}${yellow}${bold} Unpacking ${reset}${green}]${reset}"
  ditto -x -k ./*.zip . || exit 1
  if [[ "${model_input}" =~ "CML" ]] && [[ "${pre_release}" != *Kext* ]]; then
    (cd "CML" && unzip -qq ./*.zip || exit 1)
  fi
  if [[ "${model_input}" =~ "KBL" ]] && [[ "${pre_release}" != *Kext* ]]; then
    (cd "KBL" && unzip -qq ./*.zip || exit 1)
  fi
  echo
}

# Patch
function patch() {
  local unusedItems=(
    "BlueToolFixup.kext/Contents/_CodeSignature"
    "HibernationFixup.kext/Contents/_CodeSignature"
    "Kexts/SMCBatteryManager.kext/Contents/Resources"
    "KBL/CodecCommander.kext/Contents/Resources"
    "RealtekCardReader.kext/Contents/_CodeSignature"
    "RealtekCardReader.kext/Contents/Resources"
    "RealtekCardReaderFriend.kext/Contents/_CodeSignature"
    "RealtekCardReaderFriend.kext/Contents/Resources"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext.dSYM"
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext/Contents/_CodeSignature"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooInput.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext"
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext"
    "WhateverGreen.kext/Contents/_CodeSignature"
  )
  echo "${green}[${reset}${blue}${bold} Patching Resources ${reset}${green}]${reset}"
  for unusedItem in "${unusedItems[@]}"; do
    rm -rf "${unusedItem}" > /dev/null 2>&1
  done

  # Only keep OCEFIAudio_VoiceOver_Boot in OcBinaryData/Resources/Audio
  (cd "OcBinaryData-master/Resources/Audio/" && find . -maxdepth 1 -not -name "OCEFIAudio_VoiceOver_Boot*" -delete || exit 1)

  # Rename AirportItlwm.kexts to distinguish different versions
  if [[ "${pre_release}" =~ "Kext" ]]; then
    for model in "${model_list[@]}"; do
      mv "${model}/Big Sur/AirportItlwm.kext" "${model}/Big Sur/AirportItlwm_Big_Sur.kext" || exit 1
      mv "${model}/Catalina/AirportItlwm.kext" "${model}/Catalina/AirportItlwm_Catalina.kext" || exit 1
      mv "${model}/High Sierra/AirportItlwm.kext" "${model}/High Sierra/AirportItlwm_High_Sierra.kext" || exit 1
      mv "${model}/Mojave/AirportItlwm.kext" "${model}/Mojave/AirportItlwm_Mojave.kext" || exit 1
      mv "${model}/Monterey/AirportItlwm.kext" "${model}/Monterey/AirportItlwm_Monterey.kext" || exit 1
    done
  else
    mv "Big Sur/AirportItlwm.kext" "Big Sur/AirportItlwm_Big_Sur.kext" || exit 1
    mv "Catalina/AirportItlwm.kext" "Catalina/AirportItlwm_Catalina.kext" || exit 1
    mv "High Sierra/AirportItlwm.kext" "High Sierra/AirportItlwm_High_Sierra.kext" || exit 1
    mv "Mojave/AirportItlwm.kext" "Mojave/AirportItlwm_Mojave.kext" || exit 1
    mv "Monterey/AirportItlwm.kext" "Monterey/AirportItlwm_Monterey.kext" || exit 1
  fi
  echo
}

# Install
function install() {
  # Kexts
  local sharedKextItems=(
    "HibernationFixup.kext"
    "Kexts/SMCBatteryManager.kext"
    "Kexts/SMCLightSensor.kext"
    "Kexts/SMCProcessor.kext"
    "Kexts/VirtualSMC.kext"
    "Lilu.kext"
    "RealtekCardReader.kext"
    "RealtekCardReaderFriend.kext"
    "Release/NullEthernet.kext"
    "VoodooI2C.kext"
    "VoodooI2CHID.kext"
    "VoodooPS2Controller.kext"
    "WhateverGreen.kext"
    "hack-tools-master/kexts/EFICheckDisabler.kext"
    "hack-tools-master/kexts/SATA-unsupported.kext"
  )
  if [[ "${model_input}" =~ "CML" ]]; then
    local cmlKextItems=(
      "AppleALC.kext"
      "IntelBluetoothFirmware.kext"
    )
    if [[ "${pre_release}" =~ "Kext" ]]; then
      cmlKextItems=("${cmlKextItems[@]/#/CML/}")
    fi
    cmlKextItems+=(
      "${sharedKextItems[@]}"
    )
    local cmlWifiKextItems=(
      "Big Sur/AirportItlwm_Big_Sur.kext"
      "Catalina/AirportItlwm_Catalina.kext"
      "Monterey/AirportItlwm_Monterey.kext"
    )
    if [[ "${pre_release}" =~ "Kext" ]]; then
      cmlWifiKextItems=("${cmlWifiKextItems[@]/#/CML/}")
    fi
    local cmlCloverKextFolders=(
      "10.15"
      "11"
      "12"
    )
    local cmlCloverIbtInjctrDirs=(
      "10.15"
      "11"
    )
  fi
  if [[ "${model_input}" =~ "KBL" ]]; then
    local kblKextItems=(
      "AppleALC.kext"
      "IntelBluetoothFirmware.kext"
    )
    if [[ "${pre_release}" =~ "Kext" ]]; then
      kblKextItems=("${kblKextItems[@]/#/KBL/}")
    fi
    kblKextItems+=(
      "${sharedKextItems[@]}"
      "KBL/CodecCommander.kext"
    )
    local kblWifiKextItems=(
      "Big Sur/AirportItlwm_Big_Sur.kext"
      "Catalina/AirportItlwm_Catalina.kext"
      "High Sierra/AirportItlwm_High_Sierra.kext"
      "Mojave/AirportItlwm_Mojave.kext"
      "Monterey/AirportItlwm_Monterey.kext"
    )
    if [[ "${pre_release}" =~ "Kext" ]]; then
      kblWifiKextItems=("${kblWifiKextItems[@]/#/KBL/}")
    fi
    local kblCloverKextFolders=(
      "10.13"
      "10.14"
      "10.15"
      "11"
      "12"
    )
    local kblCloverIbtInjctrDirs=(
      "10.13"
      "10.14"
      "10.15"
      "11"
    )
  fi

  echo "${green}[${reset}${blue}${bold} Installing Kexts ${reset}${green}]${reset}"
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    model_kextItems="${model_prefix}KextItems"
    model_wifiKextItems="${model_prefix}WifiKextItems"
    model_cloverKextFolders="${model_prefix}CloverKextFolders"
    model_cloverIbtInjctrDirs="${model_prefix}CloverIbtInjctrDirs"
    kextItems="${model_kextItems}[@]"
    for kextDir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/Other/" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/"; do
      mkdir -p "${kextDir}" || exit 1
      for kextItem in "${!kextItems}"; do
        cp -R "${kextItem}" "${kextDir}" || copyErr
      done
    done

    cloverKextFolder="${model_cloverKextFolders}[@]"
    for cloverKextFolder in "${!cloverKextFolder}"; do
      mkdir -p "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/${cloverKextFolder}" || exit 1
    done

    if [[ "${model}" == "CML" ]]; then
      for noTouchIDDir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.15" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/"; do
        cp -R "CML/NoTouchID.kext" "${noTouchIDDir}" || copyErr
      done
    fi

    # Move AirportItlwm to corresponding Clover and OC Kext folders
    if [[ "${pre_release}" =~ "Kext" ]]; then
      cp -R "${model}/Big Sur/AirportItlwm_Big_Sur.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/11" || copyErr
      cp -R "${model}/Catalina/AirportItlwm_Catalina.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.15" || copyErr
      cp -R "${model}/Monterey/AirportItlwm_Monterey.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/12" || copyErr
      if [[ "${model}" == "KBL" ]]; then
        cp -R "${model}/High Sierra/AirportItlwm_High_Sierra.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.13" || copyErr
        cp -R "${model}/Mojave/AirportItlwm_Mojave.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.14" || copyErr
      fi
    else
      cp -R "Big Sur/AirportItlwm_Big_Sur.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/11" || copyErr
      cp -R "Catalina/AirportItlwm_Catalina.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.15" || copyErr
      cp -R "Monterey/AirportItlwm_Monterey.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/12" || copyErr
      if [[ "${model}" == "KBL" ]]; then
        cp -R "High Sierra/AirportItlwm_High_Sierra.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.13" || copyErr
        cp -R "Mojave/AirportItlwm_Mojave.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/10.14" || copyErr
      fi
    fi

    kextItems="${model_wifiKextItems}[@]"
    for kextItem in "${!kextItems}"; do
      cp -R "${kextItem}" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/" || copyErr
    done

    # Move IntelBluetoothInjector and BlueToolFixup to corresponding Clover and OC Kext folders
    kextDirs="${model_cloverIbtInjctrDirs}[@]"
    for kextDir in "${!kextDirs}"; do
      if [[ "${pre_release}" =~ "Kext" ]]; then
        cp -R "${model}/IntelBluetoothInjector.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/${kextDir}" || copyErr
      else
        cp -R "IntelBluetoothInjector.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/${kextDir}" || copyErr
      fi
    done
    cp -R "BlueToolFixup.kext" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/kexts/12" || copyErr

    if [[ "${pre_release}" =~ "Kext" ]]; then
      cp -R "${model}/IntelBluetoothInjector.kext" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/" || copyErr
    else
      cp -R "IntelBluetoothInjector.kext" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/" || copyErr
    fi
    cp -R "BlueToolFixup.kext" "${!OUTDir_MODEL_OC}/EFI/OC/Kexts/" || copyErr
  done
  echo

  # Drivers
  local driverItems=(
    "OcBinaryData-master/Drivers/ExFatDxe.efi"
    "OcBinaryData-master/Drivers/HfsPlus.efi"
  )

  echo "${green}[${reset}${blue}${bold} Installing Drivers ${reset}${green}]${reset}"
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    for driverDir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/drivers/UEFI/" "${!OUTDir_MODEL_OC}/EFI/OC/Drivers/"; do
      mkdir -p "${driverDir}" || exit 1
      for driverItem in "${driverItems[@]}"; do
        cp "${driverItem}" "${driverDir}" || copyErr
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
  if [[ "${model_input}" =~ "KBL" ]]; then
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
    if [[ ${remote} == false ]]; then
      kblAcpiItems=("${kblAcpiItems[@]/${REPO_NAME_BRANCH}/..}")
    fi
  fi
  if [[ "${model_input}" =~ "CML" ]]; then
    local cmlAcpiItems=( "${sharedAcpiItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-AWAC-DISABLE.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-DDGPU.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-LGPA.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-PMC.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-PNLFCFL.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-PS2K.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-TPD0.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-XCPM.aml"
    )
    if [[ ${remote} == false ]]; then
      cmlAcpiItems=("${cmlAcpiItems[@]/${REPO_NAME_BRANCH}/..}")
    fi
  fi

  echo "${green}[${reset}${blue}${bold} Installing ACPIs ${reset}${green}]${reset}"
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    model_acpiItems="${model_prefix}AcpiItems"
    acpiItems="${model_acpiItems}[@]"
    for acpiDir in "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/ACPI/patched/" "${!OUTDir_MODEL_OC}/EFI/OC/ACPI/"; do
      mkdir -p "${acpiDir}" || exit 1
      for acpiItem in "${!acpiItems}"; do
        cp "${acpiItem}" "${acpiDir}" || copyErr
      done
    done
  done
  echo

  # Theme
  echo "${green}[${reset}${blue}${bold} Installing Themes ${reset}${green}]${reset}"
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    if [[ ${remote} == true ]]; then
      cp -R "${REPO_NAME_BRANCH}/CLOVER/themes" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/" || copyErr
    else
      cp -R "../CLOVER/themes" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/" || copyErr
    fi

    cp -R "OcBinaryData-master/Resources" "${!OUTDir_MODEL_OC}/EFI/OC/" || copyErr
  done
  echo

  # config & README & LICENSE
  echo "${green}[${reset}${blue}${bold} Installing config & README & LICENSE ${reset}${green}]${reset}"
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    model_config="config_${model_prefix}.plist"
    if [[ ${remote} == true ]]; then
      cp "${REPO_NAME_BRANCH}/CLOVER/${model_config}" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/config.plist" || copyErr
      cp "${REPO_NAME_BRANCH}/OC/${model_config}" "${!OUTDir_MODEL_OC}/EFI/OC/config.plist" || copyErr
      for readmeDir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
        if [[ ${language} == "en_US" ]]; then
          cp "${REPO_NAME_BRANCH}/README.md" "${readmeDir}" || copyErr
        elif [[ ${language} == "zh_CN" ]]; then
          cp "${REPO_NAME_BRANCH}/Docs/README_CN.md" "${readmeDir}" || copyErr
        fi
        cp "${REPO_NAME_BRANCH}/LICENSE" "${readmeDir}" || copyErr
      done
    else
      cp "../CLOVER/${model_config}" "${!OUTDir_MODEL_CLOVER}/EFI/CLOVER/config.plist" || copyErr
      cp "../OC/${model_config}" "${!OUTDir_MODEL_OC}/EFI/OC/config.plist" || copyErr
      for readmeDir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
        if [[ ${language} == "en_US" ]]; then
          cp "../README.md" "${readmeDir}" || copyErr
        elif [[ ${language} == "zh_CN" ]]; then
          cp "../Docs/README_CN.md" "${readmeDir}" || copyErr
        fi
        cp "../LICENSE" "${readmeDir}" || copyErr
      done
    fi
  done
  echo

  # Bluetooth & GTX/MX350 & wiki
  local altModel
  local altModelPrefix

  if [[ ${language} == "en_US" ]]; then
    local sharedBtItems=( "${REPO_NAME_BRANCH}/Docs/Work-Around-with-Bluetooth.pdf" )
  elif [[ ${language} == "zh_CN" ]]; then
    local sharedBtItems=( "${REPO_NAME_BRANCH}/Docs/蓝牙解决方案.pdf" )
  fi
  if [[ "${model_input}" =~ "CML" ]]; then
    local cmlBtItems=( "${sharedBtItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB-ALL.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB-FingerBT.aml"
      "${REPO_NAME_BRANCH}/ACPI/CML/SSDT-USB-USBBT.aml"
    )
    local cmlLgpaItem="${REPO_NAME_BRANCH}/ACPI/CML/SSDT-LGPA350.aml"

    if [[ ${remote} == false ]]; then
      cmlBtItems=("${cmlBtItems[@]/${REPO_NAME_BRANCH}/..}")
      cmlLgpaItem="${cmlLgpaItem/${REPO_NAME_BRANCH}/..}"
    fi
  fi
  if [[ "${model_input}" =~ "KBL" ]]; then
    local kblBtItems=( "${sharedBtItems[@]}"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-ALL.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-FingerBT.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-USBBT.aml"
      "${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-USB-WLAN_LTEBT.aml"
    )
    local kblLgpaItem="${REPO_NAME_BRANCH}/ACPI/KBL/SSDT-LGPAGTX.aml"

    if [[ ${remote} == false ]]; then
      kblBtItems=("${kblBtItems[@]/${REPO_NAME_BRANCH}/..}")
      kblLgpaItem="${kblLgpaItem/${REPO_NAME_BRANCH}/..}"
    fi
  fi

  if [[ ${language} == "en_US" ]]; then
    local wikiItems=(
      "${REPO_NAME_BRANCH}/Docs/FAQ.pdf"
      "${REPO_NAME_BRANCH}/Docs/Set-DVMT-to-64mb.pdf"
      "${REPO_NAME_BRANCH}/Docs/Unlock-0xE2-MSR.pdf"
    )
  elif [[ ${language} == "zh_CN" ]]; then
    local wikiItems=(
      "${REPO_NAME_BRANCH}/Docs/常见问题解答.pdf"
      "${REPO_NAME_BRANCH}/Docs/设置64mb动态显存.pdf"
      "${REPO_NAME_BRANCH}/Docs/解锁0xE2寄存器.pdf"
    )
  fi
  if [[ ${remote} == false ]]; then
    wikiItems=("${wikiItems[@]/${REPO_NAME_BRANCH}/..}")
  fi

  echo "${green}[${reset}${blue}${bold} Installing Docs About Bluetooth & GTX/MX350 & wiki ${reset}${green}]${reset}"
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    model_prefix=$(echo "${model}" | tr '[:upper:]' '[:lower:]')
    model_btItems="${model_prefix}BtItems"
    btItems="${model_btItems}[@]"
    for btDir in "${!OUTDir_MODEL_CLOVER}/Bluetooth" "${!OUTDir_MODEL_OC}/Bluetooth"; do
      mkdir -p "${btDir}" || exit 1
      for btItem in "${!btItems}"; do
        cp "${btItem}" "${btDir}" || copyErr
      done
    done

    model_lgpaItem="${model_prefix}LgpaItem"
    if [[ "${model}" == "KBL" ]]; then
      altModel="GTX"
      altModelPrefix="GTX"
    elif [[ "${model}" == "CML" ]]; then
      altModel="MX350"
      altModelPrefix="350"
    fi
    if [[ ${language} == "en_US" ]]; then
      if [[ ${remote} == false ]]; then
        cp "../Docs/README_\${MODEL}.txt" "README_${altModel}.txt" || copyErr
      else
        cp "${REPO_NAME_BRANCH}/Docs/README_\${MODEL}.txt" "README_${altModel}.txt" || copyErr
      fi
      /usr/bin/sed -i "" "s:\${MODEL}:${altModel}:g" "README_${altModel}.txt"
      /usr/bin/sed -i "" "s:\${MODEL_PREFIX}:${altModelPrefix}:g" "README_${altModel}.txt"
    elif [[ ${language} == "zh_CN" ]]; then
      if [[ ${remote} == false ]]; then
        cp "../Docs/README_CN_\${MODEL}.txt" "README_CN_${altModel}.txt" || copyErr
      else
        cp "${REPO_NAME_BRANCH}/Docs/README_CN_\${MODEL}.txt" "README_CN_${altModel}.txt" || copyErr
      fi
      /usr/bin/sed -i "" "s:\${MODEL}:${altModel}:g" "README_CN_${altModel}.txt"
      /usr/bin/sed -i "" "s:\${MODEL_PREFIX}:${altModelPrefix}:g" "README_CN_${altModel}.txt"
    fi

    for lgpaDir in "${!OUTDir_MODEL_CLOVER}/${altModel}" "${!OUTDir_MODEL_OC}/${altModel}"; do
      mkdir -p "${lgpaDir}" || exit 1
      cp "${!model_lgpaItem}" "${lgpaDir}" || copyErr
      if [[ ${language} == "en_US" ]]; then
        cp "README_${altModel}.txt" "${lgpaDir}" || copyErr
      elif [[ ${language} == "zh_CN" ]]; then
        cp "README_CN_${altModel}.txt" "${lgpaDir}" || copyErr
      fi
    done

    for wikiDir in "${!OUTDir_MODEL_CLOVER}/Docs" "${!OUTDir_MODEL_OC}/Docs"; do
      mkdir -p "${wikiDir}" || exit 1
      for wikiItem in "${wikiItems[@]}"; do
        cp "${wikiItem}" "${wikiDir}" || copyErr
      done
    done
  done
  echo

  # ALCPlugFix
  if [[ "${model_input}" =~ "KBL" ]]; then
    kblAlcfixItems=(
      "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/alc_fix"
      "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/build"
      "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/README.MD"
    )
  fi

  if [[ "${model_input}" =~ "KBL" ]]; then
    local OUTDir_MODEL_CLOVER="OUTDir_KBL_CLOVER"
    local OUTDir_MODEL_OC="OUTDir_KBL_OC"
    if [[ ${remote} == true ]]; then
      cp -R ALCPlugFix-master/* "${REPO_NAME_BRANCH}/ALCPlugFix/ALCPlugFix_kbl/" || copyErr
    else
      kblAlcfixItems=("${kblAlcfixItems[@]/${REPO_NAME_BRANCH}/..}")
      cd "../" || exit 1

      # Add Cloudflare redirect to gitmodules for Chinese users
      if [[ ${language} == "zh_CN" ]]; then
        cp -f ".gitmodules" ".gitmodules_bak" || copyErr
        /usr/bin/sed -i "" "s:https:${CFURL_1}/https:g" ".gitmodules"
      fi

      git submodule init -q && git submodule update --remote -q

      # Restore .gitmodules
      if [[ ${language} == "zh_CN" ]]; then
        rm -f ".gitmodules" || exit 1
        mv -f ".gitmodules_bak" ".gitmodules" || exit 1
      fi

      cd "${WSDir}" || exit 1
    fi

    echo "${green}[${reset}${blue}${bold} Installing ALCPlugFix ${reset}${green}]${reset}"
    for alcpfDir in "${!OUTDir_MODEL_CLOVER}/ALCPlugFix" "${!OUTDir_MODEL_OC}/ALCPlugFix"; do
      mkdir -p "${alcpfDir}" || exit 1
      for alcfixItem in "${kblAlcfixItems[@]}"; do
        cp -R "${alcfixItem}" "${alcpfDir}" || copyErr
      done
    done
    echo
  fi
}

# Extract files for Clover
function extractClover() {
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
  for model in "${model_list[@]}"; do
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
function extractOC() {
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
  for model in "${model_list[@]}"; do
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
function genNote() {
  local lineStart
  local lineEnd
  local changelogPath

  if [[ ${language} == "zh_CN" ]]; then
    changelogPath="${REPO_NAME_BRANCH}/Docs/Changelog_CN.md"
  else
    changelogPath="${REPO_NAME_BRANCH}/Changelog.md"
  fi
  if [[ ${remote} == false ]]; then
    changelogPath="${changelogPath/${REPO_NAME_BRANCH}/..}"
  fi

  echo "${green}[${reset}${blue}${bold} Generating Release Notes ${reset}${green}]${reset}"
  # Release warning
  echo "#### A cold restart is required." >> ReleaseNotes.md

  lineStart=$(grep -n "XiaoMi NoteBook Pro EFI v" ${changelogPath}) && lineStart=${lineStart%%:*} && lineStart=$((lineStart+1))
  lineEnd=$(grep -n -m2 "XiaoMi NoteBook Pro EFI v" ${changelogPath} | tail -n1)
  lineEnd=${lineEnd%%:*} && lineEnd=$((lineEnd-3))
  sed -n "${lineStart},${lineEnd}p" ${changelogPath} >> ReleaseNotes.md

  # Generate Cloudflare links when using GitHub Action to publish EFI release
  if [[ ${publish_efi} == true ]]; then
    echo "-----" >> ReleaseNotes.md
    printf "#### 国内加速下载链接：\nDownload link for China:\n" >> ReleaseNotes.md
    for model in "${model_list[@]}"; do
      OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
      OUTDir_MODEL_OC="OUTDir_${model}_OC"
      echo "- [${!OUTDir_MODEL_CLOVER}.zip](${CFURL}/https://github.com/daliansky/${REPO_NAME}/releases/download/${CUR_TAG}/${!OUTDir_MODEL_CLOVER}.zip)" >> ReleaseNotes.md
      echo "- [${!OUTDir_MODEL_OC}.zip](${CFURL}/https://github.com/daliansky/${REPO_NAME}/releases/download/${CUR_TAG}/${!OUTDir_MODEL_OC}.zip)" >> ReleaseNotes.md
    done
  fi

  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    for rNoteDir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
      cp "ReleaseNotes.md" "${rNoteDir}" || copyErr
    done
  done
  echo
}

# Exclude Trash
function cTrash() {
  echo "${green}[${reset}${blue}${bold} Cleaning Trash Files ${reset}${green}]${reset}"
  if [[ ${clean_up} == true ]]; then
    find . -maxdepth 1 ! -path "./${OUTDir_KBL_CLOVER}" ! -path "./${OUTDir_KBL_OC}" ! -path "./${OUTDir_CML_CLOVER}" ! -path "./${OUTDir_CML_OC}" -exec rm -rf {} + > /dev/null 2>&1
  fi
  echo
}

# Enjoy
function enjoy() {
  for model in "${model_list[@]}"; do
    OUTDir_MODEL_CLOVER="OUTDir_${model}_CLOVER"
    OUTDir_MODEL_OC="OUTDir_${model}_OC"
    for buildDir in "${!OUTDir_MODEL_CLOVER}" "${!OUTDir_MODEL_OC}"; do
      zip -qr "${buildDir}.zip" "${buildDir}"
    done
  done
  echo "${green}[${reset}${blue}${bold} Done! Enjoy! ${reset}${green}]${reset}"
  echo
  open ./
}

function main() {
  init
  download
  unpack
  patch

  # Installation
  install
  extractClover
  extractOC

  # Generate Release Notes
  genNote

  # Clean up
  cTrash

  # Enjoy
  enjoy
}

main

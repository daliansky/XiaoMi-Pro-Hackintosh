#!/bin/bash

# Created by stevezhengshiqi on 8 Feb, 2019.
# Only support most 8th CPU.
# This script depends on CPUFriend(https://github.com/acidanthera/CPUFriend) a lot, thanks to PMHeart.

# default board-id
BOARD_ID="Mac-827FB448E656EC26"

# corresponding plist
X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"

function printHeader() {
  printf '\e[8;40;110t'

  # Interface (ref: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
  echo '  ____   ____    _   _   _____   ____    ___   _____   _   _   ____ '
  echo ' / ___| |  _ \  | | | | |  ___| |  _ \  |_ _| | ____| | \ | | |  _ \ '
  echo '| |     | |_) | | | | | | |_    | |_) |  | |  |  _|   |  \| | | | | | '
  echo '| |___  |  __/  | |_| | |  _|   |  _ <   | |  | |___  | |\  | | |_| | '
  echo ' \____| |_|      \___/  |_|     |_| \_\ |___| |_____| |_| \_| |____/ '
  echo
  echo '====================================================================='
}

# Check board-id, only system version >=10.13.6(17G2112) supports Mac-827FB448E656EC26.plist(MBP15,2)
function checkPlist() {
  if [[ ! -f "${X86_PLIST}" ]]; then
    # Use MBP14,1's plist if no Mac-827FB448E656EC26.plist
    BOARD_ID="Mac-B4831CEBD52A0C4C"
  fi
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/acidanthera/CPUFriend/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo "WARNING: Failed to retrieve latest release from ${repoURL}."
    exit 1
  fi
}

# Exit in case of failure
function networkWarn() {
  echo "ERROR: Fail to download CPUFriend, please check your connection!"
  exit 1
}

# Download CPUFriend repository and unzip latest release
function downloadKext() {
  WORK_DIR="/Users/`users`/Desktop/one-key-cpufriend"
  [[ -d "${WORK_DIR}" ]] && sudo rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}"

  echo
  echo '----------------------------------------------------------------------------------'
  echo '|* Downloading CPUFriend from https://github.com/acidanthera/CPUFriend @PMheart *|'
  echo '----------------------------------------------------------------------------------'

  # download ResourceConverter.sh
  local rcURL='https://raw.githubusercontent.com/acidanthera/CPUFriend/master/ResourceConverter/ResourceConverter.sh'
  curl --silent -O "${rcURL}" && chmod +x ./ResourceConverter.sh || networkWarn

  # download CPUFriend.kext
  local cfVER="${ver}"
  local cfFileName="${cfVER}.RELEASE.zip"
  local cfURL="https://github.com/acidanthera/CPUFriend/releases/download/${cfVER}/${cfFileName}"
  # GitHub's CDN is hosted on Amazon, so here we add -L for redirection support
  curl --silent -L -O "${cfURL}" || networkWarn
  # decompress it
  unzip -qu "${cfFileName}"
  # Copy CPUFriend.kext to Desktop
  cp -r CPUFriend.kext /Users/`users`/Desktop/
  # remove stuffs we do not need
  rm -rf "${cfFileName}" 'CPUFriend.kext.dSYM'
  echo 'Download complete'
  echo
}

# Copy the target plist
function copyPlist() {
  if [[ ! -f "${X86_PLIST}" ]]; then
    echo "ERROR: ${X86_PLIST} NOT found!"
    exit 1
  fi

  cp "${X86_PLIST}" .
}

# chenge LFM value to adjust lowest frequency
# Reconsider whether this function is necessary because LFM seems doesn't effect energy performance
function changeLFM(){
  echo "-----------------------------------------"
  echo "|****** Choose Low Frequency Mode ******|"
  echo "-----------------------------------------"
  echo "(1) Remain the same (1200/1300mhz)"
  echo "(2) 800mhz"
  read -p "Which option you want to choose? (1/2):" lfm_selection
  case "${lfm_selection}" in
    1)
    # Keep default
    ;;

    2)
    # Change 1200/1300 to 800
    /usr/bin/sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" $BOARD_ID.plist
    ;;

    *)
    echo "ERROR: Invalid input, closing the script"
    exit 1
    ;;
  esac
}

# change EPP value to adjust performance (ref: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
# TO DO: Use a more efficient way to replace frequencyvectors, see https://github.com/Piker-Alpha/freqVectorsEdit.sh
function changeEPP(){
  echo "----------------------------------------"
  echo "| Choose Energy Performance Preference |"
  echo "----------------------------------------"
  echo "(1) Max Power Saving"
  echo "(2) Balance Power (Default)"
  echo "(3) Balance performance"
  echo "(4) Performance"
  read -p "Which mode is your favourite? (1/2/3/4):" epp_selection
  case "${epp_selection}" in
    1)
    # Change 80/90/92 to C0, max power saving
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAd:DAAAAAAAAAAAAAAAAAAAAAd:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CSAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:ZXBwAAAAAAAAAAAAAAAAAAAAAACS:ZXBwAAAAAAAAAAAAAAAAAAAAAADA:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:ZXBwAAAAAAAAAAAAAAAAAAAAAACA:ZXBwAAAAAAAAAAAAAAAAAAAAAADA:g" $BOARD_ID.plist
    ;;

    2)
    # Keep default 80/90/92, balance power
    # if also no changes for lfm, exit
    if [ "${lfm_selection}" == 1 ]; then
      echo "It's nice to keep the same, see you next time."
      clean
      exit 0
    fi
    ;;

    3)
    # Change 80/90/92 to 40, balance performance
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAd:BAAAAAAAAAAAAAAAAAAAAAd:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CSAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:ZXBwAAAAAAAAAAAAAAAAAAAAAACS:ZXBwAAAAAAAAAAAAAAAAAAAAAABA:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:ZXBwAAAAAAAAAAAAAAAAAAAAAACA:ZXBwAAAAAAAAAAAAAAAAAAAAAABA:g" $BOARD_ID.plist
    ;;

    4)
    # Change 80/90/92 to 00, performance
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAd:AAAAAAAAAAAAAAAAAAAAAAd:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CSAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:ZXBwAAAAAAAAAAAAAAAAAAAAAACS:ZXBwAAAAAAAAAAAAAAAAAAAAAAAA:g" $BOARD_ID.plist
    /usr/bin/sed -i "" "s:ZXBwAAAAAAAAAAAAAAAAAAAAAACA:ZXBwAAAAAAAAAAAAAAAAAAAAAAAA:g" $BOARD_ID.plist
    ;;

    *)
    echo "ERROR: Invalid input, closing the script"
    exit 1
    ;;
  esac
}

# Generate CPUFriendDataProvider.kext and move to desktop
function generateKext(){
  echo "Generating CPUFriendDataProvider.kext"
  ./ResourceConverter.sh --kext $BOARD_ID.plist
  cp -r CPUFriendDataProvider.kext /Users/`users`/Desktop/
  echo "Generate complete"
  echo
}

# Delete tmp folder and end
function clean(){
  echo "Cleaning tmp files"
  sudo rm -rf "${WORK_DIR}"
  echo "Clean complete"
  echo
}

# Main function
function main(){
  printHeader
  checkPlist
  getGitHubLatestRelease
  downloadKext
  copyPlist
  changeLFM
  echo
  changeEPP
  echo
  generateKext
  clean
  echo "Great! This is the end of the script, please copy CPUFriend and CPUFriendDataProvider from desktop to /CLOVER/kexts/Other/(or /Library/Extensions/)"
  exit 0
}

main

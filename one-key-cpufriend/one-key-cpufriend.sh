#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 8 Feb, 2019.
# Only support most 8th CPU.
# This script depends on CPUFriend(https://github.com/acidanthera/CPUFriend) a lot, thanks to PMHeart.

# default board-id
BOARD_ID="Mac-53FDB3D8DB8CA971" # MacBookPro15,4

# Display style setting
BOLD="\033[1m"
RED="\033[1;31m"
GREEN="\033[1;32m"
OFF="\033[m"

# corresponding plist
X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"

function printHeader() {
  printf '\e[8;40;90t'

  # Interface (ref: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
  echo '  ____   ____    _   _   _____   ____    ___   _____   _   _   ____ '
  echo ' / ___| |  _ \  | | | | |  ___| |  _ \  |_ _| | ____| | \ | | |  _ \ '
  echo '| |     | |_) | | | | | | |_    | |_) |  | |  |  _|   |  \| | | | | | '
  echo '| |___  |  __/  | |_| | |  _|   |  _ <   | |  | |___  | |\  | | |_| | '
  echo ' \____| |_|      \___/  |_|     |_| \_\ |___| |_____| |_| \_| |____/ '
  echo
  echo '====================================================================='
}

# Check board-id, only system version >=10.14.6(18G87)(?) supports Mac-53FDB3D8DB8CA971.plist(MBP15,4)
function checkPlist() {
  if [[ ! -f "${X86_PLIST}" ]]; then
    # Use MBP15,2's plist if no Mac-53FDB3D8DB8CA971.plist
    BOARD_ID="Mac-827FB448E656EC26" # MacBookPro15,2
    X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"

    # check board-id, only system version >=10.13.6(17G2112) supports Mac-827FB448E656EC26.plist(MBP15,2)
    if [[ ! -f "${X86_PLIST}" ]]; then
      # Use MBP14,1's plist if no Mac-827FB448E656EC26.plist
      BOARD_ID="Mac-B4831CEBD52A0C4C" # MacBookPro14,1
      X86_PLIST="/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/${BOARD_ID}.plist"
    fi
  fi
}

function getGitHubLatestRelease() {
  local repoURL='https://api.github.com/repos/acidanthera/CPUFriend/releases/latest'
  ver="$(curl --silent "${repoURL}" | grep 'tag_name' | head -n 1 | awk -F ":" '{print $2}' | tr -d '"' | tr -d ',' | tr -d ' ')"

  if [[ -z "${ver}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: Failed to retrieve latest release from ${repoURL}."
    exit 1
  fi
}

# Exit in case of failure
function networkWarn() {
  echo -e "[ ${RED}ERROR${OFF} ]: Fail to download CPUFriend, please check your connection!"
  clean
  exit 1
}

# Download CPUFriend repository and unzip latest release
function downloadKext() {
  getGitHubLatestRelease

  # new folder for work
  WORK_DIR="$HOME/Desktop/one-key-cpufriend"
  [[ -d "${WORK_DIR}" ]] && sudo rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}" || exit 1

  echo
  echo '----------------------------------------------------------------------------------'
  echo '|* Downloading CPUFriend from https://github.com/acidanthera/CPUFriend @PMheart *|'
  echo '----------------------------------------------------------------------------------'

  # download ResourceConverter.sh
  local rcURL='https://raw.githubusercontent.com/acidanthera/CPUFriend/master/Tools/ResourceConverter.sh'
  curl --silent -O "${rcURL}" || networkWarn && chmod +x ./ResourceConverter.sh

  # download CPUFriend.kext
  local cfVER="${ver}"
  local cfFileName="CPUFriend-${cfVER}-RELEASE.zip"
  local cfURL="https://github.com/acidanthera/CPUFriend/releases/download/${cfVER}/${cfFileName}"
  # GitHub's CDN is hosted on Amazon, so here we add -L for redirection support
  curl -# -L -O "${cfURL}" || networkWarn
  # decompress it
  unzip -qu "${cfFileName}"
  # remove stuffs we do not need
  rm -rf "${cfFileName}" 'CPUFriend.kext.dSYM'
  echo -e "[ ${GREEN}OK${OFF} ]Download complete"
}

# Copy the target plist
function copyPlist() {
  if [[ ! -f "${X86_PLIST}" ]]; then
    echo -e "[ ${RED}ERROR${OFF} ]: ${X86_PLIST} NOT found!"
    clean
    exit 1
  fi

  cp "${X86_PLIST}" .
}

# chenge LFM value to adjust lowest frequency
# Reconsider whether this function is necessary because LFM seems doesn't effect energy performance
function changeLFM(){
  echo
  echo "-----------------------------------------"
  echo "|****** Choose Low Frequency Mode ******|"
  echo "-----------------------------------------"
  echo "(1) Remain the same (1200/1300mhz)"
  echo "(2) 800mhz"
  echo "(3) Customize"
  echo -e "${BOLD}Which option you want to choose? (1/2/3)${OFF}"
  read -rp ":" lfm_selection
  case ${lfm_selection} in
    1)
    # Keep default
    ;;

    2)
    # Change 1200/1300 to 800

    # change 020000000d000000 to 0200000008000000
    /usr/bin/sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" $BOARD_ID.plist

    # change 020000000c000000 to 0200000008000000
    /usr/bin/sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" $BOARD_ID.plist
    ;;

    3)
    # Customize LFM
    customizeLFM
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input, closing the script"
    clean
    exit 1
    ;;
  esac
}

# Customize LFM
function customizeLFM
{
  local Count=0
  local gLFM_RAW=""

  # check count and user input
  while  [ ${Count} -lt 3 ] && [[ ${gLFM_RAW} != 0 ]];
  do
    echo
    echo -e "${BOLD}Enter the lowest frequency in mhz (e.g. 1300, 2700), 0 to quit${OFF}"
    echo "Valid value should between 800 and 3500,"
    echo "and ridiculous value may result in hardware failure!"
    read -rp ": " gLFM_RAW
    if [ "${gLFM_RAW}" == 0 ]; then
      # if user enters 0, back to main function
      return

    # check whether gLFM_RAW is an integer
    elif [[ ${gLFM_RAW} =~ ^[0-9]*$ ]]; then

      # acceptable LFM should in 400~4000
      if [ "${gLFM_RAW}" -ge 400 ] && [ "${gLFM_RAW}" -le 4000 ]; then
        # get 4 denary number from user input, eg. 800 -> 0800
        gLFM_RAW=$(printf '%04d' "${gLFM_RAW}")
        # extract the first two digits
        gLFM_RAW=$(echo "${gLFM_RAW}" | cut -c -2)
        # remove zeros at the head, because like 08, bash will consider it as octonary number
        gLFM_RAW=$(echo "${gLFM_RAW}" | sed 's/0*//')
        # convert gLFM_RAW to hex and insert it in LFM field
        gLFM_VAL=$(printf '02000000%02x000000' "${gLFM_RAW}")
        # convert gLFM_VAL to base64
        gLFM_ENCODE=$(printf "${gLFM_VAL}" | xxd -r -p | base64)
        # extract the first 11 digits
        gLFM_ENCODE=$(echo "${gLFM_ENCODE}" | cut -c -11)

        # change 020000000d000000 to 02000000{Customized Value}000000
        /usr/bin/sed -i "" "s:AgAAAA0AAAA:${gLFM_ENCODE}:g" "$BOARD_ID.plist"
        # change 020000000c000000 to 02000000{Customized Value}000000
        /usr/bin/sed -i "" "s:AgAAAAwAAAA:${gLFM_ENCODE}:g" "$BOARD_ID.plist"
        return

      else
        # invalid value, give 3 chances to re-input
        echo
        echo -e "[ ${BOLD}WARNING${OFF} ]: Please enter valid value (400~4000)!"
        Count=$((Count+1))
      fi

    else
      # invalid value, give 3 chances to re-input
      echo
      echo -e "[ ${BOLD}WARNING${OFF} ]: Please enter valid value (400~4000)!"
      Count=$((Count+1))
    fi
  done

  if [ ${Count} -gt 2 ]; then
    # if 3 times is over and input value is still invalid, exit
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input, closing the script"
    clean
    exit 1
  fi
}

# change EPP value to adjust performance (ref: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
# TO DO: Use a more efficient way to replace frequencyvectors, see https://github.com/Piker-Alpha/freqVectorsEdit.sh
function changeEPP(){
  echo
  echo "----------------------------------------"
  echo "| Choose Energy Performance Preference |"
  echo "----------------------------------------"
  echo "(1) Max Power Saving"
  echo "(2) Balance Power (Default)"
  echo "(3) Balance performance"
  echo "(4) Performance"
  echo -e "${BOLD}Which mode is your favourite? (1/2/3/4)${OFF}"
  read -rp ":" epp_selection
  case ${epp_selection} in
    1)
    # Change 80/90/92 to C0, max power saving

    # change 657070000000000000000000000000000000000080 to 6570700000000000000000000000000000000000c0
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist

    # change 657070000000000000000000000000000000000090 to 6570700000000000000000000000000000000000c0
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
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

    # change 657070000000000000000000000000000000000080 to 657070000000000000000000000000000000000040
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist

    # change 657070000000000000000000000000000000000090 to 657070000000000000000000000000000000000040
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    ;;

    4)
    # Change 80/90/92 to 00, performance

    # change 657070000000000000000000000000000000000080 to 657070000000000000000000000000000000000000
    /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist

    # change 657070000000000000000000000000000000000090 to 657070000000000000000000000000000000000000
    /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $BOARD_ID.plist
    ;;

    *)
    echo -e "[ ${RED}ERROR${OFF} ]: Invalid input, closing the script"
    clean
    exit 1
    ;;
  esac
}

# Generate CPUFriendDataProvider.kext and move to desktop
function generateKext(){
  echo
  echo "Generating CPUFriendDataProvider.kext"
  ./ResourceConverter.sh --kext $BOARD_ID.plist
  cp -r "CPUFriendDataProvider.kext" "$HOME/Desktop/"

  # Copy CPUFriend.kext to Desktop
  cp -r "CPUFriend.kext" "$HOME/Desktop/"

  echo -e "[ ${GREEN}OK${OFF} ]Generate complete"
}

# Delete tmp folder and end
function clean(){
  echo
  echo "Cleaning tmp files"
  sudo rm -rf "${WORK_DIR}"
  echo -e "[ ${GREEN}OK${OFF} ]Clean complete"
  echo
}

# Main function
function main(){
  printHeader
  checkPlist
  downloadKext
  copyPlist
  changeLFM
  changeEPP
  generateKext
  clean
  echo -e "[ ${GREEN}OK${OFF} ]This is the end of the script, please copy CPUFriend and CPUFriendDataProvider"
  echo "from desktop to /CLOVER/kexts/Other/(or L/E/)"
  exit 0
}

main

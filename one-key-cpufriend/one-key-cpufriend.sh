#!/bin/bash

# Created by stevezhengshiqi on 8 Feb, 2019.
# Only support most 8th CPU.
# This script depends on CPUFriend(https://github.com/acidanthera/CPUFriend) a lot, thanks to Acidanthera and PMHeart.

# Interface (Ref: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
function interface(){
    printf "\e[8;40;110t"
    boardid=0
    echo "  ____   ____    _   _   _____   ____    ___   _____   _   _   ____ "
    echo " / ___| |  _ \  | | | | |  ___| |  _ \  |_ _| | ____| | \ | | |  _ \ "
    echo "| |     | |_) | | | | | | |_    | |_) |  | |  |  _|   |  \| | | | | | "
    echo "| |___  |  __/  | |_| | |  _|   |  _ <   | |  | |___  | |\  | | |_| | "
    echo " \____| |_|      \___/  |_|     |_| \_\ |___| |_____| |_| \_| |____/ "
    echo " "
    echo "===================================================================== "
}

# Exit if connection fails
function networkWarn(){
    echo "ERROR: Fail to download CPUFriend, please check the network state"
    exit 0
}

# Download CPUFriend repository and unzip latest release
function download(){
    mkdir -p Desktop/tmp/one-key-cpufriend
    cd Desktop/tmp/one-key-cpufriend
    echo "--------------------------------------------------------------------------"
    echo "|* Downloading CPUFriend from github.com/acidanthera/CPUFriend @PMHeart *|"
    echo "--------------------------------------------------------------------------"
    curl -fsSL https://raw.githubusercontent.com/acidanthera/CPUFriend/master/ResourceConverter/ResourceConverter.sh -o ./ResourceConverter.sh || networkWarn
    sudo chmod +x ./ResourceConverter.sh
    curl -fsSL https://github.com/acidanthera/CPUFriend/releases/download/1.1.6/1.1.6.RELEASE.zip -o ./1.1.6.RELEASE.zip && unzip 1.1.6.RELEASE.zip && cp -r CPUFriend.kext ../../ || networkWarn
}

# Check board-id, only system version >=10.13.6(17G2112) supports Mac-827FB448E656EC26.plist(MBP15,2)
function checkboardid(){
    if [ -f "/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-827FB448E656EC26.plist" ]; then
        boardid=Mac-827FB448E656EC26
    else
        boardid=Mac-B4831CEBD52A0C4C
    fi
}

# Copy the target plist
function copyplist(){
    sudo cp -r /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/$boardid.plist ./
}

# chenge LFM value to adjust lowest frequency
# Reconsider whether this function is necessary because LFM seems doesn't effect energy performance
function changelfm(){
    echo "-----------------------------------------"
    echo "|****** Choose Low Frequency Mode ******|"
    echo "-----------------------------------------"
    echo "(1) Remain the same (1200/1300mhz)"
    echo "(2) 800mhz (Lower frequency in low load)"
    read -p "Which option you want to choose? (1/2):" lfm_selection
    case $lfm_selection in
        1)
        # Keep default
        ;;

        2)
        # Change 1200/1300 to 800
        sudo /usr/bin/sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" $boardid.plist
        ;;

        *)
        echo "ERROR: Invalid input, closing the script"
        exit 0
        ;;
    esac
}

# change EPP value to adjust performance (ref: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
function changeepp(){
    echo "----------------------------------------"
    echo "| Choose Energy Performance Preference |"
    echo "----------------------------------------"
    echo "(1) Max Power Saving"
    echo "(2) Balance Power (Default)"
    echo "(3) Balance performance"
    echo "(4) Performance"
    read -p "Which mode is your favourite? (1/2/3/4):" epp_selection
    case $epp_selection in
        1)
        # Change 80/90 to C0, max power saving
        sudo /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        ;;

        2)
        # Keep default 80/90, balance power
        ;;

        3)
        # Change 80/90 to 40, balance performance
        sudo /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        ;;

        4)
        # Change 80/90 to 00, performance
        sudo /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        ;;

        *)
        echo "ERROR: Invalid input, closing the script"
        exit 0
        ;;
    esac
}

# Generate CPUFriendDataProvider.kext and move to desktop
function generatekext(){
    echo "Generating CPUFriendDataProvider.kext"
    sudo ./ResourceConverter.sh --kext $boardid.plist
    cp -r CPUFriendDataProvider.kext ../../
}

# Delete tmp folder and end
function clean(){
    sudo rm -rf ../../tmp

    echo "Great! This is the end of the script, please copy CPUFriend and CPUFriendDataProvider from desktop to /CLOVER/kexts/Other/"
    exit 0
}

# Main function
function main(){
    interface
    echo " "
    download
    echo " "
    checkboardid
    copyplist
    changelfm
    echo " "
    changeepp
    echo " "
    generatekext
    echo " "
    clean
    exit 0
}

main

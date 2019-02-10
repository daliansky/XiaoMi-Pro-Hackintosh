#!/bin/bash
# Created by stevezhengshiqi
# Only support 8th CPU yet, this script will force system to use MacBookPro15,2(Mac-827FB448E656EC26.plist)'s X86PlatformPlugin configuration.
# If macOS version is lower than 10.13.6(17G2112), the script will turn to MacBookPro14,1(Mac-B4831CEBD52A0C4C.plist)'s configuration.
# This script depends on CPUFriend(https://github.com/acidanthera/CPUFriend) a lot, thanks to Acidanthera.

# Interface (Ref: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
echo "  ____   ____    _   _   _____   ____    ___   _____   _   _   ____ "
echo " / ___| |  _ \  | | | | |  ___| |  _ \  |_ _| | ____| | \ | | |  _ \ "
echo "| |     | |_) | | | | | | |_    | |_) |  | |  |  _|   |  \| | | | | | "
echo "| |___  |  __/  | |_| | |  _|   |  _ <   | |  | |___  | |\  | | |_| | "
echo " \____| |_|      \___/  |_|     |_| \_\ |___| |_____| |_| \_| |____/ "
echo "===================================================================== "

# Download CPUFriend repository
mkdir -p Desktop/tmp/one-key-cpufriend
cd Desktop/tmp/one-key-cpufriend
echo '|* Downloading CPUFriend from github.com/acidanthera/CPUFriend @PMHeart *|'
echo '--------------------------------------------------------------------------'
# Exit if connection fails
curl -fsSL https://github.com/acidanthera/CPUFriend/archive/master.zip -o ./CPUFriend.zip && unzip CPUFriend.zip || exit 0

echo ' '

# Check whether MacBookPro15,2 PM plist exists (>=10.13.6(17G2112))
if [ -f "/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-827FB448E656EC26.plist" ];then

    # Copy MacBookPro15,2 PM plist to tmp folder
    sudo cp -r /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-827FB448E656EC26.plist ./

    # Lower down the min frequency to 800mhz
    echo -e "\033[1m|* Lower min frequency may help save power when CPU is running in low load *|\033[0m"
    read -p "Do you want to change minimum frequency from 1300mhz to 800mhz? (y/n):" lfm_selection
    case $lfm_selection in
        y)
        sudo sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" Mac-827FB448E656EC26.plist
        ;;

        n)
        ;;

        *)
        echo "ERROR: Invalid input, closing the script"
        exit 0
        ;;
    esac

    echo ' '

    # Choose EPP value to adjust performance (ref: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
    echo '---------------------------------------'
    echo '|**** Choose CPU performance mode ****|'
    echo '---------------------------------------'
    echo '(1) Max Power Saving'
    echo '(2) Balance Power (Default)'
    echo '(3) Balance performance'
    echo '(4) Performance'
    read -p "Which mode is your favourite? (1/2/3/4):" epp_selection
    case $epp_selection in
        1)
        # Change 90 to C0, max power saving
        sudo sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" Mac-827FB448E656EC26.plist
        ;;

        2)
        # Keep default 90, balance power
        ;;

        3)
        # Change 90 to 40, balance performance
        sudo sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" Mac-827FB448E656EC26.plist
        ;;

        4)
        # Change 90 to 00, performance
        sudo sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" Mac-827FB448E656EC26.plist
        ;;

        *)
        echo "ERROR: Invalid input, closing the script"
        exit 0
        ;;
    esac

    # Create CPUFriendDataProvider.kext and move to desktop
    CPUFriend-master/ResourceConverter/ResourceConverter.sh --kext Mac-827FB448E656EC26.plist
    cp -r CPUFriendDataProvider.kext ../../

else

    # Copy MacBookPro14,1's PM plist to tmp folder
    sudo cp -r /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-B4831CEBD52A0C4C.plist ./

    # Lower down the min frequency to 800mhz
    echo -e "\033[1m|* Lower min frequency may help save power when CPU is running in low load *|\033[0m"
    read -p "Do you want to change minimum frequency from 1300mhz to 800mhz? (y/n):" lfm_selection
    case $lfm_selection in
        y)
        sudo sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        n)
        ;;

        *)
        echo "ERROR: Invalid input, closing the script"
        exit 0
        ;;
    esac

    echo ' '

    # Choose EPP value to adjust performance (ref: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
    echo '---------------------------------------'
    echo '|**** Choose CPU performance mode ****|'
    echo '---------------------------------------'
    echo '(1) Max Power Saving'
    echo '(2) Balance Power (Default)'
    echo '(3) Balance performance'
    echo '(4) Performance'
    read -p "Which mode is your favourite? (1/2/3/4):" epp_selection
    case $epp_selection in
        1)
        # Change 80 to C0, max power saving
        sudo sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        2)
        # Keep default 80, balance power
        ;;

        3)
        # Change 80 to 40, balance performance
        sudo sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        4)
        # Change 80 to 00, performance
        sudo sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        *)
        echo "ERROR: Invalid input, closing the script"
        exit 0
        ;;
    esac

    # Generate CPUFriendDataProvider.kext and move to desktop
    CPUFriend-master/ResourceConverter/ResourceConverter.sh --kext Mac-B4831CEBD52A0C4C.plist
    cp -r CPUFriendDataProvider.kext ../../
fi

echo ' '

# Download, unzip, and copy the latest release of CPUFriend to desktop
echo '|**** Downloading the latest release of CPUFriend, credit @PMHeart ****|'
curl -fsSL https://github.com/acidanthera/CPUFriend/releases/download/1.1.6/1.1.6.RELEASE.zip -o ./1.1.6.RELEASE.zip && unzip 1.1.6.RELEASE.zip && cp -r CPUFriend.kext ../../ || echo "ERROR: Fail to download CPUFriend release, please download it maunally from https://github.com/acidanthera/CPUFriend/releases/download/1.1.6/1.1.6.RELEASE.zip."

echo ' '

# Delete tmp folder
sudo rm -rf ../../tmp

echo -e "\033[1mGreat! This is the end of the script, please copy CPUFriend and CPUFriendDataProvider from desktop to /CLOVER/kexts/Other/\033[0m"
exit 0

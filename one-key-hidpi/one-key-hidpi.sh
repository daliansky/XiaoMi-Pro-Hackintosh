#!/bin/bash

# Rewrite on Feb 25, 2019 by stevezhengshiqi
# The script is a mini version of https://github.com/xzhih/one-key-hidpi, thanks to @xzhih
# Only support Xiaomi-Pro (9e5,747)

DISPLAYPATH="/System/Library/Displays/Contents/Resources/Overrides"

# Interface (Ref:https://github.com/xzhih/one-key-hidpi/master/hidpi.sh)
function interface() {
    echo '  _    _   _____   _____    _____    _____ '
    echo ' | |  | | |_   _| |  __ \  |  __ \  |_   _|'
    echo ' | |__| |   | |   | |  | | | |__) |   | |'
    echo ' |  __  |   | |   | |  | | |  ___/    | |'
    echo ' | |  | |  _| |_  | |__| | | |       _| |_ '
    echo ' |_|  |_| |_____| |_____/  |_|      |_____|'
    echo 'This script is only for XiaoMi-Pro!'
    echo '============================================'
}

# Choose option
function choice() {
    choose=0
    echo '(1) Enable HiDPI'
    echo '(2) Disable HiDPI'
    echo '(3) Exit'
    read -p "Enter your choice [1~3]: " choose
}

# Exit if connection fails
function networkWarn(){
    echo "ERROR: Fail to download one-key-hidpi, please check the network state"
    clean
    exit 1
}

# Download from https://github.com/daliansky/XiaoMi-Pro/tree/master/one-key-hidpi
function download(){
    echo 'Downloading display files...'
    mkdir -p one-key-hidpi
    cd one-key-hidpi
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/Icons.plist -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/DisplayVendorID-9e5/DisplayProductID-747 -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/DisplayVendorID-9e5/DisplayProductID-747.icns -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/DisplayVendorID-9e5/DisplayProductID-747.tiff -O || networkWarn
    echo 'Download complete'
    echo
}

function removeold() {
    # Uninstall HiScale (Added in commit https://github.com/daliansky/XiaoMi-Pro/commit/fa35968b5acf851e274932ca52e67c43fe747877)
    echo 'Removing previous version...'
    sudo launchctl remove /Library/LaunchAgents/org.zysuper.riceCracker.plist
    sudo pkill riceCrackerDaemon
    sudo rm -f /Library/LaunchAgents/org.zysuper.ricecracker.daemon.plist
    sudo rm -f /usr/bin/riceCrackerDaemon

    # Remove previous one-key-hidpi (Added in commit https://github.com/daliansky/XiaoMi-Pro/commit/a3b7f136209a91455944b4afece7e14a931e62ba)
    sudo rm -rf $DISPLAYPATH/DisplayVendorID-9e5
    echo 'Remove complete'
    echo
}

# Create backup for Icons.plist
function backup() {
    echo 'Backing up...'
    sudo mkdir -p $DISPLAYPATH/backup
    sudo cp $DISPLAYPATH/Icons.plist $DISPLAYPATH/backup/
    echo 'Back up complete'
    echo
}

# Copy the display folder
function copy() {
    echo 'Copying file to target address...'
    sudo mkdir -p $DISPLAYPATH/DisplayVendorID-9e5
    sudo cp ./Icons.plist $DISPLAYPATH/
    sudo cp ./DisplayProductID-747 $DISPLAYPATH/DisplayVendorID-9e5/
    sudo cp ./DisplayProductID-747.icns $DISPLAYPATH/DisplayVendorID-9e5/
    sudo cp ./DisplayProductID-747.tiff $DISPLAYPATH/DisplayVendorID-9e5/
    echo 'Copy complete'
    echo
}

# Fix permission
function fixpermission() {
    echo 'Fixing permission...'
    sudo chown root:wheel $DISPLAYPATH/Icons.plist
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5/DisplayProductID-747
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5/DisplayProductID-747.icns
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5/DisplayProductID-747.tiff
    echo 'Fix complete'
    echo
}

# Clean
function clean() {
    echo 'Cleaning temporary files...'
    sudo rm -rf ../one-key-hidpi
    echo 'Clean complete'
    echo
}

# Install
function install() {
    download
    removeold
    backup
    copy
    fixpermission
    clean
    echo 'Wonderful! This is the end of the installation, please reboot and choose 1424x802 in SysPref! '
    exit 0
}

# Uninstall
function uninstall() {
    echo 'Uninstalling one-key-hidpi...'
    sudo rm -rf $DISPLAYPATH/DisplayVendorID-9e5

    # Restore Icon.plist in backup folder if presents
    if [ -f "$DISPLAYPATH/backup/Icons.plist" ];then
        sudo cp $DISPLAYPATH/backup/Icons.plist $DISPLAYPATH/
        sudo chown root:wheel $DISPLAYPATH/Icons.plist
    fi

    # Remove backup folder
    sudo rm -rf $DISPLAYPATH/backup
    echo 'Uninstall complete'
    exit 0
}

# Main function
function main() {
    interface
    choice
    case $choose in
        1)
        install
        ;;

        2)
        uninstall
        ;;

        3)
        exit 0
        ;;

        *)
        echo "ERROR: Invalid input, the script will exit";
        exit 1
        ;;
    esac
}

main

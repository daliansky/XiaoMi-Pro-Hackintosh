#!/bin/bash
#set -x # for DEBUGGING

# Create on Feb 27, 2019 by stevezhengshiqi
# Only support Xiaomi-Pro (NV156FHM-N61)

# Interface (Ref:http://patorjk.com/software/taag/#p=display&f=Ivrit&t=Color%20Profile)
function interface() {
    echo '  ____      _              ____             __ _ _       '
    echo ' / ___|___ | | ___  _ __  |  _ \ _ __ ___  / _(_) | ___  '
    echo "| |   / _ \| |/ _ \| '__| | |_) | '__/ _ \| |_| | |/ _ \ "
    echo '| |__| (_) | | (_) | |    |  __/| | | (_) |  _| | |  __/ '
    echo ' \____\___/|_|\___/|_|    |_|   |_|  \___/|_| |_|_|\___| '
    echo "Only support Xiaomi-Pro (NV156FHM-N61)"
    echo "======================================================== "
}

# Choose option
function choice() {
    echo "(1) Add Color Profile"
    echo "(2) Remove Color Profile"
    echo "(3) Exit"
    read -p "Which option you want to choose? (1/2/3):" color_option
    echo
}

# Exit if connection fails
function networkWarn(){
    echo "ERROR: Fail to download Color Profile, please check the network state"
    clean
    exit 1
}

# Download from https://github.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile
function download(){
    mkdir -p one-key-colorprofile
    cd one-key-colorprofile
    echo "Downloading Color Profile..."
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ColorProfile/NV156FHM-N61.icm -O || networkWarn
    echo "Download complete"
    echo
}

# Copy the color profile
function copy() {
    echo "Copying Color Profile..."
    sudo cp "./NV156FHM-N61.icm" /Library/ColorSync/Profiles/
    echo "Copy complete"
    echo
}

# Fix permission
function fixpermission() {
    echo "Fixing permission..."
    sudo chown root:wheel /Library/ColorSync/Profiles/NV156FHM-N61.icm
    echo "Fix complete"
    echo
}

# Clean
function clean() {
    echo "Cleaning temporary files..."
    sudo rm -rf ../one-key-colorprofile
    echo "Clean complete"
}

# Uninstall
function uninstall() {
    echo "Uninstalling..."
    sudo rm -rf /Library/ColorSync/Profiles/NV156FHM-N61.icm
    echo "Uninstall complete"
    exit 0
}

# Install function
function install() {
    download
    copy
    fixpermission
    clean
    echo 'Nice! The installation of the Color Profile completes.'
    exit 0
}

# Main function
function main() {
    interface
    choice
    case $color_option in
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
        echo "ERROR: Invalid input, closing the script"
        exit 1
        ;;
    esac
}

main

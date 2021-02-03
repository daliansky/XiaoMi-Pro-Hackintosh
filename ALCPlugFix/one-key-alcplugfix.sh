#!/bin/bash
#set -x # for DEBUGGING

# Rewrite on Feb 27, 2019 by stevezhengshiqi, special thanks to @Menchen
# Support Xiaomi-Pro (ALC298,layout-id99)

# Interface (Ref:http://patorjk.com/software/taag/#p=display&f=Ivrit&t=P%20l%20u%20g%20F%20i%20x)
function interface() {
    echo ' ____    _                   _____   _         '
    echo '|  _ \  | |  _   _    __ _  |  ___| (_) __  __ '
    echo '| |_) | | | | | | |  / _` | | |_    | | \ \/ / '
    echo '|  __/  | | | |_| | | (_| | |  _|   | |  >  <  '
    echo '|_|     |_|  \__,_|  \__, | |_|     |_| /_/\_\ '
    echo '                      |___/                    '
    echo 'Support XiaoMi-Pro 8th Gen (ALC298, layout-id 30/99)'
    echo '======================================================'
}

# Choose option
function choice() {
    echo "(1) Enable ALCPlugFix"
    echo "(2) Disable ALCPlugFix"
    echo "(3) Exit"
    read -rp "Which option you want to choose? (1/2/3):" alc_option
    echo
}

# Exit if connection fails
function networkWarn(){
    echo "ERROR: Fail to download ALCPlugFix, please check the network state"
    clean
    exit 1
}

# Download from https://github.com/Menchen/ALCPlugFix
function download(){
    mkdir -p one-key-alcplugfix
    cd one-key-alcplugfix || exit 1
    echo "Downloading audio fix patch..."
    curl -L -O https://raw.githubusercontent.com/Menchen/ALCPlugFix/master/build/Release/ALCPlugFix || networkWarn
    curl -L -O https://raw.githubusercontent.com/Menchen/ALCPlugFix/master/alc_fix/good.win.ALCPlugFix.plist || networkWarn
    curl -L -O https://raw.githubusercontent.com/Menchen/ALCPlugFix/master/alc_fix/hda-verb || networkWarn
    echo "Download complete"
    echo
}

# Copy the audio fix files
function copy() {
    echo "Copying audio fix patch..."
	if [ ! -d "/usr/local/bin" ]; then
		echo "'/usr/local/bin' not found, creating one instead..."
		sudo mkdir -p -m 775 /usr/local/bin
		sudo chown "$USER":admin /usr/local/bin
	fi
    sudo cp "./ALCPlugFix" /usr/local/bin/
    sudo cp "./hda-verb" /usr/local/bin/
    sudo cp "./good.win.ALCPlugFix.plist" /Library/LaunchDaemons/
    echo "Copy complete"
    echo
}

# Fix permission
function fixpermission() {
    echo "Fixing permission..."
    sudo chmod 755 /usr/local/bin/ALCPlugFix
    sudo chown "$USER":admin /usr/local/bin/ALCPlugFix
    sudo chmod 755 /usr/local/bin/hda-verb
    sudo chown "$USER":admin /usr/local/bin/hda-verb
    sudo chmod 644 /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    sudo chown root:wheel /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    echo "Fix complete"
    echo
}

# Load service
function loadservice() {
    echo "Loading service..."
    sudo launchctl load /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    echo "Load complete"
    echo
}

# Clean
function clean() {
    echo "Cleaning..."
    sudo rm -rf ../one-key-alcplugfix
    echo "Clean complete"
    echo
}

# Uninstall
function uninstall() {
    echo "Uninstalling..."
    sudo launchctl remove /Library/LaunchAgents/good.win.ALCPlugFix.plist
    sudo launchctl remove /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    sudo rm -rf /Library/LaunchAgents/good.win.ALCPlugFix.plist
    sudo rm -rf /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    sudo rm -rf /usr/bin/ALCPlugFix
    sudo rm -rf /usr/bin/hda-verb
    sudo rm -rf /usr/local/bin/ALCPlugFix
    sudo rm -rf /usr/local/bin/hda-verb
    echo "Uninstall complete"
    echo 
    if [[ $1 = "cleanup" ]]; then 
    return
    else exit 0 
    fi
}

# Install function
function install() {
    download
    uninstall "cleanup"
    copy
    fixpermission
    loadservice
    clean
    echo 'Nice! The installation of the ALCPlugFix daemon completes.'
    exit 0
}

# Main function
function main() {
    interface
    choice
    case $alc_option in
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

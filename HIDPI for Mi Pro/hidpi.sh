#!/bin/sh
# 
# Initialisation
function init()
{
#
cat << EEF
----------------------------------------
|*************** HIDPI ****************|
----------------------------------------
EEF
    #
    VendorID=$(ioreg -l | grep "DisplayVendorID" | awk '{print $8}')
    ProductID=$(ioreg -l | grep "DisplayProductID" | awk '{print $8}')
    EDID=$(ioreg -l | grep "IODisplayEDID" | awk '{print $8}' | sed -e 's/.$//' -e 's/^.//')

    Vid=$(echo "obase=16;$VendorID" | bc | tr 'A-Z' 'a-z')
    Pid=$(echo "obase=16;$ProductID" | bc | tr 'A-Z' 'a-z')

    edID=$(echo $EDID | sed 's/../b5/21')

    EDid=$(echo $edID | xxd -r -p | base64)
    thisDir=$(dirname $0)
    thatDir="/System/Library/Displays/Contents/Resources/Overrides"

    Overrides="\/System\/Library\/Displays\/Contents\/Resources\/Overrides\/"

    DICON="com\.apple\.cinema-display"

    imacicon=${Overrides}"DisplayVendorID-610\/DisplayProductID-a032.tiff"

    mbpicon=${Overrides}"DisplayVendorID-610\/DisplayProductID-a030-e1e1df.tiff"

    mbicon=${Overrides}"DisplayVendorID-610\/DisplayProductID-a028-9d9da0.tiff"

    lgicon=${Overrides}"DisplayVendorID-1e6d\/DisplayProductID-5b11.tiff"

    if [[ ! -d $thatDir/backup ]]; then
        echo "Backing up"
        sudo mkdir -p $thatDir/backup
        sudo cp $thatDir/Icons.plist $thatDir/backup/
        if [[ -d $thatDir/DisplayVendorID-$Vid ]]; then
            sudo cp -r $thatDir/DisplayVendorID-$Vid $thatDir/backup/
        fi
    fi
}

# CHOOSE ICON
function choose_icon()
{
    #
    mkdir $thisDir/tmp/
    curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/Icons.plist -o $thisDir/tmp/Icons.plist
    # curl -fsSL http://127.0.0.1:8080/Icons.plist -o $thisDir/tmp/Icons.plist

#
cat << EOF
----------------------------------------
|********** CHOOSE YOUR ICON ***********|
----------------------------------------
(1) iMac
(2) MacBook
(3) MacBook Pro
(4) LG Display
(5) Stay the same

EOF
read -p "Enter your choice[1~5]: " logo
case $logo in
    1) Picon=$imacicon
RP=("33" "68" "160" "90")
;;
2) Picon=$mbicon
RP=("52" "66" "122" "76")
;;
3) Picon=$mbpicon
RP=("40" "62" "147" "92")
;;
4) Picon=$lgicon
RP=("11" "47" "202" "114")
DICON=${Overrides}"DisplayVendorID-1e6d\/DisplayProductID-5b11.icns"
;;
5) rm -rf $thisDir/tmp/Icons.plist
;;
*) echo "Wrong choice, Bye";
exit 0
;;
esac 

if [[ $Picon ]]; then
    sed -i '' "s/VID/$Vid/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/PID/$Pid/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/RPX/${RP[0]}/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/RPY/${RP[1]}/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/RPW/${RP[2]}/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/RPH/${RP[3]}/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/PICON/$Picon/g" $thisDir/tmp/Icons.plist
    sed -i '' "s/DICON/$DICON/g" $thisDir/tmp/Icons.plist
fi

}

# Main function
function main()
{
    sudo mkdir -p $thisDir/tmp/DisplayVendorID-$Vid
    dpiFile=$thisDir/tmp/DisplayVendorID-$Vid/DisplayProductID-$Pid
    sudo chmod -R 777 $thisDir/tmp/

# 
cat > "$dpiFile" <<-\HIDPI
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DisplayProductID</key>
            <integer>PID</integer>
        <key>DisplayVendorID</key>
            <integer>VID</integer>
        <key>DisplayProductName</key>
            <string>Color LCD</string>
        <key>IODisplayEDID</key>
            <data>EDid</data>
        <key>scale-resolutions</key>
            <array>
                <data>
                AAAPAAAACHAA
                </data>
                <data>
                AAAMgAAABkAA
                </data>
                <data>
                AAAMgAAABwgA
                </data>
                <data>
                AAALQAAABlQA
                </data>
            </array>
        <key>target-default-ppmm</key>
            <real>10.1510574</real>
    </dict>
</plist>
HIDPI

    sed -i '' "s/VID/$VendorID/g" $dpiFile
    sed -i '' "s/PID/$ProductID/g" $dpiFile
}

# Clean up
function end()
{
    sudo cp -r $thisDir/tmp/* $thatDir/
    sudo rm -rf $thisDir/tmp
    echo "Open HiDPI successfully, please restart"
    echo "The boot logo will become very big only at first time"
}

# OPEN
function enable_hidpi()
{
    choose_icon
    main
    sed -i "" "/.*IODisplayEDID/d" $dpiFile
    sed -i "" "/.*EDid/d" $dpiFile
    end
}

# Patch EDID
function enable_hidpi_with_patch()
{
    choose_icon
    main
    sed -i '' "s:EDid:${EDid}:g" $dpiFile
    end
}

# CLOSE
function disable()
{
    sudo rm -rf $thatDir/DisplayVendorID-$Vid 
    sudo rm -rf $thatDir/Icons.plist

    sudo cp -r $thatDir/backup/* $thatDir/

    sudo rm -rf $thatDir/backup
    echo "Close successfully, please restart"
}

function start()
{
    init
# 
cat << EOF

(1) OPEN HIDPI
(2) OPEN HIDPI (Inject EDID)
(3) CLOSE HIDPI

EOF
read -p "Enter your choice[1~3]: " input
case $input in
    1) enable_hidpi
;;
2) enable_hidpi_with_patch
;;
3) disable
;;
*) echo "Wrong choice, bye";
exit 0
;;
esac 
}

start

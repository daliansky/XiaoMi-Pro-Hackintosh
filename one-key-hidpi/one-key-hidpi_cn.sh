#!/bin/bash
# stevezhengshiqi重写于2019.02.25
# 这个脚本是 https://github.com/xzhih/one-key-hidpi 的一个精简，谢谢@xzhih
# 只支持小米笔记本Pro (9e5,747)

DISPLAYPATH="/System/Library/Displays/Contents/Resources/Overrides"

# 界面 (参考:https://github.com/xzhih/one-key-hidpi/master/hidpi.sh)
function interface() {
    echo '  _    _   _____   _____    _____    _____ '
    echo ' | |  | | |_   _| |  __ \  |  __ \  |_   _|'
    echo ' | |__| |   | |   | |  | | | |__) |   | |'
    echo ' |  __  |   | |   | |  | | |  ___/    | |'
    echo ' | |  | |  _| |_  | |__| | | |       _| |_ '
    echo ' |_|  |_| |_____| |_____/  |_|      |_____|'
    echo '此脚本只限于小米笔记本Pro!'
    echo '============================================'
}

# 选择选项
function choice() {
    choose=0
    echo '(1) 开启HiDPI'
    echo '(2) 关闭HiDPI'
    echo '(3) 退出'
    read -p "输入你的选择 [1~3]: " choose
}

# 如果网络连接失败，则退出
function networkWarn(){
    echo "错误: 下载one-key-hidpi失败, 请检查网络连接状态"
    exit 0
}

# 下载资源来自 https://github.com/daliansky/XiaoMi-Pro/tree/master/one-key-hidpi
function download(){
    echo '正在下载屏幕文件'
    mkdir -p one-key-hidpi
    cd one-key-hidpi
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/Icons.plist -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/DisplayVendorID-9e5/DisplayProductID-747 -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/DisplayVendorID-9e5/DisplayProductID-747.icns -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro/master/one-key-hidpi/DisplayVendorID-9e5/DisplayProductID-747.tiff -O || networkWarn
}

function removeold() {
    # 卸载 HiScale (在commit https://github.com/daliansky/XiaoMi-Pro/commit/fa35968b5acf851e274932ca52e67c43fe747877 加入)
    echo '正在移除旧版本'
    sudo launchctl remove /Library/LaunchAgents/org.zysuper.riceCracker.plist
    sudo pkill riceCrackerDaemon
    sudo rm -f /Library/LaunchAgents/org.zysuper.ricecracker.daemon.plist
    sudo rm -f /usr/bin/riceCrackerDaemon

    # 卸载旧版本one-key-hidpi (在commit https://github.com/daliansky/XiaoMi-Pro/commit/a3b7f136209a91455944b4afece7e14a931e62ba 加入)
    sudo rm -rf $DISPLAYPATH/DisplayVendorID-9e5
}

# 给Icons.plist创建备份
function backup() {
    echo '正在备份'
    sudo mkdir -p $DISPLAYPATH/backup
    sudo cp $DISPLAYPATH/Icons.plist $DISPLAYPATH/backup/
}

# 拷贝屏幕文件夹
function copy() {
    echo '正在拷贝文件到目标路径'
    sudo mkdir -p $DISPLAYPATH/DisplayVendorID-9e5
    sudo cp ./Icons.plist $DISPLAYPATH/
    sudo cp ./DisplayProductID-747 $DISPLAYPATH/DisplayVendorID-9e5/
    sudo cp ./DisplayProductID-747.icns $DISPLAYPATH/DisplayVendorID-9e5/
    sudo cp ./DisplayProductID-747.tiff $DISPLAYPATH/DisplayVendorID-9e5/
}

# 修复权限
function fixpermission() {
    echo '正在修复权限'
    sudo chown root:wheel $DISPLAYPATH/Icons.plist
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5/DisplayProductID-747
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5/DisplayProductID-747.icns
    sudo chown root:wheel $DISPLAYPATH/DisplayVendorID-9e5/DisplayProductID-747.tiff
}

# 清理
function clean() {
    echo '正在清理临时文件'
    sudo rm -rf ../one-key-hidpi
}

# 安装
function install() {
    download
    removeold
    backup
    copy
    fixpermission
    clean
    echo '很棒! 安装已结束, 请重启并在显示器面板选择1424x802分辨率! '
}

# 卸载
function uninstall() {
    echo '正在卸载one-key-hidpi'
    sudo rm -rf $DISPLAYPATH/DisplayVendorID-9e5

    # 恢复 Icon.plist 从备份文件夹（如果存在）
    if [ -f "$DISPLAYPATH/backup/Icons.plist" ];then
        sudo cp $DISPLAYPATH/backup/Icons.plist $DISPLAYPATH/
        sudo chown root:wheel $DISPLAYPATH/Icons.plist
    fi

    # 移除备份文件夹
    sudo rm -rf $DISPLAYPATH/backup
}

# 主程序
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
        echo "错误: 无效输入, 脚本将退出";
        exit 0
        ;;
    esac
}

main

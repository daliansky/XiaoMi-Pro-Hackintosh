#!/bin/bash
#set -x # for DEBUGGING

# stevezhengshiqi创建于2019.02.27
# 仅支持小米笔记本Pro(NV156FHM-N61)

# 界面 (参考:http://patorjk.com/software/taag/#p=display&f=Ivrit&t=Color%20Profile)
function interface() {
    echo '  ____      _              ____             __ _ _       '
    echo ' / ___|___ | | ___  _ __  |  _ \ _ __ ___  / _(_) | ___  '
    echo "| |   / _ \| |/ _ \| '__| | |_) | '__/ _ \| |_| | |/ _ \ "
    echo '| |__| (_) | | (_) | |    |  __/| | | (_) |  _| | |  __/ '
    echo ' \____\___/|_|\___/|_|    |_|   |_|  \___/|_| |_|_|\___| '
    echo "仅支持小米笔记本Pro(NV156FHM-N61)"
    echo "======================================================== "
}

# 选择选项
function choice() {
    echo "(1) 添加色彩描述文件"
    echo "(2) 删除色彩描述文件"
    echo "(3) 退出"
    read -rp "你想选择哪个选项? (1/2/3):" color_option
    echo
}

# 如果网络连接失败，则退出
function networkWarn(){
    echo "错误: 下载色彩描述文件失败, 请检查网络连接状态"
    clean
    exit 1
}

# 下载文件来自 https://github.com/daliansky/XiaoMi-Pro-Hackintosh/main/ColorProfile
function download(){
    mkdir -p Desktop/one-key-colorprofile
    cd Desktop/one-key-colorprofile || exit 1
    echo "正在下载色彩描述文件..."
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/main/ColorProfile/NV156FHM-N61.icm -O || networkWarn
    echo "下载完成"
    echo
}

# 拷贝色彩描述文件
function copy() {
    echo "正在拷贝色彩描述文件..."
    sudo cp "./NV156FHM-N61.icm" /Library/ColorSync/Profiles/
    echo "拷贝完成"
    echo
}

# 修复权限
function fixpermission() {
    echo "正在修复权限..."
    sudo chown root:wheel /Library/ColorSync/Profiles/NV156FHM-N61.icm
    echo "修复完成"
    echo
}

# 清理
function clean() {
    echo "正在清理临时文件..."
    sudo rm -rf ../one-key-colorprofile
    echo "清理完成"
}

# 卸载
function uninstall() {
    echo "正在卸载..."
    sudo rm -rf /Library/ColorSync/Profiles/NV156FHM-N61.icm
    echo "卸载完成"
    exit 0
}

# 安装程序
function install() {
    download
    copy
    fixpermission
    clean
    echo '棒! 色彩描述文件安装完成。'
    exit 0
}

# 主程序
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
        echo "错误: 输入有误, 将退出脚本"
        exit 1
        ;;
    esac
}

main

#!/bin/bash

# stevezhengshiqi重写于2019.02.27, 特别感谢@Menchen
# 支持小米笔记本Pro (ALC298,节点99)

# 界面 (参考:http://patorjk.com/software/taag/#p=display&f=Ivrit&t=P%20l%20u%20g%20F%20i%20x)
function interface() {
    echo ' ____    _                   _____   _         '
    echo '|  _ \  | |  _   _    __ _  |  ___| (_) __  __ '
    echo '| |_) | | | | | | |  / _` | | |_    | | \ \/ / '
    echo '|  __/  | | | |_| | | (_| | |  _|   | |  >  <  '
    echo '|_|     |_|  \__,_|  \__, | |_|     |_| /_/\_\ '
    echo '                      |___/                    '
    echo '支持小米笔记本电脑Pro(ALC298, 节点99)'
    echo '==============================================='
}

# 选择选项
function choice() {
    echo "(1) 开启 ALCPlugFix"
    echo "(2) 关闭 ALCPlugFix"
    echo "(3) 退出"
    read -p "你想选择哪个选项? (1/2/3):" alc_option
    echo
}

# 如果网络连接失败则退出
function networkWarn(){
    echo "错误: 下载ALCPlugFix失败, 请检查网络连接状态"
    clean
    exit 1
}

# 下载资源来自 https://github.com/daliansky/XiaoMi-Pro/master/ALCPlugFix
function download(){
    mkdir -p one-key-alcplugfix
    cd one-key-alcplugfix
    echo "正在下载声卡修复文件..."
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/ALCPlugFix -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/good.win.ALCPlugFix.plist -O || networkWarn
    curl -fsSL https://raw.githubusercontent.com/daliansky/XiaoMi-Pro-Hackintosh/master/ALCPlugFix/hda-verb -O || networkWarn
    echo "下载完成"
    echo
}

# 拷贝声卡修复文件
function copy() {
    echo "正在拷贝声卡修复文件..."
	if [ ! -d "/usr/local/bin" ]; then
		echo "'/usr/local/bin' 不存在, 新建中..."
		sudo mkdir -p -m 775 /usr/local/bin
		sudo chown $USER:admin /usr/local/bin
	fi
    sudo cp "./ALCPlugFix" /usr/local/bin/
    sudo cp "./hda-verb" /usr/local/bin/
    sudo cp "./good.win.ALCPlugFix.plist" /Library/LaunchDaemons/
    echo "拷贝完成"
    echo
}

# 修复权限
function fixpermission() {
    echo "正在修复权限..."
    sudo chmod 755 /usr/local/bin/ALCPlugFix
    sudo chown $USER:admin /usr/local/bin/ALCPlugFix
    sudo chmod 755 /usr/local/bin/hda-verb
    sudo chown $USER:admin /usr/local/bin/hda-verb
    sudo chmod 644 /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    sudo chown root:wheel /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    echo "修复完成"
    echo
}

# 加载进程
function loadservice() {
    echo "正在加载进程..."
    sudo launchctl load /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    echo "加载完成"
    echo
}

# 清理
function clean() {
    echo "正在清理..."
    sudo rm -rf ../one-key-alcplugfix
    echo "清理完成"
    echo
}

# 卸载
function uninstall() {
    echo "正在卸载..."
    sudo launchctl remove /Library/LaunchAgents/good.win.ALCPlugFix.plist
    sudo launchctl remove /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    sudo rm -rf /Library/LaunchAgents/good.win.ALCPlugFix.plist
    sudo rm -rf /Library/LaunchDaemons/good.win.ALCPlugFix.plist
    sudo rm -rf /usr/bin/ALCPlugFix
    sudo rm -rf /usr/bin/hda-verb
    sudo rm -rf /usr/local/bin/ALCPlugFix
    sudo rm -rf /usr/local/bin/hda-verb
    echo "卸载完成"
    echo 
    if [[ $1 = "cleanup" ]]; then 
    return
    else exit 0 
    fi
}

# 安装程序
function install(){
    download
    uninstall "cleanup"
    copy
    fixpermission
    loadservice
    clean
    echo '棒！安装ALCPlugFix守护进程完成！'
    exit 0
}

# 主程序
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
        echo "错误: 输入有误, 将关闭脚本"
        exit 1
        ;;
    esac
}

main

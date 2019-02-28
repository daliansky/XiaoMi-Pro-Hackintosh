#!/bin/bash
# stevezhengshiqi 创建于2019年2月8日。
# 只支持大部分8代U。
# 此脚本很依赖于 CPUFriend(https://github.com/acidanthera/CPUFriend), 感谢 Acidanthera 和 PMHeart。

# 界面 (参考: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
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

# 如果网络异常，退出
function networkWarn(){
    echo "错误: 下载CPUFriend失败, 请检查网络状态"
    exit 0
}

# 下载CPUFriend仓库并解压最新release
function download(){
    mkdir -p Desktop/tmp/one-key-cpufriend
    cd Desktop/tmp/one-key-cpufriend
    echo "--------------------------------------------------------------------"
    echo "|* 正在下载CPUFriend，源自github.com/acidanthera/CPUFriend @PMHeart *|"
    echo "--------------------------------------------------------------------"
    curl -fsSL https://raw.githubusercontent.com/acidanthera/CPUFriend/master/ResourceConverter/ResourceConverter.sh -o ./ResourceConverter.sh || networkWarn
    sudo chmod +x ./ResourceConverter.sh
    curl -fsSL https://github.com/acidanthera/CPUFriend/releases/download/1.1.6/1.1.6.RELEASE.zip -o ./1.1.6.RELEASE.zip && unzip 1.1.6.RELEASE.zip && cp -r CPUFriend.kext ../../ || networkWarn
}

# 检查board-id, 系统版本>=10.13.6(17G2112)才支持Mac-827FB448E656EC26.plist(MBP15,2)
function checkboardid(){
    if [ -f "/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-827FB448E656EC26.plist" ]; then
        boardid=Mac-827FB448E656EC26
    else
        boardid=Mac-B4831CEBD52A0C4C
    fi
}

# 复制目标plist
function copyplist(){
    sudo cp -r /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/$boardid.plist ./
}

# 修改LFM值来调整最低频率
# 重新考虑这个方法是否必要, 因为LFM看起来不会影响性能表现
function changelfm(){
    echo "----------------------------"
    echo "|****** 选择低频率模式 ******|"
    echo "----------------------------"
    echo "(1) 保持不变 (1200/1300mhz)"
    echo "(2) 800mhz (低负载下频率更低)"
    read -p "你想选择哪个选项? (1/2):" lfm_selection
    case $lfm_selection in
        1)
        # 保持不变
        ;;

        2)
        # 把 1200/1300 改成 800
        sudo /usr/bin/sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" $boardid.plist
        ;;

        *)
        echo "错误: 输入有误, 脚本将退出"
        exit 0
        ;;
    esac
}

# 修改EPP值来调节性能模式 (参考: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
function changeepp(){
    echo "--------------------------"
    echo "|****** 选择性能模式 ******|"
    echo "--------------------------"
    echo "(1) 最省电模式"
    echo "(2) 平衡电量模式 (默认)"
    echo "(3) 平衡性能模式"
    echo "(4) 高性能模式"
    read -p "你想选择哪个模式? (1/2/3/4):" epp_selection
    case $epp_selection in
        1)
        # 把 80/90 改成 C0, 最省电模式
        sudo /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        ;;

        2)
        # 保持默认值 80/90, 平衡电量模式
        ;;

        3)
        # 把 80/90 改成 40, 平衡性能模式
        sudo /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        ;;

        4)
        # 把 80/90 改成 00, 高性能模式
        sudo /usr/bin/sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        sudo /usr/bin/sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" $boardid.plist
        ;;

        *)
        echo "错误: 输入有误, 脚本将退出"
        exit 0
        ;;
    esac
}

# 生成 CPUFriendDataProvider.kext 并复制到桌面
function generatekext(){
    echo "正在生成CPUFriendDataProvider.kext"
    sudo ./ResourceConverter.sh --kext $boardid.plist
    cp -r CPUFriendDataProvider.kext ../../
}

# 删除tmp文件夹并结束
function clean(){
    sudo rm -rf ../../tmp

    echo "很棒！脚本运行结束, 请把桌面上的CPUFriend和CPUFriendDataProvider放入/CLOVER/kexts/Other/下"
    exit 0
}

# 主程序
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

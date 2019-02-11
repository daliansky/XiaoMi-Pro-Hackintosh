#!/bin/bash
# stevezhengshiqi 创建于2019年2月8日。
# 暂时只支持8代U, 此脚本会强制系统使用 MacBookPro15,2(Mac-827FB448E656EC26.plist)的 X86PlatformPlugin 配置。
# 如果macOS版本低于 10.13.6(17G2112), 此脚本会使用 MacBookPro14,1(Mac-B4831CEBD52A0C4C.plist)的配置。
# 此脚本很依赖于 CPUFriend(https://github.com/acidanthera/CPUFriend), 感谢 Acidanthera。

# 界面 (源自: http://patorjk.com/software/taag/#p=display&f=Ivrit&t=C%20P%20U%20F%20R%20I%20E%20N%20D)
printf '\e[8;40;110t'
echo "  ____   ____    _   _   _____   ____    ___   _____   _   _   ____ "
echo " / ___| |  _ \  | | | | |  ___| |  _ \  |_ _| | ____| | \ | | |  _ \ "
echo "| |     | |_) | | | | | | |_    | |_) |  | |  |  _|   |  \| | | | | | "
echo "| |___  |  __/  | |_| | |  _|   |  _ <   | |  | |___  | |\  | | |_| | "
echo " \____| |_|      \___/  |_|     |_| \_\ |___| |_____| |_| \_| |____/ "
echo "===================================================================== "

# 下载 CPUFriend 仓库
mkdir -p Desktop/tmp/one-key-cpufriend
cd Desktop/tmp/one-key-cpufriend
echo '|* 正在下载 CPUFriend，来自 github.com/acidanthera/CPUFriend @PMHeart *|'
echo '----------------------------------------------------------------------'
# 如果下载失败，退出程序
curl -fsSL https://github.com/acidanthera/CPUFriend/archive/master.zip -o ./CPUFriend.zip && unzip CPUFriend.zip || exit 0

echo ' '

# 检查 MacBookPro15,2 PM plist 是否存在 (>=10.13.6(17G2112))
if [ -f "/System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-827FB448E656EC26.plist" ];then

    # 复制 MacBookPro15,2 PM plist 到 tmp 文件夹
    sudo cp -r /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-827FB448E656EC26.plist ./

    # 降低最低频率到800mhz
    echo -e "\033[1m|* 降低最低频率可以让CPU在低负载的时候更省电 *|\033[0m"
    read -p "你想要把最低频率从 1300mhz 降低到 800mhz吗? (y/n):" lfm_selection
    case $lfm_selection in
        y)
        sudo sed -i "" "s:AgAAAAwAAAA:AgAAAAgAAAA:g" Mac-827FB448E656EC26.plist
        ;;

        n)
        ;;

        *)
        echo "ERROR: 输入有误, 脚本将退出"
        exit 0
        ;;
    esac

    echo ' '

    # 选择 EPP 值来调节性能 (参考: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
    echo '---------------------------'
    echo '|**** 选择 CPU 性能模式 ****|'
    echo '---------------------------'
    echo '(1) 最省电模式'
    echo '(2) 平衡电量模式 (默认)'
    echo '(3) 平衡性能模式'
    echo '(4) 高性能模式'
    read -p "你想选择哪个模式? (1/2/3/4):" epp_selection
    case $epp_selection in
        1)
        # 把 90 改成 C0, 最省电模式
        sudo sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" Mac-827FB448E656EC26.plist
        ;;

        2)
        # 保持默认值 90, 平衡电量模式
        ;;

        3)
        # 把 90 改成 40, 平衡性能模式
        sudo sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" Mac-827FB448E656EC26.plist
        ;;

        4)
        # 把 90 改成 00, 高性能模式
        sudo sed -i "" "s:CQAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" Mac-827FB448E656EC26.plist
        ;;

        *)
        echo "ERROR: 输入有误, 脚本将退出"
        exit 0
        ;;
    esac

    # 生成 CPUFriendDataProvider.kext 并复制到桌面
    CPUFriend-master/ResourceConverter/ResourceConverter.sh --kext Mac-827FB448E656EC26.plist
    cp -r CPUFriendDataProvider.kext ../../

else

    # 复制 MacBookPro14,1's PM plist 到 tmp 文件夹
    sudo cp -r /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-B4831CEBD52A0C4C.plist ./

    # 降低最低频率到800mhz
    echo -e "\033[1m|* 降低最低频率可以让CPU在低负载的时候更省电 *|\033[0m"
    read -p "你想要把最低频率从 1300mhz 降低到 800mhz吗? (y/n):" lfm_selection
    case $lfm_selection in
        y)
        sudo sed -i "" "s:AgAAAA0AAAA:AgAAAAgAAAA:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        n)
        ;;

        *)
        echo "ERROR: 输入有误, 脚本将退出"
        exit 0
        ;;
    esac

    echo ' '

    # 选择 EPP 值来调节性能 (参考: https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/page-7)
    echo '---------------------------'
    echo '|**** 选择 CPU 性能模式 ****|'
    echo '---------------------------'
    echo '(1) 最省电模式'
    echo '(2) 平衡电量模式 (默认)'
    echo '(3) 平衡性能模式'
    echo '(4) 高性能模式'
    read -p "你想选择哪个模式? (1/2/3/4):" epp_selection
    case $epp_selection in
        1)
        # 把 80 改成 C0, 最省电模式
        sudo sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:DAAAAAAAAAAAAAAAAAAAAAc:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        2)
        # 保持默认值 80, 平衡电量模式
        ;;

        3)
        # 把 80 改成 40, 平衡性能模式
        sudo sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:BAAAAAAAAAAAAAAAAAAAAAc:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        4)
        # 把 80 改成 00, 高性能模式
        sudo sed -i "" "s:CAAAAAAAAAAAAAAAAAAAAAc:AAAAAAAAAAAAAAAAAAAAAAc:g" Mac-B4831CEBD52A0C4C.plist
        ;;

        *)
        echo "ERROR: 输入有误, 脚本将退出"
        exit 0
        ;;
    esac

    # 生成 CPUFriendDataProvider.kext 并复制到桌面
    CPUFriend-master/ResourceConverter/ResourceConverter.sh --kext Mac-B4831CEBD52A0C4C.plist
    cp -r CPUFriendDataProvider.kext ../../
fi

echo ' '

# 下载, 解压, 并复制最新release版CPUFriend到桌面
echo '|**** 正在下载最新release版CPUFriend, credit @PMHeart ****|'
curl -fsSL https://github.com/acidanthera/CPUFriend/releases/download/1.1.6/1.1.6.RELEASE.zip -o ./1.1.6.RELEASE.zip && unzip 1.1.6.RELEASE.zip && cp -r CPUFriend.kext ../../ || echo "ERROR: 下载release版CPUFriend失败, 请手动前往https://github.com/acidanthera/CPUFriend/releases/download/1.1.6/1.1.6.RELEASE.zip下载。"

echo ' '

# 删除 tmp 文件夹
sudo rm -rf ../../tmp

echo -e "\033[1m很好！脚本运行结束, 请把桌面上的 CPUFriend 和 CPUFriendDataProvider 放入 /CLOVER/kexts/Other/下\033[0m"
exit 0

#!/usr/bin/env bash
# Filename: ss-server.sh 
# Description: manage shadowsocks server
# Author: xhcoding <xhcoding@163.com>
# Copyright (C) 2018, xhcoding, all right reserved
# Created: 2018-11-26 21:00
# Version: 0.1
# Last-Update: 2018-11-26 21:00 by xhcoding
#
# Change log:
# 2018-11-26
#       * first commit 
#

# 定义文本显示颜色控制序列
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
WHITE="\e[97m"

# 操作系统信息
DISTRO="unknow"
PM=

# 配置文件位置
CONFIG_FILE="shadowsocks.json"

function log_success {
    printf "\r\033[2K   \033[00;32m [OK ] $1\n"
}

function log_fail {
    printf "\r\033[2K  \033[0;31m[ FAIL ] $1\n"
}

function prompt {
    printf "$1"
}

function msg {
    echo -e "\e[0m-----------------------------------------------"
    printf "${BLUE}$1\n"
    echo -e "\e[0m-----------------------------------------------"
}


function show_menu {
    prompt "\t${GREEN}shadowsocks 服务端管理（$DISTRO）\n\n"
    prompt "\t${YELLOW}1.${WHITE} 安装shadowsocks\n"
    prompt "\t${YELLOW}2.${WHITE} 配置shadowsocks\n"
    prompt "\n"
    prompt "\t${YELLOW}3.${WHITE} 启动shadowsocks\n"
    prompt "\t${YELLOW}4.${WHITE} 关闭shadowsocks\n"
    prompt "\t${YELLOW}5.${WHITE} 重启shadowsocks\n"
    prompt "\t${YELLOW}6.${WHITE} 查看日志\n"
    prompt "\t${YELLOW}7.${WHITE} 退出\n"
}

# $1: 包管理工具
# $2: 包名
function install_package {
    case $1 in
        pacman) 
            pacman -Q $2 >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                msg "$2 已经安装"
            else
                pacman -Sy $2
                if [$? -eq 0];then
                    msg "$2 成功安装"
                else
                    msg "${RED}$2 安装失败"
                fi
            fi;;
        yum) yum install $2;;
        apt) apt install $2;;
        pip) 
            if pip list | grep "$2"; then
                msg "$2 已经安装"
            else
                pip install $2
            fi;;
        pip3) 
            if pip3 list | grep "$2"; then
                msg "$2 已经安装"
            else
                pip3 install $2
            fi
    esac
}

# $1: 包管理工具
# $2: 包名
function uninstall_package {
    case $1 in
        pacman) pacman -Rsc $2 ;;
        yum) yum remove $2;;
        apt) apt remove $2
    esac
    if [ $? -eq 0 ] ; then 
        log_success "成功卸载 $2" 
    else 
        log_fail "卸载$2失败"
    fi
    return $?   
}


function install_shadowsocks {
    type ssserver >/dev/null  2>&1
    if [ $? -ne 0 ];then
        case $DISTRO in
            CentOS) 
                if grep -Eqi "7\." /etc/*-release; then
                    install_package $PM "git"
                    install_package $PM "libsodium"
                    install_package $PM "python34-pip"
                    install_package "pip3" "git+https://github.com/shadowsocks/shadowsocks.git@master"
                else
                    install_package $PM "git"
                    install_package $PM "python-setuptools"
                    easy_install pip
                    install_package "pip" "git+https://github.com/shadowsocks/shadowsocks.git@master"
                fi ;;
            Debian|Ubuntu )
                install_package $PM "git"
                install_package $PM python-pip
                install_package "pip" "git+https://github.com/shadowsocks/shadowsocks.git@master";;
            Arch)
                install_package $PM "git"
                install_package $PM "python-pip"
                install_package "pip" "git+https://github.com/shadowsocks/shadowsocks.git@master";;
        esac
    fi
    msg "相关软件安装完成"
    config_shadowsocks
    config_firewall
    return 0
}

# $1: 端口
function config_firewall {
    msg "开始配置防火墙规则"
    case $DISTRO in
        CentOS) 
            if grep -Eqi "7\." /etc/*-release; then
                firewall-cmd --zone=public --add-port=${1}/tcp --permanent >/dev/null 2>&1
                firewall-cmd --zone=public --add-port=${1}/udp --permanent >/dev/null 2>&1
                firewall-cmd --reload >/dev/null 2>&1
            else
                /sbin/iptables -I INPUT -p tcp --dport ${1} -j ACCEPT >/dev/null 2>&1
                /sbin/iptables -I INPUT -p udp --dport ${1} -j ACCEPT >/dev/null 2>&1
                /etc/rc.d/init.d/iptables save >/dev/null 2>&1
            fi ;;
    esac
    msg "防火墙配置完成"
}

function config_shadowsocks {
    msg "\t开始配置shadowsocks"
    prompt "${YELLOW}请输入shadowsocks端口号，默认为5666:"
    read server_port

    server_port=${server_port:-5666}

    msg "端口：${server_port}"
    prompt "${YELLOW}请输入shadowsocks 密码， 默认自动生成10密码："
    read password
    password=${password:-$(head -c 100 /dev/urandom | tr -dc a-z0-9A-Z |head -c 10)}
    msg "密码：${password}"
    
    declare -a methods
    methods[1]="aes-128-cfb"
    methods[2]="aes-128-ctr"
    methods[3]="aes-128-gcm"
    methods[4]="aes-192-cfb"
    methods[5]="aes-192-ctr"
    methods[6]="aes-192-gcm"
    methods[7]="aes-256-cfb"
    methods[8]="aes-256-ctr"
    methods[9]="aes-256-gcm"
    methods[10]="bf-cfb"
    methods[11]="camellia-128-cfb"
    methods[12]="camellia-192-cfb"
    methods[13]="camellia-256-cfb"
    methods[14]="cast5-cfb"
    methods[15]="chacha20"
    methods[16]="chacha20-ietf"
    methods[17]="chacha20-ietf-poly1305"
    methods[18]="des-cfb"
    methods[19]="idea-cfb"
    methods[20]="rc4-md5"
    methods[21]="salsa20"
    methods[22]="seed-cfb"
    methods[23]="seprent-256-cfb"
    
    prompt "${YELLOW}加密方式：\n"
    for i in $(seq 1 23); do
        prompt "\t${YELLOW}${i}. ${WHITE}${methods[i]}\n"
    done
    prompt "\n${RED}注意：chacha20-*/salsa20需要安装libsodium\n\n"
    prompt "${YELLOW}请选择加密方式，默认为 20. rc4-md5："
    read method_index
    method_index=${method_index:-20}
    msg "加密方式：${methods[method_index]}"
    if [ $method_index -eq 15 ] || [ $method_index -eq 16 ] || [ $method_index -eq 17 ] || [ $method_index -eq 21 ];then
        msg "开始安装libsodium..."
        install_package $PM libsodium
    fi

    printf "{\n" > $CONFIG_FILE
    printf "\t\"server\": \"0.0.0.0\",\n" >> $CONFIG_FILE
    printf "\t\"server_port\":${server_port},\n" >> $CONFIG_FILE
    printf "\t\"local_address\": \"127.0.0.1\",\n" >> $CONFIG_FILE
    printf "\t\"local_port\": 1080,\n" >> $CONFIG_FILE
    printf "\t\"password\": \"${password}\",\n" >> $CONFIG_FILE
    printf "\t\"timeout\": 300,\n" >> $CONFIG_FILE
    printf "\t\"method\": \"${methods[method_index]}\",\n" >> $CONFIG_FILE
    printf "\t\"fast_open\": false\n" >> $CONFIG_FILE
    printf "}\n" >> $CONFIG_FILE
    
    msg "配置成功，配置文件位置: $(cd $(dirname $CONFIG_FILE); pwd)/$(basename $CONFIG_FILE)"
}

function start_shadowsocks {
    ssserver -c  $(cd $(dirname $CONFIG_FILE); pwd)/$(basename $CONFIG_FILE) -d start >/dev/null 2>&1
    ps -ef | grep "shadowsocks.json " | grep -v "grep" >/dev/null  2>&1
    if [ $? -eq 0 ]; then
        msg "shadowsocks 启动成功"
    else
        msg "shadowsocks 启动失败，请查看日志。"
    fi
}

function stop_shadowsocks {
    ssserver -c $(cd $(dirname $CONFIG_FILE); pwd)/$(basename $CONFIG_FILE) -d stop >/dev/null 2>&1
    msg "shadowsocks 成功关闭"
}

function reboot_shadowsocks {
    ssserver -c  $(cd $(dirname $CONFIG_FILE); pwd)/$(basename $CONFIG_FILE) -d reboot >/dev/null 2>&1
    ps -ef | grep "shadowsocks.json " | grep -v "grep" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        msg "shadowsocks 重启成功"
    else
        msg "shadowsocks 重新启动失败，请查看日志。"
    fi   
}

function log_shadowsocks {
    less /var/log/shadowsocks.log 
}

function get_dist_name {
    if grep -Eqi "CentOS" /etc/issue 2>/dev/null || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue 2>/dev/null || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue 2>/dev/null || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue 2>/dev/null || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue 2>/dev/null || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue 2>/dev/null || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue 2>/dev/null || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Arch" /etc/issue 2>/dev/null || grep -Eq "Arch" /etc/*-release; then
        DISTRO='Arch'
        PM='pacman'
    else
        DISTRO='unknow'
    fi
}

function check_root {
    if [ $UID -ne 0 ]; then
        prompt "${RED}运行此脚本需要 root 权限。\n即： sudo $0\n"
        exit 1
    fi
}


check_root

get_dist_name

# uninstall_package $PM neofetch
# install_package $PM neofetch

while :
do

    show_menu
    read -p "输入数字 [1 - 7]：" input
    case $input in
        1) install_shadowsocks ;;
        2) config_shadowsocks ;;
        3) start_shadowsocks ;;
        4) stop_shadowsocks ;;
        5) reboot_shadowsocks;;
        6) log_shadowsocks;;
        7) prompt "${GREEN}退出成功 \n" ; exit 0 ;;
        *) prompt "${RED}无效的输入！\n"
    esac
done

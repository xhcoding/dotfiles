#!/usr/bin/env bash
# Filename: bootstrap.sh 
# Description: bootstrap install things
# Author: xhcoding <xhcoding@163.com>
# Copyright (C) 2018, xhcoding, all right reserved
# Created: 2018-11-24 21:00
# Version: 0.1
# Last-Update: 2018-11-25 21:00 by xhcoding # # Change log:
# 2018-11-24
#       * first commit 
#

# 进入配置文件根目录
cd "$(dirname "$0")"
# 配置文件根目录
DOTFILES_ROOT=$(pwd -P)

# 开启失败即退出
set -e

# 几个信息显示函数
function info {
    printf "\r  [ \033[00;34mINFO\033[0m ] $1\n"
}

function user {
    printf "\r  [ \033[0;33mUSER\033[0m ] $1"
}

function success {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function fail {
    printf "\r\033[2K  [ \033[0;31mFAIL\033[0m ] $1\n"
    echo ''
    exit
}

# 链接文件
# $1: 源文件
# $2: 目标文件
# $3: 目标文件存在时的操作
#   s: skip all
#   o: overwrite
#   b: backup
#   a/empty: ask
function link_file {
    local src=$1 dst=$2 action=$3
    local overwrite= backup= skip=
    local res=
    
    if [ -f "$dst" -o -d "$dst" -o -L "dst" ] ; then
        if [ "$action" == "s" ] ; then
            skip=true
        elif [ "$action" == "o" ]; then
            overwrite=true
        elif [ "$action" == "b" ]; then
            backup=true
        else
            user "\nFile already exists: \033[31m $dst \033[0m , what do you want to do?\n[s]kip (default),\n[o]verwrite,\n[b]ackup,\nYour choose: "
            read -n 1 action
            
            case "$action" in
                o )
                    overwrite=true;;
                b ) 
                    backup=true;;
                s )
                    skip=true;;
                * )
                    skip=true;;
            esac
            
        fi
        
    fi

    
    if [ "$overwrite" == "true" ] ; then
        rm -rf "$dst"
        success "remove $dst"
    fi
    
    if [ "$backup" == "true" ] ; then
        mv "$dst" "${dst}.backup"
        success "moved $dst to ${dst}.backup"
    fi
    
    if [ "$skip" == "true" ] ; then
        success "skipped $src"
    fi
    if [ "$skip" != "true" ] ; then
        ln -s "$1" "$2"
        success "linked $1 to $2"
    fi
}


# 复制文件
# $1: 源文件
# $2: 目标文件
# $3: 目标文件存在时的操作
#   s: skip all
#   o: overwrite
#   b: backup
#   a/empty: ask
function copy_file {
    local src=$1 dst=$2 action=$3
    local overwrite= backup= skip=
    local res=
    
    if [ -f "$dst" -o -d "$dst" -o -L "dst" ] ; then
        if [ "$action" == "s" ] ; then
            skip=true
        elif [ "$action" == "o" ]; then
            overwrite=true
        elif [ "$action" == "b" ]; then
            backup=true
        else
            user "\nFile already exists: \033[31m $dst \033[0m  , what do you want to do?\n[s]kip (default),\n[o]verwrite,\n[b]ackup,\nYour choose: "
            read -n 1 action
            
            case "$action" in
                o )
                    overwrite=true;;
                b ) 
                    backup=true;;
                s )
                    skip=true;;
                * )
                    skip=true;;
            esac
            
        fi
        
    fi

    
    if [ "$overwrite" == "true" ] ; then
        rm -rf "$dst"
        success "remove $dst"
    fi
    
    if [ "$backup" == "true" ] ; then
        if [ -d "${dst}.backup" -o -f "${dst}.backup" -o -L "${dst}.backup" ] ; then
            rm -rf "${dst}.backup"
            success "rm old backup"
        fi
        mv "$dst" "${dst}.backup"
        success "moved $dst to ${dst}.backup"
    fi
    
    if [ "$skip" == "true" ] ; then
        success "skipped $src"
    fi
    
    if [ "$skip" != "true" ] ; then
        cp -R "$1" "$2"
        success "copyed $1 to $2"
    fi
}

function install_config {
    local dotconfig_dir="$DOTFILES_ROOT/.config"
    local homeconfig_dir="$DOTFILES_ROOT/home"

    info "config install started"
    
    # $HOME/.config
    if [ -d "$dotconfig_dir" ] ; then
        
        for filename in $(ls -A $dotconfig_dir); do
            copy_file "$dotconfig_dir/$filename" "$HOME/.config/$filename" $1
            success "installed $filename"
        done
    fi
    
    # $HOME

    for filename in $(ls -A $homeconfig_dir); do
        copy_file "$homeconfig_dir/$filename" "$HOME/$filename" $1
        success "installed $filename"
    done
    info "config install finished"
}


function install_etc {
    local etcconfig_dir="$DOTFILES_ROOT/etc"
    for filename in $(ls -A $etcconfig_dir); do
        copy_file "$etcconfig_dir/$filename" "/etc/$filename" $1
    done
}


function install_emacs {
    # emacs
    if [ -d "$HOME/.emacs.d" ] ; then
        copy_file "$HOME/.emacs.d" "$HOME/.emacs.d.backup" o
        rm -rf "$HOME/.emacs.d/"
    fi
    git clone -b develop https://github.com/hlissner/.emacs.d ~/.emacs.d
    if [ -d "$HOME/.config/doom" ] ; then
        copy_file "$HOME/.config/doom" "$HOME/.config/doom.backup" o
        rm -rf "$HOME/.config/doom/"
    fi
    git clone https://github.com/xhcoding/doom-private.git ~/.config/doom
    cd ~/.emacs.d
    make all
    success "emacs config installed"
}

function install_package {
    local package_list_file="$DOTFILES_ROOT/arch-package.list"
    local pacman_command="pacman -S --needed --noconfirm "
    set +e
    pacman -Syu --needed --noconfirm
    for package in $(cat $package_list_file) ; do
        $pacman_command $package
    done
    set -e
}

function display_usage {
    echo "./bootstrap.sh -f function [args]"
    echo "functions:  "
    echo "1. install_config: install personal config."
    echo "2. install_etc(root): install system etc config."
    echo "3. install_emacs: install emacs config."
    echo "4. install_package(root): install package in arch-package.list ."
}

function install_grub {
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch
    grub-mkconfig -o /boot/grub/grub.cfg
}

if [ "$1" == "-h" -o "$1" == "--help" ] ; then
    display_usage
elif [ "$1" == "-f" -o "$1" == "--function" ]; then
    $2 $3 
fi

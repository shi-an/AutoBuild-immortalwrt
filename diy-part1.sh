#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 导入配置函数
source ../config_functions.sh

echo "=== 开始 DIY 第一部分配置 ==="

# 加载自定义 feeds 配置
echo "=== 加载自定义 feeds 配置 ==="
if [ -f "../custom_feeds.txt" ]; then
    while IFS= read -r line; do
        # 跳过注释行和空行
        if [[ $line =~ ^# ]] || [[ -z $line ]]; then
            continue
        fi
        
        # 解析行：feed名称 仓库地址 分支
        read -r feed_name repo_url branch <<< "$line"
        
        if [ -n "$feed_name" ] && [ -n "$repo_url" ]; then
            # 如果分支未指定，使用 master
            if [ -z "$branch" ]; then
                branch="master"
            fi
            
            safe_add_feed "$feed_name" "$repo_url" "$branch"
        fi
    done < "../custom_feeds.txt"
    echo "自定义 feeds 配置加载完成"
else
    echo "未找到自定义 feeds 配置文件: custom_feeds.txt"
fi

# 加载系统配置
echo "=== 加载系统配置 ==="
if [ -f "../system_config.txt" ]; then
    while IFS= read -r line; do
        # 跳过注释行和空行
        if [[ $line =~ ^# ]] || [[ -z $line ]]; then
            continue
        fi
        
        # 解析配置行
        read -r config_type config_value1 config_value2 <<< "$line"
        
        case $config_type in
            "hostname")
                echo "设置主机名: $config_value1"
                sed -i "s/ImmortalWrt/$config_value1/g" package/base-files/files/bin/config_generate
                ;;
            "timezone")
                echo "设置时区: $config_value1"
                sed -i "s|UTC|$config_value1|g" package/base-files/files/bin/config_generate
                ;;
            "theme")
                echo "设置默认主题: $config_value1"
                sed -i "s/luci-theme-bootstrap/$config_value1/g" feeds/luci/collections/luci/Makefile
                ;;
            # 可以继续添加更多配置类型
        esac
    done < "../system_config.txt"
    echo "系统配置加载完成"
else
    echo "未找到系统配置文件: system_config.txt"
fi

echo "=== DIY 第一部分配置完成 ==="

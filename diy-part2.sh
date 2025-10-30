#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 导入配置函数
source ../config_functions.sh

echo "=== 开始 DIY 第二部分配置 ==="

# 自动克隆自定义软件包
echo "=== 自动克隆自定义软件包 ==="
if [ -f "../custom_packages.txt" ]; then
    # 创建 package 目录（如果不存在）
    mkdir -p package
    
    while IFS= read -r line; do
        # 跳过注释行和空行
        if [[ $line =~ ^# ]] || [[ -z $line ]]; then
            continue
        fi
        
        # 解析行：软件包名称 仓库地址 分支 目标目录 是否启用
        read -r pkg_name repo_url branch target_dir enable_flag <<< "$line"
        
        if [ -n "$repo_url" ] && [ -n "$target_dir" ]; then
            # 如果分支未指定，使用 master
            if [ -z "$branch" ]; then
                branch="master"
            fi
            
            echo "正在处理: $pkg_name -> $target_dir"
            
            # 克隆软件包
            if git_clone_package "$repo_url" "$branch" "$target_dir"; then
                echo "  ✅ 成功克隆 $pkg_name"
                
                # 如果启用标志为 y，则添加到配置
                if [ "$enable_flag" = "y" ]; then
                    echo "  ✅ 启用软件包: $pkg_name"
                    echo "CONFIG_PACKAGE_$pkg_name=y" >> .config
                fi
            else
                echo "  ❌ 克隆失败: $pkg_name"
            fi
        else
            echo "  ⚠️ 跳过无效行: $line"
        fi
    done < "../custom_packages.txt"
    
    echo "自定义软件包处理完成"
else
    echo "未找到自定义软件包配置文件: custom_packages.txt"
fi

# 执行额外的自定义脚本（如果存在）
if [ -f "../custom_script.sh" ]; then
    echo "=== 执行额外自定义脚本 ==="
    chmod +x "../custom_script.sh"
    "../custom_script.sh"
    echo "额外自定义脚本执行完成"
fi

# 加入OpenClash核心（如果启用了OpenClash）
if grep -q "CONFIG_PACKAGE_luci-app-openclash=y" .config 2>/dev/null; then
    echo "=== 配置 OpenClash 核心 ==="
    if [ -f "../preset-clash-core.sh" ]; then
        chmod -R a+x "../preset-clash-core.sh"  
        "../preset-clash-core.sh"
        echo "OpenClash 核心配置完成"
    else
        echo "未找到 preset-clash-core.sh 脚本"
    fi
fi

# 复制自定义文件
echo "=== 复制自定义文件 ==="
if [ -f "../banner" ]; then
    echo "复制自定义 banner"
    cp -f ../banner package/base-files/files/etc/banner
fi

if [ -f "../99-default-settings" ]; then
    echo "复制默认设置"
    cp -f ../99-default-settings package/emortal/default-settings/files/99-default-settings
fi

echo "=== DIY 第二部分配置完成 ==="
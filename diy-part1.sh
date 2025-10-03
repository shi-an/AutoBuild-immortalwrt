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

# 函数：安全添加 feed 源（如果不存在）
safe_add_feed() {
    local feed_name="$1"
    local feed_url="$2"
    
    # 检查是否已存在相同名称的源
    if ! grep -q "src-git $feed_name " feeds.conf.default; then
        echo "添加 feed 源: $feed_name"
        echo "src-git $feed_name $feed_url" >> feeds.conf.default
    else
        echo "Feed 源 $feed_name 已存在，跳过添加"
    fi
}

# 取消注释现有的 feed 源（如果需要）
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 安全地添加 feed 源
safe_add_feed modem "https://github.com/FUjr/modem_feeds.git;main"
safe_add_feed turboacc "https://github.com/chenmozhijin/turboacc"
safe_add_feed lienol "https://github.com/Lienol/openwrt-package"

# 其他可选的 feed 源（已注释掉）
# safe_add_feed helloworld "https://github.com/fw876/helloworld"
# safe_add_feed passwall "https://github.com/xiaorouji/openwrt-passwall"
# safe_add_feed kiddin9 "https://github.com/kiddin9/openwrt-packages"
# safe_add_feed kenzok8 "https://github.com/kenzok8/openwrt-packages"
# safe_add_feed innmonkey "https://github.com/innmonkey/openwrt-packages"
# safe_add_feed istore "https://github.com/linkease/istore;main"
# safe_add_feed nas "https://github.com/linkease/nas-packages.git;master"
# safe_add_feed nas_luci "https://github.com/linkease/nas-packages-luci.git;main"
# safe_add_feed 5gsupport "https://github.com/Siriling/5G-Modem-Support.git;main"

echo "Feed 源添加完成"

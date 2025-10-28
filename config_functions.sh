#!/bin/bash

# 通用配置函数库

# 函数：安全添加 feed 源（如果不存在）
safe_add_feed() {
    local feed_name="$1"
    local feed_url="$2"
    local branch="$3"
    
    # 如果未指定分支，使用 master
    if [ -z "$branch" ]; then
        branch="master"
    fi
    
    # 完整的 feed URL
    local full_feed_url="$feed_url;$branch"
    
    # 检查是否已存在相同名称的源
    if ! grep -q "src-git $feed_name " feeds.conf.default; then
        echo "添加 feed 源: $feed_name ($branch)"
        echo "src-git $feed_name $full_feed_url" >> feeds.conf.default
    else
        echo "Feed 源 $feed_name 已存在，跳过添加"
    fi
}

# 函数：克隆软件包
git_clone_package() {
    local repo_url="$1"
    local branch="$2"
    local target_dir="$3"
    
    # 如果目标目录已存在，先备份
    if [ -d "package/$target_dir" ]; then
        echo "  目标目录已存在，备份为: package/${target_dir}.backup"
        mv "package/$target_dir" "package/${target_dir}.backup"
    fi
    
    # 克隆软件包
    if git clone --depth=1 -b "$branch" "$repo_url" "package/$target_dir" 2>/dev/null; then
        # 如果克隆成功，删除备份（如果有）
        if [ -d "package/${target_dir}.backup" ]; then
            rm -rf "package/${target_dir}.backup"
        fi
        return 0
    else
        # 如果克隆失败，恢复备份
        if [ -d "package/${target_dir}.backup" ]; then
            mv "package/${target_dir}.backup" "package/$target_dir"
            echo "  已恢复备份"
        fi
        return 1
    fi
}

# 函数：Git稀疏克隆
git_sparse_clone() {
    local branch="$1"
    local repourl="$2" 
    shift 2
    git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
    local repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
    cd $repodir && git sparse-checkout set $@
    mv -f $@ ../package
    cd .. && rm -rf $repodir
}

# 函数：检查并创建目录
ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "创建目录: $dir"
    fi
}

# 函数：验证URL是否可达
validate_url() {
    local url="$1"
    if curl --output /dev/null --silent --head --fail "$url"; then
        return 0
    else
        return 1
    fi
}
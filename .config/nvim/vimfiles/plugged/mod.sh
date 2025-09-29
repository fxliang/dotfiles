#!/bin/bash

# 遍历当前目录下的所有子目录（除了 . 和 ..）
for dir in */; do
    # 去掉结尾的斜杠
    dir="${dir%/}"
    # 检查是否是目录且包含 .git 文件夹
    if [[ -d "$dir/.git" ]]; then
        cd "$dir"
        # 获取当前的 origin URL
        current_url=$(git remote get-url origin 2>/dev/null)
        echo $dir 
        current_branch=$(git rev-parse --abbrev-ref HEAD)
        cd ..
        mv "$dir" "${dir}_backup"
        git clone --depth=1 "$current_url" "$dir" -b "$current_branch"
        rm -rf "${dir}_backup"
    else
        echo "跳过: $dir (不是Git仓库)"
    fi
done


#!/bin/bash

# 遍历当前目录下的所有子目录（除了 . 和 ..）
for dir in */; do
    # 去掉结尾的斜杠
    dir="${dir%/}"
    # 检查是否是目录且包含 .git 文件夹
    if [[ -d "$dir/.git" ]]; then
        echo "处理: $dir"
        # 进入目录
        cd "$dir"
        # 获取当前的 origin URL
        current_url=$(git remote get-url origin 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            echo "  当前URL: $current_url"
            
            # 检查是否是 https://github.com 开头的URL
            if [[ "$current_url" == https://github.com/* ]]; then
                # 提取用户名和仓库名
                user_repo=$(echo "$current_url" | sed 's|https://github.com/||' | sed 's|\.git$||')
                # 构建新的 SSH URL
                new_url="git@github.com:${user_repo}.git"
                # 修改远程 URL
                git remote set-url origin "$new_url"
                echo "  已更新为: $new_url"
            else
                echo "  非HTTPS GitHub URL，跳过"
            fi
        else
            echo "  无法获取origin URL或不存在"
        fi
        git rebase --root --onto HEAD
        git gc
        git prune
        git repack -d
        
        echo "----------------------------------------"
        cd ..
    else
        echo "跳过: $dir (不是Git仓库)"
    fi
done

echo "所有仓库处理完成！"

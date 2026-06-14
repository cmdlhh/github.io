#!/bin/bash

# 确保脚本在出错时立即退出
set -eu

BRANCH="gh-pages"
LOCAL_PUBLIC_DIR="$(pwd)/public"
DEFAULT_REPO_URL="git@github.com:cmdlhh/cmdlhh.github.io.git"
ORIGINAL_DIR=$(pwd)

# 优先从当前仓库读取远程地址，否则使用默认值
REPO_URL=$(git remote get-url origin 2>/dev/null || echo "$DEFAULT_REPO_URL")

echo "使用仓库地址: $REPO_URL"

# 清理旧的构建输出，避免残留文件
echo "正在清理旧的构建输出..."
rm -rf "$LOCAL_PUBLIC_DIR"

# 构建网站
echo "正在构建网站..."
hugo --gc

# 检查是否有 public 目录
if [ ! -d "$LOCAL_PUBLIC_DIR" ]; then
    echo "错误：$LOCAL_PUBLIC_DIR 目录不存在，请检查 Hugo 构建是否成功"
    exit 1
fi

# 创建临时目录
echo "正在准备部署..."
temp_dir=$(mktemp -d)
cd "$temp_dir"

# 初始化一个新的git仓库
echo "正在初始化临时Git仓库..."
git init
# 添加远程仓库
git remote add origin "$REPO_URL"

# 确保切换到gh-pages分支
echo "正在切换到 $BRANCH 分支..."
if git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
    git fetch origin "$BRANCH"
    git checkout -b "$BRANCH" origin/"$BRANCH" || {
        echo "警告：无法切换到现有分支，创建新分支"
        git checkout -b "$BRANCH"
    }
else
    git checkout --orphan "$BRANCH"
    git rm -rf --cached . 2>/dev/null || true
fi

# 清空临时目录中的所有内容（除了.git目录）
echo "正在清理临时目录..."
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# 复制构建目录中的所有文件到临时目录（包括隐藏文件）
echo "正在复制网站文件..."
cp -a "$LOCAL_PUBLIC_DIR"/. .

# 添加所有更改
git add .

# 提交更改
git commit -m "更新博客内容 $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到 GitHub Pages，使用强制推送确保覆盖远程内容
echo "正在推送到 GitHub Pages $BRANCH 分支..."
git push -f origin "$BRANCH"

# 清理临时目录
cd "$ORIGINAL_DIR"
rm -rf "$temp_dir"

# 从REPO_URL提取用户名和仓库名
repo_path=$(echo "$REPO_URL" | sed 's|.*github.com[/:]||; s|\.git$||')
git_username="${repo_path%%/*}"
repo_name="${repo_path##*/}"

# 判断是否为GitHub Pages用户站点（仓库名以.github.io结尾）
if [[ "$repo_name" == *.github.io ]]; then
    echo "部署成功！博客已更新到 https://$git_username.github.io/"
else
    echo "部署成功！博客已更新到 https://$git_username.github.io/$repo_name/"
fi

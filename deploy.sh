#!/bin/bash

# 确保脚本在出错时立即退出
set -e

# 配置项
REPO_URL="git@github.com:cmdlhh/cmdlhh.github.io.git"
BRANCH="gh-pages"
# 使用相对路径替代绝对路径，以隐藏用户目录信息
LOCAL_PUBLIC_DIR="$(pwd)/public"

# 清理并构建网站
echo "正在构建网站..."
hugo

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
if git ls-remote --exit-code --heads origin $BRANCH >/dev/null 2>&1; then
    # 如果远程分支存在，获取它的最新状态
    git fetch origin $BRANCH
    git checkout -b $BRANCH origin/$BRANCH || {
        echo "警告：无法切换到现有分支，创建新分支"
        git checkout -b $BRANCH
    }
else
    # 如果远程分支不存在，创建一个新的空分支
    git checkout --orphan $BRANCH
    # 删除所有文件以创建真正的空分支
    git rm -rf --cached .
fi

# 清空临时目录中的所有内容（除了.git目录）
echo "正在清理临时目录..."
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# 复制构建目录中的所有文件到临时目录
echo "正在复制网站文件..."
cp -r "$LOCAL_PUBLIC_DIR"/* .

# 添加所有更改
git add .

# 提交更改
git commit -m "更新博客内容 $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到 GitHub Pages，使用强制推送确保覆盖远程内容
echo "正在推送到 GitHub Pages $BRANCH 分支..."
git push -f origin $BRANCH

# 清理临时目录
cd -
rm -rf "$temp_dir"

# 从REPO_URL提取用户名和仓库名以生成博客URL
git_username=$(echo "$REPO_URL" | sed -n 's/.*github.com[\/:]\([^/]*\)\/\([^.]*\).*/\1/p')
repo_name=$(echo "$REPO_URL" | sed -n 's/.*github.com[\/:]\([^/]*\)\/\([^.]*\).*/\2/p')
echo "部署成功！博客已更新到 https://$git_username.github.io/$repo_name/"
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

# 检查分支是否存在
if git ls-remote --exit-code --heads origin $BRANCH >/dev/null 2>&1; then
    # 分支存在，克隆它
echo "正在克隆 $BRANCH 分支..."
git clone -b $BRANCH "$REPO_URL" .
else
    # 分支不存在，创建新的空分支
mkdir temp_repo
cd temp_repo
git init
# 创建 README.md 文件作为初始内容
echo "# GitHub Pages Branch" > README.md
# 创建 .gitignore 文件
echo "*" > .gitignore
echo "!.gitignore" >> .gitignore
echo "!README.md" >> .gitignore
git add -f .gitignore README.md
git commit -m "Initial commit for GitHub Pages"
git remote add origin "$REPO_URL"
# 推送新分支到远程
echo "正在创建 $BRANCH 分支..."
git push -u origin main:$BRANCH

# 添加短暂延迟确保分支创建成功
echo "等待分支创建完成..."
sleep 2

cd ..
# 克隆新创建的分支
if ! git clone -b $BRANCH "$REPO_URL" .; then
    echo "错误：克隆 $BRANCH 分支失败，请稍后手动尝试部署"
    exit 1
fi
fi

# 复制构建目录中的所有文件到临时目录
cp -r "$LOCAL_PUBLIC_DIR"/* .

# 添加所有更改
git add .

# 提交更改
git commit -m "更新博客内容 $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到 GitHub Pages
echo "正在推送到 GitHub Pages $BRANCH 分支..."
git push origin $BRANCH

# 清理临时目录
cd -
rm -rf "$temp_dir"

# 从REPO_URL提取用户名和仓库名以生成博客URL
git_username=$(echo "$REPO_URL" | sed -n 's/.*github.com[\/:]\([^/]*\)\/\([^.]*\).*/\1/p')
repo_name=$(echo "$REPO_URL" | sed -n 's/.*github.com[\/:]\([^/]*\)\/\([^.]*\).*/\2/p')
echo "部署成功！博客已更新到 https://$git_username.github.io/$repo_name/"
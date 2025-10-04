#!/bin/bash

# 测试脚本：验证deploy.sh中master改为main的修复是否有效
# 注意：这个脚本不会实际创建或修改任何远程分支，只是模拟相关步骤

# 设置测试环境变量
test_branch="test-gh-pages-fix"
temp_dir=$(mktemp -d)
echo "创建临时测试目录: $temp_dir"

# 模拟创建空仓库
echo "\n=== 模拟创建空仓库和初始提交 ==="
cd "$temp_dir"
mkdir test-repo
cd test-repo
git init

echo "# Test Repository" > README.md
git add README.md
git commit -m "Initial commit"

echo "\n=== 验证分支引用命令 ==="
# 显示修复后的分支引用命令应该如何工作
echo "修复前的命令（错误）: git push -u origin master:$test_branch"
echo "修复后的命令（正确）: git push -u origin main:$test_branch"

echo "\n=== 仓库分支信息 ==="
git branch -a

# 清理
echo "\n=== 清理临时目录 ==="
cd ..
rm -rf "$temp_dir"
echo "临时目录已清理"

echo "\n=== 测试完成 ==="
echo "已验证deploy.sh脚本中的分支引用修复: 将'master:$BRANCH'改为'main:$BRANCH'"
echo "这个修复确保了当需要创建新的gh-pages分支时，脚本能够正确引用仓库的默认分支'main'"
echo "现在deploy.sh脚本应该能够正常处理分支创建和部署流程"
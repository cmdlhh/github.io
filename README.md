# 我的技术博客

这是一个使用 Hugo 搭建的个人技术博客，主题采用 PaperMod。

## 博客简介

这个博客用于分享技术学习笔记、项目经验、实用工具推荐和编程技巧总结。

## 本地开发

### 前提条件

- 安装 Hugo：`brew install hugo`（macOS）或其他平台的安装方法
- Git

### 克隆仓库

```bash
git clone https://github.com/cmdlhh/github.io.git
cd github.io
```

### 更新主题

```bash
git submodule update --init --recursive
```

### 本地预览

```bash
hugo server -D
```

然后在浏览器中访问 `http://localhost:1313/` 查看博客。

### 构建静态网站

```bash
hugo
```

生成的静态文件会存放在 `public` 目录中。

## 项目结构

```
├── archetypes/      # 内容模板
├── assets/          # 资源文件
├── content/         # 内容目录
│   ├── about/       # 关于页面
│   └── posts/       # 博客文章
├── layouts/         # 自定义布局
├── public/          # 生成的静态文件
├── static/          # 静态资源
├── themes/          # 主题目录
│   └── PaperMod/    # PaperMod 主题
├── .gitignore       # Git 忽略文件
└── hugo.toml        # Hugo 配置文件
```

## 部署到 GitHub Pages

### 使用部署脚本

项目中包含了一个方便的部署脚本 `deploy.sh`，可以一键完成部署：

```bash
chmod +x deploy.sh  # 如果还没有执行权限
./deploy.sh
```

### 脚本功能说明

这个部署脚本会自动：
1. 构建静态网站
2. 检查 GitHub 上是否有 `gh-pages` 分支
3. 如果没有 `gh-pages` 分支，会自动创建一个新的空分支
4. 将构建后的文件推送到 `gh-pages` 分支

### 首次部署注意事项

首次部署完成后，需要在 GitHub 仓库的设置中配置 GitHub Pages：

1. 登录 GitHub，进入仓库页面
2. 点击 "Settings" 选项卡
3. 在左侧菜单中选择 "Pages"
4. 在 "Source" 部分，选择 "Deploy from a branch"
5. 在 "Branch" 下拉菜单中，选择 `gh-pages` 分支和 `/ (root)` 目录
6. 点击 "Save" 按钮

### 手动部署方法

如果需要手动部署，可以按照以下步骤操作：

1. 构建静态网站：`hugo`
2. 进入 `public` 目录：`cd public`
3. 初始化 Git 仓库：`git init`
4. 添加远程仓库：`git remote add origin https://github.com/cmdlhh/github.io.git`
5. 切换到 gh-pages 分支：`git checkout -b gh-pages` 或 `git checkout gh-pages`
6. 添加所有文件：`git add .`
7. 提交更改：`git commit -m "Deploy website"`
8. 推送到远程：`git push -u origin gh-pages`

## 主题说明

使用的是 PaperMod 主题，这是一个简洁、美观的 Hugo 主题，支持响应式设计，适合用于博客和文档网站。

## 许可证

MIT
# 分支说明

本项目包含两个主要分支，用于不同的用途。

## 1. main 分支

- **用途**：存储网站的源代码和内容
- **包含的文件**：
  - Hugo 配置文件 (`hugo.toml`)
  - 文章内容 (`content/` 目录)
  - 主题文件和自定义模板 (`layouts/` 和 `assets/` 目录)
  - 静态资源 (`static/` 目录)
  - 部署脚本 (`deploy.sh`)
  - 其他开发相关文件

- **工作流程**：
  1. 在 main 分支上编写内容、修改配置或自定义主题
  2. 提交更改到 main 分支
  3. 推送更改到 GitHub 的 main 分支
  4. 运行 `./deploy.sh` 脚本将更改部署到 gh-pages 分支

## 2. gh-pages 分支

- **用途**：存储构建后的静态网站文件，用于 GitHub Pages 部署
- **包含的文件**：
  - 构建后的 HTML、CSS、JavaScript 文件
  - 优化后的图片和其他静态资源
  - 不包含源代码文件

- **工作流程**：
  1. 不要直接修改 gh-pages 分支的内容
  2. 所有更改都应通过 `./deploy.sh` 脚本自动生成和部署
  3. GitHub Pages 会自动从该分支提供网站内容

## 部署流程

1. 在 main 分支上完成所有更改
2. 提交并推送更改到 GitHub 的 main 分支
3. 运行 `./deploy.sh` 脚本：
   - 该脚本会构建网站
   - 将构建后的文件提交到 gh-pages 分支
   - 将 gh-pages 分支推送到 GitHub
4. 等待几分钟，GitHub Pages 会自动更新网站

## 注意事项

- **不要直接修改 gh-pages 分支**：所有更改都应通过 main 分支和部署脚本进行
- **定期备份 main 分支**：main 分支包含所有源代码，应定期备份
- **检查部署状态**：部署完成后，访问 https://cmdlhh.github.io/cmdlhh/ 检查网站是否更新

## 分支切换命令

```bash
# 切换到 main 分支
git checkout main

# 切换到 gh-pages 分支
git checkout gh-pages
```

## 查看分支状态

```bash
# 查看本地分支
git branch

# 查看所有分支（包括远程分支）
git branch -a
```
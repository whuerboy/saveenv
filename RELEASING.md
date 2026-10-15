# 发布指南（项目维护者）

## 1. 上传源码到 GitHub

先在 GitHub 网站创建名为 `saveenv` 的**公开空仓库**（不要让 GitHub 自动生成 README/LICENSE，因为本项目已有）。在仓库源码根目录执行：

```bash
git init
git add .
git commit -m "Initial SaveEnv v0.1.0"
git branch -M main
git remote add origin https://github.com/YOUR_NAME/saveenv.git
git push -u origin main
```

将 `YOUR_NAME` 替换为你自己的 GitHub 用户名或组织名称。确保 Git 已配置用户身份并具有推送权限。

## 2. 建立标签及发行版

```bash
git tag -a v0.1.0 -m "SaveEnv v0.1.0"
git push origin v0.1.0
```

随后在仓库页面点击 `Releases` -> `Draft a new release` -> 选择 `v0.1.0` 标签 -> 上传 `saveenv-v0.1.0.zip` -> 发布。

如已经安装并登录 `gh`（GitHub CLI），也可以直接：

```bash
gh release create v0.1.0 /path/to/saveenv-v0.1.0.zip \
  --title "SaveEnv v0.1.0" \
  --notes "Initial public release: Bash shortcuts for Python project environments."
```

也可只使用 GitHub 自动生成的 Source code ZIP；这种情况下无须手动上传 ZIP。

## 3. 提供下载地址

- 仓库：`https://github.com/YOUR_NAME/saveenv`
- 最新版本：`https://github.com/YOUR_NAME/saveenv/releases/latest`
- 上传的发行包：`https://github.com/YOUR_NAME/saveenv/releases/latest/download/saveenv-v0.1.0.zip`

注意：以上均是**替换用户名后**的地址，上传并公开发布之前无法访问。

## 4. 发布检查清单

- [ ] 在 WSL Ubuntu 上执行 `bash tests/test.sh`
- [ ] 检查 `README.md` 使用说明
- [ ] 根据需要更新 `LICENSE` 中的版权署名
- [ ] 确认 GitHub Actions 测试通过
- [ ] 确认 ZIP 根目录下有 `install.sh`
- [ ] 下载 Release 包，在干净的 WSL 用户账户中安装验证

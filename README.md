# SaveEnv

A small Bash tool for WSL/Linux: register **the current directory + active Python virtual environment** as a short command.

在 WSL / Linux 中，一次注册当前项目目录和 Python 环境，以后输入一个命令即可跳转并激活环境。

## 功能

- 自动记录当前目录（`pwd -P`）。
- 识别已激活的 `venv` / `virtualenv` (`$VIRTUAL_ENV`) 和 Conda (`$CONDA_PREFIX`)。
- 将快捷命令持久化到 `~/.config/saveenv/entries/`；在新的 Bash 终端自动加载。
- 支持查询、列出和删除快捷命令。
- 不需要 Python 包管理器，不修改项目内部文件。

**支持环境：** Bash（WSL2 Ubuntu 等 Linux 发行版）。暂不支持 Zsh、Fish、PowerShell、pyenv 自动检测及 Poetry/Pipenv 非激活模式。

## 安装

先从 GitHub 克隆仓库（将以下地址替换为你实际发布的仓库地址）：

```bash
git clone https://github.com/YOUR_NAME/saveenv.git
cd saveenv
bash install.sh
source ~/.bashrc
```

也可以从 Releases 下载 ZIP，解压后在工具目录运行 `bash install.sh`。

> 安装只向 `~/.bashrc` 添加一段带标记的 loader，主体放在 `~/.local/share/saveenv/saveenv.bash`。安装前可查看脚本源码。

## 使用示例

先进入一个 Python 项目并激活虚拟环境：

```bash
cd ~/projects/my-rag
source .venv/bin/activate
saveenv rag
```

以后新开一个 WSL 终端，只需执行 `rag`，即可进入保存的目录并激活相应环境。

Conda 示例：

```bash
cd ~/projects/my-agent
conda activate agent-env
saveenv agent
```

> 使用 Conda 时，请确保已经完成 `conda init bash`，并重启终端或重新加载 `~/.bashrc`，以便在快捷函数中使用 `conda activate`。

## 命令

| 命令 | 作用 |
| --- | --- |
| `saveenv rag` | 为当前目录及活动虚拟环境创建快捷命令 `rag` |
| `rag` | 跳转到项目，并激活保存的虚拟环境 |
| `saveenv list` | 列出已保存的快捷命令 |
| `saveenv show rag` | 查看快捷函数的 Bash 定义 |
| `saveenv remove rag` | 删除快捷命令 |
| `saveenv help` | 显示帮助 |

名称只允许字母、数字、下划线（不能以数字开头），不会覆盖已经存在的 Shell 命令和快捷函数。路径中包含空格也受支持。

## 目录结构

```text
saveenv/
├── src/saveenv.bash    # 主体功能：当前 Shell 中运行的 Bash 函数
├── install.sh          # 将工具安装到 ~/.local/share/saveenv
├── uninstall.sh        # 卸载脚本
├── tests/test.sh       # 隔离 HOME 下的功能测试
├── LICENSE
└── README.md
```

## 测试

```bash
bash tests/test.sh
```

测试在临时 HOME 中执行，不修改真实用户的 `.bashrc` 或现有虚拟环境。

## 卸载

在项目源码目录下执行：

```bash
bash uninstall.sh
```

默认保留已保存的快捷命令。彻底清除：

```bash
bash uninstall.sh --purge
```

## 工作原理

`install.sh` 让 `~/.bashrc` 加载 `saveenv.bash`。`saveenv` 必须是 Bash **函数**，而不能只是外部子进程，这样快捷函数才可以对当前终端执行 `cd` 和 `source`。

创建时，工具使用 `printf '%q'` 转义目录和环境路径，在 `~/.config/saveenv/entries/NAME.bash` 中写入形如：

```bash
rag() {
    builtin cd -- /home/user/projects/my-rag || return
    source /home/user/projects/my-rag/.venv/bin/activate
}
```

每次启动 Bash 时重新加载这些文件。请不要从不可信位置复制 `.bash` 快捷配置到 `entries` 目录，因为它们会在 Shell 启动时被执行。

## 开发与发行

可将此项目直接上传到 GitHub；按版本创建 `v0.1.0` Tag / Release，并将 ZIP 包作为发行资产附加。也可以直接使用 GitHub 自动生成的源码 ZIP。

## License

MIT（见 LICENSE）。

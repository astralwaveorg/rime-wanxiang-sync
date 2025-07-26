# Rime 万象 | 自动同步与个人配置方案

[![CI/CD Status](https://github.com/astralwaveio/rime-wanxiang-sync/actions/workflows/auto-sync-wanxiang.yml/badge.svg)](https://github.com/astralwaveio/rime-wanxiang-sync/actions/workflows/auto-sync-wanxiang.yml)
[![Latest Release](https://img.shields.io/github/v/release/astralwaveio/rime-wanxiang-sync?display_name=tag&sort=semver&color=blue)](https://github.com/astralwaveio/rime-wanxiang-sync/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/astralwaveio/rime-wanxiang-sync/main)](https://github.com/astralwaveio/rime-wanxiang-sync/commits/main)
[![Stars](https://img.shields.io/github/stars/astralwaveio/rime-wanxiang-sync?style=social)](https://github.com/astralwaveio/rime-wanxiang-sync/stargazers)
[![Issues](https://img.shields.io/github/issues/astralwaveio/rime-wanxiang-sync)](https://github.com/astralwaveio/rime-wanxiang-sync/issues)

本项目是一个自动化的 Rime 输入法配置仓库，旨在解决以下痛点：
1.  **保持更新**：自动同步上游优秀 Rime 方案（[amzxyz/rime_wanxiang](https://github.com/amzxyz/rime_wanxiang)）的最新版本。
2.  **高度个性化**：无缝集成个人定制的配置，无需在每次更新后手动合并。
3.  **开箱即用**：通过 GitHub Actions 自动打包成可直接使用的 `.zip` 压缩包，方便在多平台快速部署。

简单来说，你只需要维护自己的个人配置，此仓库会自动帮你完成与上游方案的合并、更新与打包工作。

## ✨ 项目特性

- **自动同步**：每两天或当您推送新配置时，自动拉取上游 `rime_wanxiang` 方案的最新基础文件。
- **个性化配置**：您所有的个人配置都存放在 `custom/` 目录中，与基础方案分离，易于管理和迁移。
- **自动发布**：同步和合并完成后，自动生成一个带有版本号（精确到分钟）的 GitHub Release，并附上打包好的 `rime.zip`。
- **纯净打包**：发布的 `rime.zip` 中只包含 Rime 运行所需的纯净配置文件，排除了 `.git`, `.github` 等无关文件。
- **跨平台兼容**：生成的配置文件可用于所有支持 Rime 的平台，如 Windows (小狼毫), macOS (鼠须管) 和 Linux (中州韵)。

## 🚀 如何使用 (终端用户)

如果您只是想使用本仓库已经配置好的输入方案，请按以下步骤操作。

### 1. 安装 Rime 输入法

请确保您的系统上已安装 Rime 输入法。
- **Windows**: [小狼毫 (Weasel)](https://rime.im/download/)
- **macOS**: [鼠须管 (Squirrel)](https://rime.im/download/)
- **Linux**: 中州韵 (ibus-rime / fcitx-rime / fcitx5-rime)

### 2. 下载配置文件

前往本仓库的 [**Releases 页面**](https://github.com/astralwaveio/rime-wanxiang-sync/releases/latest)，下载最新版本下的 `rime.zip` 文件。

### 3. 部署配置文件

部署过程会覆盖您现有的 Rime 配置，请注意备份。

1.  **找到 Rime 用户设定目录**：
    - **Windows**: `%APPDATA%\Rime` 或 `C:\Users\你的用户名\AppData\Roaming\Rime`
    - **macOS**: `~/Library/Rime`
    - **Linux**:
        - IBus: `~/.config/ibus/rime/`
        - Fcitx: `~/.config/fcitx/rime/`
        - Fcitx5: `~/.config/fcitx5/rime/`

2.  **清空旧配置**：为了避免冲突，请**删除**用户设定目录下的**所有**旧文件和文件夹。

3.  **解压新配置**：将下载的 `rime.zip` 文件解压，并将解压后的所有内容复制到刚才清空的用户设定目录中。

4.  **重新部署**：
    - 右键点击输入法图标，选择“重新部署 (Redeploy / Deploy)”。
    - 等待部署完成后，即可享受最新的输入方案。

## 🔧 如何复刻 (Fork) 并用于您自己的配置

您可以复刻此仓库，打造属于您自己的自动化 Rime 配置流程。

### 第 1 步：复刻仓库

点击本仓库右上角的 **Fork** 按钮，将其复刻到您自己的 GitHub 账户下。

### 第 2 步：启用 GitHub Actions

**这是最关键的一步！** 出于安全原因，GitHub 在复刻的仓库上默认禁用 Actions 工作流。您需要手动启用它。

1.  进入您复刻后的仓库，点击 **Settings** (设置)。
2.  在左侧导航栏选择 **Actions** -> **General**。
3.  在 "Actions permissions" 部分，选择 **Allow all actions and reusable workflows** 并保存。

![Enable Actions](https://docs.github.com/assets/cb-122532/images/help/repository/actions-permissions-all-actions.png)

### 第 3 步：个性化您的配置

您的所有个人配置都应放在 `custom/` 目录下。该目录下的文件会在同步后**覆盖**基础方案中的同名文件。

1.  **克隆您的仓库**到本地：
    ```bash
    git clone [https://github.com/你的用户名/rime-wanxiang-sync.git](https://github.com/你的用户名/rime-wanxiang-sync.git)
    ```

2.  **修改 `custom/` 目录**：
    - `default.custom.yaml`: 全局配置，如设置候选词数量、翻页键等。
    - `weasel.custom.yaml`: 小狼毫 (Windows) 的专属配置，如外观、字体等。
    - `squirrel.custom.yaml`: 鼠须管 (macOS) 的专属配置。
    - `custom_phrase.txt`: 您的个人词库。
    - 您可以添加任何其他的 Rime 配置文件。

3.  **提交并推送**您的修改：
    ```bash
    git add .
    git commit -m "更新我的个人配置"
    git push
    ```

### 第 4 步：触发工作流并获取您的 Release

当您完成以上配置并推送到 `main` 分支后，GitHub Actions 会自动运行。您也可以通过以下方式手动触发：

- **手动触发**：进入仓库的 **Actions** 标签页，选择 `自动同步 Rime 万象方案` 工作流，点击 **Run workflow**。

工作流成功运行后，您就可以在您自己仓库的 **Releases** 页面找到为您量身定制、打包好的 `rime.zip` 了！

### (可选) 第 5 步：自定义工作流

您可以修改 `.github/workflows/auto-sync.yml` 文件来进行更深度的定制：
- **修改同步频率**：调整 `on.schedule.cron` 的值。
- **更换上游方案**：修改 `API_URL` 变量中的仓库地址。
- **增删排除文件**：在 `rsync` 命令中调整 `--exclude` 参数。

## 📂 项目结构

```
.
├── .github/workflows/auto-sync.yml  # 核心的 GitHub Actions 工作流文件
├── custom/                          # 存放您所有的个人配置文件 (核心修改区)
│   ├── default.custom.yaml
│   ├── custom_phrase.txt
│   └── ...
├── bin/                             # 存放 Rime 运行可能需要的二进制文件 (受保护，不会被同步删除)
├── README.md                        # 本说明文件
└── ...                              # 其他由上游同步而来的基础配置文件
```

## 🙏 致谢

- **Rime 输入法引擎**: [rime/weasel](https://github.com/rime/weasel), [rime/squirrel](https://github.com/rime/squirrel), 等。
- **上游方案**: [amzxyz/rime_wanxiang](https://github.com/amzxyz/rime_wanxiang)
- **语法模型**: [amzxyz/RIME-LMDG](https://github.com/amzxyz/RIME-LMDG)
- **语法模型最新发行版本下载**: [wanxiang-lts-zh-hans.gram](https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram)

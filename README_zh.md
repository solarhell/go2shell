# go2shell

[English](README.md)

一个简洁高效的 macOS 应用，可以在 Finder 当前目录快速打开终端。

![macOS](https://img.shields.io/badge/macOS-Sequoia%2015%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6.2-orange)

![settings](screenshots/settings.jpg)

## ✨ 功能特性

- 🚀 **一键启动** - 从 Finder 工具栏快速打开终端
- 🎯 **智能终端检测** - 自动检测系统中已安装的终端应用
- 🎨 **真实应用图标** - 使用终端应用的原生图标
- ⚡️ 纯 Swift 实现，轻量高效
- 🔧 简单易用，无需复杂配置
- 📦 适用于 macOS Sequoia 15.0+

### 支持的终端应用

应用会自动检测以下终端，只显示已安装的，未安装的灰显提示：

- ✅ **Terminal.app** (系统自带)
- ✅ **iTerm2**
- ✅ **Warp**
- ✅ **Ghostty**
- ✅ **WezTerm**

> 如果首选终端被卸载，会自动回退到系统内置的 Terminal.app。

## 📦 安装

### Homebrew（推荐）

```bash
# 安装
brew install --no-quarantine solarhell/tap/go2shell

# 升级
brew upgrade --no-quarantine solarhell/tap/go2shell
```

### 从源码构建

```bash
make install
```

## 🎯 使用方式

### 第一步：添加到 Finder 工具栏

1. **打开 Applications 文件夹**
2. **按住 ⌘ (Command) 键**
3. **将 go2shell.app 图标拖到任意 Finder 窗口的工具栏上**
4. 完成！工具栏上会出现 go2shell 图标

### 第三步：使用

- 在任意 Finder 窗口点击工具栏上的 go2shell 图标
- 应用会自动在当前目录打开你选择的终端
- 无需任何额外操作！

### 修改设置

**方式 1：按住 Option 键**
- 按住 Option (⌥) 键点击 Finder 工具栏上的 go2shell
- 或按住 Option 键在 Finder 中双击应用图标
- 在设置界面中选择你喜欢的终端

**方式 2：命令行**
```bash
open /Applications/go2shell.app --args --show-ui
```

## 📋 系统要求

- macOS Sequoia 15.0 或更高版本
- Xcode 16+ (用于构建)

## 🚀 快速开始

```bash
# 1. 构建并安装应用
make install

# 2. 将应用拖到 Finder 工具栏
# - 打开 /Applications 文件夹
# - 按住 ⌘ (Command) 键
# - 将 go2shell.app 拖到 Finder 工具栏

# 完成！点击工具栏图标即可在当前目录打开终端
```

## 🔨 构建

本项目使用 **Swift Package Manager (SPM)** 和 **Makefile** 构建。

### 方法一：使用 Makefile（推荐）

```bash
# 查看所有可用命令
make help

# 构建应用
make build

# 安装到 /Applications
make install

# 清理构建文件
make clean

# 运行应用（显示设置界面）
/Applications/go2shell.app/Contents/MacOS/go2shell --show-ui

# 调试信息
make debug
```

### 方法二：使用 Swift Package Manager 直接构建

```bash
# 编译项目
swift build -c release

# 运行可执行文件
.build/release/go2shell
```

> **注意**: 直接使用 SPM 只能编译源代码，不会创建完整的 App Bundle。要创建可安装的 .app，请使用 `make build`。

## 📦 安装

### 自动安装（推荐）

```bash
make install
```

这会自动：
1. 构建应用
2. 复制到 `/Applications` 目录

### 手动安装

1. 构建完成后，将 `.build/go2shell.app` 复制到 `/Applications` 目录

```bash
cp -r .build/go2shell.app /Applications/
```

2. **添加到 Finder 工具栏**

- 打开 Finder，按住 **Command (⌘)** 键
- 将 `go2shell.app` 从 Applications 文件夹拖到 Finder 工具栏上

完成！现在你可以点击 Finder 工具栏的 go2shell 图标快速打开终端。

## 🎨 自定义图标（可选）

如果你想自定义应用图标：

1. 准备一个 1024x1024 的 PNG 图标文件
2. 将其命名为 `icon.png` 并放在 `Resources/` 目录下
3. 运行图标生成命令：

```bash
make icon
```

4. 重新构建应用：

```bash
make build
```

## ⚙️ 设置

### 方式一：首次运行（自动显示）

首次安装后点击应用，会自动显示设置界面

### 方式二：通过 Option 键

按住 Option (⌥) 键点击应用图标即可打开设置界面，在那里你可以：
- 选择首选终端（Terminal.app、iTerm2、Warp、Ghostty、WezTerm）
- 查看使用说明
- 了解应用信息

### 方式二：通过命令行

```bash
# 设置为 Terminal.app（默认）
defaults write com.solarhell.go2shell PreferredTerminal Terminal

# 设置为 iTerm2
defaults write com.solarhell.go2shell PreferredTerminal iTerm

# 设置为 Warp
defaults write com.solarhell.go2shell PreferredTerminal Warp

# 设置为 Ghostty
defaults write com.solarhell.go2shell PreferredTerminal Ghostty

# 设置为 WezTerm
defaults write com.solarhell.go2shell PreferredTerminal WezTerm
```

### 开发测试

```bash
# 打开主窗口（UI 模式 - 默认）
make run-ui
# 或直接运行
/Applications/go2shell.app/Contents/MacOS/go2shell

# 打开设置窗口
make run-settings
# 或
/Applications/go2shell.app/Contents/MacOS/go2shell --settings

# 快速打开终端（不显示 UI）
/Applications/go2shell.app/Contents/MacOS/go2shell --open-terminal

# 查看调试信息
make debug

# 查看所有可用命令
make help
```

## 🔧 工作原理

### 从 Finder 工具栏点击
1. 使用 Apple Events (AppleScript) 获取当前激活的 Finder 窗口路径
2. 如果没有打开的 Finder 窗口，则使用桌面路径
3. 根据用户偏好，调用相应终端的 AppleScript API
4. 在指定路径打开新的终端会话，然后自动退出应用

### 主窗口模式（双击应用）
- 显示现代化的 SwiftUI 界面
- 提供图形化的终端选择器
- 显示详细的安装和使用说明
- 实时保存用户偏好设置

### 设置模式（Option + 点击）
- 打开高级设置窗口
- 提供更多配置选项
- 显示应用版本和系统信息

## 📁 项目结构

```
go2shell/
├── Package.swift                      # Swift Package Manager 配置
├── Makefile                           # 构建自动化脚本
│
├── Sources/                           # 主应用源代码
│   ├── main.swift                    # 入口文件
│   ├── Views.swift                   # SwiftUI 界面
│   ├── TerminalManager.swift         # 终端管理逻辑
│   ├── Terminal.swift                # Terminal.app ScriptingBridge 定义
│   ├── Finder.swift                  # Finder ScriptingBridge 定义
│   └── FinderManager.swift           # Finder 路径获取逻辑
│
├── Resources/                        # 应用资源
│   ├── Info.plist                    # 应用配置
│   ├── go2shell.entitlements         # 应用权限
│   └── AppIcon.icns                  # 应用图标
│
└── .build/                           # SPM 构建输出（自动生成）
    ├── release/                      # Release 版本可执行文件
    └── go2shell.app                  # 最终的 App Bundle
```

## 🔐 权限说明

### 主应用权限 (Resources/go2shell.entitlements)
- `com.apple.security.automation.apple-events`: 允许发送 Apple Events 控制终端
- `com.apple.security.application-groups`: 允许主应用和 Extension 共享数据

### Finder Sync Extension 权限 (FinderSyncExtension/FinderSync.entitlements)
- `com.apple.security.app-sandbox`: 启用应用沙盒（Extension 必需）
- `com.apple.security.automation.apple-events`: 允许打开终端
- `com.apple.security.files.user-selected.read-write`: 允许访问用户选择的文件
- `com.apple.security.application-groups`: 与主应用共享偏好设置

## 🛠️ 调试技巧

### 查看日志

```bash
# 查看应用日志
log stream --predicate 'subsystem contains "com.go2shell"'
```

### 重置 Finder

```bash
# 重启 Finder
killall Finder
```

## 📝 常见问题

| 问题 | 解决方案 |
|------|----------|
| 工具栏没有显示 go2shell 按钮 | 请确保已启用 Finder Sync Extension：<br>1. 打开"系统设置" > "通用" > "登录项与扩展"<br>2. 找到"Finder 扩展" > 启用 "go2shell"<br>3. 重启 Finder：`killall Finder` |
| 点击按钮无反应 | 请确保授予应用"自动化"权限：<br>1. 打开"系统设置" > "隐私与安全性" > "自动化"<br>2. 找到 go2shell 并确保已勾选 Finder 和 Terminal |
| 如何打开设置界面 | 三种方式：<br>1. 双击 `/Applications/go2shell.app`（显示主界面）<br>2. 按住 Option 键点击应用（显示高级设置）<br>3. 运行命令：`/Applications/go2shell.app/Contents/MacOS/go2shell --settings` |
| Extension 不工作 | 1. 检查 Extension 是否已启用（系统设置 > 扩展）<br>2. 重启 Finder：`killall Finder`<br>3. 查看日志：`log stream --predicate 'subsystem contains "com.go2shell"'` |
| 如何卸载 | 1. 在系统设置中禁用 Finder Sync Extension<br>2. 删除 `/Applications/go2shell.app`<br>3. （可选）删除偏好设置：`defaults delete com.solarhell.go2shell` |

## 💻 技术栈

- **语言**: Swift 6.2
- **最低系统**: macOS 15.0 (Tahoe 26)
- **构建工具**:
  - Swift Package Manager (SPM) - 编译和依赖管理
  - Makefile - 构建自动化和 App Bundle 打包
- **框架**:
  - Cocoa (UI)
  - SwiftUI (现代界面)
  - AppleScript/Apple Events (终端控制)

### 为什么使用 SPM + Makefile？

1. **SPM** 提供：
   - 标准化的 Swift 项目结构
   - 依赖管理
   - 快速的增量编译
   - 跨平台兼容性

2. **Makefile** 处理：
   - App Bundle 创建和打包
   - 代码签名
   - 资源文件复制
   - 一键安装和测试

## 🔮 未来计划

- [x] 支持 Terminal.app、iTerm2、Warp、Ghostty、WezTerm
- [x] 使用应用原生图标
- [x] 未安装终端灰显提示，首选终端被卸载自动回退
- [ ] 支持在新标签页或新窗口中打开
- [ ] 支持快捷键
- [ ] 支持自定义终端命令（如切换到特定目录后运行脚本）

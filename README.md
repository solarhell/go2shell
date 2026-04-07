# go2shell

[中文文档](README_zh.md)

Quickly open a terminal from the current Finder directory.

![macOS](https://img.shields.io/badge/macOS-Sequoia%2015%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6.2-orange)

![settings](screenshots/settings.jpg)

## Features

- **One-click launch** — Open a terminal right from the Finder toolbar
- **Smart detection** — Automatically detects installed terminal apps
- **Native icons** — Displays each terminal's real app icon
- Pure Swift, lightweight and fast
- Simple to use, no complex configuration needed

### Supported Terminals

The app auto-detects the following terminals. Uninstalled ones are greyed out:

- **Terminal.app** (built-in)
- **iTerm2**
- **Warp**
- **Ghostty**
- **WezTerm**

> If the preferred terminal is uninstalled, it automatically falls back to the built-in Terminal.app.

## Install

### Homebrew (recommended)

```bash
# Install
brew install --no-quarantine solarhell/tap/go2shell

# Upgrade
brew upgrade --no-quarantine solarhell/tap/go2shell
```

### Build from source

```bash
make install

# Then drag go2shell.app from /Applications to the Finder toolbar
# (hold ⌘ while dragging)

# Done! Click the toolbar icon to open a terminal in the current directory.
```

## Usage

### Step 1: Add to Finder Toolbar

1. Open the Applications folder
2. Hold **⌘ (Command)**
3. Drag `go2shell.app` onto any Finder window's toolbar
4. Done!

### Step 3: Use

- Click the go2shell icon in any Finder window's toolbar
- A terminal opens at the current directory automatically

### Change Settings

**Option 1: Hold Option key**
- Hold **Option (⌥)** and click go2shell in the Finder toolbar
- Or hold Option and double-click the app icon in Finder
- Select your preferred terminal in the settings UI

**Option 2: Command line**
```bash
open /Applications/go2shell.app --args --show-ui
```

**Option 3: Defaults**
```bash
# Set to Terminal.app (default)
defaults write com.solarhell.go2shell PreferredTerminal Terminal

# Set to iTerm2
defaults write com.solarhell.go2shell PreferredTerminal iTerm

# Set to Warp / Ghostty / WezTerm
defaults write com.solarhell.go2shell PreferredTerminal Warp
defaults write com.solarhell.go2shell PreferredTerminal Ghostty
defaults write com.solarhell.go2shell PreferredTerminal WezTerm
```

## System Requirements

- macOS Sequoia 15.0+
- Xcode 16+ (for building)

## Build

Built with **Swift Package Manager** and **Makefile**.

### Using Makefile (recommended)

```bash
make help      # Show all commands
make build     # Build the app
make install   # Install to /Applications
make clean     # Clean build files
make debug     # Show debug info
```

### Using SPM directly

```bash
swift build -c release
.build/release/go2shell
```

> **Note**: SPM alone only compiles the binary. Use `make build` to create a full App Bundle.

## How It Works

1. Uses Apple Events (AppleScript) to get the frontmost Finder window's path
2. Falls back to the Desktop path if no Finder window is open
3. Opens the preferred terminal at that path via AppleScript
4. Exits automatically after launching the terminal

## Project Structure

```
go2shell/
├── Package.swift              # SPM configuration
├── Makefile                   # Build automation
├── Sources/
│   ├── main.swift             # Entry point
│   ├── Views.swift            # SwiftUI interface
│   ├── TerminalManager.swift  # Terminal launch logic
│   ├── Terminal.swift         # Terminal.app ScriptingBridge
│   ├── Finder.swift           # Finder ScriptingBridge
│   └── FinderManager.swift    # Finder path retrieval
├── Resources/
│   ├── Info.plist             # App configuration
│   ├── go2shell.entitlements  # App entitlements
│   └── AppIcon.icns           # App icon
└── .build/                    # Build output (generated)
```

## Roadmap

- [x] Support Terminal.app, iTerm2, Warp, Ghostty, WezTerm
- [x] Native app icons
- [x] Grey out uninstalled terminals, auto-fallback on uninstall
- [ ] Open in new tab or new window
- [ ] Keyboard shortcuts
- [ ] Custom terminal commands (e.g., run a script after cd)

## License

MIT

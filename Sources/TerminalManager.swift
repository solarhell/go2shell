// 移植自 OpenInTerminal - OpenInTerminalCore/App.swift (Terminal 部分)

import Cocoa
import ScriptingBridge

class TerminalManager {
    enum Terminal: String, CaseIterable {
        case terminal = "Terminal"
        case iterm = "iTerm"
        case warp = "Warp"
        case ghostty = "Ghostty"
        case wezterm = "WezTerm"
        case kitty = "Kitty"
        case alacritty = "Alacritty"

        var displayName: String {
            switch self {
            case .terminal: return "Terminal.app"
            case .iterm: return "iTerm2"
            case .warp: return "Warp"
            case .ghostty: return "Ghostty"
            case .wezterm: return "WezTerm"
            case .kitty: return "Kitty"
            case .alacritty: return "Alacritty"
            }
        }

        var appPath: String {
            switch self {
            case .terminal: return "/System/Applications/Utilities/Terminal.app"
            case .iterm: return "/Applications/iTerm.app"
            case .warp: return "/Applications/Warp.app"
            case .ghostty: return "/Applications/Ghostty.app"
            case .wezterm: return "/Applications/WezTerm.app"
            case .kitty: return "/Applications/kitty.app"
            case .alacritty: return "/Applications/Alacritty.app"
            }
        }

        var isInstalled: Bool {
            FileManager.default.fileExists(atPath: appPath)
        }
    }

    static func openTerminal(atPath path: String) {
        let terminalName = UserDefaults.standard.string(forKey: "PreferredTerminal") ?? "Terminal"
        var terminal = Terminal(rawValue: terminalName) ?? .terminal
        if !terminal.isInstalled {
            terminal = .terminal
        }

        switch terminal {
        case .terminal:
            openAppleTerminal(atPath: path)
        case .iterm:
            openITerm(atPath: path)
        case .warp:
            openWarp(atPath: path)
        case .ghostty:
            openGhostty(atPath: path)
        case .wezterm:
            openWezTerm(atPath: path)
        case .kitty:
            openKitty(atPath: path)
        case .alacritty:
            openAlacritty(atPath: path)
        }
    }

    /// Terminal.app — 移植自 OpenInTerminal 的 ScriptingBridge 方式
    private static func openAppleTerminal(atPath path: String) {
        let url = URL(fileURLWithPath: path)
        guard let terminal = SBApplication(bundleIdentifier: "com.apple.Terminal") as TerminalApplication?,
              let open = terminal.open else {
            return
        }
        open([url])
        terminal.activate()
    }

    /// iTerm2 — 移植自 OpenInTerminal 的 shell 命令方式
    private static func openITerm(atPath path: String) {
        let escapedPath = path.specialCharEscaped(2)
        let source = """
        do shell script "open -a iTerm \(escapedPath)"
        """
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }

    /// Warp
    private static func openWarp(atPath path: String) {
        let escapedPath = path.specialCharEscaped(2)
        let source = """
        do shell script "open -a Warp \(escapedPath)"
        """
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }

    /// Ghostty
    private static func openGhostty(atPath path: String) {
        let escapedPath = path.specialCharEscaped(2)
        let source = """
        do shell script "open -a Ghostty \(escapedPath)"
        """
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }

    /// WezTerm
    private static func openWezTerm(atPath path: String) {
        let escapedPath = path.specialCharEscaped(2)
        let source = """
        do shell script "open -a WezTerm \(escapedPath)"
        """
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }

    /// Kitty
    private static func openKitty(atPath path: String) {
        let escapedPath = path.specialCharEscaped(2)
        let source = """
        do shell script "open -a kitty \(escapedPath)"
        """
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }

    /// Alacritty
    private static func openAlacritty(atPath path: String) {
        let escapedPath = path.specialCharEscaped(2)
        let source = """
        do shell script "open -a Alacritty \(escapedPath)"
        """
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }
}

// 移植自 OpenInTerminal - String+Extension.swift
extension String {
    func specialCharEscaped(_ escapeCount: Int = 1) -> String {
        var result = self
        let specialChars = [" ", "(", ")", "&", "|", ";", "\"", "'", "<", ">", "`", "!", "{", "}", "[", "]", "$", "#", "^", "~", "?", "*", "\\"]
        let escape = String(repeating: "\\", count: escapeCount)
        for char in specialChars {
            result = result.replacingOccurrences(of: char, with: escape + char)
        }
        return result
    }
}

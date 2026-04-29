# go2shell Makefile
# 使用 Swift Package Manager 构建 macOS 应用

.PHONY: all build clean install uninstall run run-ui run-settings test help icon reset debug

# 变量定义
APP_NAME = go2shell
BUNDLE_ID = com.solarhell.go2shell
BUILD_DIR = .build
RELEASE_DIR = $(BUILD_DIR)/release
APP_BUNDLE = $(BUILD_DIR)/$(APP_NAME).app
INSTALL_PATH = /Applications/$(APP_NAME).app
HOST_ARCH = $(shell uname -m)

# 默认目标
all: build

# 显示帮助信息
help:
	@echo "go2shell 构建系统 (基于 Swift Package Manager)"
	@echo ""
	@echo "可用命令:"
	@echo "  make build      - 构建应用（默认）"
	@echo "  make clean      - 清理构建文件"
	@echo "  make install    - 安装到 /Applications"
	@echo "  make uninstall  - 从 /Applications 卸载"
	@echo "  make run        - 运行应用（显示设置界面）"
	@echo "  make run-settings - 运行应用（高级设置）"
	@echo "  make test       - 运行测试"
	@echo "  make icon       - 生成应用图标"
	@echo "  make reset      - 重置 Finder 和扩展"
	@echo "  make debug      - 显示调试信息"
	@echo ""

# 构建应用
build:
	@echo "🔨 开始构建 go2shell..."
	@echo ""

	# 使用 SPM 构建 Release 版本
	@echo "📦 使用 Swift Package Manager 编译..."
	@swift build -c release
	@echo "✅ Swift 编译完成"
	@echo ""

	# 创建 App Bundle
	@echo "📁 创建 App Bundle 结构..."
	@$(MAKE) --no-print-directory create-bundle
	@echo "✅ App Bundle 创建完成"
	@echo ""

	# 代码签名
	@echo "✍️  代码签名..."
	@$(MAKE) --no-print-directory codesign
	@echo "✅ 代码签名完成"
	@echo ""

	@echo "✅ 构建完成！"
	@echo "📦 应用位置: $(APP_BUNDLE)"
	@echo ""
	@echo "下一步: make install"

# 创建 App Bundle 结构
create-bundle:
	@rm -rf $(APP_BUNDLE)
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@mkdir -p $(APP_BUNDLE)/Contents/Resources

	# 复制主应用可执行文件
	@cp $(RELEASE_DIR)/go2shell $(APP_BUNDLE)/Contents/MacOS/

	# 复制 SPM resource bundle（本地化资源等）
	# $(RELEASE_DIR) 是 SPM 在当前架构构建后创建的符号链接，自动指向 .build/<arch>-apple-macosx/release
	@for bundle in $(RELEASE_DIR)/*.bundle; do \
		if [ -d "$$bundle" ]; then \
			cp -r "$$bundle" $(APP_BUNDLE)/Contents/Resources/; \
		fi; \
	done

	# 复制主应用配置
	@cp Resources/Info.plist $(APP_BUNDLE)/Contents/

	# 复制图标（如果存在）
	@if [ -f Resources/AppIcon.icns ]; then \
		cp Resources/AppIcon.icns $(APP_BUNDLE)/Contents/Resources/; \
	fi

	# 复制本地化资源
	@for lproj in Resources/*.lproj; do \
		if [ -d "$$lproj" ]; then \
			cp -r "$$lproj" $(APP_BUNDLE)/Contents/Resources/; \
		fi; \
	done

# 代码签名
codesign:
	# 签名主应用
	@codesign --force --deep --sign - \
		--entitlements Resources/go2shell.entitlements \
		$(APP_BUNDLE)

# 清理构建文件
clean:
	@echo "🧹 清理构建文件..."
	@swift package clean
	@rm -rf $(BUILD_DIR)
	@rm -rf .swiftpm
	@echo "✅ 清理完成"

# 安装到 /Applications
install: build
	@echo "📦 安装 go2shell 到 /Applications..."
	@if [ -d "$(INSTALL_PATH)" ]; then \
		echo "⚠️  $(INSTALL_PATH) 已存在，将覆盖"; \
		rm -rf "$(INSTALL_PATH)"; \
	fi
	@cp -r $(APP_BUNDLE) $(INSTALL_PATH)
	@echo "✅ 应用已安装到 $(INSTALL_PATH)"
	@echo ""

# 卸载
uninstall:
	@echo "🗑️  卸载 go2shell..."
	@if [ -d "$(INSTALL_PATH)" ]; then \
		rm -rf "$(INSTALL_PATH)"; \
		echo "✅ 已卸载 $(INSTALL_PATH)"; \
	else \
		echo "⚠️  $(INSTALL_PATH) 不存在"; \
	fi
	@echo ""
	@echo "💡 如需完全清理，还可以运行:"
	@echo "   defaults delete $(BUNDLE_ID)"

# 运行应用（主界面 - 默认）
run: build
	@echo "🪟 运行 go2shell (主界面)..."
	@$(APP_BUNDLE)/Contents/MacOS/go2shell

# 运行应用（UI 模式 - 别名）
run-ui: run

# 运行应用（设置模式）
run-settings: build
	@echo "⚙️  运行 go2shell (设置模式)..."
	@$(APP_BUNDLE)/Contents/MacOS/go2shell --settings

# 生成图标
icon:
	@if [ ! -f "Resources/icon.png" ]; then \
		echo "❌ 未找到 Resources/icon.png"; \
		echo "请提供一个 1024x1024 的 PNG 图标文件"; \
		exit 1; \
	fi
	@echo "🎨 生成应用图标..."
	@mkdir -p $(BUILD_DIR)/AppIcon.iconset
	@sips -z 16 16     Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_16x16.png >/dev/null
	@sips -z 32 32     Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_16x16@2x.png >/dev/null
	@sips -z 32 32     Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_32x32.png >/dev/null
	@sips -z 64 64     Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_32x32@2x.png >/dev/null
	@sips -z 128 128   Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_128x128.png >/dev/null
	@sips -z 256 256   Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_128x128@2x.png >/dev/null
	@sips -z 256 256   Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_256x256.png >/dev/null
	@sips -z 512 512   Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_256x256@2x.png >/dev/null
	@sips -z 512 512   Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_512x512.png >/dev/null
	@sips -z 1024 1024 Resources/icon.png --out $(BUILD_DIR)/AppIcon.iconset/icon_512x512@2x.png >/dev/null
	@iconutil -c icns $(BUILD_DIR)/AppIcon.iconset -o Resources/AppIcon.icns
	@rm -rf $(BUILD_DIR)/AppIcon.iconset
	@echo "✅ 图标生成完成: Resources/AppIcon.icns"

# 打包 Release zip（用于 Homebrew Cask 分发；按当前主机架构命名）
release: build
	@echo "📦 打包 Release ($(HOST_ARCH))..."
	@mkdir -p build
	@cd .build && zip -r ../build/go2shell-macOS-$(HOST_ARCH).zip go2shell.app
	@echo "✅ 打包完成: build/go2shell-macOS-$(HOST_ARCH).zip"
	@shasum -a 256 build/go2shell-macOS-$(HOST_ARCH).zip

# 运行测试
test:
	@echo "🧪 运行测试..."
	@swift test

# 重置 Finder
reset:
	@echo "🔄 重置 Finder..."
	@killall Finder || true
	@echo "✅ 重置完成"

# 调试信息
debug:
	@echo "🔍 调试信息"
	@echo "============"
	@echo "Swift 版本:"
	@swift --version
	@echo ""
	@echo "应用状态:"
	@if [ -d "$(INSTALL_PATH)" ]; then \
		echo "✅ 已安装: $(INSTALL_PATH)"; \
	else \
		echo "❌ 未安装"; \
	fi

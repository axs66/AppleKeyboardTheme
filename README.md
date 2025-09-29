# Keyboard Color Tweak

一个为 iOS 16 无根越狱设计的键盘颜色自定义插件。

## 功能特性

- 自定义键盘背景颜色
- 支持红、绿、蓝和透明度调节
- 在系统设置中提供设置面板
- 支持 iOS 16 无根越狱环境
- 实时预览颜色变化（无需重启，滑动即生效）
- 启用/禁用开关，随时还原系统样式

## 安装要求

- iOS 16.0 或更高版本
- 无根越狱环境（如 Dopamine、XinaA15 等）
- PreferenceLoader 2.2.4 或更高版本

## 编译安装

1. 确保已安装 Theos 开发环境
2. 在项目根目录执行：
   ```bash
   make clean package install
   ```

## 使用方法

1. 安装插件后，在系统设置中找到"键盘颜色"选项
2. 使用滑块调整红、绿、蓝和透明度值
3. 设置会立即生效，无需重启；如未刷新，可最小化键盘再唤起
4. 点击"恢复默认设置"可重置所有颜色值

## 文件结构

```
KeyboardColorTweak/
├── Tweak.xm                    # 主要插件代码
├── KeyboardColorTweak.plist    # 插件配置文件
├── Makefile                    # 编译配置
├── control                     # 包信息
└── Preferences/                # 设置面板
    ├── KeyboardColorPrefs.h    # 设置面板头文件
    ├── KeyboardColorPrefs.mm   # 设置面板实现
    ├── Root.plist             # 设置界面配置
    ├── Info.plist             # 设置面板信息
    └── Makefile               # 设置面板编译配置
```

## 技术实现

- 使用 Logos 语法 hook `UIInputWindowController` 类
- 通过 `NSUserDefaults`（App Group/套件名 `com.yourcompany.keyboardcolor`）存储设置
- 滑块/开关通过 Darwin 通知 `com.yourcompany.keyboardcolor/ReloadPrefs` 实时刷新
- 使用 `Preferences` 框架创建系统设置面板
- 支持无根越狱的 `rootless` 打包方案

## 注意事项

- 插件仅影响系统键盘，不影响第三方键盘
- 某些应用可能有特殊的键盘样式，可能不受影响
- 建议在安装前备份设备数据

## 许可证

本项目采用 MIT 许可证。

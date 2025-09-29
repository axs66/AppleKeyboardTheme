ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KeyboardColorPrefs

KeyboardColorPrefs_FILES = KeyboardColorPrefs.mm
KeyboardColorPrefs_FRAMEWORKS = UIKit
# 避免在 CI 上对私有框架 Preferences 进行硬链接，运行时由宿主进程加载
KeyboardColorPrefs_LDFLAGS = -Wl,-undefined,dynamic_lookup
KeyboardColorPrefs_INSTALL_PATH = /Library/PreferenceBundles
KeyboardColorPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

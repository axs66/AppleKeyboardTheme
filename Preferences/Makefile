ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KeyboardColorPrefs

KeyboardColorPrefs_FILES = KeyboardColorPrefs.mm
KeyboardColorPrefs_FRAMEWORKS = UIKit
KeyboardColorPrefs_PRIVATE_FRAMEWORKS = Preferences
KeyboardColorPrefs_INSTALL_PATH = /Library/PreferenceBundles
KeyboardColorPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

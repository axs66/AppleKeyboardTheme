ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_INSTALLATION_PREFIX = /var/jb

INSTALL_TARGET_PROCESSES = SpringBoard
TWEAK_NAME = AppleKeyboardTheme

AppleKeyboardTheme_FILES = Tweak.x
AppleKeyboardTheme_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AppleKeyboardTheme_EXTRA_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	# 确保主题目录存在
	mkdir -p $(THEOS_STAGING_DIR)/var/jb/Library/Keyboard/Themes/CustomBackground.theme
	chmod 755 $(THEOS_STAGING_DIR)/var/jb/Library/Keyboard/Themes

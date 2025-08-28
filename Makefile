ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_INSTALLATION_PREFIX = /var/jb

AppleKeyboardTheme_FILES = Tweak.x
AppleKeyboardTheme_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AppleKeyboardTheme_FRAMEWORKS = UIKit
AppleKeyboardTheme_PRIVATE_FRAMEWORKS = UIKitCore  # 关键私有框架

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

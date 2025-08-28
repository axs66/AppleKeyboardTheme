export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppleKeyboardTheme
AppleKeyboardTheme_FILES = Tweak.x
AppleKeyboardTheme_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

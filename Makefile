TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NPColor

NPColor_FILES = Tweak.x
NPColor_CFLAGS = -fobjc-arc
PColor_PRIVATE_FRAMEWORKS = PlatterKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Aweme

TWEAK_NAME = AwemeX_iPadFix

AwemeX_iPadFix_FILES = AwemeX_iPadFix.xm
AwemeX_iPadFix_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

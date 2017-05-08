LOCAL_PATH := $(call my-dir)


include $(CLEAR_VARS)
 
LOCAL_MODULE    := nativecode
LOCAL_SRC_FILES := nativecode.c
LOCAL_LDLIBS 	:= -llog
include $(BUILD_SHARED_LIBRARY)

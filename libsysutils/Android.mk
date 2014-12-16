ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:=                             \
                  src/SocketListener.cpp      \
                  src/FrameworkListener.cpp   \
                  src/NetlinkListener.cpp     \
                  src/NetlinkEvent.cpp        \
                  src/FrameworkCommand.cpp    \
                  src/SocketClient.cpp        \
                  src/ServiceManager.cpp

LOCAL_MODULE:= libsysutils

LOCAL_C_INCLUDES := $(KERNEL_HEADERS) $(LOCAL_PATH)/../include/

LOCAL_CFLAGS := -DHAVE_SYS_UIO_H

LOCAL_SHARED_LIBRARIES := libcutils

include $(BUILD_SHARED_LIBRARY)

endif

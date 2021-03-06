#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(my-dir)
include $(CLEAR_VARS)

ifeq ($(TARGET_CPU_SMP),true)
    targetSmpFlag := -DANDROID_SMP=1
else
    targetSmpFlag := -DANDROID_SMP=0
endif
hostSmpFlag := -DANDROID_SMP=0

commonSources := \
	array.c \
	hashmap.c \
	atomic.c.arm \
	native_handle.c \
	buffer.c \
	socket_inaddr_any_server.c \
	socket_local_client.c \
	socket_local_server.c \
	socket_loopback_client.c \
	socket_loopback_server.c \
	socket_network_client.c \
	sockets.c \
	config_utils.c \
	cpu_info.c \
	load_file.c \
	list.c \
	open_memstream.c \
	strdup16to8.c \
	strdup8to16.c \
	record_stream.c \
	process_name.c \
	properties.c \
	qsort_r_compat.c \
	threads.c \
	sched_policy.c \
	iosched_policy.c \
	str_parms.c \

commonHostSources := \
        ashmem-host.c

commonSources += \
    abort_socket.c \
    fs.c \
    selector.c \
    multiuser.c \
    zygote.c


# Static library for host
# ========================================================
#LOCAL_MODULE := libcutils
#LOCAL_SRC_FILES := $(commonSources) $(commonHostSources) dlmalloc_stubs.c
#LOCAL_LDLIBS := -lpthread
#LOCAL_STATIC_LIBRARIES := liblog
#LOCAL_CFLAGS += $(hostSmpFlag)
#include $(BUILD_HOST_STATIC_LIBRARY)


# Static library for host, 64-bit
# ========================================================
#include $(CLEAR_VARS)
#LOCAL_MODULE := lib64cutils
#LOCAL_SRC_FILES := $(commonSources) $(commonHostSources) dlmalloc_stubs.c
#LOCAL_LDLIBS := -lpthread
#LOCAL_STATIC_LIBRARIES := lib64log
#LOCAL_CFLAGS += $(hostSmpFlag) -m64
#include $(BUILD_HOST_STATIC_LIBRARY)


# Shared and static library for target
# ========================================================

# This is needed in LOCAL_C_INCLUDES to access the C library's private
# header named <bionic_time.h>
#
libcutils_c_includes := bionic/libc/private

include $(CLEAR_VARS)
LOCAL_MODULE := libcutils_static
LOCAL_SRC_FILES := $(commonSources) \
        android_reboot.c \
        ashmem-dev.c \
        debugger.c \
        klog.c \
        mq.c \
        partition_utils.c \
        qtaguid.c \
        uevent.c

ifeq ($(TARGET_ARCH),arm)
LOCAL_SRC_FILES += arch-arm/memset32.S
else  # !arm
ifeq ($(TARGET_ARCH_VARIANT),x86-atom)
LOCAL_CFLAGS += -DHAVE_MEMSET16 -DHAVE_MEMSET32
LOCAL_SRC_FILES += arch-x86/android_memset16.S arch-x86/android_memset32.S memory.c
else # !x86-atom
ifeq ($(TARGET_ARCH),mips)
LOCAL_SRC_FILES += arch-mips/android_memset.c
else # !mips
LOCAL_SRC_FILES += memory.c
endif # !mips
endif # !x86-atom
endif # !arm

LOCAL_C_INCLUDES := $(libcutils_c_includes) $(KERNEL_HEADERS) $(LOCAL_PATH)/../include/
LOCAL_EXPORT_C_INCLUDES = $(LOCAL_PATH)/../include
LOCAL_STATIC_LIBRARIES := liblog_static
LOCAL_CFLAGS += $(targetSmpFlag) $(CUTILS_CFLAGS)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libcutils
LOCAL_WHOLE_STATIC_LIBRARIES := libcutils_static
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_CFLAGS += $(targetSmpFlag)
LOCAL_C_INCLUDES := $(libcutils_c_includes)
LOCAL_EXPORT_C_INCLUDES = $(LOCAL_PATH)/../include
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tst_str_parms
LOCAL_CFLAGS += -DTEST_STR_PARMS
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../include/
LOCAL_SRC_FILES := str_parms.c hashmap.c memory.c
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(call all-makefiles-under,$(LOCAL_PATH))

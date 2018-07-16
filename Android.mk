LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CLANG := true

LOCAL_MODULE := libwaltham

WALTHAM_GEN_FILES_DIR := $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libwaltham_intermediates

LOCAL_PATH_WALTHAM := $(LOCAL_PATH)

VARS_OLD := $(.VARIABLES)
CUR-DIR := $(shell pwd)
$(foreach v,                                        \
  $(filter-out $(VARS_OLD) VARS_OLD,$(.VARIABLES)), \
  $(warning $(v) = $($(v))))

tools = \
	$(LOCAL_PATH)/tools/gen.py

core_interface = \
	$(LOCAL_PATH)/data/private.xml \
	$(LOCAL_PATH)/data/public.xml \
	$(LOCAL_PATH)/data/command.xml

core_interface_include := $(addprefix -i ,$(core_interface))

$(WALTHAM_GEN_FILES_DIR)/waltham-client.h:
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham//header-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m client \
		-t header

$(WALTHAM_GEN_FILES_DIR)/client-serialice.c: $(WALTHAM_GEN_FILES_DIR)/waltham-client.h
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/serial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m client \
		-t marshaller

$(WALTHAM_GEN_FILES_DIR)/client-deserialice.c: $(WALTHAM_GEN_FILES_DIR)/waltham-client.h
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/deserial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m client \
		-t demarshaller

$(WALTHAM_GEN_FILES_DIR)/waltham-server.h:
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/header-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m server \
		-t header

$(WALTHAM_GEN_FILES_DIR)/server-serialice.c: $(WALTHAM_GEN_FILES_DIR)/waltham-server.h
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/serial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m server \
		-t marshaller

$(WALTHAM_GEN_FILES_DIR)/server-deserialice.c: $(WALTHAM_GEN_FILES_DIR)/waltham-server.h
	$(warning $(LOCAL_PATH_WALTHAM))
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
	-p $(LOCAL_PATH_WALTHAM)/src/waltham/deserial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m server \
		-t demarshaller



LOCAL_SRC_FILES :=	\
				../../$(WALTHAM_GEN_FILES_DIR)/client-serialice.c \
				../../$(WALTHAM_GEN_FILES_DIR)/client-deserialice.c \
				../../$(WALTHAM_GEN_FILES_DIR)/server-serialice.c \
				../../$(WALTHAM_GEN_FILES_DIR)/server-deserialice.c \
				src/waltham/marshaller.c \
				src/waltham/message.c \
				src/waltham/waltham-connection.c \
				src/waltham/waltham-object.c \
				src/waltham/waltham-util.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src/waltham $(LOCAL_PATH)/../../$(WALTHAM_GEN_FILES_DIR)

include $(BUILD_SHARED_LIBRARY)


# Client

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
		tests/client-api-example.c

LOCAL_MODULE := waltham-client
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
LOCAL_CFLAGS += -Wno-unused-parameter

LOCAL_SHARED_LIBRARIES += libwaltham

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src/waltham $(LOCAL_PATH)/../../$(WALTHAM_GEN_FILES_DIR)

include $(BUILD_EXECUTABLE)

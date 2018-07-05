LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CLANG := true

LOCAL_MODULE := libwaltham

$(warning LOCAL_PATH)
$(warning $(LOCAL_PATH))

LOCAL_PATH_WALTHAM := $(LOCAL_PATH)

tools = \
	$(LOCAL_PATH)/tools/gen.py

core_interface = \
	$(LOCAL_PATH)/data/private.xml \
	$(LOCAL_PATH)/data/public.xml \
	$(LOCAL_PATH)/data/command.xml

core_interface_include := $(addprefix -i ,$(core_interface))

external/waltham/src/waltham/waltham-client.h:
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham//header-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m client \
		-t header

external/waltham/src/waltham/client-serialice.c: external/waltham/src/waltham/waltham-client.h
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/serial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m client \
		-t marshaller

external/waltham/src/waltham/client-deserialice.c: external/waltham/src/waltham/waltham-client.h
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/deserial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m client \
		-t demarshaller

external/waltham/src/waltham/waltham-server.h:
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/header-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m server \
		-t header

external/waltham/src/waltham/server-serialice.c: external/waltham/src/waltham/waltham-server.h
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
		-p $(LOCAL_PATH_WALTHAM)/src/waltham/serial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m server \
		-t marshaller

external/waltham/src/waltham/server-deserialice.c: external/waltham/src/waltham/waltham-server.h
	$(warning $(LOCAL_PATH_WALTHAM))
	$(LOCAL_PATH_WALTHAM)/tools/gen.py \
	-p $(LOCAL_PATH_WALTHAM)/src/waltham/deserial-preamble.txt \
		$(core_interface_include) \
		-o $@ \
		-m server \
		-t demarshaller



LOCAL_SRC_FILES :=	\
				src/waltham/client-serialice.c \
				src/waltham/client-deserialice.c \
				src/waltham/server-serialice.c \
				src/waltham/server-deserialice.c \
				src/waltham/marshaller.c \
				src/waltham/message.c \
				src/waltham/waltham-connection.c \
				src/waltham/waltham-object.c \
				src/waltham/waltham-util.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src/waltham

include $(BUILD_SHARED_LIBRARY)


# Client

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
		tests/client-api-example.c

LOCAL_MODULE := waltham-client

LOCAL_CFLAGS += -Wno-unused-parameter

LOCAL_SHARED_LIBRARIES += libwaltham

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src/waltham

include $(BUILD_EXECUTABLE)

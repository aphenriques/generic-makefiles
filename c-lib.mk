TARGET:=
SRC_DIRS:=. $(wildcard */.)
FILTER_OUT:=
INCLUDE_DIRS:=
SYSTEM_INCLUDE_DIRS:=
LIB_DIRS:=
LDLIBS:=

# '-isystem <dir>' supress warnings from included headers in <dir>. These headers are also excluded from dependency generation
CFLAGS:=-g -O0 -Wall -fPIC $(addprefix -I, $(INCLUDE_DIRS)) $(addprefix -isystem , $(SYSTEM_INCLUDE_DIRS))
ARFLAGS:=rcs
LDFLAGS:=$(addprefix -L, $(LIB_DIRS)) -shared

################################################################################

ifeq ($(shell uname -s),Darwin)
SHARED_LIB_EXTENSION:=dylib
else
SHARED_LIB_EXTENSION:=so
endif

STATIC_LIB:=$(TARGET).a
SHARED_LIB:=$(TARGET).$(SHARED_LIB_EXTENSION)

SRC_DIRS:=$(subst /.,,$(SRC_DIRS))
SRCS:=$(filter-out $(FILTER_OUT), $(wildcard $(addsuffix /*.c, $(SRC_DIRS))))
OBJS:=$(addsuffix .o, $(basename $(SRCS)))
DEPS:=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all static shared clean

all: static shared

static: $(STATIC_LIB)

shared: $(SHARED_LIB)

$(STATIC_LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(SHARED_LIB): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix /*.d, $(SRC_DIRS)) $(addsuffix /*.o, $(SRC_DIRS)) $(STATIC_LIB) $(SHARED_LIB)
#	rm -f $(DEPS) $(OBJS) $(STATIC_LIB) $(SHARED_LIB)

%.d: %.c
	$(CC) $(CFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

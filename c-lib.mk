TARGET=
SRC_DIRS=. $(wildcard */.)
FILTER_OUT=
INCLUDE_DIRS=
LIB_DIRS=
LDLIBS=

CFLAGS=-g -O0 -Wall -fPIC $(addprefix -I, $(INCLUDE_DIRS))
ARFLAGS=rcs
LDFLAGS=-shared $(addprefix -L, $(LIB_DIRS))

################################################################################

ifeq ($(shell uname -s),Darwin)
SHARED_LIB_EXTENSION=dylib
else
SHARED_LIB_EXTENSION=so
endif

STATIC_LIB=$(TARGET).a
SHARED_LIB=$(TARGET).$(SHARED_LIB_EXTENSION)

SRCS=$(filter-out $(join $(dir $(FILTER_OUT)), $(notdir $(FILTER_OUT))), $(wildcard $(addsuffix *.c, $(dir $(SRC_DIRS)))))
OBJS=$(addsuffix .o, $(basename $(SRCS)))
DEPS=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all static shared clean

all: static shared

static: $(STATIC_LIB)

shared: $(SHARED_LIB)

$(STATIC_LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(SHARED_LIB): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix *.d, $(dir $(SRC_DIRS))) $(addsuffix *.o, $(dir $(SRC_DIRS))) $(STATIC_LIB) $(SHARED_LIB)
#	rm -f $(DEPS) $(OBJS) $(STATIC_LIB) $(SHARED_LIB)

%.d: %.c
	$(CC) $(CFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

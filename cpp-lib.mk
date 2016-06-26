TARGET:=
SRC_DIRS:=. $(wildcard */.)
FILTER_OUT:=
INCLUDE_DIRS:=
LIB_DIRS:=
LDLIBS:=

CXXFLAGS:=-g -O0 --std=c++14 -Wall -fPIC $(addprefix -I, $(INCLUDE_DIRS))
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
SRCS:=$(filter-out $(FILTER_OUT), $(wildcard $(addsuffix /*.cpp, $(SRC_DIRS))))
OBJS:=$(addsuffix .o, $(basename $(SRCS)))
DEPS:=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all static shared clean

all: static shared

static: $(STATIC_LIB)

shared: $(SHARED_LIB)

$(STATIC_LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(SHARED_LIB): $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix /*.d, $(SRC_DIRS)) $(addsuffix /*.o, $(SRC_DIRS)) $(STATIC_LIB) $(SHARED_LIB)
#	rm -f $(DEPS) $(OBJS) $(STATIC_LIB) $(SHARED_LIB)

%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

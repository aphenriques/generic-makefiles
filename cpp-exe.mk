TARGET:=
SRC_DIRS:=. $(wildcard */.)
FILTER_OUT:=
INCLUDE_DIRS:=
SYSTEM_INCLUDE_DIRS:=
LIB_DIRS:=
LDLIBS:=

# '-isystem <dir>' supress warnings from included headers in <dir>. These headers are also excluded from dependency generation
CXXFLAGS:=-g -O0 --std=c++14 -Wall $(addprefix -I, $(INCLUDE_DIRS)) $(addprefix -isystem , $(SYSTEM_INCLUDE_DIRS))
LDFLAGS:=$(addprefix -L, $(LIB_DIRS))

################################################################################

SRC_DIRS:=$(subst /.,,$(SRC_DIRS))
SRCS:=$(filter-out $(FILTER_OUT), $(wildcard $(addsuffix /*.cpp, $(SRC_DIRS))))
OBJS:=$(addsuffix .o, $(basename $(SRCS)))
DEPS:=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix /*.d, $(SRC_DIRS)) $(addsuffix /*.o, $(SRC_DIRS)) $(TARGET)
#	rm -f $(DEPS) $(OBJS) $(TARGET)

%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

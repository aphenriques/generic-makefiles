TARGET=
SRC_DIRS=. $(wildcard */.)
FILTER_OUT=
INCLUDE_DIRS=
LIB_DIRS=
LDLIBS=

CXXFLAGS=-g -O0 --std=c++11 -Wall $(addprefix -I, $(INCLUDE_DIRS))
LDFLAGS=$(addprefix -L, $(LIB_DIRS))

################################################################################

SRCS=$(filter-out $(join $(dir $(FILTER_OUT)), $(notdir $(FILTER_OUT))), $(wildcard $(addsuffix *.cpp, $(dir $(SRC_DIRS)))))
OBJS=$(addsuffix .o, $(basename $(SRCS)))
DEPS=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix *.d, $(dir $(SRC_DIRS))) $(addsuffix *.o, $(dir $(SRC_DIRS))) $(TARGET)
#	rm -f $(DEPS) $(OBJS) $(TARGET)

%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

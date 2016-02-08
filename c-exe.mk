TARGET:=
SRC_DIRS:=. $(wildcard */.)
FILTER_OUT:=
INCLUDE_DIRS:=
LIB_DIRS:=
LDLIBS:=

CFLAGS:=-g -O0 -Wall $(addprefix -I, $(INCLUDE_DIRS))
LDFLAGS:=$(addprefix -L, $(LIB_DIRS))

################################################################################

SRCS:=$(filter-out $(FILTER_OUT), $(wildcard $(addsuffix /*.c, $(SRC_DIRS))))
OBJS:=$(addsuffix .o, $(basename $(SRCS)))
DEPS:=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix /*.d, $(SRC_DIRS)) $(addsuffix /*.o, $(SRC_DIRS)) $(TARGET)
#	rm -f $(DEPS) $(OBJS) $(TARGET)

%.d: %.c
	$(CC) $(CFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

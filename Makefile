EXEC = $(shell basename $(shell pwd))
SOURCE = src
BUILD = build

CPPFLAGS = -std=c++1z -stdlib=libc++ -pedantic -fmodules-ts -fprebuilt-module-path=$(BUILD)/$(SOURCE)

SOURCES := $(shell find $(SOURCE) -name *.cpp)
MODULES := $(shell find $(SOURCE) -name *.cppm)
PCMS := $(MODULES:%.cppm=$(BUILD)/%.pcm)
OBJS := $(SOURCES:%.cpp=$(BUILD)/%.o) $(MODULES:%.cppm=$(BUILD)/%.o)

$(BUILD)/%.pcm: %.cppm
	@mkdir -p $(@D)
	$(CXX) $(CPPFLAGS) --precompile $< -o $@

$(BUILD)/%.o: $(BUILD)/%.pcm
	@mkdir -p $(@D)
	$(CXX) $(CPPFLAGS) -c $< -o $@

$(BUILD)/%.o: %.cpp | $(PCMS)
	@mkdir -p $(@D)
	$(CXX) $(CPPFLAGS) -c $< -o $@

$(BUILD)/$(EXEC): $(OBJS)
	@mkdir -p $(@D)
	$(CXX) $(CPPFLAGS) $(OBJS) -o $@

.PRECIOUS: $(BUILD)/%.pcm $(BUILD)/%.o
.PHONY: clean all

all: $(BUILD)/$(EXEC)

clean:
	@rm -rf $(BUILD)

EXEC = mod
SOURCE = src
BUILD = build

CPPFLAGS = -std=c++14 -stdlib=libc++ -pedantic -fmodules-ts -fprebuilt-module-path=$(BUILD)/$(SOURCE)

SOURCES := $(shell find $(SOURCE) -name *.cpp)
MODULES := $(shell find $(SOURCE) -name *.cppm)
PCMS := $(MODULES:%.cppm=$(BUILD)/%.pcm)
OBJS := $(SOURCES:%.cpp=$(BUILD)/%.o) $(MODULES:%.cppm=$(BUILD)/%.o)

$(BUILD)/%.pcm: %.cppm
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) --precompile $< -o $@

$(BUILD)/%.o: $(BUILD)/%.pcm
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) -c $< -o $@

$(BUILD)/%.o: %.cpp $(PCMS)
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) -c $< -o $@

$(BUILD)/$(EXEC): $(OBJS)
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(OBJS) -o $@

.PRECIOUS: $(BUILD)/%.pcm $(BUILD)/%.o
.PHONY: clean

$(shell mkdir -p $(BUILD))

clean:
	rm -rf $(BUILD)

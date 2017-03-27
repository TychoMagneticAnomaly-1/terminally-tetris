# A Makefile based on the Google Test sample Makefile
# https://github.com/google/googletest/blob/master/googletest/make/Makefile
#
# Modified with the help of http://nuclear.mutantstargoat.com/articles/make/
#
# SYNOPSIS:
#
#   make - makes the main file.
#   make clean  - removes all files generated by make.
#   make test - runs all tests

# Create a build directory
BUILD_DIR = build
dummy_build_folder := $(shell mkdir -p $(BUILD_DIR))

# Which compilers to use
CPP=g++ -std=c++11
C=gcc

# Where to find source code.
SRC_DIR = src

# Test code
TEST_DIR = tests

# Where to find build objects
BUILD_DIR = build

# The working directory
CURRENT_DIR = $(shell pwd)

# Dependency header files
DEP_HEADERS = $(SRC_DIR)/*.h
TEST_HEADERS = $(TEST_DIR)/*.h

VPATH = $(SRC_DIR):$(BUILD_DIR)

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread

# C flags
CFLAGS = -std=c99

# Graphics flags
GRAPHICSFLAGS = -lglut -lGL -lGLU

# ncurses flag
LDFLAGS = -lncurses

# The Makefile's run command
RUN = $(BUILD_DIR)/main

# Build targets.
.PHONY: all
all : $(RUN)
	LD_LIBRARY_PATH=$(CURRENT_DIR)/build ./build/main 0

.PHONY: clean
clean :
	rm -f $(BUILD_DIR)/*

.PHONY: test
test :
	LD_LIBRARY_PATH=$(CURRENT_DIR)/build ./build/main 1

# Builds the main file.
OBJ = $(BUILD_DIR)/main.o \
	  $(BUILD_DIR)/utils.o $(BUILD_DIR)/renderer.o \
	  $(BUILD_DIR)/block_factory.o

# ==== Make rules ====

$(BUILD_DIR)/main: $(OBJ)
	$(C) $^ -o $@ $(LDFLAGS) $(CFLAGS)

# Builds the dependency object files.
$(BUILD_DIR)/main.o : $(SRC_DIR)/main.c $(DEP_HEADERS)
	$(C) -c $< -o $@ $(CFLAGS)

# Builds cpp files in src/
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.cpp $(SRC_DIR)/%.h
	$(CPP) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# Builds c files in src/
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.c $(SRC_DIR)/%.h $(DEP_HEADERS)
	$(C) -c $< -o $@ $(CFLAGS)


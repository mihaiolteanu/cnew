#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Please provide the name of the project"
    exit 1
fi

project_name=$1

# Create the folder structure.
mkdir ${project_name} && cd ${project_name}
mkdir src obj include tests

# Create a general makefile with automatic dependency generation
# for the application and normal build for the test cases.
cat > Makefile <<'EOF'
TARGET := main
TARGET_TEST := $(TARGET)_test
CFLAGS += -g
CFLAGS += -std=c99
INC := -Iinclude

# Automatic dependency generation from this link:
# http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
DEPDIR = .d
$(shell mkdir -p $(DEPDIR) >/dev/null)
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

SRCS := $(wildcard src/*.c)
OBJS := $(SRCS:.c=.o)
OBJS := $(subst src, obj, $(OBJS))

TEST_SRCS := $(wildcard tests/*.c)
TEST_OBJS := $(TEST_SRCS:.c=.o)

obj/%.o : src/%.c
	$(COMPILE.c) $(DEPFLAGS) $(INC) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

# No automatic dependency for test files.
tests/%.o : tests/%.c
	$(COMPILE.c) $(INC) $(OUTPUT_OPTION) $<

all: $(TARGET) $(TARGET_TEST)

$(TARGET): $(OBJS)
	$(LINK.o) -o $@ $^

# The target usually has a source file with the target's name that contains a
# main method. Remove that, as the test target also has a main method.
OBJS_MINUS_TARGET := $(filter-out obj/$(TARGET).o, $(OBJS))
$(TARGET_TEST): $(OBJS_MINUS_TARGET) $(TEST_OBJS)
	$(LINK.o) -o $@ $^

-include $(DEPDIR)/*.d

clean:
	@rm -rf $(TARGET) $(OBJS) $(TEST_OBJS) $(TARGET_TEST) $(DEPDIR)
EOF

# Create a sample application
cat > src/main.c <<'EOF'
#include <stdio.h>
#include "add.h"

int main(int argc, char *argv[]) {
        int res = add(2, 3);
        
        printf("%d\n", res);
        return 0;
}
EOF

cat > src/add.c <<'EOF'
int add(int a, int b) {
        return a + b;
}
EOF

cat > include/add.h <<'EOF'
extern int add(int a, int b);
EOF

cat > tests/test_main.c <<'EOF'
#include <stdio.h>
#include "test_main.h"

int main(void) {
        run_all_add_tests();

        printf("All add tests passed\n");
}
EOF

cat > tests/test_main.h <<'EOF'
#ifndef TESTS_MAIN_H
#define TESTS_MAIN_H

extern void run_all_add_tests();

#endif // TESTS_MAIN_H
EOF

# Add some sample tests for the add functionp
cat > tests/test_add.c <<'EOF'
#include <assert.h>
#include "add.h"

// Test functions
static void test_add_positive();
static void test_add_negative();
static void test_add_zero();

void run_all_add_tests() {
        test_add_positive();
        test_add_negative();
        test_add_zero();
}

static void test_add_positive() {
        int a = 5;
        int b = 10;
        int exp = 15;
        int res = add(a, b);
        assert(res == exp);
}
static void test_add_negative() {
        int a = -3;
        int b = -2;
        int exp = -5;
        int res = add(a, b);
        assert(res == exp);
}

static void test_add_zero() {
        int a = 0;
        int b = 2;
        int exp = 2;
        int res = add(a, b);
        assert(res == exp);
}
EOF

# Add a gitignore file.
cat > .gitignore <<'EOF'
###For C
# Object files
*.o
*.ko
*.obj
*.elf

# Precompiled Headers
*.gch
*.pch

# Libraries
*.lib
*.a
*.la
*.lo

# Shared objects (inc. Windows DLLs)
*.dll
*.so
*.so.*
*.dylib

# Executables
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex

# Debug files
*.dSYM/


###For Emacs
*~
[#]*[#]
.\#*

TAGS

# For stackdumps
*.stackdump

# Autogenerated dependency folder
.d
EOF

# Init a new git project
git init 
git add .gitignore Makefile include src tests
git commit -m "Initial commit"

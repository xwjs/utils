#! /usr/bin/bash

kill_port()
{
    local port="$1"

    if [ ! -n "$1" ];then
        echo "doesnet has any port"
        return 1
    fi

    local pids=$(lsof -ti :$port)

    if [ -z "$pids" ];then
        echo "no any process running in port $port"
    fi

    for pid in $pids;do
        echo "kill process : $pid"
        kill -9 "$pid"
    done
}

project()
{
    local pwd=$(pwd)
    mkdir -p $pwd/include $pwd/lib $pwd/output $pwd/src

echo '#include <iostream>

#define UNUSED(x) (void)(x)

int main(int argc, char *argv[])
{
    UNUSED(argc),UNUSED(argv);
    
    return 0;
}
' >> $pwd/src/main.cpp

echo '
# define the Cpp compiler to use
CXX = g++

# define any compile-time flags
CXXFLAGS        := -std=c++17 -Wall -Wextra -pedantic -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -g

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib Id specify
#   their path using -Lpath, something like:
LFLAGS =

# define output directory
OUTPUT  := output

# define source directory
SRC             := src

# define include directory
INCLUDE := include

# define lib directory
LIB             := lib

ifeq ($(OS),Windows_NT)
MAIN    := main.exe
SOURCEDIRS      := $(SRC)
INCLUDEDIRS     := $(INCLUDE)
LIBDIRS         := $(LIB)
FIXPATH = $(subst /,\,$1)
RM                      := del /q /f
MD      := mkdir
else
MAIN    := main
SOURCEDIRS      := $(shell find $(SRC) -type d)
INCLUDEDIRS     := $(shell find $(INCLUDE) -type d)
LIBDIRS         := $(shell find $(LIB) -type d)
FIXPATH = $1
RM = rm -f
MD      := mkdir -p
endif

# define any directories containing header files other than /usr/include
INCLUDES        := $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))

# define the C libs
LIBS            := $(patsubst %,-L%, $(LIBDIRS:%/=%))

# define the C source files
SOURCES         := $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))

# define the C object files
OBJECTS         := $(SOURCES:.cpp=.o)

# define the dependency output files
DEPS            := $(OBJECTS:.o=.d)

#
# The following part of the makefile is generic; it can be used to
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from make depend
#

OUTPUTMAIN      := $(call FIXPATH,$(OUTPUT)/$(MAIN))

all: $(OUTPUT) $(MAIN)
        @echo Executing all complete!

$(OUTPUT):
        $(MD) $(OUTPUT)

$(MAIN): $(OBJECTS)
        $(CXX) $(CXXFLAGS) $(INCLUDES) -o $(OUTPUTMAIN) $(OBJECTS) $(LFLAGS) $(LIBS)

# include all .d files
-include $(DEPS)

# this is a suffix replacement rule for building .os and .ds from .cs
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file)
# -MMD generates dependency output files same name as the .o file
# (see the gnu make manual section about automatic variables)
.cpp.o:
        $(CXX) $(CXXFLAGS) $(INCLUDES) -c -MMD $<  -o $@

.PHONY: clean
clean:
        $(RM) $(OUTPUTMAIN)
        $(RM) $(call FIXPATH,$(OBJECTS))
        $(RM) $(call FIXPATH,$(DEPS))
        @echo Cleanup complete!

run: all
        ./$(OUTPUTMAIN)
        @echo Executing run: all complete!
' >> $pwd/Makefile
}

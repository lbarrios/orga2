UNAME:=$(shell uname)
CC = gcc
ASM = nasm
DBG = gdb
CFLAGS64 = -ggdb -Wall -std=c99 -pedantic -m64 -D__OS__=$(UNAME)
ASMFLAGS64 = -felf64 -g -F dwarf
CFLAGS   = $(CFLAGS64)
ASMFLAGS = $(ASMFLAGS64)

ifeq ($(UNAME),Linux)
	UBUNTU = $(shell lsb_release -sd)
else
	UBUNTU:=no
endif

OPENCV_LIB = `pkg-config --cflags --libs opencv`

BIN = tp2
BIN_DIR = ../bin



#popart_c.o popart.o \

COBJS = tp2.o cli.o utils.o \
	tiles_c.o tiles.o \
	popart_c2.o popart.o \
	ldr_c.o ldr.o \
	temperature_c.o temperature.o
COBJS1 := $(addsuffix .1,${COBJS}) opencv_wrapper.o
COBJS2 := $(addsuffix .2,${COBJS}) opencv_wrapper.o
COBJS3 := $(addsuffix .3,${COBJS}) opencv_wrapper.o

COBJS := $(COBJS) opencv_wrapper.o

ASMOBJS = tiles_asm.o \
	popart_asm.o \
	ldr_asm.o \
	temperature_asm.o

OBJS = $(COBJS) $(ASMOBJS)
OBJS1 = $(COBJS1) $(ASMOBJS)
OBJS2 = $(COBJS2) $(ASMOBJS)
OBJS3 = $(COBJS3) $(ASMOBJS)
# OBJS = $(COBJS) tmp.o

.PHONY: all clean

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(OPENCV_LIB) -lm
	cp $(BIN) $(BIN_DIR)/$(BIN).O0

$(BIN).O1: $(OBJS1)
	$(CC) $(CFLAGS) -O1 $(OBJS1) -o $@ $(OPENCV_LIB) -lm
	cp $(BIN).O1 $(BIN_DIR)/$(BIN).O1

$(BIN).O2: $(OBJS2)
	$(CC) $(CFLAGS) -O2 $(OBJS2) -o $@ $(OPENCV_LIB) -lm
	cp $(BIN).O2 $(BIN_DIR)/$(BIN).O2

$(BIN).O3: $(OBJS3)
	$(CC) $(CFLAGS) -O3 $(OBJS3) -o $@ $(OPENCV_LIB) -lm
	cp $(BIN).O3 $(BIN_DIR)/$(BIN).O3

opencv_wrapper.o: opencv_wrapper.c
	$(CC) $(CFLAGS) -c -o $@ $< $(OPENCV_LIB)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< -lm
%.o.1: %.c
	$(CC) $(CFLAGS) -O1 -c -o $@ $< -lm
%.o.2: %.c
	$(CC) $(CFLAGS) -O2 -c -o $@ $< -lm
%.o.3: %.c
	$(CC) $(CFLAGS) -O3 -c -o $@ $< -lm

%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

all: $(BIN) $(BIN).O1 $(BIN).O2 $(BIN).O3

clean:
	rm -f $(OBJS)
	rm -f $(OBJS1)
	rm -f $(OBJS2)
	rm -f $(OBJS3)
	rm -f ./$(BIN) ./$(BIN).O1 ./$(BIN).O2 ./$(BIN).O3
	rm -f $(BIN_DIR)/$(BIN).O0 $(BIN_DIR)/$(BIN).O1 $(BIN_DIR)/$(BIN).O2 $(BIN_DIR)/$(BIN).O3


installopencv:
	sudo apt-get install libcv-dev libhighgui-dev libcvaux-dev libc6-dev
ifeq "Ubuntu 13.10" "${UBUNTU}"
	sudo cp opencv1310.pc /usr/lib/pkgconfig/opencv.pc
endif



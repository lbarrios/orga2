#!/usr/bin/env bash
MAKE=gmake
BOCHS=bochs

$MAKE --makefile=Makefile.bsd clean && $MAKE --makefile=Makefile.bsd && $BOCHS -f bochsrc.bsd

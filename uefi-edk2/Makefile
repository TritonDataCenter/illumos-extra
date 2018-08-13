#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2018 Joyent, Inc.
#


VER =	uefi-edk2-a36132939e

include ../Makefile.defs

PATCHES =		Patches/*
UNPACK_SENTINEL =	edksetup.sh

include ../Makefile.targ

STRAPPROTO=	$(PWD)/../../../proto.strap
MAKE_ARGS+=	AS=$(STRAPPROTO)/usr/gnu/bin/gas \
		AR=$(STRAPPROTO)/usr/gnu/bin/gar \
		LD=$(STRAPPROTO)/usr/gnu/bin/gld \
		OBJCOPY=$(STRAPPROTO)/usr/gnu/bin/gobjcopy \
		CC=$(STRAPPROTO)/usr/bin/gcc \
		CXX=$(STRAPPROTO)/usr/bin/g++

ARCH=		X64
UEFI_TARGET=	RELEASE

ROMS=		uefi uefi-csm

.NOTPARALLEL: $(ROMS) csm16

all: $(ROMS)

basetools: $(VER.64)/$(UNPACK_SENTINEL)
	mkdir -p $(VER.64)/Build
	ln -sf $(STRAPPROTO)/usr/bin/gcc $(VER.64)/Build/gcc
	ln -sf $(STRAPPROTO)/usr/gnu/bin/gld $(VER.64)/Build/ld
	ln -sf /opt/local/bin/gmake $(VER.64)/Build/make
	ln -sf $(STRAPPROTO)/usr/gnu/bin/gar $(VER.64)/Build/ar
	ln -sf $(STRAPPROTO)/usr/gnu/bin/gobjcopy $(VER.64)/Build/objcopy
	ln -sf /opt/local/bin/nasm $(VER.64)/Build/nasm
	$(MAKE) $(MAKE_ARGS) ARCH=$(ARCH) -C $(VER.64)/BaseTools

csm16:
	bash -c "cd $(VER.64); \
		source edksetup.sh; \
		$(MAKE) $(MAKE_ARGS) ARCH=$(ARCH) -C BhyvePkg/Csm/BhyveCsm16"

uefi-csm: csm16

$(ROMS): basetools
	rm -rf $(VER.64)/Build/BhyveX64
	bash -c 'cd $(VER.64); \
		source edksetup.sh; \
		export ILGCC_BIN=$(PWD)/$(VER.64)/Build/; \
		[[ $@ == uefi-csm ]] && extra_cflags=-DCSM_ENABLE=TRUE; \
		build -t ILGCC -a $(ARCH) -b $(UEFI_TARGET) \
			-p BhyvePkg/BhyvePkgX64.dsc \
			-DDEBUG_ON_SERIAL_PORT=TRUE -DFD_SIZE_1MB \
			$${extra_cflags}'
	mv $(VER.64)/Build/BhyveX64/RELEASE_ILGCC/FV/BHYVE.fd \
		$(VER.64)/Build/$@-rom.bin

install: all
	mkdir -p $(DESTDIR)/usr/share/bhyve
	for rom in $(ROMS); do \
		/usr/sbin/install -m 0755 -f $(DESTDIR)/usr/share/bhyve \
		    $(VER.64)/Build/$$rom-rom.bin; \
	done

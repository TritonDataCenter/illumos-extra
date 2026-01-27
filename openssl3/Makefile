#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright (c) 2009, 2010, Oracle and/or its affiliates. All rights reserved.
# Copyright 2022 Joyent, Inc.
# Copyright 2025 MNX Cloud, Inc.
# Copyright 2026 Edgecast Cloud LLC.
#

VER = openssl-3.0.19
LIBVER =	3

include ../Makefile.defs

SHELL =		/bin/bash
BUILD64 =	yes
UNPACK_SENTINEL =	Configure
AUTOCONF_OUT =	include/openssl/conf.h

MT_CPPFLAGS =	-D_REENTRANT
SHARED_CFLAGS =	-fPIC -DPIC
SHARED_LDFLAGS =	-fPIC -shared

CHECK_LIBS = \
	$(VER.32)/libcrypto-smartos.so.$(LIBVER) \
	$(VER.32)/libssl-smartos.so.$(LIBVER) \
	$(VER.64)/libcrypto-smartos.so.$(LIBVER) \
	$(VER.64)/libssl-smartos.so.$(LIBVER)

#
# There are races between the building of assembly language sources and
# the assembly of those files.  Disable parallel build.
#
PARALLEL =

CPPFLAGS += \
	-DSOLARIS_OPENSSL \
	-DNO_WINDOWS_BRAINDEATH

CFLAGS += \
	-O3 \
	-march=pentium \
	-Wall \
	-Werror \
	-DPK11_LIB_LOCATION=\\"/usr/lib/libpkcs11.so.1\\"

CFLAGS.64 += \
	-O3 \
	-Wall \
	-Werror \
	-DPK11_LIB_LOCATION=\\"/usr/lib/64/libpkcs11.so.1\\"

CFLAGS += -Wno-stringop-truncation -Wno-stringop-overflow
CFLAGS.64 += -Wno-stringop-truncation -Wno-stringop-overflow

LIBS +=	-lsocket -lnsl

ifeq ($(STRAP),strap)
	LDFLAGS +=	$(SYSLIBDIRS:%=-R$(DESTDIR)/%)
	LDFLAGS.64 +=	$(SYSLIBDIRS:%=-R$(DESTDIR)/%/64)
endif

PATCHES =	Patches/*

AUTOCONF_ENV =
AUTOCONF_OPTS += \
	--api=1.1.1 \
	--openssldir=/etc/openssl \
	no-rc5 \
	no-mdc2 \
	no-idea \
	enable-md2 \
	threads \
	shared

AUTOCONF_OPTS.32 += \
	smartos-x86-gcc

AUTOCONF_OPTS.64 += \
	smartos64-x86_64-gcc

#$(PKCS11_DST.32)/%: engine_pkcs11/%
#	cp $< $@

#$(PKCS11_DST.64)/%: engine_pkcs11/%
#	cp $< $@

$(VER.32)/%: %
	cp $< $@

$(VER.64)/%: %
	cp $< $@

$(VER.32)/include/openssl/%: %
	cp $< $@

$(VER.64)/include/openssl/%: %
	cp $< $@

$(VER.32)/configure: $(VER.32)/Configure Makefile $(VER.32)/include/openssl/sunw_prefix.h
	sed -e 's#@@CC@@#$(GCC.32)#g' \
	    -e 's#@@CPPFLAGS@@#$(CPPFLAGS)#g' \
	    -e 's#@@CFLAGS@@#$(CFLAGS)#g' \
	    -e 's#@@MT_CPPFLAGS@@#$(MT_CPPFLAGS)#g' \
	    -e 's#@@LDFLAGS@@#$(LDFLAGS)#g' \
	    -e 's#@@LIBS@@#$(LIBS)#g' \
	    -e 's#@@SHARED_CFLAGS@@#$(SHARED_CFLAGS)#g' \
	    -e 's#@@SHARED_LDFLAGS@@#$(SHARED_LDFLAGS)#g' < $< > $@
	chmod +x $@

$(VER.64)/configure: $(VER.64)/Configure Makefile $(VER.64)/include/openssl/sunw_prefix.h
	sed -e 's#@@CC@@#$(GCC.64)#g' \
	    -e 's#@@CPPFLAGS@@#$(CPPFLAGS)#g' \
	    -e 's#@@CFLAGS@@#$(CFLAGS.64)#g' \
	    -e 's#@@MT_CPPFLAGS@@#$(MT_CPPFLAGS)#g' \
	    -e 's#@@LDFLAGS@@#$(LDFLAGS.64)#g' \
	    -e 's#@@LIBS@@#$(LIBS)#g' \
	    -e 's#@@SHARED_CFLAGS@@#$(SHARED_CFLAGS)#g' \
	    -e 's#@@SHARED_LDFLAGS@@#$(SHARED_LDFLAGS)#g' < $< > $@
	chmod +x $@

all: all_autoconf

.PHONY: check
check: $(CHECK_LIBS)
	./tools/checksyms.bash $(CHECK_LIBS)

$(CHECK_LIBS): all

install_32: all check
	DESTDIR=$(DESTDIR) VERDIR=$(VER.32) LIBVER=$(LIBVER) \
	    ksh93 ./install-sfw

install_64: all check
	DESTDIR=$(DESTDIR) VERDIR=$(VER.64) LIBVER=$(LIBVER) \
	    ksh93 ./install-sfw-64

install: install_32 install_64

include ../Makefile.targ

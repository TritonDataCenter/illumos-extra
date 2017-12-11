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
# Copyright (c) 2017, Joyent, Inc.
#

VER = openssl-1.0.2n
LIBVER =	1.0.0

include ../Makefile.defs

SHELL =		/bin/bash
BUILD64 =	yes
UNPACK_SENTINEL =	Configure
AUTOCONF_OUT =	crypto/opensslconf.h

MT_CPPFLAGS =	-D_REENTRANT
SHARED_CFLAGS =	-fPIC -DPIC
SHARED_LDFLAGS =	-fPIC -shared

PKCS11_SRCS = \
	hw_pk11_err.c \
	hw_pk11_err.h \
	hw_pk11_pub.c \
	hw_pk11_uri.c \
	hw_pk11_uri.h \
	hw_pk11.c \
	hw_pk11.h

PKCS11_DST.32 =	$(VER.32)/crypto/engine
PKCS11_DST.64 = $(VER.64)/crypto/engine

PKCS11.32 =	$(PKCS11_SRCS:%=$(PKCS11_DST.32)/%)
PKCS11.64 =	$(PKCS11_SRCS:%=$(PKCS11_DST.64)/%)

CHECK_LIBS = \
	$(VER.32)/libsunw_crypto.so.$(LIBVER) \
	$(VER.32)/libsunw_ssl.so.$(LIBVER) \
	$(VER.64)/libsunw_crypto.so.$(LIBVER) \
	$(VER.64)/libsunw_ssl.so.$(LIBVER)

#
# There are races between the building of assembly language sources and
# the assembly of those files.  Disable parallel build.
#
PARALLEL =

CPPFLAGS += \
	-DSOLARIS_OPENSSL \
	-DNO_WINDOWS_BRAINDEATH \
	-include openssl/sunw_prefix.h

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

LIBS +=	-lsocket -lnsl

ifeq ($(STRAP),strap)
	LDFLAGS +=	$(SYSLIBDIRS:%=-R$(DESTDIR)/%)
	LDFLAGS.64 +=	$(SYSLIBDIRS:%=-R$(DESTDIR)/%/64)
endif

PATCHES =	Patches/*

AUTOCONF_ENV =
AUTOCONF_OPTS += \
	--openssldir=/etc/openssl \
	--install_prefix=$(DESTDIR) \
	no-rc3 \
	no-rc5 \
	no-mdc2 \
	no-idea \
	no-hw_4758_cca \
	no-hw_aep \
	no-hw_atalla \
	no-hw_chil \
	no-hw_gmp \
	no-hw_ncipher \
	no-hw_nuron \
	no-hw_padlock \
	no-hw_sureware \
	no-hw_ubsec \
	no-hw_cswift \
	enable-md2 \
	threads \
	shared

AUTOCONF_OPTS.32 += \
	smartos-x86-gcc

AUTOCONF_OPTS.64 += \
	smartos64-x86_64-gcc

$(PKCS11_DST.32)/%: engine_pkcs11/%
	cp $< $@

$(PKCS11_DST.64)/%: engine_pkcs11/%
	cp $< $@

$(VER.32)/%: %
	cp $< $@

$(VER.64)/%: %
	cp $< $@

$(VER.32)/configure: $(VER.32)/Configure Makefile $(PKCS11.32) \
    $(VER.32)/sunw_prefix.h
	sed -e 's#@@CC@@#$(GCC)#g' \
	    -e 's#@@CPPFLAGS@@#$(CPPFLAGS)#g' \
	    -e 's#@@CFLAGS@@#$(CFLAGS)#g' \
	    -e 's#@@MT_CPPFLAGS@@#$(MT_CPPFLAGS)#g' \
	    -e 's#@@LDFLAGS@@#$(LDFLAGS)#g' \
	    -e 's#@@LIBS@@#$(LIBS)#g' \
	    -e 's#@@SHARED_CFLAGS@@#$(SHARED_CFLAGS)#g' \
	    -e 's#@@SHARED_LDFLAGS@@#$(SHARED_LDFLAGS)#g' < $< > $@
	chmod +x $@

$(VER.64)/configure: $(VER.64)/Configure Makefile $(PKCS11.64) \
    $(VER.64)/sunw_prefix.h
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

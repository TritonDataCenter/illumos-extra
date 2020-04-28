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
# Copyright 2020 Joyent, Inc.
#

VER =	nss-3.25

include ../Makefile.defs

NSPRVER =	nspr-4.12
TARBALL =	$(VER)-with-$(NSPRVER).tar.gz

# FIXME: gcc9
XCFLAGS = -Wno-unused -Wno-int-in-bool-context -Wno-stringop-truncation


AUTOCONF_CPPFLAGS =
UNPACK_SENTINEL =	.stamp
FROB_SENTINEL.32 =	/bin/true
FROB_SENTINEL.64 =	/bin/true

PATCHES =	Patches/*

include ../Makefile.targ

all: all_32 all_64

all_32: $(VER.32)/$(UNPACK_SENTINEL)
	(cd $(VER.32)/nss; \
	    PATH=$(PATH) \
	    gmake BUILD_OPT=1 BUILD_SUN_PKG=1 NS_USE_GCC=1 NO_MDUPDATE=1 \
	    NSPR_CONFIGURE_ENV="CC=\"$(GCC.32)\" CXX=\"$(CXX.32)\"" \
	    CC="$(GCC.32)" CXX="$(GXX.32)" AS="$(GCC.32)" \
	    CPPFLAGS="$(CPPFLAGS)" XCFLAGS="$(XCFLAGS)" LDFLAGS="$(LDFLAGS)" \
	    NSS_DISABLE_GTESTS=1 nss_build_all )

all_64: $(VER.64)/$(UNPACK_SENTINEL)
	(cd $(VER.64)/nss; \
	    PATH=$(PATH) \
	    gmake USE_64=1 BUILD_OPT=1 BUILD_SUN_PKG=1 NS_USE_GCC=1 \
	    NSPR_CONFIGURE_ENV="CC=\"$(GCC.64)\" CXX=\"$(CXX.64)\"" \
	    CC="$(GCC.64)" CXX="$(GXX.64)" AS="$(GCC.64)" \
	    CPPFLAGS="$(CPPFLAGS)" XCFLAGS="$(XCFLAGS)" \
	    LDFLAGS="$(LDFLAGS.64)" \
	    NSS_DISABLE_GTESTS=1 NO_MDUPDATE=1 nss_build_all )

install: all
	DESTDIR=$(DESTDIR) ksh93 ./install-nss $(VER.32)
	DESTDIR=$(DESTDIR) MACH64=amd64 ksh93 ./install-nss-64 $(VER.64)

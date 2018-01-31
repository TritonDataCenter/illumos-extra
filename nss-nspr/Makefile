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

VER =	nss-3.25

include ../Makefile.defs

NSPRVER =	nspr-4.12
TARBALL =	$(VER)-with-$(NSPRVER).tar.gz

AUTOCONF_CPPFLAGS =
UNPACK_SENTINEL =	.stamp
FROB_SENTINEL.32 =	/bin/true
FROB_SENTINEL.64 =	/bin/true

PATCHES =	Patches/*

include ../Makefile.targ

all: all_32 all_64

all_32: $(VER.32)/$(UNPACK_SENTINEL)
	@ (cd $(VER.32)/nss; \
	    PATH=$(PATH) \
	    gmake BUILD_OPT=1 BUILD_SUN_PKG=1 NS_USE_GCC=1 NO_MDUPDATE=1 \
	    CC="$(GCC)" CXX="$(GXX)" CPPFLAGS="$(CPPFLAGS)" \
	    LDFLAGS="$(LDFLAGS)" NSS_DISABLE_GTESTS=1 nss_build_all )

all_64: $(VER.64)/$(UNPACK_SENTINEL)
	@ (cd $(VER.64)/nss; \
	    PATH=$(PATH) \
	    gmake USE_64=1 BUILD_OPT=1 BUILD_SUN_PKG=1 NS_USE_GCC=1 \
	    CC="$(GCC.64)" CXX="$(GXX.64)" CPPFLAGS="$(CPPFLAGS)" \
	    LDFLAGS="$(LDFLAGS.64)" NSS_DISABLE_GTESTS=1 NO_MDUPDATE=1 \
	    nss_build_all )

install: all
	DESTDIR=$(DESTDIR) ksh93 ./install-nss $(VER.32)
	DESTDIR=$(DESTDIR) MACH64=amd64 ksh93 ./install-nss-64 $(VER.64)
	# Apology in advance; see OS-6582 for why we're doing this.
	if [[ ! -f $(DESTDIR)/usr/include/zconf.h.orig ]]; then \
		cp $(DESTDIR)/usr/include/zconf.h \
		   $(DESTDIR)/usr/include/zconf.h.orig; \
		$(GPATCH) -d $(DESTDIR)/usr/include -p$(PATCHSTRIP) \
		    <zconf.patch; \
	fi

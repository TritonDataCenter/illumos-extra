#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at COPYING
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at COPYING.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright (c) 2012, Joyent, Inc.  All rights reserved.
#

VER =	nss-3.12.8

include ../Makefile.defs

NSPRVER =	nspr-4.8.6
TARBALL =	$(VER)-with-$(NSPRVER).tar.gz

UNPACK_SENTINEL =	.stamp
FROB_SENTINEL.32 =	/bin/true
FROB_SENTINEL.64 =	/bin/true

include ../Makefile.targ

all: all_32 all_64

all_32: $(VER.32)/$(UNPACK_SENTINEL)
	@ (cd $(VER.32)/mozilla/security/nss; \
	    PATH=$(PATH) \
	    gmake BUILD_OPT=1 BUILD_SUN_PKG=1 NS_USE_GCC=1 NO_MDUPDATE=1 \
	    nss_build_all )

all_64: $(VER.64)/$(UNPACK_SENTINEL)
	@ (cd $(VER.64)/mozilla/security/nss; \
	    PATH=$(PATH) \
	    gmake USE_64=1 BUILD_OPT=1 BUILD_SUN_PKG=1 NS_USE_GCC=1 \
	    NO_MDUPDATE=1 nss_build_all )

install: all
	DESTDIR=$(DESTDIR) ksh93 ./install-nss $(VER.32)
	DESTDIR=$(DESTDIR) MACH64=amd64 ksh93 ./install-nss-64 $(VER.64)

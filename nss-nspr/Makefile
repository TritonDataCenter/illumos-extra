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
# Copyright (c) 2010 Joyent Inc.
#

VER=nss-3.12.8
VER64=$(VER)-64
NSPRVER=nspr-4.8.6
TARBALL=$(VER)-with-$(NSPRVER).tar.gz
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
all: real-all

all32: $(VER)/.stamp
	@ (cd $(VER)/mozilla/security/nss; \
	    gmake BUILD_OPT=1 NS_USE_GCC=1 NO_MDUPDATE=1 nss_build_all )

all64: $(VER64)/.stamp
	@ (cd $(VER64)/mozilla/security/nss; \
	    gmake USE_64=1 BUILD_OPT=1 NS_USE_GCC=1 NO_MDUPDATE=1 nss_build_all )

install: all
	DESTDIR=$(DESTDIR) ksh93 ./install-nss $(VER)
	DESTDIR=$(DESTDIR) MACH64=amd64 ksh93 ./install-nss-64 $(VER64)

real-all: all32 all64

$(VER)/.stamp $(VER64)/.stamp: $(TARBALL)
	gzip -dc $(TARBALL) | tar xopf -
	mv $(VER) $(VER64)
	gzip -dc $(TARBALL) | tar xopf -
	touch $(VER)/.stamp
	touch $(VER64)/.stamp

clean:
	-rm -rf $(VER)
	-rm -rf $(VER64)


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
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright (c) 2018, Joyent, Inc.  All rights reserved.
#

VER =	gcc-4.4.4
MPFR_VER =	mpfr-3.1.2
GMP_VER =	gmp-5.1.1
PREFIX =	/usr/gcc/4

include ../Makefile.defs

SEPARATE_BUILD =	yes

GCC =	/opt/local/bin/gcc
GXX =	/bin/false
CFLAGS =	-nostdinc -isystem /usr/include -g -O2

AUTOCONF_PREFIX = $(PREFIX)

AUTOCONF_OPTS += \
	--with-ld=/usr/bin/ld \
	--without-gnu-ld \
	--with-gnu-as \
	--with-as=$(DESTDIR)/usr/gnu/bin/gas \
	--enable-languages="c,c++" \
	--enable-shared \
	--disable-nls

AUTOCONF_ENV += \
	DESTDIR=$(DESTDIR) \
	MAKE=$(MAKE)

OVERRIDES += \
	$(AUTOCONF_CFLAGS) \
	STAGE1_CFLAGS="$(CFLAGS)" \
	CFLAGS_FOR_TARGET="$(CFLAGS)"

#
# Because we use a different build directory, we need to make sure we
# catch that when cleaning.
#
CLEANFILES += $(VER)-32.build $(VER)-32strap.build

#
# Unlike everything else, gcc is built to be a cross-compiler, really.  It
# never runs on the target system, only the build system.  So it should not
# be using the proto area's headers or libraries.  Its own libraries will be
# built by the new compiler, and generally aren't using system headers anyway.
# This is not really completely true; for example, libstdc++.  This will
# need more work to be really right.  We only deliver the libraries.
#
AUTOCONF_CPPFLAGS =
AUTOCONF_LIBS =
GENLDFLAGS =

PATCHES =	Patches/*
ALL_TGT =	bootstrap

include ../Makefile.targ
include ../Makefile.targ.autoconf

#
# We could use the mpfr and gmp from the build system (since the compiler will
# be run here), but there's no good way to make gcc build itself correctly if
# we do.  There are two main problems:
#
# 1. Stage2 and later cc1 and company don't honour any combination of LDFLAGS,
# LDFLAGS_FOR_TARGET, BOOT_LDFLAGS, STAGE2_LDFLAGS, etc.  The only ways to
# get these things built with -R/opt/local/lib are to use LD_OPTIONS, which will
# yield the wrong results for libraries, or to hack configure.
#
# 2. Even if we could get -R/opt/local/lib into these programs without building
# the libraries incorrectly, it would still be wrong.  The pkgsrc lib directory
# on many systems contains libgcc_s.so.1; however, cc1 was built by the stage2
# compiler and should find the libgcc that matches that compiler.  That happens
# to be the one we just built, not the pkgsrc one.
#
# Instead we have mpfr and gmp built as part of the gcc build itself.
#
$(AUTOCONF_OUT.32): | $(VER.32)/mpfr $(VER.32)/gmp

$(VER.32)/mpfr: $(MPFR_VER).tar.gz | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -z --no-same-owner -f $(MPFR_VER).tar.gz
	mv -f .unpack32/$(MPFR_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

$(VER.32)/gmp: $(GMP_VER).tar.bz2 | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -j --no-same-owner -f $(GMP_VER).tar.bz2
	mv -f .unpack32/$(GMP_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

LIBTAR=$(STRAPPROTO)/gcclibs.tar.gz

ifeq ($(STRAP),strap)

#
# The runtime libraries that we build into proto.strap should be made to search
# for their dependencies there as well, so that programs built to run on the
# build machine (from proto.strap) find the correct copies of these libraries.
# (Currently, this is only relevant for libstdc++.)
#
# Before we do so, however, we'll keep copies for the non-strap build to pick
# up.
#
# We should also remove the "fixed" includes: they are just bad copies of the
# potentially old system headers.
#
FIXLIBS = libgcc_s.so libstdc++.so libssp.so
LIBDIR=$(DESTDIR)/$(PREFIX)/lib

.PHONY: strapfix
strapfix:
	[[ -h $(LIBDIR)/64 ]] || ln -s amd64 $(LIBDIR)/64
ifeq ($(PRIMARY_COMPILER),gcc4)
	mkdir -p $(DESTDIR)/usr/bin
	for f in gcc g++ cpp; do \
		ln -sf $(DESTDIR)/$(PREFIX)/bin/$$f $(DESTDIR)/usr/bin/$$f; \
	done
	rm -f $(LIBTAR)
	for lib in $(FIXLIBS); do \
		(cd $(LIBDIR)/.. && gtar uvf $(LIBTAR) \
		    lib/$$lib.* lib/64/$$lib.*) ; \
	done
endif
	find $(LIBDIR) -name include-fixed | xargs rm -rf
	for lib in $(FIXLIBS); do \
		/usr/bin/elfedit -e 'dyn:runpath $(LIBDIR)' $(LIBDIR)/$$lib ; \
		/usr/bin/elfedit -e 'dyn:runpath $(LIBDIR)/64' \
		    $(LIBDIR)/64/$$lib ; \
	done


else

#
# A non-strap build: do not install anything other than our saved copy of the
# runtime libraries. This should only happen for the primary compiler.
#
.PHONY: fixup
fixup:
	cd $(DESTDIR)/usr && gtar xvf $(LIBTAR)

endif

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
# Copyright (c) 2018, Joyent, Inc.
#

VER =		gcc-6.4.0
MPFR_VER =	mpfr-3.1.6
GMP_VER =	gmp-6.1.2
MPC_VER =	mpc-1.0.3
PREFIX =	/usr/gcc/6

include ../Makefile.defs

SEPARATE_BUILD =	yes

GCC =	/opt/local/bin/gcc
GXX =	/opt/local/bin/g++
CFLAGS = -g -O2

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
# When building the strap code, it needs to exist in a different prefix.
#
ifeq ($(STRAP),strap)
AUTOCONF_PREFIX = $(PREFIX)
endif

#
# The runtime libraries that we build into proto.strap should be made to search
# for their dependencies there as well, so that programs built to run on the
# build machine (from proto.strap) find the correct copies of these libraries.
#
ifeq ($(STRAP),strap)
	STRAPFIX_LINKS= \
		$(DESTDIR)/$(PREFIX)/lib/64
	STRAPFIX_FILES_32 = \
		$(DESTDIR)/$(PREFIX)/lib/libgcc_s.so.1 \
		$(DESTDIR)/$(PREFIX)/lib/libstdc++.so.6
	STRAPFIX_FILES_64 = \
		$(DESTDIR)/$(PREFIX)/lib/64/libgcc_s.so.1 \
		$(DESTDIR)/$(PREFIX)/lib/64/libstdc++.so.6
	STRAPFIX_FILES = $(STRAPFIX_FILES_32) $(STRAPFIX_FILES_64)
endif

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
# To reduce repository size, the source files are stored in Manta and
# need to be downloaded.
#
$(TARBALL) $(MPFR_VER).tar.bz2 $(GMP_VER).tar.bz2 $(MPC_VER).tar.gz:
	if [[ ! -f $@.sha1 ]]; then \
		echo "Missing required digest file!"; \
		exit 1; \
	fi; \
	curl -o $@.tmp $(FETCH_BASE)/$@
	digest -a sha1 $@.tmp > $@.tmp.sha1
	cmp -s $@.sha1 $@.tmp.sha1
	rm -f $@.tmp.sha1
	mv $@.tmp $@

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
$(AUTOCONF_OUT.32): | $(VER.32)/mpfr $(VER.32)/gmp $(VER.32)/mpc

$(VER.32)/mpfr: $(MPFR_VER).tar.bz2 | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -j --no-same-owner -f $(MPFR_VER).tar.bz2
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

$(VER.32)/mpc: $(MPC_VER).tar.gz | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -z --no-same-owner -f $(MPC_VER).tar.gz
	mv -f .unpack32/$(MPC_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

.PHONY: strapfix
strapfix: $(STRAPFIX_LINKS) $(STRAPFIX_FILES) | install
	for f in $(STRAPFIX_FILES_32); do \
		/usr/bin/elfedit -e \
		    'dyn:runpath $(DESTDIR)/$(PREFIX)/lib' \
		    $$f; \
	done
	for f in $(STRAPFIX_FILES_64); do \
		/usr/bin/elfedit -e \
		    'dyn:runpath $(DESTDIR)/$(PREFIX)/lib/64' \
		    $$f; \
	done

$(STRAPFIX_LINKS):
	mkdir -p `dirname $@`
	[[ -h $@ ]] || ln -s amd64 $@

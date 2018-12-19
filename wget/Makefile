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

VER =			wget-1.18

include ../Makefile.defs

UNPACK_SENTINEL =	configure.ac

AUTOCONF_ENV += \
			LD_OPTIONS="-M $(BASE)/mapfile_noexstk" \
			PERL=/opt/local/bin/perl \
			POD2MAN=/opt/local/bin/pod2man \
			DESTDIR="$(DESTDIR)" \
			CTFMERGE="$(CTFMERGE)" \
			CTFCONVERT="$(CTFCONVERT)" \
			ALTCTFCONVERT="$(ALTCTFCONVERT)"

AUTOCONF_OPTS += \
			--sysconfdir=/etc \
			--with-ssl=openssl \
			--infodir=/usr/share/info \
			--disable-rpath

CFLAGS +=		-O2 -gdwarf-2 \
			-fno-inline-functions \
			-fno-inline-functions-called-once \
			-fno-inline-small-functions

CTF_PROGRAMS =		/usr/bin/wget

PATCHES =		Patches/*

include ../Makefile.targ

all: all_autoconf

#
# This version of the wget configure.ac script requires m4 macros from
# pkg-config in order to correctly generate configure via autoreconf.  Rather
# than require pkg-config be installed on the build machine, as we do not
# intend to _run_ it, we drop an appropriate copy of "pkg.m4" in the right
# place here.
#
$(VER.32)/configure: $(VER.32)/configure.ac
	test -f $(VER.32)/m4/pkg.m4 || cp pkg.m4 $(VER.32)/m4/pkg.m4
	cd $(VER.32) && env - PATH=$(PATH) $(AUTOCONF_ENV) autoreconf

install: all
	mkdir -p $(DESTDIR)/usr/bin
	ginstall -m 0555 $(BASE)/$(VER.32)/src/wget $(DESTDIR)/usr/bin/wget
	mkdir -p $(DESTDIR)/usr/share/man/man1
	ginstall -m 0444 $(BASE)/$(VER.32)/doc/wget.1 \
	    $(DESTDIR)/usr/share/man/man1
	env - $(AUTOCONF_ENV) $(MAKE_CTF.32) $(CTF_PROGRAMS)

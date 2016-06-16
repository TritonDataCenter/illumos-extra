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
# Copyright 2016 Joyent, Inc.
#

VER =			wget-1.18

include ../Makefile.defs

UNPACK_SENTINEL =	configure.ac

AUTOCONF_ENV += \
			LD_OPTIONS="-M $(BASE)/mapfile_noexstk" \
			PERL=/usr/perl5/5.12/bin/perl \
			POD2MAN=/usr/perl5/5.12/bin/pod2man \
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

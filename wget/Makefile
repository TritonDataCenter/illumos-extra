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

VER =	wget-1.12

include ../Makefile.defs

AUTOCONF_ENV += \
	LD_OPTIONS="-M $(BASE)/mapfile_noexstk" \
	PERL=/usr/perl5/5.12/bin/perl \
	POD2MAN=/usr/perl5/5.12/bin/pod2man
AUTOCONF_OPTS += \
	--sysconfdir=/etc \
	--with-ssl \
	--infodir=/usr/share/info \
	--disable-rpath

TARBALL =		$(VER).tar.bz2
TARBALL_COMPRESS =	-j

PATCHES =	Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	mkdir -p $(DESTDIR)/usr/bin
	ginstall -m 0555 $(BASE)/$(VER.32)/src/wget $(DESTDIR)/usr/bin/wget
	mkdir -p $(DESTDIR)/usr/share/man/man1
	ginstall -m 0444 $(BASE)/$(VER.32)/doc/wget.1 \
	    $(DESTDIR)/usr/share/man/man1

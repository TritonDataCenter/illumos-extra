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
# Copyright (c) 2012, Joyent, Inc.  All rights reserved.
#

VER =	ntp-dev-4.2.5p200

include ../Makefile.defs

AUTOCONF_OPTS += \
	--prefix=/usr \
	--mandir=/usr/man \
	--bindir=/usr/sbin \
	--with-binsubdir=sbin \
	--libexecdir=/usr/lib/inet \
	--sysconfdir=/etc/inet \
	--enable-all-clocks \
	--enable-debugging \
	--enable-debug-timing \
	--disable-optional-args \
	--enable-parse-clocks \
	--enable-ignore-dns-errors \
	--without-ntpsnmpd \
	--without-lineeditlibs \
	--with-openssl-libdir=/lib \
	--disable-getifaddrs

CFLAGS +=	-O2

#
# ntp unfortunately shares a symbol name with libc and generates a warning that
# would normally be fatal:
# ld: warning: symbol 'monitor' has differing types:
#        (file ../libntp/libntp.a(audio.o) type=OBJT; file
# 	  .../proto/usr/lib/libc.so type=FUNC);
#        ../libntp/libntp.a(audio.o) definition taken
#
# Until such a time as this is fixed, we instead ignore -zfatal-warnings and
# just add -zassert-deflib. Unfortunately we don't have a programatic way to
# check it currently, but this will have to do for now.
#
LDFLAGS = $(T32_LDFLAGS) -zassert-deflib

AUTOCONF_ENV += \
	LD_OPTIONS="$(LDFLAGS)" \
	DESTDIR="$(DESTDIR)" \
	PATH_PERL=/usr/perl5/bin/perl

PATCHSTRIP =	0
PATCHES =	Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	(cd $(VER.32); env - $(AUTOCONF_ENV) PATH=$(PATH) gmake $(install_PARALLEL) install)
	(env - $(AUTOCONF_ENV) ./install-ntp)

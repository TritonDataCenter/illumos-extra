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
# Copyright 2019 Joyent, Inc.
#

VER =	ntp-4.2.8p8

include ../Makefile.defs

UNPACK_SENTINEL =	configure.ac

AUTOCONF_OPTS += \
	--prefix=/usr \
	--mandir=/usr/man \
	--bindir=/usr/sbin \
	--with-binsubdir=sbin \
	--libexecdir=/usr/sbin \
	--sysconfdir=/etc/inet \
	--with-perl=$(PATH_PERL) \
	--with-perllibdir=$(PERLLIBDIR) \
	--enable-all-clocks \
	--enable-debugging \
	--enable-debug-timing \
	--disable-optional-args \
	--enable-parse-clocks \
	--enable-ignore-dns-errors \
	--without-ntpsnmpd \
	--without-lineeditlibs \
	--with-crypto=sunw \
	--without-sntp \
	--enable-local-libevent \
	--disable-getifaddrs

CFLAGS += \
	-O2 -gdwarf-2 \
	-fno-inline-functions \
	-fno-inline-functions-called-once \
	-fno-inline-small-functions

AUTOCONF_ENV += \
	LD_OPTIONS="$(LDFLAGS)" \
	DESTDIR="$(DESTDIR)" \
	CTFCONVERT="$(CTFCONVERT)"

PATCHSTRIP =	0
PATCHES =	Patches/*

CTF_PROGRAMS_USR_SBIN = \
	ntp-keygen \
	ntpd \
	ntpdate \
	ntpdc \
	ntpq \
	ntptime \
	tickadj

CTF_PROGRAMS = $(CTF_PROGRAMS_USR_SBIN:%=/usr/sbin/%)

include ../Makefile.targ

$(VER.32)/configure: $(VER.32)/configure.ac
	(cd $(VER.32) && env - $(AUTOCONF_ENV) PATH=$(PATH) \
	    autoreconf -fi)

all: all_autoconf

install: all
	(cd $(VER.32) && env - $(AUTOCONF_ENV) PATH=$(PATH) \
	    gmake $(install_PARALLEL) install)
	(env - $(AUTOCONF_ENV) $(MAKE_CTF.32) $(CTF_PROGRAMS))
	(env - $(AUTOCONF_ENV) ./install-ntp)

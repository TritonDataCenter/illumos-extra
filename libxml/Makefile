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
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright (c) 2013, Joyent, Inc.  All rights reserved.
# Copyright 2025 MNX Cloud, Inc.
#

VER =	libxml2-2.13.8

include ../Makefile.defs

BUILD64 =	yes

LIBXML2_LDFLAGS = \
	-Wl,-zdefs \
	-Wl,-ztext \
	-Wl,-zcombreloc

LDFLAGS +=	$(LIBXML2_LDFLAGS)
LDFLAGS.64 +=	$(LIBXML2_LDFLAGS)

LIBS +=	\
	-lpthread \
	-lc

CPPFLAGS +=	\
	-D_FILE_OFFSET_BITS=64 \
	-D_LARGEFILE_SOURCE

AUTOCONF_OPTS += \
	--with-threads \
	--without-python \
	--enable-symbol-versioning=$(BASE)/mapfile

#PATCHES =	Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	DESTDIR=$(DESTDIR) PATH=$(PATH) ksh93 ./install-libxml2 $(VER.32)
	DESTDIR=$(DESTDIR) PATH=$(PATH) ksh93 ./install-libxml2-64 $(VER.64)

test: test32 test64

test32: all
	(cd $(VER.32); \
	    LD_LIBRARY_PATH=$(DESTDIR)/lib:$(DESTDIR)/usr/lib gmake tests) 

test64: all
	(cd $(VER.64); \
	    LD_LIBRARY_PATH_64=$(DESTDIR)/lib/64:$(DESTDIR)/usr/lib/64 \
	    gmake tests)

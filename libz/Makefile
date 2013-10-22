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
# Copyright (c) 2012, Joyent, Inc.  All rights reserved.
#

VER =	zlib-1.2.3

include ../Makefile.defs

AUTOCONF_OPTS += \
	--shared

#
# zlib's configure isn't a real autoconf, and it breaks horribly if this
# stuff is set.
#
AUTOCONF_CFLAGS =
AUTOCONF_CFLAGS.64 =
AUTOCONF_LDFLAGS =
AUTOCONF_LDFLAGS.64 =

AUTOCONF_CC =		CC="$(GCC) $(CPPFLAGS)"
AUTOCONF_CC.64 =	CC="$(GCC.64) $(CPPFLAGS)"

#
# LDFLAGS is used by zlib's build system to build programs, not the library
# itself.  For that, it accepts only a combined linker+flags+libs command
# line via the LDSHARED variable.
#
LDSHARED_FLAGS = \
	-shared \
	-Wl,-h,libz.so.1 \
	-Wl,-zdefs \
	-Wl,-ztext \
	-Wl,-zcombreloc \
	-Wl,-M,../mapfile

ifneq ($(STRAP),strap)
	LDSHARED_FLAGS += $(GENLDFLAGS)
endif

LDSHARED_FLAGS.32 =	$(LDSHARED_FLAGS) $(SYSLIBDIRS:%=-L$(DESTDIR)/%)
LDSHARED_FLAGS.64 =	$(LDSHARED_FLAGS) $(SYSLIBDIRS:%=-L$(DESTDIR)/%/64)
LDSHARED_LIBS =		-lc

ifeq ($(STRAP),strap)
	LDSHARED_FLAGS.32 += $(SYSLIBDIRS:%=-R$(DESTDIR)/%)
	LDSHARED_FLAGS.64 += $(SYSLIBDIRS:%=-R$(DESTDIR)/%/64)
endif

LDFLAGS +=	-L. -lz -lc
LDFLAGS.64 +=	-L. -lz -lc

OVERRIDES = \
	LDSHARED="$(GCC) $(LDSHARED_FLAGS.32) $(LDSHARED_LIBS)" \
	LDFLAGS="$(LDFLAGS)"

OVERRIDES.64 = \
	LDSHARED="$(GCC.64) $(LDSHARED_FLAGS.64) $(LDSHARED_LIBS)" \
	LDFLAGS="$(LDFLAGS.64)"

BUILD32 =	yes
BUILD64 =	yes

include ../Makefile.targ

all: all_autoconf

install: all
	BASE=$(BASE) DESTDIR=$(DESTDIR) VERS=$(VER.32) ksh93 ./install-zlib
	BASE=$(BASE) DESTDIR=$(DESTDIR) VERS=$(VER.64) MACH64=amd64 \
	    ksh93 ./install-zlib-64

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
# Copyright 2016 Joyent, Inc.
#

VER =	libidn2-0.11

include ../Makefile.defs

CPPFLAGS +=	-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
CFLAGS +=	-g

AUTOCONF_ENV += \
	INSTALL="/usr/ucb/install -c"

PATCHES =	Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	DESTDIR=$(DESTDIR) VERS=$(VER.32) /bin/bash ./install-sfw

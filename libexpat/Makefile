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
# Copyright 2025 MNX Cloud, Inc.
# Copyright 2026 Edgecast Cloud LLC.
#

VER =	expat-2.7.4

include ../Makefile.defs

BUILD64 =	yes

CPPFLAGS += \
	-D_FILE_OFFSET_BITS=64 \
	-D_LARGEFILE_SOURCE \
	-D_HAVE_EXPAT_CONFIG_H

CFLAGS +=	-g -fPIC

AUTOCONF_ENV += \
	INSTALL="/usr/ucb/install -c"

# PATCHES = Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	DESTDIR=$(DESTDIR) VERS=$(VER.32) /bin/bash ./install-sfw
	DESTDIR=$(DESTDIR) VERS=$(VER.64) MACH64=amd64 \
	    /bin/bash ./install-sfw-64

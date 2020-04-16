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
# Copyright 2020 Joyent, Inc.
#

VER =	ipmitool-1.8.18

include ../Makefile.defs

CPPFLAGS +=	-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
# need INT8_MIN and much other stuff
CPPFLAGS += -D__EXTENSIONS__
CFLAGS +=	-g

AUTOCONF_ENV += \
	LD=/usr/bin/ld \
	INSTALL="ginstall -c"
AUTOCONF_OPTS += \
	--enable-solaris-opt \
	--enable-intf-lanplus

PATCHES +=	Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	DESTDIR=$(DESTDIR) VERS=$(VER.32) /bin/bash ./install-joyent

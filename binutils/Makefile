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
# Copyright 2018, Joyent, Inc.
#

VER =	binutils-2.25.1

include ../Makefile.defs

#
# binutils configure ignores $CPPFLAGS, so pass our needed changes through
# $CFLAGS.
#
CFLAGS += $(CPPFLAGS)

TARBALL =		$(VER).tar.bz2
TARBALL_COMPRESS =	-j
AUTOCONF_OPTS = \
	--prefix=/usr/gnu \
	--enable-64-bit-bfd \
	--program-prefix=g

PATCHES =	patches/*

AUTOCONF_ENV += \
	CC=gcc \
	CXX=g++ \
	DESTDIR=$(DESTDIR) \
	MAKE=gmake \
	CONFIG_SHELL=/bin/bash

include ../Makefile.targ
include ../Makefile.targ.autoconf

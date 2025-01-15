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
# Copyright 2024 MNX Cloud, Inc.
#

VER =	rsync-3.4.0

include ../Makefile.defs

AUTOCONF_ENV += \
	LD_OPTIONS="-M $(BASE)/mapfile_noexstk"
AUTOCONF_OPTS += --with-included-popt \
	--disable-zstd --disable-lz4 --disable-xxhash --disable-openssl

BUILD32 =
BUILD64 = yes

PATCHES =	Patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	VERDIR=$(VER.64) ksh93 ./install-sfw

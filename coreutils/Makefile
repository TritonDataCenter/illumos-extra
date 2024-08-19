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

VER =	coreutils-9.4

include ../Makefile.defs

BUILD32 =
BUILD64 = yes

include ../Makefile.targ

# Jenkins agents run as root, and coreutils' configure doesn't like that
# without an override. Oh and make sure it's the 64-bit build override too.
AUTOCONF_ENV.64 += FORCE_UNSAFE_CONFIGURE=1
OVERRIDES.64 += FORCE_UNSAFE_CONFIGURE=1

LD_LIBRARY_PATH_HACK = /tmp/extra-ldlibpath
PATCHES = Patches/*

all: all_autoconf

scribble_ld_library:
	echo $(DESTDIR)/lib/64 > $(LD_LIBRARY_PATH_HACK)

install: scribble_ld_library all
	/bin/rm -rf $(LD_LIBRARY_PATH_PACK)
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/share/man/man1
	cp $(BASE)/$(VER.64)/src/readlink $(DESTDIR)/usr/bin
	cp $(BASE)/$(VER.64)/src/seq $(DESTDIR)/usr/bin
	cp $(BASE)/$(VER.64)/src/stat $(DESTDIR)/usr/bin
	cp -f $(BASE)/$(VER.64)/man/readlink.1 $(DESTDIR)/usr/share/man/man1
	cp -f $(BASE)/$(VER.64)/man/seq.1 $(DESTDIR)/usr/share/man/man1
	cp -f $(BASE)/$(VER.64)/man/stat.1 $(DESTDIR)/usr/share/man/man1

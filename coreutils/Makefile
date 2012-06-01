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
#

VER =	coreutils-8.13

include ../Makefile.defs
include ../Makefile.targ

all: all_autoconf

install: all
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/share/man/man1
	cp $(BASE)/$(VER.32)/src/readlink $(DESTDIR)/usr/bin
	cp $(BASE)/$(VER.32)/src/seq $(DESTDIR)/usr/bin
	cp $(BASE)/$(VER.32)/src/stat $(DESTDIR)/usr/bin
	cp -f $(BASE)/$(VER.32)/man/readlink.1 $(DESTDIR)/usr/share/man/man1
	cp -f $(BASE)/$(VER.32)/man/seq.1 $(DESTDIR)/usr/share/man/man1
	cp -f $(BASE)/$(VER.32)/man/stat.1 $(DESTDIR)/usr/share/man/man1

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
# Copyright (c) 2017, Joyent, Inc.
#

VER =	pigz-2.3.4

include ../Makefile.defs

BINDIR =	$(DESTDIR)/usr/img/sbin/

PATCHES = \
	pigz-configure.patch \
	pigz-Makefile.patch

include ../Makefile.targ

all: all_autoconf

install: all
	mkdir -p $(BINDIR)
	ginstall -m 0555 $(BASE)/$(VER.32)/pigz $(BINDIR)/pigz

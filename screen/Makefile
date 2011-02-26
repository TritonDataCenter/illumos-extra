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
# Copyright (c) 2010 Joyent Inc.
#

VER=screen-4.0.3
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
CC=gcc
GTAR=/usr/bin/gtar
SH=ksh93

#-include ../Makefile.inc

all: $(VER)/config.status
	(cd $(VER); env - $(MAKE) all)

install: all
	mkdir -p $(DESTDIR)/usr/bin
	ginstall -m 0555 $(BASE)/$(VER)/screen $(DESTDIR)/usr/bin/screen
	ginstall -m 0444 $(BASE)/$(VER)/doc/screen.1 $(DESTDIR)/usr/share/man/man1/screen.1

$(VER)/config.status: $(VER)/configure
	(cd $(VER); env \
	    CC=$(CC) \
	    "CFLAGS=$(CFLAGS)" \
	    PATH=$(PATH) \
	    MAKE=$(MAKE) \
	./configure --prefix=/usr)

$(VER)/configure: $(VER).tar.gz
	$(GTAR) zxpf $(VER).tar.gz
	gpatch -p0 < Patches/misc.c.patch
	touch $(VER)/configure

clean:
	-rm -rf $(VER)

FRC:

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
# Copyright (c) 2018, Joyent, Inc.  All rights reserved.
#

VER =	ncurses-5.7

include ../Makefile.defs

BUILD64 =	yes

AUTOCONF_PREFIX =	/usr/gnu
AUTOCONF_OPTS += \
	-C \
	--with-shared \
	--without-normal

AUTOCONF_OPTS.64 += \
	--libdir=/usr/gnu/lib/amd64

# /bin/sh (aka ksh93)'s cat builtin likes to omit the final newline, which
# causes problems with generating headers.sh using successive here docs.
# Use bash for now to avoid lines being merged by this.
AUTOCONF_ENV += 	CONFIG_SHELL=/bin/bash
AUTOCONF_ENV.64 +=	CONFIG_SHELL=/bin/bash

LDFLAGS +=	-R/usr/gnu/lib
LDFLAGS.64 +=	-R/usr/gnu/lib/amd64

PATCHES = \
	ncurses-01-widec.diff \
	ncurses-02-rpath.diff

USRDIR =	$(DESTDIR)/usr

include ../Makefile.targ

all: hack-curses all_autoconf

#
# This horrid mess is needed because the ncurses build process isn't smart
# enough to look in its own directories for libraries before those passed
# in via -Lwhatever in LDFLAGS.  So we move any problematic ones out of the
# way before we build, then move them back after.
#
# You got a better idea?
#
.PHONY: hack-curses
hack-curses:
	for l in form menu panel; do \
		if [ -L $(DESTDIR)/usr/lib/lib$$l.so ]; then \
			mv $(DESTDIR)/usr/lib/lib$$l.so \
			    $(DESTDIR)/usr/lib/lib$$l__curses.so; \
		fi; \
		if [ -L $(DESTDIR)/usr/lib/64/lib$$l.so ]; then \
			mv $(DESTDIR)/usr/lib/64/lib$$l.so \
			    $(DESTDIR)/usr/lib/64/lib$$l__curses.so; \
		fi; \
	done

.PHONY: hack-curses
unhack-curses:
	for l in form menu panel; do \
		if [ -L $(DESTDIR)/usr/lib/lib$$l__curses.so ]; then \
			mv $(DESTDIR)/usr/lib/lib$$l__curses.so \
			    $(DESTDIR)/usr/lib/lib$$l.so; \
		fi; \
		if [ -L $(DESTDIR)/usr/lib/64/lib$$l__curses.so ]; then \
			mv $(DESTDIR)/usr/lib/64/lib$$l__curses.so \
			    $(DESTDIR)/usr/lib/64/lib$$l.so; \
		fi; \
	done

install: all unhack-curses
	mkdir -p $(DESTDIR)
	(cd $(VER.64); env - PATH=/usr/bin:$(PATH) \
	    gmake DESTDIR=$(DESTDIR) install)
	(cd $(VER.32); env - PATH=/usr/bin:$(PATH) \
	    gmake DESTDIR=$(DESTDIR) install)
	mv $(USRDIR)/gnu/bin/infocmp $(USRDIR)/bin/ginfocmp
	mv $(USRDIR)/gnu/bin/tic $(USRDIR)/bin/gtic
	mv $(USRDIR)/gnu/bin/toe $(USRDIR)/bin/gtoe
	mv $(USRDIR)/gnu/bin/tput $(USRDIR)/bin/gtput
	mv $(USRDIR)/gnu/bin/tset $(USRDIR)/bin/gtset
	rm -rf $(USRDIR)/include/ncurses
	mv $(USRDIR)/gnu/include/ncurses $(USRDIR)/include
	mkdir -p $(USRDIR)/gnu/share/doc/ncurses
	rm -f $(USRDIR)/gnu/share/doc/ncurses/README
	cp $(VER.32)/README $(USRDIR)/gnu/share/doc/ncurses

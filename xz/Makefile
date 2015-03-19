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
# Copyright 2015 Joyent, Inc.
#

LVER =	5.2.1
VER = 	xz-$(LVER)

include ../Makefile.defs

AUTOCONF_OPTS += \
	--disable-rpath

include ../Makefile.targ

all: all_autoconf

#
# See README.integration for more information
#
install: all
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/lib
	mkdir -p $(DESTDIR)/usr/share/man/man1
	/usr/bin/elfedit -e 'dyn:value -s SONAME libjoy_lzma.so.5' \
	    $(BASE)/$(VER.32)/src/liblzma/.libs/liblzma.so.$(LVER) \
	    $(DESTDIR)/usr/lib/libjoy_lzma.so.$(LVER)
	chmod 0555 $(DESTDIR)/usr/lib/libjoy_lzma.so.$(LVER)
	/usr/bin/elfedit -e 'dyn:value -dynndx 0' \
	    $(BASE)/$(VER.32)/src/xz/.libs/xz | /usr/bin/grep -q liblzma.so.5
	/usr/bin/elfedit -e 'dyn:value -s -dynndx 0 libjoy_lzma.so.5' \
	    $(BASE)/$(VER.32)/src/xz/.libs/xz \
	    $(DESTDIR)/usr/bin/xz
	ginstall -m 0555 $(BASE)/$(VER.32)/src/xz/xz.1 $(DESTDIR)/usr/share/man/man1

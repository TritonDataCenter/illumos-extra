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

include ../Makefile.defs

SRC=$(shell (pwd))
LIBDIR=${DESTDIR}/usr/lib/iconv
LIB64DIR=$(LIBDIR)/amd64

all:
	@(cd src; pwd; unset MAKE; SRC=$(SRC) $(SUN_MAKE) all)
	
install: all
	@(cd src; pwd; unset MAKE; SRC=$(SRC) $(SUN_MAKE) install)
	mkdir -p $(LIBDIR)
	mkdir -p $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/646%UTF-8.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%646.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%UCS-2.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%UCS-2LE.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UCS-2%UTF-8.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UCS-2LE%UTF-8.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/646%UTF-8.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UTF-8%646.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UTF-8%UCS-2.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UTF-8%UCS-2LE.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UCS-2%UTF-8.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UCS-2LE%UTF-8.so $(LIB64DIR)

#
# We explicitly use the dmake that we install as part of the build
# bootstrap here to invoke the clean target, as the make that we build
# may have already been removed.
#
clean:
	test -x /opt/local/bin/dmake
	@(cd src; pwd; unset MAKE; SRC=$(SRC) /opt/local/bin/dmake clean)
	rm -rf proto

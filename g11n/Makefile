#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").  
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright 2013, Joyent, Inc.  All rights reserved.
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
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%646.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%UCS-2.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%UCS-2LE.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UCS-2%UTF-8.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UCS-2LE%UTF-8.so $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UTF-8%646.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UTF-8%UCS-2.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UTF-8%UCS-2LE.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UCS-2%UTF-8.so $(LIB64DIR)
	cp proto/i386/fileroot/usr/lib/iconv/amd64/UCS-2LE%UTF-8.so $(LIB64DIR)

clean:
	@(cd src; pwd; unset MAKE; SRC=$(SRC) $(SUN_MAKE) clean)

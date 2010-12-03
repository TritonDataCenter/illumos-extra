#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.

# Copyright (c) 2010 Joyent Inc.

# This makefile is unusual, because it builds both 32 and 64 bit
# versions of the library.  The builds occur in separate subdirs,
# and 2 install scripts are used.

VER=libxml2-2.7.6
VER64=$(VER)-64

LDFLAGS=	-z defs -z text -z combreloc -lpthread
LARGEFILES=	-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

BASE=$(PWD)
DESTDIR=$(BASE)/../proto

-include ../Makefile.inc

all: real-all

all32: $(VER)/config.status
	(cd $(VER); env - PATH=$(PATH) "CFLAGS=$(LARGEFILES)" \
	    make -e libxml2.la; \
	    env - PATH=$(PATH) "CFLAGS=$(LARGEFILES)" \
	    make -e) 

all64: $(VER64)/config.status
	(cd $(VER64); env - PATH=$(PATH) "CC=cc" \
	    "CFLAGS=-m64 $(LARGEFILES)" \
	    make -e libxml2.la; \
	    env - PATH=$(PATH) "CFLAGS=-m64 $(LARGEFILES)" \
	    make -e) 

install: all
	BASE=$(BASE) DESTDIR=$(DESTDIR) PATH=$(PATH) ksh93 ./install-libxml2 $(VER)
	BASE=$(BASE) DESTDIR=$(DESTDIR) PATH=$(PATH) MACH64=amd64 ksh93 ./install-libxml2-64 $(VER64)

real-all: all32 all64

test: test32 test64

# Test suite don't work under normal make, have to use gmake

test32: all32
	(cd $(VER); gmake tests) 

test64: all64
	(cd $(VER64); gmake tests)

$(VER)/config.status: $(VER)/configure
	(cd $(VER); \
	    env - "CC=cc" "CFLAGS=$(LARGEFILES)" \
	    "LDFLAGS=$(LDFLAGS)" \
	    "PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH)" \
	    ./configure --prefix=/usr --with-threads \
	    --without-python)
	cp mapfile $(VER)/libxml2.syms
	patch -N $(VER)/libtool < libtool.patch

$(VER64)/config.status: $(VER64)/configure
	(cd $(VER64); \
	    env - "CC=cc" "CFLAGS=-m64 $(LARGEFILES)" \
	    "LDFLAGS=$(LDFLAGS)" \
	    "PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH)" \
	    ./configure --prefix=/usr --with-threads \
	    --without-python)
	cp mapfile $(VER64)/libxml2.syms
	patch -N $(VER64)/libtool < libtool.patch

$(VER)/configure: $(VER).tar.gz
	mkdir -p tmp; gzip -dc $(VER).tar.gz | (cd tmp; tar xopf -)
	mv tmp/$(VER) $(VER); rmdir tmp
	touch $(VER)/configure

$(VER64)/configure: $(VER).tar.gz
	mkdir -p tmp; gzip -dc $(VER).tar.gz | (cd tmp; tar xopf -)
	mv tmp/$(VER) $(VER64); rmdir tmp
	touch $(VER64)/configure

clean:
	-rm -rf $(VER) $(VER64)

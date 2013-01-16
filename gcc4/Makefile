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
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright (c) 2013, Joyent, Inc.  All rights reserved.
#

#
# This makefile has not been adapted to use the infrastructure because of
# the need to build in a separate subdirectory from the source.  This could
# be accommodated without excessive effort but is a highly unusual pattern.
#

VER =	gcc-4.4.4

include ../Makefile.defs

CLEANFILES +=	$(VER)-i386-build

GCC =	/opt/local/bin/gcc
GXX =	/bin/false

include ../Makefile.targ

all: $(VER)-i386-build/config.status
	(cd $(VER)-i386-build; env - \
	    CC=$(GCC) \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(PATH) \
	    STAGE1_CFLAGS="-g -O2" \
	    CFLAGS_FOR_TARGET="-g -O2" \
	    MAKE=gmake gmake \
		CFLAGS="-g -O2" \
		STAGE1_CFLAGS="-g -O2" \
		CFLAGS_FOR_TARGET="-g -O2" $(PARALLEL) bootstrap)

install: all
	(cd $(VER)-i386-build; env - \
	    CC=$(GCC) \
	    CFLAGS="-g -O2" \
	    STAGE1_CFLAGS="-g -O2" \
	    CFLAGS_FOR_TARGET="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(PATH) \
	    MAKE=gmake gmake \
		CFLAGS="-g -O2" \
		STAGE1_CFLAGS="-g -O2" \
		CFLAGS_FOR_TARGET="-g -O2" $(PARALLEL) install)

$(VER)-i386-build/config.status: $(VER)-i386-build $(VER.32)/configure
	(cd $(VER)-i386-build; env - \
	    CC=$(GCC) \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(PATH) \
	    MAKE=gmake \
	../$(VER.32)/configure \
		--prefix=/usr \
		--with-ld=/usr/bin/ld \
		--without-gnu-ld \
		--with-gnu-as \
		--with-as=$(DESTDIR)/usr/gnu/bin/gas \
		--enable-languages="c,c++" \
		--enable-shared \
		--with-gmp=/opt/local \
		--with-mpfr=/opt/local \
		--disable-nls \
		--with-included-gettext)

$(VER)-i386-build:
	mkdir -p $@

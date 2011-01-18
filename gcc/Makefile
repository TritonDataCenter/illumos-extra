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
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

#
# Copyright 2011 Joyent Inc.
#

VER=gcc-3.4.3

SFW_PATH="/usr/sfw/bin:/usr/bin:/usr/ccs/bin"

BASE=$(PWD)
DESTDIR=$(BASE)/../proto

all: $(VER)-i386-build/config.status
	(cd $(VER)-i386-build; env - \
	    CC=gcc \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    STAGE1_CFLAGS="-g -O2" \
	    CFLAGS_FOR_TARGET="-g -O2" \
	    PATH=$(SFW_PATH) \
	    MAKE=gmake gmake \
		CFLAGS="-g -O2" \
		STAGE1_CFLAGS="-g -O2" \
		CFLAGS_FOR_TARGET="-g -O2" bootstrap)

install: all
	(cd $(VER)-i386-build; env - \
	    CC=gcc \
	    CFLAGS="-g -O2" \
	    STAGE1_CFLAGS="-g -O2" \
	    CFLAGS_FOR_TARGET="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(SFW_PATH) \
	    MAKE=gmake gmake \
		CFLAGS="-g -O2" \
		STAGE1_CFLAGS="-g -O2" \
		CFLAGS_FOR_TARGET="-g -O2" install)
	ROOT=$(DESTDIR) ksh93 ./install-sfw

$(VER)-i386-build/config.status: $(VER)-i386-build $(VER)/configure
	(cd $(VER)-i386-build; env - \
	    CC=gcc \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(SFW_PATH) \
	    MAKE=gmake \
	../$(VER)/configure \
		--prefix=/usr/sfw \
		--with-as=/usr/sfw/bin/gas \
		--with-gnu-as \
		--with-ld=/usr/ccs/bin/ld \
		--without-gnu-ld \
		--enable-languages="c,c++,f77,objc" \
		--enable-shared)

$(VER)/configure: $(VER).tar.gz
	/usr/bin/gzip -dc $(VER).tar.gz | gtar xpf - --no-same-owner
	gpatch -p0 < patch
	gpatch -p0 < patch.gcc.makefile.in
	gpatch -p0 < patch.gcc.configure
	gpatch -p0 < patch.intl.configure
	gpatch -p0 < patch.sol2.h
	gpatch -p0 < patch.i386.sol2-10.h
	gpatch -p0 < patch.g++spec.c
	gpatch -p0 < patch.c-parse.in
	touch $(VER)/configure

$(VER)-i386-build:
	mkdir -p $@

clean:
	-rm -rf $(VER) $(VER)-i386-build


FRC:

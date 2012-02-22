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
# Copyright 2012 Joyent Inc.
#

VER=gcc-4.4.4

SFW_PATH="/usr/ccs/bin:/opt/local/bin:/usr/sfw/bin:/usr/bin:/opt/local/bin"

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
		CFLAGS_FOR_TARGET="-g -O2" $(PARALLEL) bootstrap)

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
		CFLAGS_FOR_TARGET="-g -O2" $(PARALLEL) install)

$(VER)-i386-build/config.status: $(VER)-i386-build $(VER)/configure
	(cd $(VER)-i386-build; env - \
	    CC=gcc \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(SFW_PATH) \
	    MAKE=gmake \
	../$(VER)/configure \
		--prefix=/usr/sfw \
		--with-ld=/usr/ccs/bin/ld \
		--without-gnu-ld \
		--with-gnu-as \
		--with-as=/usr/gnu/bin/as \
		--enable-languages="c,c++" \
		--enable-shared \
		--with-gmp=/opt/local \
		--with-mpfr=/opt/local \
		--disable-nls \
		--with-included-gettext)

$(VER)/configure: $(VER).tar.bz2
	/usr/bin/bzcat $(VER).tar.bz2 | gtar xpf - --no-same-owner
	touch $(VER)/configure

$(VER)-i386-build:
	mkdir -p $@

clean:
	-rm -rf $(VER) $(VER)-i386-build


FRC:

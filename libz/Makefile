#
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
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

# Copyright (c) Joyent Inc

# This makefile is unusual, because it builds both 32 and 64 bit
# versions of the library.  The builds occur in separate subdirs,
# and 2 install scripts are used.


VER=zlib-1.2.3
VER64=$(VER)-64

BASE=$(PWD)
DESTDIR=$(BASE)/../proto

all: real-all

all32: $(VER)/zconf.h
	(cd $(VER); env "CC=cc -KPIC" \
	    "LDSHARED=cc -G -KPIC -h libz.so.1 -z defs -z text -z combreloc -M ../mapfile -L. -lc" \
	    PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    make -e)

# must override LDSHARED here, or the makefile uses the wrong
# flags and tries to run the linker in 32-bit mode...libtool
# isn't looking so bad after all...sigh.

all64: $(VER64)/zconf.h
	(cd $(VER64); env "CC=cc" "CFLAGS=-m64 -KPIC"  \
	    "LDSHARED=cc -m64 -G -KPIC -h libz.so.1 -z defs -z text -z combreloc -M ../mapfile -L. -lc" \
	    PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    make -e)

install: all
	BASE=$(BASE) DESTDIR=$(DESTDIR) ksh93 ./install-zlib
	BASE=$(BASE) DESTDIR=$(DESTDIR) MACH64=amd64 ksh93 ./install-zlib-64

real-all: all32 all64

$(VER)/zconf.h: $(VER)/configure
	(cd $(VER); env \
	    PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    ./configure --shared \
		--prefix=/usr)

# the use of CFLAGS instead of CFLAGS64 in the following configure
# step is intentional, since the configure script does not know
# how to deal with the v9 compile flags.  During the actual build,
# (in the all64 target) we use CFLAGS64 to get v9 objects on sparc.

$(VER64)/zconf.h: $(VER64)/configure
	(cd $(VER64); env \
	    PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    ./configure --shared \
		--prefix=/usr)

# more hackiness - if building 64 bit objects, clone the source
# directory after extracting it.

$(VER)/configure: $(VER).tar.gz
	gzip -dc $(VER).tar.gz | tar xopf -
	mv $(VER) $(VER64)
	touch $(VER64)/configure
	gzip -dc $(VER).tar.gz | tar xopf -
	touch $(VER)/configure

clean:
	-rm -rf $(VER)
	-rm -rf $(VER64)

install_h:


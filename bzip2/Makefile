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
# Copyright (c) 2001, 2010, Oracle and/or its affiliates. All rights reserved.
#
# Copyright (c) 2012 Joyent Inc.
#

# This makefile is unusual, because it builds both 32 and 64 bit
# versions of the library.  The builds occur in separate subdirs,
# and 2 install scripts are used.

VER=bzip2-1.0.6
GCC=$(DESTDIR)/usr/sfw/bin/gcc

all: real-all

# each all target has 2 parts.  The first builds the commands, and
# the second builds the shared library.

all32: $(VER)/i386/Makefile
	(cd $(VER)/i386; env \
	    CC=$(GCC) gmake)

all64: $(VER)/amd64/Makefile
	(cd $(VER)/amd64; env \
	    CC=$(GCC) gmake)

install: all
	/usr/bin/ksh93 ./install-bzip2 $(PWD)/$(VER)

real-all: all32 all64

$(VER)/Makefile.dist: $(VER).tar.gz
	gzip -dc $(VER).tar.gz | tar xopf -
	(cd $(VER); gpatch -p1 < ../bzip2.patch)
	cp $(VER)/Makefile $(VER)/Makefile.dist

$(VER)/i386/Makefile: $(VER)/Makefile.dist makefile.build
	mkdir -p $(VER)/i386
	cp makefile.build $(VER)/i386/Makefile

$(VER)/amd64/Makefile: $(VER)/Makefile.dist makefile.build.64
	mkdir -p $(VER)/amd64
	cp makefile.build.64 $(VER)/amd64/Makefile

clean:
	-rm -rf $(VER)

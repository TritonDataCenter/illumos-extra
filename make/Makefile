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

VER=usr

include ../Makefile.defs

UNPACK_SENTINEL =	src/OPENSOLARIS.LICENSE
TARBALL =		devpro-make-src-20061219.tar.bz2
TARBALL_COMPRESS =	-j

ifneq ($(STRAP),strap)
MAKE_PREFIX =	 		/opt/local
MAKE_DESTDIR =			$(DESTDIR)
BUILD_MAKE =			$(SUN_MAKE)
else
MAKE_PREFIX =			$(DESTDIR)/usr
MAKE_DESTDIR =			/
BUILD_MAKE =			$(SUN_MAKE_STRAP) 
endif


PATCHES += install.patch \
	prefix.patch \
	dmake.patch

#
# Build errors often get lost so instead we check for a few files that we expect
# in the proto area.
#
all: $(VER.32)/$(UNPACK_SENTINEL)
	cd $(VER.32)/src; pwd; DESTDIR=$(MAKE_DESTDIR) \
	    PREFIX=$(MAKE_PREFIX) \
	    MAKE=$(BUILD_MAKE) \
	    ./build
	[[ -f $(MAKE_DESTDIR)/$(MAKE_PREFIX)/bin/dmake ]]

install: all

include ../Makefile.targ

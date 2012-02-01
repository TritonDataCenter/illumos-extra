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
# Copyright 2012, Joyent, Inc.  All rights reserved.
#

MAKE=/usr/ccs/bin/make
SRC=$(shell (pwd))
LIBDIR=${DESTDIR}/usr/lib/iconv

all:
	@(cd src; pwd; SRC=$(SRC) $(MAKE) all)
	
install: all
	@(cd src; pwd; SRC=$(SRC) $(MAKE) install)
	mkdir -p $(LIBDIR)
	cp proto/i386/fileroot/usr/lib/iconv/UTF-8%646.so $(LIBDIR)

clean:
	@(cd src; pwd; SRC=$(SRC) $(MAKE) clean)
	
FRC:


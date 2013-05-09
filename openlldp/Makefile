#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at COPYING
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at COPYING.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright (c) 2013, Joyent, Inc.  All rights reserved.
#

VER =	openlldp-0.4alpha

PATCHES =	Patches/*

include ../Makefile.defs
include ../Makefile.targ

all: all_autoconf

install: all
	mkdir -p $(DESTDIR)/usr/sbin
	rm -f $(DESTDIR)/usr/sbin/lldpd
	rm -f $(DESTDIR)/usr/sbin/lldpneighbors
	rm -f $(DESTDIR)/lib/svc/manifest/network/lldpd.xml
	install -s -m 555 -f $(DESTDIR)/usr/sbin $(VER.32)/src/lldpd
	install -s -m 555 -f $(DESTDIR)/usr/sbin $(VER.32)/src/lldpneighbors
	install -s -m 444 -f $(DESTDIR)/lib/svc/manifest/network lldpd.xml

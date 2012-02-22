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
# Copyright (c) 2012 Joyent Inc.
#

VER=tar-1.23
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
CC=$(DESTDIR)/usr/sfw/bin/gcc
SH=ksh93
LD_OPTIONS="-M $(BASE)/mapfile_noexstk"

all: $(VER)/config.status
	(cd $(VER); env - CC=$(CC) LD_OPTIONS=$(LD_OPTIONS) PATH="/usr/perl5/bin:$(PATH)" gmake $(PARALLEL))

install: all
	mkdir -p $(DESTDIR)/usr/bin
	ginstall -m 0555 $(BASE)/$(VER)/src/tar $(DESTDIR)/usr/bin/gtar

$(VER)/config.status:
	gtar -jxf $(VER).tar.bz2
	(cd $(VER); ./configure --with-rmt=/usr/sbin/rmt --libexecdir=/usr/sbin --program-prefix=g)

clean:
	-rm -rf $(VER)


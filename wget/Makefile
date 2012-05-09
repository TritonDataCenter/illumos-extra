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

VER=wget-1.12
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
CC=$(DESTDIR)/usr/bin/gcc
GTAR=/usr/bin/gtar
SH=ksh93

all: $(VER)/config.status
	(cd $(VER); env - $(MAKE) $(PARALLEL) all)

install: all
	mkdir -p $(DESTDIR)/usr/bin
	ginstall -m 0555 $(BASE)/$(VER)/src/wget $(DESTDIR)/usr/bin/wget
	mkdir -p $(DESTDIR)/usr/share/man/man1
	ginstall -m 0444 $(BASE)/$(VER)/doc/wget.1 $(DESTDIR)/usr/share/man/man1

$(VER)/config.status: $(VER)/configure
	(cd $(VER); env \
	    CC=$(CC) \
	    "CFLAGS=$(CFLAGS)" \
	    "LD_OPTIONS=-L$(ROOT)/mapfile_noexstk" \
	    PERL=/usr/perl5/5.12/bin/perl \
	    POD2MAN=/usr/perl5/5.12/bin/pod2man \
	    PATH=$(PATH) \
	    MAKE=$(MAKE) \
	./configure --prefix=/usr --sysconfdir=/etc --with-ssl --infodir=/usr/share/info)

$(VER)/configure: $(VER).tar.bz2
	$(GTAR) jxpf $(VER).tar.bz2 --no-same-owner
	gpatch -p0 < Patches/no_charset_alias.patch
	gpatch -p0 < Patches/sysdep.h.patch
	gpatch -p0 < Patches/wgetrc.patch
	touch $(VER)/configure

clean:
	-rm -rf $(VER)

FRC:

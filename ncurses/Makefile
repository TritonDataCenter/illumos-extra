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
# Copyright (c) 2010 Joyent Inc., All rights reserved.
#

VER=ncurses-5.7
VER64=$(VER)-64
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
USRDIR=$(DESTDIR)/usr

all: $(VER)/config.status $(VER64)/config.status
	( cd $(VER); env - PATH=$(PATH) \
	    gmake )
	( cd $(VER64); env - PATH=$(PATH) \
	    gmake )

install:
	mkdir -p $(DESTDIR)
	@ ( cd $(VER); \
	    gmake DESTDIR=$(DESTDIR) install)
	@ ( cd $(VER64); \
	    gmake DESTDIR=$(DESTDIR) install)
	mv $(USRDIR)/gnu/bin/infocmp $(USRDIR)/bin/ginfocmp
	mv $(USRDIR)/gnu/bin/tic $(USRDIR)/bin/gtic
	mv $(USRDIR)/gnu/bin/toe $(USRDIR)/bin/gtoe
	mv $(USRDIR)/gnu/bin/tput $(USRDIR)/bin/gtput
	mv $(USRDIR)/gnu/bin/tset $(USRDIR)/bin/gtset
	rm -rf $(USRDIR)/include/ncurses
	mv $(USRDIR)/gnu/include/ncurses $(USRDIR)/include
	mkdir -p $(USRDIR)/gnu/share/doc/ncurses
	cp $(VER)/README $(USRDIR)/gnu/share/doc/ncurses

clean:
	rm -rf $(VER) $(VER64)

$(VER)/config.status: $(VER)/configure
	(cd $(VER); ./configure --prefix=/usr/gnu -C --with-shared --without-normal)

$(VER64)/config.status: $(VER64)/configure
	(cd $(VER64); ./configure --prefix=/usr/gnu --libdir=/usr/gnu/lib/amd64 -C --with-shared --without-normal)

$(VER)/configure: $(VER64)/configure
	gtar -zxf $(VER).tar.gz
	(cd $(VER) \
	; gpatch -p1 --no-backup-if-mismatch < ../ncurses-01-widec.diff \
	; gpatch -p1 --no-backup-if-mismatch < ../ncurses-02-rpath.diff \
    )
	touch $(VER)/configure

$(VER64)/configure: $(VER).tar.gz
	gtar -zxf $(VER).tar.gz
	mv $(VER) $(VER64)
	(cd $(VER64) \
	; gpatch -p1 --no-backup-if-mismatch < ../ncurses-01-widec.diff \
	; gpatch -p1 --no-backup-if-mismatch < ../ncurses-02-rpath.diff \
    )
	touch $(VER64)/configure


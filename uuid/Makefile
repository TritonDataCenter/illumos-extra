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

VER=uuid-1.6.2
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
GCC=$(DESTDIR)/usr/sfw/bin/gcc
PATH=$(DESTDIR)/usr/sfw/bin/:/sbin:/usr/sbin:/usr/bin

all: $(VER)/config.h
	( cd $(VER); CC=$(GCC) PATH=$(PATH) gmake $(PARALLEL))

install: all
	mkdir -p $(DESTDIR)
	( cd $(VER); \
	    gmake DESTDIR=$(DESTDIR) install)

clean:
	rm -rf $(VER)

$(VER)/config.h: $(VER)/configure
	( cd $(VER); CC=$(GCC) PATH=$(PATH) \
	 	./configure --disable-shared --prefix=/usr)

$(VER)/configure: $(VER).tar.gz
	gtar -zxf $(VER).tar.gz
	touch $(VER)/configure

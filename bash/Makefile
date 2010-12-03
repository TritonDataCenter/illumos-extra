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
# Copyright (c) 2010 Joyent Inc.
#

VER=bash-4.1
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
MAKE=gmake

-include ../Makefile.inc

all: $(VER)/config.status
	( cd $(VER); env - PATH=$(PATH) \
	    gmake )

install:
	mkdir -p $(DESTDIR)
	( cd $(VER); \
	    gmake DESTDIR=$(DESTDIR) install)

clean:
	rm -rf $(VER)

$(VER)/config.status: $(VER)/configure
	    (cd $(VER); ./configure --prefix=/usr)

$(VER)/configure:
	gtar -zxf $(VER).tar.gz


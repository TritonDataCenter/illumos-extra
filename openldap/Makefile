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
# Copyright (c) 2011 Joyent Inc.
#

VER=openldap-2.4.26
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
GCC=/usr/bin/gcc
PATH=/sbin:/usr/sbin:/usr/bin
MAKE=/opt/local/bin/make
LDFLAGS=-Wl,-R/usr/openldap/lib -Wl,-R/lib -Wl,-R/usr/lib -Wl,-R/usr/sfw/lib

-include ../Makefile.inc

all: $(VER)/config.h
	( cd $(VER); gmake)

install: all
	mkdir -p $(DESTDIR)
	( cd $(VER); XLDFLAGS="$(LDFLAGS)" \
	    gmake DESTDIR=$(DESTDIR) install)

clean:
	rm -rf $(VER)

$(VER)/config.h: $(VER)/configure
	(cd $(VER); MAKE=$(MAKE) ./configure --disable-slapd --without-cyrus-sasl \
		--sysconfdir=/etc --localstatedir=/var/db/openldap \
		--with-tls=openssl --prefix=/usr/openldap)

$(VER)/configure: $(VER).tgz
	gtar -zxf $(VER).tgz
	touch $(VER)/configure

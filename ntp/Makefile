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

#
# Copyright (c) 2009, 2010, Oracle and/or its affiliates. All rights reserved.
#
# Copyright 2012 Joyent Inc
#


VER =		ntp-dev-4.2.5p200
TARBALL =	$(VER).tar.gz

#       configure(1) options to use
# a default --prefix and --mandir are set in Makefile.master
CONFIGURE_OPTIONS =	--prefix=/usr
CONFIGURE_OPTIONS +=	--mandir=/usr/man
CONFIGURE_OPTIONS +=	--bindir=/usr/sbin
CONFIGURE_OPTIONS +=	--with-binsubdir=sbin
CONFIGURE_OPTIONS +=	--libexecdir=/usr/lib/inet
CONFIGURE_OPTIONS +=	--sysconfdir=/etc/inet
CONFIGURE_OPTIONS +=	--enable-all-clocks
CONFIGURE_OPTIONS +=	--enable-debugging
CONFIGURE_OPTIONS +=	--enable-debug-timing
CONFIGURE_OPTIONS +=	--disable-optional-args
CONFIGURE_OPTIONS +=	--enable-parse-clocks
CONFIGURE_OPTIONS +=	--enable-ignore-dns-errors
CONFIGURE_OPTIONS +=	--without-ntpsnmpd
CONFIGURE_OPTIONS +=	--without-lineeditlibs
CONFIGURE_OPTIONS +=	--with-openssl-libdir=/lib
CONFIGURE_OPTIONS +=	--disable-getifaddrs

TARGET_ENV =  CC="$(DESTDIR)/usr/bin/gcc"
TARGET_ENV += CFLAGS="-O2"
TARGET_ENV += LD_OPTIONS="-L${DESTDIR}/usr/lib"
TARGET_ENV += DESTDIR=$(DESTDIR)
TARGET_ENV += MAKE=gmake

all: $(VER)/config.status
	(cd $(VER); env - $(TARGET_ENV) gmake $(PARALLEL) all)

install: all
	(cd $(VER); env - $(TARGET_ENV) gmake $(PARALLEL) install)
	(env - $(TARGET_ENV) ./install-ntp)

$(VER)/config.status: clean $(VER)/.patched
	(cd $(VER) ; env - PATH_PERL=/usr/perl5/bin/perl \
		bash ./configure $(CONFIGURE_OPTIONS) $(TARGET_ENV))

$(VER)/.patched: $(VER)
	(cd $(VER) ; env - ; for x in ../Patches/*; \
		do gpatch -p0 < $$x; done ;  touch .patched)

$(VER):
	gtar -zxf $(TARBALL)

clean:
	-rm -rf $(VER)

FRC:

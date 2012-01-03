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
# Copyright 2012 Joyent, Inc
#
VER =           perl-5.12.3
TARBALL=$(VER).tar.gz

BASE=$(PWD)
DESTDIR=$(BASE)/../proto

GCC=$(DESTDIR)/usr/sfw/bin/gcc

all: $(VER)/perldtrace.h
	(cd $(VER); LC_ALL=C gmake)

test: all
	(cd $(VER); gmake  test)


install: all
	(cd $(VER);\
	    rm -f $(DESTDIR)/usr/perl5/5.12/lib/i86pc-solaris-64int/.packlist;\
	    DESTDIR=$(DESTDIR) \
	    gmake  install)

$(VER):
	gtar -zxf $(TARBALL)

$(VER)/cflags: $(VER)
	(cd $(VER) && \
	cp -f ../config.over ./config.over && \
	PATH=/usr/bin:/usr/sbin:/usr/sfw/bin:$(PATH) \
	./Configure -des -Dcc=$(GCC) )

$(VER)/perldtrace.h: $(VER)/cflags
	(cd $(VER) && \
	/usr/sbin/dtrace -h -s perldtrace.d -o perldtrace.h)


clean:
	rm -rf $(VER)


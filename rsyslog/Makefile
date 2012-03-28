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
# Copyright (c) 2012, Joyent, Inc. All rights reserved.
#

VER=rsyslog-5.8.9
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
CC=$(DESTDIR)/usr/sfw/bin/gcc
GTAR=/usr/bin/gtar

all: $(VER)/config.status
	(cd $(VER); env - PATH=$(PATH) $(MAKE) $(PARALLEL) all)

install: all
	mkdir -p $(DESTDIR)/usr/sbin
	mkdir -p $(DESTDIR)/usr/lib/rsyslog
	mkdir -p $(DESTDIR)/usr/share/man/man1m
	mkdir -p $(DESTDIR)/usr/share/man/man4
	ginstall -m 0755 $(BASE)/$(VER)/tools/rsyslogd \
	    $(DESTDIR)/usr/sbin/rsyslogd
	cp $(BASE)/$(VER)/runtime/.libs/*.so $(DESTDIR)/usr/lib/rsyslog
	cp $(BASE)/$(VER)/plugins/*/.libs/*.so $(DESTDIR)/usr/lib/rsyslog
	cp $(BASE)/$(VER)/.libs/*.so $(DESTDIR)/usr/lib/rsyslog
	cp $(BASE)/$(VER)/tools/rsyslogd.8 \
	    $(DESTDIR)/usr/share/man/man1m/rsyslogd.1m
	cp $(BASE)/$(VER)/tools/rsyslog.conf.5 \
	    $(DESTDIR)/usr/share/man/man4/rsyslog.conf.4
	cp $(BASE)/rsyslog.conf $(DESTDIR)/etc/rsyslog.conf

$(VER)/config.status: $(VER)/configure
	(cd $(VER); env \
	    CC=$(CC) \
	    "CFLAGS=$(CFLAGS)" \
	    PATH=$(PATH) \
	    MAKE=$(MAKE) \
	./configure --prefix=/usr --enable-imsolaris=yes --enable-mail=yes \
	    --enable-omprog=yes)

$(VER)/configure: $(VER).tar.gz
	$(GTAR) zxpf $(VER).tar.gz
	touch $(VER)/configure

clean:
	-rm -rf $(VER)

FRC:

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
# Copyright (c) 2012, Joyent, Inc.  All rights reserved.
#

VER =	rsyslog-5.8.9

include ../Makefile.defs

AUTOCONF_OPTS += \
	--enable-imsolaris=yes \
	--enable-imfile=yes \
	--enable-mail=yes \
	--enable-omprog=yes

PATCHES = patches/*

include ../Makefile.targ

all: all_autoconf

install: all
	mkdir -p $(DESTDIR)/usr/sbin
	mkdir -p $(DESTDIR)/usr/lib/rsyslog
	mkdir -p $(DESTDIR)/usr/share/man/man1m
	mkdir -p $(DESTDIR)/usr/share/man/man4
	ginstall -m 0755 $(BASE)/$(VER.32)/tools/rsyslogd \
	    $(DESTDIR)/usr/sbin/rsyslogd
	cp $(BASE)/$(VER.32)/runtime/.libs/*.so $(DESTDIR)/usr/lib/rsyslog
	cp $(BASE)/$(VER.32)/plugins/*/.libs/*.so $(DESTDIR)/usr/lib/rsyslog
	cp $(BASE)/$(VER.32)/.libs/*.so $(DESTDIR)/usr/lib/rsyslog
	cp $(BASE)/$(VER.32)/tools/rsyslogd.8 \
	    $(DESTDIR)/usr/share/man/man1m/rsyslogd.1m
	cp $(BASE)/$(VER.32)/tools/rsyslog.conf.5 \
	    $(DESTDIR)/usr/share/man/man4/rsyslog.conf.4
	cp $(BASE)/rsyslog.conf $(DESTDIR)/etc/rsyslog.conf

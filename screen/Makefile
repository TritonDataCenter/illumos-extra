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
# Copyright 2018, Joyent, Inc.  All rights reserved.
#

VER =	screen-4.4.0

include ../Makefile.defs

PATCHES =	Patches/*

#
# We set _XOPEN_SOURCE=700 so that screen can access additional fields in
# struct msghdr. pkgsrc also does this.
#
AUTOCONF_ENV += \
	CFLAGS="-std=c99 -D_XOPEN_SOURCE=700"

#
# It is important to make sure that screen has a prefix of /usr. When screen
# builds and prefix is not set, it runs which screen to determine the prefix. On
# the first build, this means that you will probably get /usr/bin/screen.
# However, on subsequent builds, you will get the one from the proto area. Even
# worse, if PATH were ever pathological, you could potentially get
# /opt/local/bin which would be terrible.
#
AUTOCONF_OPTS = \
	--prefix=/usr \
	--enable-colors256 \
	--with-sys-screenrc=/etc/screenrc

include ../Makefile.targ

all: all_autoconf

install: all
	mkdir -p $(DESTDIR)/usr/bin
	ginstall -m 0555 $(BASE)/$(VER.32)/screen $(DESTDIR)/usr/bin/screen
	ginstall -m 0444 $(BASE)/$(VER.32)/doc/screen.1 \
	    $(DESTDIR)/usr/share/man/man1/screen.1

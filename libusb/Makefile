#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2019, Joyent, Inc.
#

VER =	libusb-1.0.22

include ../Makefile.defs

BUILD32 =
BUILD64 = yes

TARBALL =		$(VER).tar.bz2
TARBALL_COMPRESS =	-j

AUTOCONF_OPTS =	\
	--prefix=/usr		\
	--enable-shared		\
	--disable-static	\
	--disable-timerfd

#
# Annoyingly, the configure script for libusb does not allow you to
# specify additional libraries (LIBS is completely ignored for SunOS), so we
# force it in the configure script instead
#PATCHES = configure.patch new.patch

include ../Makefile.targ

all: all_autoconf

install: all
	DESTDIR=$(DESTDIR) PATH=$(PATH) ksh93 ./install-sfw-64 $(VER.64)

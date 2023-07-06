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
# Copyright 2021 Joyent, Inc.
# Copyright 2023 MNX Cloud, Inc.
#

VER =	openldap-2.5.14

include ../Makefile.defs

TARBALL =		$(VER).tgz
AUTOCONF_PREFIX =	/usr/openldap
AUTOCONF_OUT =		config.h

AUTOCONF_OPTS += \
	--disable-slapd \
	--without-cyrus-sasl \
	--sysconfdir=/etc \
	--localstatedir=/var/dp/openldap \
	--with-tls=openssl

LDFLAGS += \
	-Wl,-R/usr/openldap/lib

PATCHES =	Patches/*

include ../Makefile.targ
include ../Makefile.targ.autoconf

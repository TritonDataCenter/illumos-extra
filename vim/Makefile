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
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright 2020 Joyent, Inc.
#

VER =	vim82

include ../Makefile.defs

PATCHES = Patches/defaults.vim

BUILD32 =
BUILD64 = yes

AUTOCONF_OUT =	src/auto/config.status
AUTOCONF_ENV += \
	STRIP=/usr/bin/strip
AUTOCONF_OPTS += \
	--disable-gui \
	--disable-gtktest \
	--with-features=huge \
	--without-x

TARBALL =		vim-8.2.tar.bz2
TARBALL_COMPRESS =	-j

include ../Makefile.targ
include ../Makefile.targ.autoconf

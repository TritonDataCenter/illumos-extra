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
# Copyright (c) 2012, Joyent, Inc.  All rights reserved.
#

VER =	dialog-1.1-20111020

include ../Makefile.defs

AUTOCONF_OUT =	src/auto/config.status
AUTOCONF_OPTS += \
	--mandir=/usr/share/man \
	--disable-Xdialog \
	--disable-rpath-hack

include ../Makefile.targ
include ../Makefile.targ.autoconf

PATCHES = Patches/*

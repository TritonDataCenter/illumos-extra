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
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Copyright (c) 2018, Joyent, Inc.
#

#
# This build is not autoconf-style, but we still want to pick up our compilers
# etc.
#
include ../Makefile.defs

METAINFO_FILE = ../METADATA
VER = openssl-0.9.8zg

PKCS11_LIB = /usr/lib/libpkcs11.so.1
PKCS11_LIB64 = /usr/lib/64/libpkcs11.so.1

ifneq ($(STRAP),strap)
	LDFLAGS += $(GENLDFLAGS)
endif

GENERIC_CONFIGURE_OPTIONS = \
	-DSOLARIS_OPENSSL -DNO_WINDOWS_BRAINDEATH \
	--openssldir=/etc/openssl \
	--prefix=/usr \
	--install_prefix=$(DESTDIR) \
	no-ec \
	no-ecdh \
	no-ecdsa \
	no-rc3 \
	no-rc5 \
	no-mdc2 \
	no-idea \
	no-hw_4758_cca \
	no-hw_aep \
	no-hw_atalla \
	no-hw_chil \
	no-hw_gmp \
	no-hw_ncipher \
	no-hw_nuron \
	no-hw_padlock \
	no-hw_sureware \
	no-hw_ubsec \
	no-hw_cswift \
	threads \
	shared

CONFIGURE_OPTIONS64_i386 = solaris64-x86_64-gcc-sunw
CONFIGURE_OPTIONS64 = $(GENERIC_CONFIGURE_OPTIONS) \
		$(CONFIGURE_OPTIONS64_i386) \
		--pk11-libname=$(PKCS11_LIB64)

CONFIGURE_OPTIONS_i386 = solaris-x86-gcc-sunw
CONFIGURE_OPTIONS = $(GENERIC_CONFIGURE_OPTIONS) \
		$(CONFIGURE_OPTIONS_i386) \
		--pk11-libname=$(PKCS11_LIB)


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
# Copyright (c) 2009, 2010, Oracle and/or its affiliates. All rights reserved.
# Copyright 2021 Joyent, Inc.
# Copyright 2023 MNX Cloud, Inc.
#

VER =	openssh-9.2p1

include ../Makefile.defs

UNPACK_SENTINEL =	configure.ac

AUTOCONF_OPTS += \
	--libexecdir=/usr/lib/ssh \
	--sbindir=/usr/lib/ssh \
	--sysconfdir=/etc/ssh \
	--bindir=/usr/bin \
	--with-audit=solaris \
	--with-kerberos5=$(DESTDIR)/usr \
	--with-pam \
	--with-sandbox=solaris \
	--with-solaris-contracts \
	--with-solaris-privs \
	--with-tcp-wrappers \
	--with-4in6 \
	--with-Werror=no \
	--enable-strip=no \
	--without-rpath \
	--disable-lastlog \
	--with-privsep-user=daemon \
	--without-openssl-header-check \
	--with-key-dir=/var/ssh \
	--with-sys-moduli=/usr/share/lib/ssh/moduli

#
# On SmartOS we want to use the xauth from pkgsrc for our X11 forwarding,
# since we don't ship X11 in the base system at all (and thus won't have a
# /usr/bin/xauth or /usr/X11/bin/xauth or similar). If it's not present
# that's no problem (the code handles this and just won't do transitive
# forwarding).
#
# We don't/can't use the platform sshd for LX branded zones, where this
# path would be incorrect, and the sngl brand is dead, so building the
# pkgsrc path in here should be fine.
#
AUTOCONF_OPTS += \
	--with-xauth=/opt/local/bin/xauth

AUTOCONF_ENV += \
	DESTDIR="$(DESTDIR)" \
	CTFCONVERT="$(CTFCONVERT)"

CFLAGS += \
	-O2 -gdwarf-2 \
	-fno-inline-functions \
	-fno-inline-functions-called-once \
	-fno-inline-small-functions \
	-DSET_USE_PAM -DDEPRECATE_SUNSSH_OPT -DKRB5_BUILD_FIX \
	-DDTRACE_SFTP -DDISABLE_BANNER -DPAM_ENHANCEMENT \
	-DPAM_BUGFIX -DOPTION_DEFAULT_VALUE -DHAVE_EVP_SHA256 \
	-DPER_SESSION_XAUTHFILE \
	-I$(DESTDIR)/usr/include/kerberosv5

LDFLAGS +=	-B direct -z nolazyload

CTF_PROGRAMS_USR_BIN = \
	ssh \
	scp \
	ssh-add \
	ssh-agent \
	ssh-keygen \
	ssh-keyscan \
	sftp

CTF_PROGRAMS_USR_LIB_SSH = \
	sshd \
	ssh-keysign \
	ssh-pkcs11-helper \
	sftp-server

CTF_PROGRAMS = \
	$(CTF_PROGRAMS_USR_BIN:%=/usr/bin/%) \
	$(CTF_PROGRAMS_USR_LIB_SSH:%=/usr/lib/ssh/%)

PATCHSTRIP =	1
PATCHES =	Patches/*

include ../Makefile.targ

$(VER.32)/configure: $(VER.32)/configure.ac
	(cd $(OBJ.32); \
	    env - PATH=$(PATH) $(AUTOCONF_ENV) \
	    autoreconf -fi)

all: all_autoconf

install: all
	(cd $(VER.32); env - $(AUTOCONF_ENV) PATH=$(PATH) \
	     gmake $(install_PARALLEL) $(OVERRIDES) install DESTDIR=$(DESTDIR))
	(rm $(VER.32)/sftp_provider.o)
	(env - $(AUTOCONF_ENV) $(MAKE_CTF.32) $(CTF_PROGRAMS))

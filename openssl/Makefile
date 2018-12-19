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
# Copyright (c) 2018, Joyent, Inc.
#

#
# openssl has a painfully baroque build system (read Configure if you doubt it).
# Configure allows us to add -D options, but there's no way to over-ride
# compiler flags. We want to point to the proto headers, though, so we are
# forced to hack this in by claiming our compiler is "$(GCC) $(CPPFLAGS)".
# I'm sorry.
#

BASE=$(PWD)
DESTDIR=$(BASE)/../proto

#
# This version of openssl is so downrev that its build-time Perl scripts won't
# work with the /opt/local/ version of Perl, so we have to use our bootstrap
# Perl here.  And, in fact, this is really the only reason we have the bootstrap
# Perl.
#
PERL=$(STRAPPROTO)/usr/perl5/5.12/bin/perl

include Makefile.com

MANDIR = $(DESTDIR)/usr/share/man

CONFIG_STATUS = config.status

all: all32 all64

all32: $(VER.32)/$(CONFIG_STATUS)
	cd $(VER.32); gmake

all64: $(VER.64)/$(CONFIG_STATUS)
	cd $(VER.64); gmake

# opensslconf.h is patched to ensure suitability for both 64bit and 32bit
$(VER.32)/$(CONFIG_STATUS): $(VER.32)/configure
	cd $(VER.32); env - PATH=$(PATH) CC="$(GCC) $(CPPFLAGS)" \
	PERL=$(PERL) ksh93 ./Configure $(CONFIGURE_OPTIONS)
	gpatch -p1 $(VER.32)/crypto/opensslconf.h opensslconf.patch
	cd $(VER.32); gmake  depend
	touch $@

$(VER.64)/$(CONFIG_STATUS): $(VER.64)/configure
	cd $(VER.64); env - PATH=$(PATH) CC="$(GCC) $(CPPFLAGS)" \
	PERL=$(PERL) ksh93 ./Configure $(CONFIGURE_OPTIONS64)
	cd $(VER.64); gmake  depend
	touch $@

install: all install32 install64

install32: all32
	MACH32=i386 VERDIR=$(VER.32) BASE=$(BASE) DESTDIR=$(DESTDIR) \
	    VERSION=$(VER) ksh93 ./install-sfw

install64: all64
	MACH64=amd64 VERDIR=$(VER.64) BASE=$(BASE) DESTDIR=$(DESTDIR) \
	    VERSION=$(VER) ksh93 ./install-sfw-64

$(VER.32)/configure: $(VER)-src
	cp -r $(VER)-src $(VER.32)
	( cd $(VER.32) ; gpatch -p1 < ../configure.patch )
	( cd $(VER.32) ; gpatch -p1 < ../limits.patch )
	cp engine_pkcs11/* $(VER.32)/crypto/engine/
	touch $(VER.32)/configure
	cp -r $(VER.32) $(VER.64)

clean:
	-rm -rf $(VER.32) $(VER.64)

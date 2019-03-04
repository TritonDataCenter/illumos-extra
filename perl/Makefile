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
# Copyright (c) 2019, Joyent, Inc.
#


VER =	perl-5.12.3

include ../Makefile.defs

UNPACK_SENTINEL =	Configure

LF_CPPFLAGS = \
	-D_LARGEFILE_SOURCE \
	-D_FILE_OFFSET_BITS=64

BASIC_CPPFLAGS = \
	-fno-strict-aliasing \
	-pipe \
	-fstack-protector

CPPFLAGS += \
	$(BASIC_CPPFLAGS) \
	$(LF_CPPFLAGS) \
	-DPERL_USE_SAFE_PUTENV

NATIVE_CPPFLAGS += \
	$(BASIC_CPPFLAGS) \
	$(LF_CPPFLAGS) \
	-DPERL_USE_SAFE_PUTENV

LDFLAGS += \
	-fstack-protector

NATIVE_LDFLAGS += \
	-fstack-protector

SHARED_LDFLAGS = \
	-G \
	$(LDFLAGS)

NATIVE_SHARED_LDFLAGS = \
	-G \
	$(NATIVE_LDFLAGS)

PATCHES += \
	dtrace.patch \
	native.patch \
	fix-gcc-errno.patch

#
# This is where things get really gross.  There is stuff in ON that is going
# to use the bootstrap perl to build various artifacts (binary and otherwise).
# When it does so, that perl needs to know to look in the *proto* area, not
# the bootstrap proto area, for everything except its own installed files.  So
# all the header and library flags need to point there.  Similarly, when we
# build the perl that will end up in the platform, it needs to go in the proto
# area but its configuration must reflect the installed (platform) paths.
#
# To accommodate both of these, we split the familiar config.sh into the
# perl-build-time config.over and the perl-run-time (consumer build-time)
# Config_heavy.pl.  We further introduce the notion of the "next" proto area;
# that is, where the perl we're building should tell its consumers to look
# for the rest of the system.  Similarly, "this" proto simply means where
# *this* perl will itself be installed.  This system implies knowledge of
# the mechanism used to build bootstrap and ordinary proto areas in
# smartos-live and it will not otherwise work.
#
# Further complicating matters is the need for differences in runtime
# configuration between the bootstrap and delivered perl, giving rise to two
# different Config_heavy.pl templates.
#
# Finally, because the bootstrap perl actually knows that it's going to end
# up in the bootstrap proto area (it has to, since it will be run from there
# and needs to know to look there for pieces of itself), we do NOT use
# DESTDIR when installing it.  We *do* when installing the delivered perl,
# which is never run on the build system.  Thus, INSTALL_DESTDIR is set only
# for the regular build; for the bootstrap build it is empty.
#
# The alternative to this is to run the perl on the build system during the
# build.  However, the platform image on the build machine may be arbitrarily
# old, and doing this would create a platform image (and this also fake subset)
# flag day if and when the perl in this repo is changed.  This is because it is
# necessary for the binary modules in ON to be built against the same perl that
# will actually be installed on the running system.  In this regard they are
# quite similar to other ON consumers of -extra bits.  The only complication is
# that consuming perl as a binary module conventionally requires not only that
# the headers and libraries be present but also that a matching perl be
# available and executable at build time.
#
# I can't believe we've made it this far without any profanity.  Holy fuck!
#
INSTALL_DESTDIR :=	$(shell [[ -z "$(STRAP)" ]] && echo "$(DESTDIR)")
NEXTPROTO :=	$(shell [[ -n "$(STRAP)" ]] && echo "$(DESTDIR:.strap=)")

CONFIG_PL =	Config_heavy.pl$(STRAP)
ROOTBASE =	$(DESTDIR)/usr/perl5/5.12
ROOTCONFIG_PL =	$(ROOTBASE)/lib/i86pc-solaris-64int/Config_heavy.pl

CLEANFILES +=	$(CONFIG_PL)

XFORM.sh = \
	sed -e 's;@@CC@@;$(GCC);g' \
	    -e 's;@@CPPFLAGS@@;$(CPPFLAGS);g' \
	    -e 's;@@CFLAGS@@;$(CFLAGS);g' \
	    -e 's;@@NATIVE_CPPFLAGS@@;$(NATIVE_CPPFLAGS);g' \
	    -e 's;@@NATIVE_CFLAGS@@;$(NATIVE_CFLAGS);g' \
	    -e 's;@@BASIC_CPPFLAGS@@;$(BASIC_CPPFLAGS);g' \
	    -e 's;@@LF_CPPFLAGS@@;$(LF_CPPFLAGS);g' \
	    -e 's;@@LDFLAGS@@;$(LDFLAGS);g' \
	    -e 's;@@NATIVE_LDFLAGS@@;$(NATIVE_LDFLAGS);g' \
	    -e 's;@@LIBS@@;$(LIBS);g' \
	    -e 's;@@GMAKE@@;$(MAKE);g' \
	    -e 's;@@THISPROTO@@;$(STRAP:strap=$(DESTDIR));g' \
	    -e 's;@@NEXTPROTO@@;$(NEXTPROTO);g' \
	    -e 's;@@NATIVE_SHARED_LDFLAGS@@;$(NATIVE_SHARED_LDFLAGS);g' \
	    -e 's;@@SHARED_LDFLAGS@@;$(SHARED_LDFLAGS);g' < $< > $@

include ../Makefile.targ

all: $(VER.32)/perldtrace.h
	(cd $(VER.32); LC_ALL=C $(MAKE) $(OS_1828_WAR))

test: all
	(cd $(VER.32); $(MAKE) $(OS_1828_WAR) test)

install: all $(CONFIG_PL)
	(cd $(VER.32);\
	    rm -f $(DESTDIR)/usr/perl5/5.12/lib/i86pc-solaris-64int/.packlist;\
	    gmake DESTDIR=$(INSTALL_DESTDIR) $(OS_1828_WAR) install)
	rm -f $(DESTDIR)/usr/perl5/5.12/lib/i86pc-solaris-64int/Config_heavy.pl
	cp $(CONFIG_PL) $(ROOTCONFIG_PL)

$(VER.32)/config.over: config.over.in $(VER.32)/$(UNPACK_SENTINEL) Makefile
	$(XFORM.sh)

$(CONFIG_PL): $(CONFIG_PL).in Makefile
	$(XFORM.sh)

$(VER.32)/cflags: $(VER.32)/config.over $(VER.32)/Configure
	(cd $(VER.32) && \
	    ./Configure -des -Dcc="$(GCC)" -Duse64bitint)

$(VER.32)/perldtrace.h: $(VER.32)/cflags
	(cd $(VER.32) && \
	    /usr/sbin/dtrace -h -s perldtrace.d -o perldtrace.h)

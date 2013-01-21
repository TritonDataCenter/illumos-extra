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
# Copyright (c) 2012, Joyent, Inc.  All rights reserved.
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

LDFLAGS += \
	-fstack-protector

SHARED_LDFLAGS = \
	-G \
	$(LDFLAGS)

include ../Makefile.targ

all: $(VER.32)/perldtrace.h
	(cd $(VER.32); LC_ALL=C $(MAKE))

test: all
	(cd $(VER.32); $(MAKE) test)

install: all
	(cd $(VER.32);\
	    rm -f $(DESTDIR)/usr/perl5/5.12/lib/i86pc-solaris-64int/.packlist;\
	    DESTDIR=$(DESTDIR) \
	    gmake  install)
	rm -f $(DESTDIR)/usr/perl5/5.12/lib/i86pc-solaris-64int/Config_heavy.pl
	cp Config_heavy.pl $(DESTDIR)/usr/perl5/5.12/lib/i86pc-solaris-64int/

$(VER.32)/config.over: config.over.in $(VER.32)/$(UNPACK_SENTINEL)
	sed -e 's#@@CC@@#$(GCC)#g' \
	    -e 's#@@CPPFLAGS@@#$(CPPFLAGS)#g' \
	    -e 's#@@CFLAGS@@#$(CFLAGS)#g' \
	    -e 's#@@BASIC_CPPFLAGS@@#$(BASIC_CPPFLAGS)#g' \
	    -e 's#@@LF_CPPFLAGS@@#$(LF_CPPFLAGS)#g' \
	    -e 's#@@LDFLAGS@@#$(LDFLAGS)#g' \
	    -e 's#@@LIBS@@#$(LIBS)#g' \
	    -e 's#@@GMAKE@@#$(MAKE)#g' \
	    -e 's#@@SHARED_LDFLAGS@@#$(SHARED_LDFLAGS)#g' < $< > $@

$(VER.32)/cflags: $(VER.32)/config.over $(VER.32)/Configure
	(cd $(VER.32) && \
	    ./Configure -des -Dcc=$(GCC) )

$(VER.32)/perldtrace.h: $(VER.32)/cflags
	(cd $(VER.32) && \
	    /usr/sbin/dtrace -h -s perldtrace.d -o perldtrace.h)

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
# Copyright (c) 2018, Joyent, Inc.
#

#
# The mdb_v8 build has built-in dependencies as git submodules. To
# prepare an updated version of this, you should perform the following
# steps, the github release tarballs are misleading and will not work!
#
# 1. clone mdb_v8 into a directory named mdb_v8-<ver>
# 2. Checkout the corresponding tag, via git checkout <tag>
# 3. From one directory up, run tar cvzf mdb_v8-<ver>.tar.gz mdb_v8-<ver>
#

VER =	mdb_v8-1.3.0

include ../Makefile.defs
include ../Makefile.targ

CLEANFILES += .unpack

CTF_LIBS = $(VER)/build/ia32/mdb_v8.so \
	$(VER)/build/amd64/mdb_v8.so

#
# Required for CTF generation
#
CFLAGS += -g

#
# To avoid "error: left shift of negative value"
#
CFLAGS += -Wno-shift-negative-value

#
# There are a couple of bugs in the currently released version of mdb_v8
# that do not support parallelism, thus we explicitly do not include any
# -j options below. The build is also very small, so it is unlikely to
# make a meaningful difference.
#
all: $(VER)/GNUMakefile
	cd $(VER) && \
	    env - $(AUTOCONF_ENV) PATH=$(PATH) $(MAKE) $(OVERRIDES) release

install: all
	rm -f $(DESTDIR)/usr/lib/mdb/proc/v8.so
	$(ALTCTFCONVERT) -l $(VER) -o $(DESTDIR)/usr/lib/mdb/proc/v8.so \
	    $(VER)/build/ia32/mdb_v8.so
	rm -f $(DESTDIR)/usr/lib/mdb/proc/amd64/v8.so
	$(ALTCTFCONVERT) -l $(VER) -o $(DESTDIR)/usr/lib/mdb/proc/amd64/v8.so \
	    $(VER)/build/amd64/mdb_v8.so

$(VER)/GNUMakefile: $(VER).tar.gz
	-rm -rf $(VER)
	mkdir -p .unpack
	gtar x -C .unpack -z --no-same-owner -f $(VER).tar.gz
	mv -f .unpack/$(VER) $(VER)
	-rmdir .unpack

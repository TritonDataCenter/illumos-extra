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
# Copyright (c) 2001, 2010, Oracle and/or its affiliates. All rights reserved.
# Copyright (c) 2012, Joyent Inc.  All rights reserved.
#

BVER =	bzip2-1.0.6
VER = $(BVER)$(STRAP)

include ../Makefile.defs

OVERRIDES +=	CC="$(GCC)"
OVERRIDES.64 +=	CC="$(GCC.64)"

CLEANFILES +=	bzgrep.tmp $(VER)strap

include ../Makefile.targ

all: all_32 all_64

all_32: $(VER)/i386/Makefile
	(cd $(VER)/i386; \
	    env - PATH=$(PATH) $(MAKE) $(PARALLEL) $(OVERRIDES))

all_64: $(VER)/amd64/Makefile
	(cd $(VER)/amd64; \
	    env - PATH=$(PATH) $(MAKE) $(PARALLEL) $(OVERRIDES.64))

install: all
	/usr/bin/ksh93 ./install-bzip2 $(PWD)/$(VER)

$(VER)/Makefile.dist: $(BVER).tar.gz
	-rm -rf $(VER)
	mkdir -p .unpack
	gtar x -C .unpack -z --no-same-owner -f $(BVER).tar.gz
	mv -f .unpack/$(BVER) $(VER)
	-rmdir .unpack
	(cd $(VER); gpatch -p1 < ../bzip2.patch)
	cp $(VER)/Makefile $(VER)/Makefile.dist

$(VER)/i386/Makefile $(VER)/amd64/Makefile: $(VER)/Makefile.dist makefile.build
	mkdir -p $(@D)
	cp makefile.build $@

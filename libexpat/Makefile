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
# Copyright (c) 2012 Joyent, Inc. All rights reserved.
#

VER=expat-2.0.1
VER64=$(VER)-64
LARGEFILES= -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
CCSMAKE=/usr/ccs/bin/make
CC=cc
CCC=ccc
CC64=$(CC)
CCC64=$(CCC)
CCFLAGS="-KPIC"
CCFLAGS64="-m64 -KPIC"

all: real-all

all32: $(VER)/config.status
	(cd $(VER); env \
	    CC=$(CC) CXX=$(CCC) \
	    "CFLAGS= -g -DHAVE_EXPAT_CONFIG_H $(LARGEFILES)" \
	    "INSTALL=/usr/ucb/install -c" \
        PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    MAKE=$(CCSMAKE) $(CCSMAKE))
	@find . -name core -exec rm -f {} \;

all64: $(VER64)/config.status
	(cd $(VER64); env \
	    "CC=$(CC64)" "CXX=$(CCC64)" \
	    "CFLAGS=$(CCFLAGS64) -g -DHAVE_EXPAT_CONFIG_H $(LARGEFILES)" \
	    "INSTALL=/usr/ucb/install -c" \
        PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    MAKE=$(CCSMAKE) $(CCSMAKE))
	@find . -name core -exec rm -f {} \;

install: all
	DESTDIR=$(DESTDIR) /bin/bash ./install-sfw
	DESTDIR=$(DESTDIR) MACH64=amd64 /bin/bash ./install-sfw-64

real-all: all32 all64

$(VER)/config.status: $(VER)/configure
	(cd $(VER); env \
        PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    CC=$(CC) CFLAGS=$(CCFLAGS) CXX=$(CCC) \
	    "INSTALL=/usr/ucb/install -c" \
	    "MAKE=$(CCSMAKE)" \
	    ./configure --prefix=/usr)

$(VER64)/config.status: $(VER64)/configure
	(cd $(VER64); env \
        PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH) \
	    CC=$(CC64) CFLAGS=$(CCFLAGS64) CXX=$(CCC64) \
	    "INSTALL=/usr/ucb/install -c" \
	    "MAKE=$(CCSMAKE)" \
	    ./configure --prefix=/usr)

$(VER)/configure: $(VER).tar.gz
	gzip -dc $(VER).tar.gz | tar xopf -
	(cd $(VER); gpatch -p0 < ../CVE-2009-3560.patch)
	(cd $(VER); gpatch -p0 < ../CVE-2009-3720.patch)
	touch $(VER)/configure

$(VER64)/configure: $(VER).tar.gz
	mkdir -p tmp
	gzip -dc $(VER).tar.gz | (cd tmp; tar xopf -)
	rm -rf $(VER64)
	mv tmp/$(VER) $(VER64); rmdir tmp
	(cd $(VER64); gpatch -p0 < ../CVE-2009-3560.patch)
	(cd $(VER64); gpatch -p0 < ../CVE-2009-3720.patch)
	touch $(VER64)/configure
clean:
	-rm -rf $(VER)
	-rm -rf $(VER64)

install_h:


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
# Copyright (c) 2010 Joyent Inc.
#

VER=rsync-3.0.6
BASE=$(PWD)
DESTDIR=$(BASE)/../proto
CCSMAKE=/usr/ccs/bin/make
CC=cc
GTAR=/usr/bin/gtar
SH=ksh93

-include ../Makefile.inc

all: $(VER)/config.status
	(cd $(VER); env \
	    CC=$(CC) \
	    LD_OPTIONS="-M $(BASE)/mapfile_noexstk -L/usr/sfw/lib -R/usr/sfw/lib" \
	    PATH=$(PATH) \
	    MAKE=$(CCSMAKE) $(CCSMAKE))
	@find . -name core -exec rm -f {} \;

install: all
	VERDIR=$(VER) $(SH) ./install-sfw

$(VER)/config.status: $(VER)/configure
	(cd $(VER); env \
	    CC=$(CC) \
	    "CFLAGS=$(CFLAGS)" \
	    "LD_OPTIONS=-L/usr/sfw/lib -R/usr/sfw/lib" \
	    PATH=$(PATH) \
	    MAKE=$(CCSMAKE) \
	./configure --prefix=/usr --with-included-popt )

$(VER)/configure: $(VER).tar.gz
	$(GTAR) zxpf $(VER).tar.gz --no-same-owner
	patch $(VER)/rsync.1 < rsync.1.diff
	touch $(VER)/configure
	find $(VER) -type d -exec /usr/bin/chmod 755 "{}" \;
	find $(VER) -type f -exec /usr/bin/chmod ugo+r "{}" \;

clean:
	-rm -rf $(VER)

FRC:

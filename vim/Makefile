#
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
#
# Copyright (c) 2010 Joyent Inc.
#

VER=vim72
BASE=$(PWD)
DESTDIR=$(BASE)/../proto

all: $(VER)/src/auto/config.status
	(cd $(VER); env \
	    "CC=gcc" "CXX=g++" \
	    make -e)

install: all
	(cd $(VER); env \
	    "CC=gcc" "CXX=g++" \
	    DESTDIR=$(DESTDIR) \
	    make -e install)
#	(BASE=$(BASE) ksh93 ./install.sfw)

$(VER)/src/auto/config.status: $(VER)/configure
	(cd $(VER); env \
	    "CC=gcc" "CXX=g++" \
	    "PATH=/opt/SUNWspro/bin:/usr/gnu/bin:$(PATH)" \
	    ./configure --prefix=/usr \
	                --disable-gui \
			--disable-gtktest \
			--with-features=huge \
	                --without-x )

$(VER)/configure:
	gtar -jxf $(VER).tar.bz2
	touch $(VER)/configure

clean:
	-rm -rf $(VER)

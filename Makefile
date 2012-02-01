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
# Copyright (c) 2012, Joyent, Inc.
#
# To build everything just run 'gmake' in this directory.
#

PATH=/sbin:/usr/sbin:/usr/bin:/opt/SUNWspro/bin:/opt/local/bin
BASE=$(PWD)
DESTDIR=$(BASE)/proto
SUBDIRS= bash bzip2 curl g11n gcc gcc4 gnupg gtar gzip less libexpat libidn \
	libm libxml libz ncurses node.js nss-nspr ntp openldap openssl perl \
	rsync screen socat uuid vim wget

NAME=illumos-extra

AWK=$(shell (which gawk 2>/dev/null | grep -v "^no ") || which awk)
BRANCH=$(shell git symbolic-ref HEAD | $(AWK) -F/ '{print $$3}')

ifeq ($(TIMESTAMP),)
  TIMESTAMP=$(shell date -u "+%Y%m%dT%H%M%SZ")
endif

GITDESCRIBE=g$(shell git describe --all --long | $(AWK) -F'-g' '{print $$NF}')
TARBALL=$(NAME)-$(BRANCH)-$(TIMESTAMP)-$(GITDESCRIBE).tgz

-include Makefile.inc

#
# pkg-config may be installed. This will actually only hurt us rather than help
# us. pkg-config is based as a part of the pkgsrc packages and will pull in
# versions of libraries that we have in /opt/local rather than using the ones in
# /usr that we want. PKG_CONFIG_LIBDIR controls the actual path. This
# environment variable nulls out the search path. Other vars just control what
# gets appended.
#
$(SUBDIRS): FRC
	cd $@; PKG_CONFIG_LIBDIR="" $(MAKE) DESTDIR=$(DESTDIR) install

install: $(SUBDIRS)

clean: 
	-for dir in $(SUBDIRS); do (cd $$dir; $(MAKE) DESTDIR=$(DESTDIR) clean); done
	-rm -rf proto

manifest:
	cp manifest $(DESTDIR)/$(DESTNAME)

tarball:
	tar -zcf $(TARBALL) manifest proto

FRC:

.PHONY: manifest

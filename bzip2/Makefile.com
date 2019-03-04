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
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Copyright (c) 2019, Joyent, Inc.
#

LIBRARY = libbz2.a
VERS = .1

OBJECTS = \
	blocksort.o  \
	huffman.o    \
	crctable.o   \
	randtable.o  \
	compress.o   \
	decompress.o \
	bzlib.o

bzip2_OBJECTS = \
	bzip2.o

bzip2recover_OBJECTS = \
	bzip2recover.o

LDFLAGS += -Wl,-Bdirect -Wl,-zdefs -Wl,-ztext -Wl,-zcombreloc
LDFLAGS += -Wl,-M../../mapfile -Wl,-h,$(DYNLIB)
LDFLAGS += -L. -L$(DESTDIR)/usr/lib -L$(DESTDIR)/lib
ifneq ($(STRAP),strap)
	LDFLAGS += $(GENLDFLAGS)
endif
LDLIBS += -lc

PROGS = bzip2 bzip2recover
PROG_LDFLAGS += -Wl,-Bdirect -L.
ifneq ($(STRAP),strap)
	PROG_LDFLAGS += $(GENLDFLAGS)
endif
bzip2_LDLIBS += -lbz2

# --- Generic ---

CPPFLAGS += -I..
CFLAGS += -fPIC -O2
DYNLIB = $(LIBRARY:.a=.so)$(VERS)
LIBLINKS = $(LIBRARY:.a=.so)

LINK.prog = $(CC) $(PROG_LDFLAGS) -o $@ $($(@)_OBJECTS) \
	    $(PROG_LDLIBS) $($(@)_LDLIBS)

all: $(LIBLINKS) $(DYNLIB) $(PROGS)

$(LIBLINKS): $(DYNLIB)
	ln -sf $(DYNLIB) $(LIBLINKS)

$(DYNLIB): $(OBJECTS)
	rm -f $(DYNLIB)
	$(CC) $(CFLAGS) -shared -o $(DYNLIB) $(OBJECTS) $(LDFLAGS) $(LDLIBS)

%.o: ../%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# --- Specific ---

bzip2: $(LIBLINKS) $(DYNLIB) $(bzip2_OBJECTS)
	$(LINK.prog)

bzip2recover: $(bzip2recover_OBJECTS)
	$(LINK.prog)

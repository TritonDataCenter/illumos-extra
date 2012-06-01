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
# Copyright (c) 2012 Joyent Inc.
#

include ../Makefile.defs

PROG =		cpp
PROGDIR =	/usr/lib

OBJS = \
	cpp.o \
	y.tab.o

CLEANFILES += \
	y.tab.c

CFLAGS +=	-O2
LD =		$(GCC)

COMPILE.c =	$(GCC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
LINK.prog =	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
PROTOFILES =	$(DESTDIR)$(PROGDIR)/$(PROG)

all: $(PROG)

install: $(PROTOFILES)

clean:
	-rm -f $(OBJS) $(CLEANFILES) $(PROG)

$(PROG): $(OBJS)
	$(LINK.prog)

%.o: %.c
	$(COMPILE.c)

$(DESTDIR)$(PROGDIR)/%: %
	mkdir -p $(DESTDIR)$(PROGDIR)
	/usr/sbin/install -m 0755 -f $(DESTDIR)$(PROGDIR) $(PROG)

y.tab.c: cpy.y
	$(YACC) cpy.y

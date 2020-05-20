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

PROG =		cpp$(STRAP)
PROGDIR =	/usr/lib

OBJS = \
	cpp.o$(STRAP) \
	y.tab.o$(STRAP)

CLEANFILES += \
	y.tab.c$(STRAP)

CERRWARN=	-Wall -Wextra
CERRWARN +=	-Wno-unknown-pragmas
CERRWARN +=	-Wno-sign-compare
CERRWARN +=	-Wno-unused-label
CFLAGS +=	-O2 $(CERRWARN)
LD =		$(GCC)

COMPILE.c =	$(GCC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
LINK.prog =	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
PROTOFILES =	$(DESTDIR)$(PROGDIR)/$(PROG)

all: $(PROG)

install: $(PROTOFILES)

clean:
	-rm -f $(OBJS) $(CLEANFILES) $(PROG) *strap

$(PROG): $(OBJS)
	$(LINK.prog)

%.o$(STRAP): %.c
	$(COMPILE.c)

y.tab.o$(STRAP): yylex.c

#
# We need to distinguish between the cpp build in the bootstrap and the cpp
# built normally. However, when we install it, they need to have the same name.
# To handle this we add a small bit of shell logic. Note that the mv bit is
# explicitly ignored and instead we do a final check to make sure we have
# something called cpp at the very end which will either be because of install
# or because of the later mv.
#
$(DESTDIR)$(PROGDIR)/%: %
	mkdir -p $(DESTDIR)$(PROGDIR)
	/usr/sbin/install -m 0755 -f $(DESTDIR)$(PROGDIR) $(PROG)
	-[ "$(PROG)" == "cppstrap" ] && mv -f $(DESTDIR)$(PROGDIR)/$(PROG) \
	    $(DESTDIR)$(PROGDIR)/cpp
	[ -f "$(DESTDIR)$(PROGDIR)/cpp" ]

y.tab.c: cpy.y
	$(YACC) cpy.y

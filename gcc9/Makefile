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
# Copyright 2020 Joyent, Inc.
#

#
# The tarball is from a specific tagged release of
# https://github.com/illumos/gcc repository.  This includes all of the
# illumos-specific modifications we need.  We could probably do a git clone
# instead, but the tarball method is easier given these Makefiles.  The odd
# prefix of "gcc-gcc-..." is due to github's <repo>-<tag> naming.
#

include ../Makefile.defs

BUILD64=yes
BUILD32=

GCC_VER = 9
VER = gcc-gcc-9.3.0-pre
MPFR_VER = mpfr-4.0.2
GMP_VER = gmp-6.2.0
MPC_VER = mpc-1.1.0

include ../Makefile.gcc

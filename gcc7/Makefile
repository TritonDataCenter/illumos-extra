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
# The GCC tarball is a copy of the https://github.com/illumos/gcc repository,
# gcc-7.3.0-il-1 branch.  This includes all of the Illumos-specific
# modifications we need.  We could probably do a git clone instead, but the
# tarball method is easier given these Makefiles.
#

include ../Makefile.defs

GCC_VER = 7
VER = gcc-7.3.0-il-1
MPFR_VER = mpfr-3.1.6
GMP_VER = gmp-6.1.2
MPC_VER = mpc-1.0.3
GXX = /opt/local/bin/g++
CFLAGS = -g -O2

include ../Makefile.gcc

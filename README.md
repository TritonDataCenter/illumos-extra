# illumos-extra: extra software for illumos distributions

## Overview

This repository, illumos-extra, is a collection of software which falls
into two categories: either it is an illumos build and/or run-time
dependency or it is a piece of additional software that SmartOS uses.
For example, the `gcc*` and `binutils` directories are examples of
illumos dependencies, while `node.js` and `lldp` are examples of extra
pieces of software that SmartOS uses to form its core ram-disk.
illumos-extra is a fundamental part of the SmartOS build process;
however, it may be used outside of building SmartOS itself.

Building is broken down into two different phases.  The first phase is
the `strap` phase, short for bootstrap.  It builds all of build-time
dependencies for illumos and the rest of the SmartOS build.  This is a
minimal subset of the software.  The core guiding principle of this
phase to eliminate the dependencies for building illumos and thus
SmartOS from the build system itself.  This allows the build system to
evolve independently of the requirements of building the system itself.

The second phase of the build occurs after illumos has been built.
While the first phase uses libraries from the build system, the second
phase only uses the headers and libraries from the proto area of the
illumos build.  This adds an important and necessary constraint:
software built against the proto area cannot be run on the build system
itself, it must be thought of and treated like a cross-compilation
environment.

## Architecture

Every directory in illumos-extra contains a source tarball, a GNU
compatible makefile, and optionally, a series of patches that should be
applied to the source code.  illumos-extra uses recursive gmake to build
each component directory.  As most of these projects are based around
the ecosystem of GNU autoconf, a preset series of Makefiles are provided
to take care of building and installing the software.  Additional
autoconf options and patches are specified in these per-directory
makefiles.

The top-level makefiles, `Makefile.defs`, `Makefile.targ`, and
`Makefile.targ.autconf` ensure that the proper directories, prefixes,
and compilers are used based on whether the strap build is running or
not.

## Known Issues

  * binutils does not always properly perform incremental builds.
    (OS-3122)

  * Various pieces of software run programs from the proto area as part
    of their build.

## Future directions

The following components live in illumos-extra that should more likely
be a part of illumos itself:

  * g11n - Provides iconv modules for internationalization
  * make - Provides Sun parallel make, the `dmake` binary

They will not be removed until the projects have been integrated
upstream.

## Bugs and Contributing

If you encounter any issues with the build process, please reach out to
us and file a bug on http://github.com/joyent/illumos-extra/issues. Bug
fixes and other contributions are accepted, they should be submitted to
the illumos-extra github repository.

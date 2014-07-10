# NTP

This is the "dev" branch of the reference NTP implementation from
http://ntp.org.

## Manual Pages

The software makes use of GNU AutoGen for manual page generation.
Unfortunately, due to some combination of AutoGen and custom templates shipped
and used in the NTP distribution, correct manual page generation has become
virtually impossible.  In order to work around this defect without regressing
the documentation, pre-rendered copies of the set of manual pages from the
previous version of NTP will be shipped in place.

## Patches

Some patches are required to make the build process, and resultant software,
behave.  These patches, present in the `Patches/` directory, are briefly
described below:

### `etcfix.patch`

The historic Solaris location for `ntp.conf` was in `/etc/inet`.  The source
requires some patches to allow us to use this path, instead of the default
`/etc/ntp.conf`.

### `monitor.patch`

The `libntp` library unfortunately shares a symbol name with `libc` and
generates a warning that would normally be fatal:

    ld: warning: symbol 'monitor' has differing types:
        (file ../libntp/libntp.a(audio.o) type=OBJT; file
        .../proto/usr/lib/libc.so type=FUNC);
        ../libntp/libntp.a(audio.o) definition taken

This patch allows us to continue using the `-zfatal-warnings` flag for `ld`.

### `no_sntp.patch`

We do not wish to build the `sntp` binary, so we patch the Makefile to avoid
doing so.

### `configure.patch` (and `perl.patch`, `openssl.patch`)

The GNU Autoconf-based build system used by NTP is, to say the least,
unfortunate.  In particular, it spectacularly hamfists the detection and use of
OpenSSL: the search behaviour is broken, and a failure does not halt the build.
We patch the M4 source file for OpenSSL detection to accept a special flag:

    ./configure --with-crypto=sunw

Which forces our sane build flags to be used without any further detection or
mangling.  We also patch in a `--with-perllibdir` flag, and a `--with-perl`
flag, such that we can ship the platform-private `NTP` perl module in
`/usr/perl5/5.12/lib` instead of `/usr/share`, and ensure it uses the correct
`perl` interpreter.

The primary patch, `configure.patch`, includes a regenerated `configure`
script.  The M4 source file changes are in `perl.patch` and `openssl.patch`.

### `ntp_util.patch`

The include Perl module, `NTP::Util`, does not work completely correctly with
the version of the `Socket` module that ships in the platform Perl
distribution.  Specifically, the version string is `"1.87_01"`, which emits a warning:

    Argument "1.87_01" isn't numeric in numeric ge (>=) at
        /usr/perl5/5.12/lib/NTP/Util.pm line 16.

This patch makes us assume an old version of `Socket`, which is what we ship,
and prevents the warning from being emitted.  This is tracked upstream as [ntp
bug 2620](http://bugs.ntp.org/show_bug.cgi?id=2620)

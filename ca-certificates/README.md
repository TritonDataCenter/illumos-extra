# ca-certificates

The trusted root CA bundle for the global zone.

## What ships

`cacert.pem` goes to `/usr/share/ca-certificates/cacert.pem`, and the manifest
links `/etc/openssl/cert.pem` to it.

That is the only path we ship, because it is the only one the platform reads.
The platform OpenSSL is built with `--openssldir=/etc/openssl`, which makes
`/etc/openssl/cert.pem` its `X509_CERT_FILE`. Every program in the platform that
does TLS, which is curl, wget, openssl and gpg, gets the bundle from there.

Do not add a link for a path some other operating system uses. Add a path when a
program we ship needs it, and not before.

The bundle goes in `/usr` because the boot archive holds `/usr` as a compressed
image. Only the link goes in `/etc`.

Do not put the certificates in `/etc/openssl/certs` as one file for each CA plus
hash links. That layout is more than 1 MB, and this bundle is less than 200 KB.

## Where it comes from

`https://curl.se/ca/cacert.pem`, which the curl project makes from the Mozilla
NSS `certdata.txt` with `mk-ca-bundle.pl`. Only roots with the
`SERVER_AUTH:TRUSTED_DELEGATOR` trust bits are in it. The head of the file gives
the source URL and the date of the Mozilla data.

## How to update it

    gmake update

This gets the bundle and its hash, checks one against the other, writes
`cacert.fingerprints`, and replaces all three files. Commit the three together.

## How to review an update

Review the change to `cacert.fingerprints`. Do not review the change to
`cacert.pem`.

`cacert.fingerprints` holds the SHA-256 fingerprint and subject of each
certificate in the bundle, sorted by fingerprint. `mkfingerprints` makes it. A
fingerprint is the identity of a certificate. The names in `cacert.pem` are
comments, so a bad bundle can name a certificate anything it wants, but it
cannot give it a fingerprint that it does not have.

For each added line, check the fingerprint against Mozilla. For each removed
line, check that Mozilla removed that root.

The hash in `cacert.pem.sha256` comes from the same server as the bundle, so it
finds damage in transfer only. It is not proof that the bundle is good.

The build checks `cacert.pem` against `cacert.pem.sha256` and against
`cacert.fingerprints`, and stops if either does not agree.

## Local CA certificates

Do not edit the shipped bundle. `/` is a ramdisk, so an edit is lost at the next
boot, and `/usr` is read-only.

To use a different set of CAs now, do one of these:

- Install the pkgsrc `mozilla-rootcerts` package. The root profile finds it and
  sets `CURL_CA_BUNDLE`, which has priority over the shipped bundle.
- Set `SSL_CERT_FILE` or `SSL_CERT_DIR` for the software that needs it.

A supported way to add a site CA, for example for a TLS interception proxy, is
not yet in the platform.

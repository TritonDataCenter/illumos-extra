# ca-certificates

cacert.pem is the Mozilla CA bundle as published by the curl project at
https://curl.se/ca/cacert.pem. We install it as
/usr/share/ca-certificates/cacert.pem, with /etc/openssl/cert.pem as a symlink
to it, which is where the platform OpenSSL looks by default.

To update, run `gmake update` and commit cacert.pem, cacert.pem.sha256 and
cacert.fingerprints together. The build fails if they don't agree.

When reviewing an update, look at the diff to cacert.fingerprints rather than
cacert.pem. Each line is a certificate's SHA-256 fingerprint and subject, so
added roots can be checked against Mozilla's list.

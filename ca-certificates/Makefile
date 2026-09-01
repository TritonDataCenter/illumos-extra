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
# Copyright 2026 Edgecast Cloud LLC.
#

include ../Makefile.defs

BUNDLE =	cacert.pem
BUNDLE_SHA =	$(BUNDLE).sha256
BUNDLE_FP =	cacert.fingerprints
BUNDLE_URL =	https://curl.se/ca/$(BUNDLE)
CERTDIR =	usr/share/ca-certificates

#
# -q must come first. It stops curl from reading .curlrc, which could otherwise
# add insecure, cacert, proxy or resolve settings to these transfers.
#
CURL =		curl -q -fsS --proto '=https' --tlsv1.2

CLEANFILES =	$(BUNDLE).new $(BUNDLE_SHA).new $(BUNDLE_FP).new

all: verify

#
# The bundle is data, not source. Its hash is pinned in $(BUNDLE_SHA), which
# changes only in a reviewed commit. Do not ship a bundle that does not match.
#
verify:
	@read expected junk < $(BUNDLE_SHA); \
	actual=`digest -a sha256 $(BUNDLE)`; \
	if [ "$$expected" != "$$actual" ]; then \
		echo "$(BUNDLE): sha256 mismatch" >&2; \
		echo "  expected $$expected" >&2; \
		echo "  actual   $$actual" >&2; \
		exit 1; \
	fi
	@./mkfingerprints $(BUNDLE) | diff -u $(BUNDLE_FP) - || { \
		echo "$(BUNDLE): does not hold the certificates in $(BUNDLE_FP)" >&2; \
		exit 1; \
	}

install: verify
	mkdir -p $(DESTDIR)/$(CERTDIR)
	ginstall -m 0444 $(BUNDLE) $(DESTDIR)/$(CERTDIR)/$(BUNDLE)

#
# Get a new bundle from upstream. Run this by hand, then commit the three
# files it writes. The build never does this.
#
# The hash comes from the same server as the bundle, so it finds damage in
# transfer only. It is not proof that the bundle is good.
#
# The control against a bad bundle is the review of the change to $(BUNDLE_FP).
# Do not review the change to $(BUNDLE), because the names in it are comments
# and can say anything. Check each added fingerprint against Mozilla.
#
update:
	$(CURL) -o $(BUNDLE).new $(BUNDLE_URL)
	$(CURL) -o $(BUNDLE_SHA).new $(BUNDLE_URL).sha256
	@read expected junk < $(BUNDLE_SHA).new; \
	actual=`digest -a sha256 $(BUNDLE).new`; \
	if [ "$$expected" != "$$actual" ]; then \
		echo "downloaded $(BUNDLE) does not match its sha256" >&2; \
		exit 1; \
	fi
	./mkfingerprints $(BUNDLE).new > $(BUNDLE_FP).new
	mv $(BUNDLE).new $(BUNDLE)
	mv $(BUNDLE_SHA).new $(BUNDLE_SHA)
	mv $(BUNDLE_FP).new $(BUNDLE_FP)
	@echo "Review the change to $(BUNDLE_FP) before you commit."

clean:
	-rm -f $(CLEANFILES)

.PHONY: all verify install update clean

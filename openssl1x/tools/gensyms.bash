#! /bin/bash

TOOLS_BASE="$(dirname $0)"
HEADER="sunw_prefix.h"
MF_CRYPTO="mapfile-vers.crypto"
MF_SSL="mapfile-vers.ssl"

hdr_header()
{
	hdr=$1

	cat > "$hdr" <<EOF
#ifndef _SUNW_PREFIX_H
#define	_SUNW_PREFIX_H

EOF
}

mapfile_header()
{
	mapfile=$1

	cat > "$mapfile" <<EOF
\$mapfile_version 2

SYMBOL_VERSION SUNWprivate_1.1 {
    global:
EOF
}

hdr_footer()
{
	hdr=$1

	cat >> "$hdr" <<EOF

#endif /* _SUNW_PREFIX_H */
EOF
}

mapfile_footer()
{
	mapfile=$1

	cat >> "$mapfile" <<EOF
    local:
	*;
};
EOF
}

extract_syms()
{
	lib=$1
	lib64=$2
	hdr=$3
	mapfile=$4

	/usr/bin/nm -pgh "$lib" "$lib64" | \
	    awk -f "$TOOLS_BASE/gensyms.awk" | \
	    sort | uniq | while read sym; do \
		printf "#pragma redefine_extname\t$sym sunw_$sym\n" >> "$hdr"
		printf "\tsunw_$sym;\n" >> "$mapfile"
	done
}

root=$1

hdr_header "$HEADER"
mapfile_header "$MF_CRYPTO"
mapfile_header "$MF_SSL"

extract_syms $root/lib/libcrypto.so.1.0.0 $root/lib/64/libcrypto.so.1.0.0 \
    "$HEADER" "$MF_CRYPTO"
extract_syms $root/lib/libssl.so.1.0.0 $root/lib/64/libssl.so.1.0.0 \
    "$HEADER" "$MF_SSL"

hdr_footer "$HEADER"
mapfile_footer "$MF_CRYPTO"
mapfile_footer "$MF_SSL"

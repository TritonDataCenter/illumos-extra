#!/usr/bin/bash
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
# Copyright (c) 2017, Joyent, Inc.
#

#
# Symbol check logic for verifying that there are no new leaked symbols.
#

#
# These are functions and symbols that are allowed to be there due to
# the ABI.
#
ALLOWED_FUNCS="_init _fini"
ALLOWED_SYMS="_DYNAMIC _edata _end _etext _fini _GLOBAL_OFFSET_TABLE_"
ALLOWED_SYMS="$ALLOWED_SYMS _init _lib_version _PROCEDURE_LINKAGE_TABLE_"

NM=/usr/bin/nm
PREFIX="^sunw_"
BAD_COUNT=0

function check()
{
	local lib=$1
	local nmval=$2
	local allowed=$3
	local warntype=$4
	local addr stype name match

	while read addr stype name; do
		if [[ "$stype" != $nmval ]]; then
			continue
		fi

		if [[ "$name" =~ $PREFIX ]]; then
			continue;
		fi

		match=
		for sym in $allowed; do
			if [[ "$sym" == "$name" ]]; then
				match="yes"
				break;
			fi
		done

		if [[ -n "$match" ]]; then
			continue
		fi

		((BAD_COUNT++))
		echo "Unprefixed $warntype in $lib: $name"
	done < <($NM -ph $lib)
}

for f in $*; do
	check $f "T" "$ALLOWED_FUNCS" "function"
	check $f "D" "$ALLOWED_SYMS" "symbol"
done

if [[ $BAD_COUNT -ne 0 ]]; then
	echo "Unprefixed symbols exist, terminating"
	exit 1
fi

exit 0

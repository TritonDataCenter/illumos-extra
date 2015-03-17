#!/bin/ksh
#
# This simple program demonstrates that 256 colour terminal sequences
# are working as expected.  It can be run manually within screen to
# verify that 256 colour support has been enabled in the build.
#

COLOUR_MIN=0
COLOUR_MAX=255

EXTENDED_START=16
GREYSCALE_START=232

PER_LINE=8

(( i = COLOUR_MIN ))
while (( i <= COLOUR_MAX )); do
	case "$i" in
	0)
		printf 'System Colours:\n'
		;;
	$EXTENDED_START)
		printf '\nExtended (256) Colours:\n'
		;;
	$GREYSCALE_START)
		printf '\nGreyscale Ramp:\n'
		;;
	esac

	printf '\x1b[48;5;%dm %3d \x1b[0m' "${i}" "${i}"

        if (( i > 0 && i % PER_LINE == (PER_LINE - 1) )); then
		printf '\n'
	fi

	(( i++ ))
done
printf '\n'

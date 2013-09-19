#!/bin/bash

PARSE_ONLY=0

function just_body {
    if [[ $PARSE_ONLY == 1 ]]; then
        sed -e '/^[[:space:]]*$/d' -e '/^#/d' \
            -e 's/^[[:space:]]\+//' -e 's/[[:space:]]\+/ /g'
    else
        sed -e '/^#/d' -e '/^$/d'
    fi
}

function test_file {
    file=$1
    diff -L "$file (Sun cpp)" -L "$file (Joyent cpp)" -u \
        <(/usr/lib/cpp $file 2>/dev/null | just_body) \
        <(./cpp $file 2>/dev/null | just_body)
}

while getopts p name; do
    case $name in
        p) PARSE_ONLY=1;;
    esac
done
shift $(($OPTIND - 1))

if (( $# > 0 )); then
    while (( $# > 0 )); do
        test_file $1
        shift;
    done
else
    for elt in /usr/include/**/*.h; do
        # C++ that will never parse
        [[ $elt == */firefox/* ]] && continue
        # Triggers pre-ANSI infinitely recursive expansion
        [[ $elt == */ncurses/* ]] && continue
        print -u2 "*** $elt"
        test_file $elt
    done
fi

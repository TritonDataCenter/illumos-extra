/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").  
 * You may not use this file except in compliance with the License.
 *
 * You can obtain a copy of the license at src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright (c) 1996 by Sun Microsystems, Inc.
 * All Rights Reserved.
 */

#pragma	ident	"@(#)cnv_utf8ucs2.c 1.1	96/08/12 SMI"

#include <sys/types.h>
#include "ucs2.h"
#include "utf8.h"
#include "Assert.h"
#include "errnum.h"
#include "general.h"
#include "utf8gen.h"
#include "gentypes.h"
#include "cnv_utf8ucs2.h"

int
_cnv_utf8ucs2(uchar_t **ib, uchar_t **ob, uchar_t *ibt, uchar_t *obt)
{
    int i;
    int nbyte;
    ucs2_t word;
    uchar_t bits;

    if (no_room_for_ucs2_cnv(*ob, obt))
	return EE2BIG;

    if (is7bit_value(**ib)) {
	set_ucs2_word_BB(*ob, **ib);
	*ob += sizeof(ucs2_t);
	*ib += sizeof(uchar_t);
	return 0;
    }

    if (!utf8_begin_seq(**ib))
	return EEILSEQ;

    nbyte = UTF8_GETB0_NBYTE(*ib);

    Assert(nbyte >= MIN_UTF8_UCS2_BYTES || nbyte <= MAX_UTF8_UCS2_BYTES);

    if (incomplete_utf8_seq2(nbyte, *ib, ibt))
	return EEINVAL;

    word = 0;
    for (i = 0; i < nbyte; i++) {
        switch (i) {
            case 0: bits = UTF8_GETB0_UCS_BITS(*ib,nbyte); break;
            case 1: bits = UTF8_GETB1_UCS_BITS(*ib); break;
            case 2: bits = UTF8_GETB2_UCS_BITS(*ib); break;
            case 3: bits = UTF8_GETB3_UCS_BITS(*ib); break;
            case 4: bits = UTF8_GETB4_UCS_BITS(*ib); break;
            case 5: bits = UTF8_GETB5_UCS_BITS(*ib); break;
	    default: return -1;
	}

        word |= bits << (6 * ((nbyte-1) - i));
    }

    set_ucs2_word_BB(*ob, word);
    *ob += sizeof(ucs2_t);
    *ib += nbyte;
    return 0;
}

#pragma weak conv_utf8ucs2 = _conv_utf8ucs2

int
_conv_utf8ucs2(uchar_t *buf, ucs2_t *word, int len)
{
    return _cnv_utf8ucs2(&buf, 
		    (uchar_t**)&word,
		    (uchar_t*)(buf+len),
		    ((uchar_t*)word)+sizeof(ucs2_t));
}

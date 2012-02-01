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

#pragma	ident	"@(#)cnv_ucs2utf8.c 1.2	96/09/10 SMI"

#include <sys/types.h>
#include "ucs2.h"
#include "utf8.h"
#include "errnum.h"
#include "gentypes.h"
#include "cnv_ucs2utf8.h"

int
_cnv_ucs2utf8(uchar_t **ib, uchar_t **ob, uchar_t *ibt, uchar_t *obt)
{
    int rval;
    ucs2_t ucs2;

    if (incomplete_ucs2_seq(*ib, ibt))
	return EEINVAL;

    ucs2 = get_ucs2_word_BB(*ib);

    if (no_room_for_utf8_cnv(ucs2, *ob, obt))
	return EE2BIG;

    if (!valid_ucs2_value(ucs2))
	return EEILSEQ;

    if ((rval = __cnv_ucs4utf8(ucs2, *ob)) == -1)
	return -1;

    *ib += sizeof(ucs2_t);
    *ob += rval;

    return 0;
}

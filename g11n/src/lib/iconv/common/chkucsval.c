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

#pragma	ident	"@(#)chkucsval.c 1.3	97/11/25 SMI"

#include "ucs2.h"
#include "ucs4.h"
#include "gentypes.h"

int
_valid_ucs2_value(ucs4_t ucs)
{
#ifdef TEST_UCS
    return 1;
#endif

    if (ucs > UCS2_MAXVAL)
    	return 0;

    if (!_in_defined_ucs2_charblock(ucs))
    	return 0;

    return 1;
}

int
_valid_ucs4_value(ucs4_t ucs4)
{
#ifdef TEST_UCS
    return 1;
#endif

    if (ucs4 > UCS4_MAXVAL)
    	return 0;

    if (ext_ucs4_lsw(ucs4) > UCS4_PPRC_MAXVAL)
    	return 0;

    if (!_in_defined_ucs2_charblock(ucs4))
    	return 0;

    return 1;
}

int
_in_defined_ucs2_charblock(ucs4_t ucs)
{

#ifdef TEST_UCS
    return 1;
#endif

    if (ucs <= 0x4ff) 
	return 1;

    if (ucs >= 0x530 && ucs <= 0x6ff)
	return 1;

    if (ucs >= 0x900 && ucs <= 0xd7f)
	return 1;

    if (ucs >= 0xe00 && ucs <= 0xeff)
	return 1;

    if (ucs >= 0x10a0 && ucs <= 0x11ff)
	return 1;

    if (ucs >= 0x1e00 && ucs <= 0x27bf)
	return 1;

    if (ucs >= 0x3000 && ucs <= 0x319f)
	return 1;

    if (ucs >= 0x3200 && ucs <= 0x33ff)
	return 1;

    if (ucs >= 0x4e00 && ucs <= 0x9fff)
	return 1;

    if (ucs >= 0xac00 && ucs <= 0xd7a3)
	return 1;

    if (ucs >= 0xe000 && ucs <= 0xfdff)
	return 1;

    if (ucs >= 0xfe20 && ucs <= 0xfffd)
	return 1;

    return 0;
}

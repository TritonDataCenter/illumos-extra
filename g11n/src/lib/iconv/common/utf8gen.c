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

#pragma	ident	"@(#)utf8gen.c 1.2	97/11/25 SMI"

#include <sys/types.h>
#include "utf8gen.h"
#include "gentypes.h"

int
_get_utf8_bcnt(uchar_t c)
{
    return UTF8_GETB0_NBYTE(&c);
}

int
_get_ucs4utf8_bcnt(ucs4_t val)
{
    if (val >= 0x0 && val <= 0x7f)
	return 1;

    if (val >= 0x80 && val <= 0x7ff)
	return 2;

    if (val >= 0x800 && val <= 0xffff)
	return 3;

    if (val >= 0x1000 && val <= 0x1fffff)
	return 4;

    if (val >= 0x200000 && val <= 0x3ffffff)
	return 5;
    
    if (val >= 0x4000000 && val <= 0x7fffffff)
	return 6;

    return -1;
}

uchar_t
UTF8_GETB0_UCS_BITS(uchar_t *b, int nbyte)
{
    if (nbyte == 2)
	return b[0]&(uchar_t)0x1f;
    if (nbyte == 3)
	return b[0]&(uchar_t)0x0f;
    if (nbyte == 4)
	return b[0]&(uchar_t)0x07;
    if (nbyte == 5)
	return b[0]&(uchar_t)0x03;
    if (nbyte == 6)
	return b[0]&(uchar_t)0x01;
    if (nbyte == 1)
	return b[0];

    return 0;
}

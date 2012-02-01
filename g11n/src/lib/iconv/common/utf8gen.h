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

#ifndef UTF8GEN_H
#define UTF8GEN_H

#pragma	ident	"@(#)utf8gen.h 1.2	96/09/10 SMI"

#include <sys/types.h>
#include "gentypes.h"

#define UTF8_GETB1_UCS_BITS(b)	(((b)[1])&0x3f)
#define UTF8_GETB2_UCS_BITS(b)  (((b)[2])&0x3f)
#define UTF8_GETB3_UCS_BITS(b)  (((b)[3])&0x3f)
#define UTF8_GETB4_UCS_BITS(b)  (((b)[4])&0x3f)
#define UTF8_GETB5_UCS_BITS(b)  (((b)[5])&0x3f)

/*
 * COULD BE OPTIMIZED ON A PER-CHARACTER SET BASIS,
 * i.e., iso8859 will have at most 3 bytes (usually 2 or 
 * less) so there is no need to check for 4,5, or 6 bytes.
 */

#define UTF8_GETB0_NBYTE(b)     ((((b)[0])&(uchar_t)0xfc)==(uchar_t)0xfc?6:\
                                 (((b)[0])&(uchar_t)0xf8)==(uchar_t)0xf8?5:\
                                 (((b)[0])&(uchar_t)0xf0)==(uchar_t)0xf0?4:\
                                 (((b)[0])&(uchar_t)0xe0)==(uchar_t)0xe0?3:\
                                 (((b)[0])&(uchar_t)0xc0)==(uchar_t)0xc0?2:\
                                 1)

#define get_utf8_bcnt(c)	_get_utf8_bcnt(c)
#define get_ucs4utf8_bcnt(v)	_get_ucs4utf8_bcnt(v)
#define get_ucs2utf8_bcnt(v)	_get_ucs4utf8_bcnt((ucs4_t)(v))

int _get_utf8_bcnt(uchar_t);
int _get_ucs4utf8_bcnt(ucs4_t);
#endif

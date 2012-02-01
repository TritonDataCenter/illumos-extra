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

#pragma	ident	"@(#)cnv_ucs4utf8_2.c 1.4	97/11/25 SMI"

#include <sys/types.h>
#include "debug.h"
#include "gentypes.h"
#include "cnv_ucs4utf8_2.h"

debug(static char *FN = "__cnv_ucs4utf8";)

int
__cnv_ucs4utf8(ucs4_t val, uchar_t *buf)
{
    if (val >= 0x0 && val <= 0x7f) {
	UTF8_SET1B(buf,val);
	return 1;
    }

    if (val >= 0x80 && val <= 0x7ff) {
	UTF8_SET2B(buf,val);
	debug(dumpbuf(FN, buf, 2));
	return 2;
    }

    if (val >= 0x800 && val <= 0xffff) {
	UTF8_SET3B(buf,val);
	debug(dumpbuf(FN, buf, 3));
	return 3;
    }

    if (val >= 0x1000 && val <= 0x1fffff) {
	UTF8_SET4B(buf,val);
	debug(dumpbuf(FN, buf, 4));
	return 4;
    }

    if (val >= 0x200000 && val <= 0x3ffffff) {
	UTF8_SET5B(buf,val);
	debug(dumpbuf(FN, buf, 5));
	return 5;
    }
    
    if (val >= 0x4000000 && val <= 0x7fffffff) {
	UTF8_SET6B(buf,val);
	debug(dumpbuf(FN, buf, 6));
	return 6;
    }

    return -1;
}

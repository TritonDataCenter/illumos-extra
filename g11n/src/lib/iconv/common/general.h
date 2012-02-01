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
 * Copyright 1998 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#ifndef GENERAL_H
#define GENERAL_H
#include <sys/types.h>

#define UTF8_BUFSZ		6
#define is7bit_value(p)		(((p))<=0x7f)

#define swap_ucs2_bytes(ucs2) {					\
	    uchar_t byte;					\
	    byte = *((uchar_t*)(ucs2));				\
	    *((uchar_t*)ucs2) = *(((uchar_t*)ucs2)+1);		\
	    *(((uchar_t*)ucs2)+1) = byte;			\
	}
#endif

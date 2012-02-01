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

#ifndef CNV_UTF8UCS2_H
#define CNV_UTF8UCS2_H
#include "gentypes.h"

#define MIN_UTF8_UCS2_BYTES	1
#define MAX_UTF8_UCS2_BYTES	3

int conv_utf8ucs2(uchar_t*,ucs2_t*,int);
int _cnv_utf8ucs2(uchar_t**,uchar_t**,uchar_t*,uchar_t*);
#endif

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

#ifndef Assert_h
#define Assert_h
#pragma ident   "@(#)Assert.h 1.2     97/11/25 SMI"

#ifdef _KERNEL
    #ifdef NDEBUG
    #define Assert(exp)
    #else
    #include <sys/debug.h>
    #define Assert(exp) ((void)((exp) || assfail(#exp, __FILE__, __LINE__)))
    #endif
#else
    #include <assert.h>
    #define Assert(exp) assert(exp)
#endif
#endif

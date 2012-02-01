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

#ifndef CNV_UCS4UTF8_2_H
#define CNV_UCS4UTF8_2_H

#pragma	ident	"@(#)cnv_ucs4utf8_2.h 1.3	97/11/25 SMI"

#define UTF8_SET1B(b,v)    		\
    (b[0]=(v&0x7f))

#define UTF8_SET2B(b,v)    		\
    (b[0]=(0xc0|((v>>6)&0x1f)));	\
    (b[1]=(0x80|((v&0x3f))))

#define UTF8_SET3B(b,v)    		\
    (b[0]=(0xe0|((v>>12)&0xf)));	\
    (b[1]=(0x80|((v>>6)&0x3f)));	\
    (b[2]=(0x80|((v&0x3f))))

#define UTF8_SET4B(b,v)    		\
    (b[0]=(0xf0|((v>>18)&0x7)));	\
    (b[1]=(0x80|((v>>12)&0x3f)));	\
    (b[2]=(0x80|((v>>6)&0x3f)));	\
    (b[3]=(0x80|((v&0x3f))))

#define UTF8_SET5B(b,v)    		\
    (b[0]=(0xf8|((v>>24)&0x3)));	\
    (b[1]=(0x80|((v>>18)&0x3f)));	\
    (b[2]=(0x80|((v>>12)&0x3f)));	\
    (b[3]=(0x80|((v>>6)&0x3f)));	\
    (b[4]=(0x80|((v&0x3f))))

#define UTF8_SET6B(b,v)			\
    (b[0]=(0xfc|((v>>30)&0x1)));	\
    (b[1]=(0x80|((v>>24)&0x3f)));	\
    (b[2]=(0x80|((v>>18)&0x3f)));	\
    (b[3]=(0x80|((v>>12)&0x3f)));	\
    (b[4]=(0x80|((v>>6)&0x3f)));	\
    (b[5]=(0x80|((v&0x3f))))
#endif

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

#ifndef UTF8_H
#define UTF8_H
#define utf8_begin_seq(c)	(((c)&0xc0)==0xc0)
#define not_utf8_begin_seq(c)	(((c)&0xc0)!=0xc0)
#define room_for_utf8_cnv(b1,p1,p2) 	(((p1)+_get_ucs4utf8_bcnt(b1))<=(p2))
#define no_room_for_utf8_cnv(b1,p1,p2) 	(((p1)+_get_ucs4utf8_bcnt(b1))>(p2))
#define incomplete_utf8_seq(p1,p2) 	(((p1)+_get_utf8_bcnt(*(p1)))>(p2))
#define incomplete_utf8_seq2(n,p1,p2) 	((((p1)+(n)))>(p2))
#endif

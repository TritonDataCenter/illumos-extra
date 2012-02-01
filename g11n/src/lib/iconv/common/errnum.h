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

#ifndef ERRNUM_H
#define ERRNUM_H

#include <errno.h>

#define EEILSEQ		(-(EILSEQ))
#define EE2BIG		(-(E2BIG))
#define EEINVAL		(-(EINVAL))
#define EEAGAIN		(-(EAGAIN))

#ifdef NO_EEILSEQ	/* for testing only */
#undef EEILSEQ
#define EEILSEQ 0
#endif
	
#ifdef NO_EE2BIG	/* for testing only */
#undef EE2BIG
#define EE2BIG 0
#endif

#ifdef NO_EEINVAL	/* for testing only */
#undef EEINVAL
#define EEINVAL 0
#endif

#ifdef NO_EEAGAIN	/* for testing only */
#undef EEAGAIN
#define EEAGAIN 0
#endif
#endif

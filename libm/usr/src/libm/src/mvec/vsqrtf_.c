/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").
 * You may not use this file except in compliance with the License.
 *
 * You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at usr/src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#pragma ident	"@(#)vsqrtf_.c	1.5	06/01/31 SMI"

extern void __vsqrtf( int, float *, int, float *, int );

#if !defined(LIBMVEC_SO_BUILD)
#if defined(ARCH_v8plusa) || defined(ARCH_v8plusb) || defined(ARCH_v9a) || defined(ARCH_v9b)
#define CHECK_ULTRA3
#endif
#endif	/* !defined(LIBMVEC_SO_BUILD) */

#ifdef CHECK_ULTRA3
#include <strings.h>
#define sysinfo _sysinfo
#include <sys/systeminfo.h>

#define BUFLEN	257

static int use_ultra3 = 0;

extern void __vsqrtf_ultra3( int, float *, int, float *, int );
#endif

#pragma weak vsqrtf_ = __vsqrtf_

#ifndef LIBMTSK_BASED

/* just invoke the serial function */
void
__vsqrtf_( int *n, float *x, int *stridex, float *y, int *stridey )
{
#ifdef CHECK_ULTRA3
	int		u;
	char	buf[BUFLEN];

	u = use_ultra3;
	if (!u) {
		/* use __vsqrtf_ultra3 on Cheetah (and ???) */
		if (sysinfo(SI_ISALIST, buf, BUFLEN) > 0 && !strncmp(buf, "sparcv9+vis2", 12))
			u = 3;
		else
			u = 1;
		use_ultra3 = u;
	}
	if (u & 2)
		__vsqrtf_ultra3( *n, x, *stridex, y, *stridey );
	else
#endif
	__vsqrtf( *n, x, *stridex, y, *stridey );
}

#else

#include "mtsk.h"

static float *xp, *yp;
static int sx, sy;

/* m-function for parallel vsqrtf */
void
__vsqrtf_mfunc( struct MFunctionBlock *MFunctionBlockPtr, int LowerBound,
	int UpperBound, int Step )
{
	__vsqrtf( UpperBound - LowerBound + 1, xp + sx * LowerBound, sx,
		yp + sy * LowerBound, sy );
}

#ifdef CHECK_ULTRA3
/* m-function for ultra3 version of parallel vsqrtf */
void
__vsqrtf_ultra3_mfunc( struct MFunctionBlock *MFunctionBlockPtr, int LowerBound,
	int UpperBound, int Step )
{
	__vsqrtf_ultra3( UpperBound - LowerBound + 1, xp + sx * LowerBound, sx,
		yp + sy * LowerBound, sy );
}
#endif

void
__vsqrtf_( int *n, float *x, int *stridex, float *y, int *stridey )
{
	struct MFunctionBlock m;
	int i;
#ifdef CHECK_ULTRA3
	int		u;
	char	buf[BUFLEN];

	u = use_ultra3;
	if (!u) {
		/* use __vsqrtf_ultra3 on Cheetah (and ???) */
		if (sysinfo(SI_ISALIST, buf, BUFLEN) > 0 && !strncmp(buf, "sparcv9+vis2", 12))
			u = 3;
		else
			u = 1;
		use_ultra3 = u;
	}
#endif

	/* if ncpus < 2, we are already in a parallel construct, or there
	   aren't enough vector elements to bother parallelizing, just
	   invoke the serial function */
	i = __mt_getncpus_();
	if ( i < 2 || *n < ( i << 3 ) || __mt_inepc_() || __mt_inapc_() )
	{
#ifdef CHECK_ULTRA3
		if (u & 2)
			__vsqrtf_ultra3( *n, x, *stridex, y, *stridey );
		else
#endif
		__vsqrtf( *n, x, *stridex, y, *stridey );
		return;
	}

	/* should be safe, we already know we're not in a parallel region */
	xp = x;
	sx = *stridex;
	yp = y;
	sy = *stridey;

#ifdef CHECK_ULTRA3
	if (u & 2)
		m.MFunctionPtr = &__vsqrtf_ultra3_mfunc;
	else
#endif
	m.MFunctionPtr = &__vsqrtf_mfunc;
	m.LowerBound = 0;
	m.UpperBound = *n - 1;
	m.Step = 1;
	__mt_dopar_vfun_( m.MFunctionPtr, m.LowerBound, m.UpperBound, m.Step );
}

#endif

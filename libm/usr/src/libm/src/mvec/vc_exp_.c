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

#pragma ident	"@(#)vc_exp_.c	1.4	06/01/31 SMI"

extern void __vc_exp( int, float *, int, float *, int, float * );

#pragma weak vc_exp_ = __vc_exp_

#ifndef LIBMTSK_BASED

/* just invoke the serial function */
void
__vc_exp_( int *n, float *x, int *stridex, float *y, int *stridey,
	float *tmp )
{
	__vc_exp( *n, x, *stridex, y, *stridey, tmp );
}

#else

#include "mtsk.h"

static float *xp, *yp, *tp;
static int sx, sy;

/* m-function for parallel vc_exp */
void
__vc_exp_mfunc( struct MFunctionBlock *MFunctionBlockPtr, int LowerBound,
	int UpperBound, int Step )
{
	__vc_exp( UpperBound - LowerBound + 1, xp + ( sx << 1 ) * LowerBound, sx,
		yp + ( sy << 1 ) * LowerBound, sy, tp + LowerBound );
}

void
__vc_exp_( int *n, float *x, int *stridex, float *y, int *stridey,
	float *tmp )
{
	struct MFunctionBlock m;
	int i;

	/* if ncpus < 2, we are already in a parallel construct, or there
	   aren't enough vector elements to bother parallelizing, just
	   invoke the serial function */
	i = __mt_getncpus_();
	if ( i < 2 || *n < ( i << 3 ) || __mt_inepc_() || __mt_inapc_() )
	{
		__vc_exp( *n, x, *stridex, y, *stridey, tmp );
		return;
	}

	/* should be safe, we already know we're not in a parallel region */
	xp = x;
	sx = *stridex;
	yp = y;
	sy = *stridey;
	tp = tmp;

	m.MFunctionPtr = &__vc_exp_mfunc;
	m.LowerBound = 0;
	m.UpperBound = *n - 1;
	m.Step = 1;
	__mt_dopar_vfun_( m.MFunctionPtr, m.LowerBound, m.UpperBound, m.Step );
}

#endif

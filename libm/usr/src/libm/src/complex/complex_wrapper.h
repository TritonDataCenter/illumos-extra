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

#ifndef _COMPLEX_WRAPPER_H
#define	_COMPLEX_WRAPPER_H

#pragma ident	"@(#)complex_wrapper.h	1.7	06/01/31 SMI"

#if !defined(__cplusplus) && (__STDC_VERSION__ >= 199901L || defined(_STDC_C99))

#define	dcomplex	double complex
#define	fcomplex	float complex
#define	ldcomplex	long double complex
#define	_X_RE(__t, __z)	((__t *) &__z)[0]
#define	_X_IM(__t, __z)	((__t *) &__z)[1]
#define	D_RE(__z)	_X_RE(double, __z)
#define	D_IM(__z)	_X_IM(double, __z)
#define	F_RE(__z)	_X_RE(float, __z)
#define	F_IM(__z)	_X_IM(float, __z)
#define	LD_RE(__z)	_X_RE(long double, __z)
#define	LD_IM(__z)	_X_IM(long double, __z)

#include <complex.h>

#else	/* !defined(__cplusplus) && (__STDC_VERSION__ >= 199901L || ...) */

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	double __re;
	double __im;
} dcomplex;

typedef struct {
	float __re;
	float __im;
} fcomplex;

typedef struct {
	long double __re;
	long double __im;
} ldcomplex;

#define	D_RE(__z)	(__z).__re
#define	D_IM(__z)	(__z).__im
#define	F_RE(__z)	(__z).__re
#define	F_IM(__z)	(__z).__im
#define	LD_RE(__z)	(__z).__re
#define	LD_IM(__z)	(__z).__im

extern float cabsf(fcomplex);
extern float cargf(fcomplex);
extern float cimagf(fcomplex);
extern float crealf(fcomplex);
extern fcomplex cacosf(fcomplex);
extern fcomplex cacoshf(fcomplex);
extern fcomplex casinf(fcomplex);
extern fcomplex casinhf(fcomplex);
extern fcomplex catanf(fcomplex);
extern fcomplex catanhf(fcomplex);
extern fcomplex ccosf(fcomplex);
extern fcomplex ccoshf(fcomplex);
extern fcomplex cexpf(fcomplex);
extern fcomplex clogf(fcomplex);
extern fcomplex conjf(fcomplex);
extern fcomplex cpowf(fcomplex, fcomplex);
extern fcomplex cprojf(fcomplex);
extern fcomplex csinf(fcomplex);
extern fcomplex csinhf(fcomplex);
extern fcomplex csqrtf(fcomplex);
extern fcomplex ctanf(fcomplex);
extern fcomplex ctanhf(fcomplex);

extern double cabs(dcomplex);
extern double carg(dcomplex);
extern double cimag(dcomplex);
extern double creal(dcomplex);
extern dcomplex cacos(dcomplex);
extern dcomplex cacosh(dcomplex);
extern dcomplex casin(dcomplex);
extern dcomplex casinh(dcomplex);
extern dcomplex catan(dcomplex);
extern dcomplex catanh(dcomplex);
extern dcomplex ccos(dcomplex);
extern dcomplex ccosh(dcomplex);
extern dcomplex cexp(dcomplex);
extern dcomplex clog(dcomplex);
extern dcomplex conj(dcomplex);
extern dcomplex cpow(dcomplex, dcomplex);
extern dcomplex cproj(dcomplex);
extern dcomplex csin(dcomplex);
extern dcomplex csinh(dcomplex);
extern dcomplex csqrt(dcomplex);
extern dcomplex ctan(dcomplex);
extern dcomplex ctanh(dcomplex);

extern long double cabsl(ldcomplex);
extern long double cargl(ldcomplex);
extern long double cimagl(ldcomplex);
extern long double creall(ldcomplex);
extern ldcomplex cacoshl(ldcomplex);
extern ldcomplex cacosl(ldcomplex);
extern ldcomplex casinhl(ldcomplex);
extern ldcomplex casinl(ldcomplex);
extern ldcomplex catanhl(ldcomplex);
extern ldcomplex catanl(ldcomplex);
extern ldcomplex ccoshl(ldcomplex);
extern ldcomplex ccosl(ldcomplex);
extern ldcomplex cexpl(ldcomplex);
extern ldcomplex clogl(ldcomplex);
extern ldcomplex conjl(ldcomplex);
extern ldcomplex cpowl(ldcomplex, ldcomplex);
extern ldcomplex cprojl(ldcomplex);
extern ldcomplex csinhl(ldcomplex);
extern ldcomplex csinl(ldcomplex);
extern ldcomplex csqrtl(ldcomplex);
extern ldcomplex ctanhl(ldcomplex);
extern ldcomplex ctanl(ldcomplex);

#ifdef __cplusplus
}
#endif

#endif	/* !defined(__cplusplus) && (__STDC_VERSION__ >= 199901L || ...) */

#if defined(__sparc)
#define	HIWORD	0
#define	LOWORD	1
#define	HI_XWORD(x)	((unsigned *) &x)[0]
#define	XFSCALE(x, n)	((unsigned *) &x)[0] += n << 16	/* signbitl(x) == 0 */
#define	CHOPPED(x)	((long double) ((double) (x)))
#elif defined(__i386) || defined(__LITTLE_ENDIAN)
#define	HIWORD	1
#define	LOWORD	0
#define	HI_XWORD(x)	((((int *) &x)[2] << 16) | \
			(0xffff & ((unsigned *) &x)[1] >> 15))
#define	XFSCALE(x, n)	((unsigned short *) &x)[4] += n	/* signbitl(x) == 0 */
#define	CHOPPED(x)	((long double) ((float) (x)))
#else
#error Unknown architecture
#endif
#define	HI_WORD(x)	((int *) &x)[HIWORD]	/* for double */
#define	LO_WORD(x)	((int *) &x)[LOWORD]	/* for double */
#define	THE_WORD(x)	((int *) &x)[0]		/* for float */

/*
 * iy:ly must have the sign bit already cleared
 */
#define	ISINF(iy, ly)	(((iy - 0x7ff00000) | ly) == 0)

#endif	/* _COMPLEX_WRAPPER_H */

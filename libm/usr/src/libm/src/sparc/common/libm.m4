!
! CDDL HEADER START
!
! The contents of this file are subject to the terms of the
! Common Development and Distribution License (the "License").
! You may not use this file except in compliance with the License.
!
! You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
! or http://www.opensolaris.org/os/licensing.
! See the License for the specific language governing permissions
! and limitations under the License.
!
! When distributing Covered Code, include this CDDL HEADER in each
! file and include the License file at usr/src/OPENSOLARIS.LICENSE.
! If applicable, add the following below this CDDL HEADER, with the
! fields enclosed by brackets "[]" replaced with your own identifying
! information: Portions Copyright [yyyy] [name of copyright owner]
!
! CDDL HEADER END
!
! Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
! Use is subject to license terms.
!
! @(#)libm.m4	1.118	06/01/31 SMI
!
undefine(`_C')dnl
define(`_C',`')dnl
ifdef(`ELFOBJ', `define(NAME,$1)' , `define(NAME,_$1)')dnl
ifdef(`ARCH_v7', `define(NO_MULDIV)')dnl
ifdef(`ARCH_v7', `define(NO_FSMULD)')dnl
ifdef(`ARCH_v8a', `define(NO_FSMULD)')dnl
ifdef(`ARCH_v8plusa', `define(ARCH_v8plus)')dnl
ifdef(`ARCH_v8plusb', `define(ARCH_v8plus)')dnl
ifdef(`ARCH_v8plusb', `define(ARCH_v8plusa)')dnl
dnl
ifdef(`NO_FSMULD', `dnl
	.inline	NAME(r_hypot_),2
	ld	[%o0],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	ld	[%o0],%f0	! load result with first argument
	bne	2f
	nop
	fabss	%f0,%f0
	ld	[%o1],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
2:		
	ld	[%o1],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	bne	4f
	nop
	ld	[%o1],%f0	! second argument inf
	fabss	%f0,%f0
	ld	[%o0],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
4:
	fstod	%f0,%f0
	ld	[%o1],%f3
	fmuld	%f0,%f0,%f0
	fstod	%f3,%f2
	fmuld	%f2,%f2,%f2
	faddd	%f2,%f0,%f0
	fsqrtd	%f0,%f0
	fdtos	%f0,%f0
5:
	.end

	.inline	NAME(__c_abs),1
	ld	[%o0],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	ld	[%o0],%f0
	bne	2f
	nop
	fabss	%f0,%f0
	ld	[%o0+4],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
2:		
	ld	[%o0+4],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	bne	4f
	nop
	ld	[%o0+4],%f0
	fabss	%f0,%f0
	ld	[%o0],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
! store to 8-aligned address
4:
	fstod	%f0,%f0
	ld	[%o0+4],%f3
	fmuld	%f0,%f0,%f0
	fstod	%f3,%f2
	fmuld	%f2,%f2,%f2
	faddd	%f2,%f0,%f0
	fsqrtd	%f0,%f0
	fdtos	%f0,%f0
5:
	.end

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_mult)(c, a, b)
! complex *c, *a, *b;
! {
	.inline	NAME(__Fc_mult),3
!    21	  	c->real = (a->real *  b->real) - (a->imag *  b->imag)

	ld	[%o1+4],%f0
	ld	[%o2+4],%f1
	fstod	%f0,%f2		! f2 = a->imag
	fstod	%f1,%f4		! f4 = b->imag
	fmuld	%f2,%f4,%f6	! f6 = (a->imag *  b->imag)
	ld	[%o1],%f0
	ld	[%o2],%f1
	fstod	%f0,%f8		! f8 = a->real
	fstod	%f1,%f10	! f10 = b->real
	fmuld	%f8,%f10,%f0
	fsubd	%f0,%f6,%f6
!    22	  	c->imag = (a->real *  b->imag) + (a->imag *  b->real)

	fmuld	%f2,%f10,%f2	! f2 = a->imag * b->real
	fmuld	%f8,%f4,%f4	! f4 = a->real * b->imag
	faddd	%f2,%f4,%f4
	fdtos	%f6,%f0
	fdtos	%f4,%f1
	st	%f0,[%o0]
	st	%f1,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_div)(c, a, b)
! complex *c, *a, *b
! {
	.inline	NAME(__Fc_div),3
	ld	[%o2+4],%o3
	sethi	%hi(0x7fffffff),%o4
	or	%o4,%lo(0x7fffffff),%o4	! [internal]
	andcc	%o3,%o4,%g0
	ld	[%o2],%f6		! f6 gets reb
	bne	1f
	nop
	ld	[%o1],%f0
	ld	[%o2],%f1
	fdivs	%f0,%f1,%f0
	st	%f0,[%o0]
	ld	[%o2],%f4
	ld	[%o1+4],%f3
	fdivs	%f3,%f4,%f3
	st	%f3,[%o0+4]
	ba	2f
	nop
1:					! [internal]
	fstod	%f6,%f8			! f8/9 gets reb
	ld	[%o2+4],%f19		! f19 gets imb
	ld	[%o1+4],%f13		! f13 gets ima
	fstod	%f13,%f24		! f24/5 gets ima
	fstod	%f19,%f10		! f10/11 gets imb
	fmuld	%f8,%f8,%f16		! f16/17 gets reb**2
	ld	[%o1],%f19		! f19 gets rea
	fmuld	%f24,%f10,%f0		! f0/f1 gets ima*imb
	fstod	%f19,%f26		! f26/7 gets rea
	fmuld	%f10,%f10,%f12		! f12/13 gets imb**2
	faddd	%f12,%f16,%f12		! f12/13 gets reb**2+imb**2
	fmuld	%f26,%f8,%f2		! f2/3 gets rea*reb
	faddd	%f2,%f0,%f2		! f2/3 gets rea*reb+ima*imb
	fdivd	%f2,%f12,%f2		! f2/3 gets rec
	fmuld	%f24,%f8,%f24		! f24/5 gets ima*reb
	fmuld	%f26,%f10,%f10		! f10/11 gets rea*imb
	fsubd	%f24,%f10,%f10		! f10/11 gets ima*reb-rea*imb
	fdtos	%f2,%f7			! f7 gets rec
	fdivd	%f10,%f12,%f12		! f12 gets imc
	fdtos	%f12,%f15		! f15 gets imc
	st	%f7,[%o0]
	st	%f15,[%o0+4]
2:
	.end
! }

')dnl
ifdef(`NO_FSMULD', `', `dnl
dnl!	v8 (and up) implementation specific inline expansion templates
dnl!	[efficient implementation of fsmuld assumed]
dnl!
	.inline	NAME(r_hypot_),2
	ld	[%o0],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	ld	[%o0],%f0	! load result with first argument
	bne	2f
	nop
	fabss	%f0,%f0
	ld	[%o1],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
2:
	ld	[%o1],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	bne	4f
	nop
	ld	[%o1],%f0	! second argument inf
	fabss	%f0,%f0
	ld	[%o0],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
4:
	ld	[%o1],%f3
	fsmuld	%f0,%f0,%f0
	fsmuld	%f3,%f3,%f2
	faddd	%f2,%f0,%f0
	fsqrtd	%f0,%f0
	fdtos	%f0,%f0
5:
	.end

	.inline	NAME(__c_abs),1
	ld	[%o0],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	ld	[%o0],%f0
	bne	2f
	nop
	fabss	%f0,%f0
	ld	[%o0+4],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
2:
	ld	[%o0+4],%o4
	sethi	0x1fffff,%o5
	or	%o5,1023,%o5
	and	%o4,%o5,%o4
	sethi	0x1fe000,%o3
	cmp	%o4,%o3
	bne	4f
	nop
	ld	[%o0+4],%f0
	fabss	%f0,%f0
	ld	[%o0],%f1
	.volatile
	fcmps	%f0,%f1		! generate invalid for Snan
	.nonvolatile
	nop
	fba	5f
	nop
! store to 8-aligned address
4:
	ld	[%o0+4],%f3
	fsmuld	%f0,%f0,%f0
	fsmuld	%f3,%f3,%f2
	faddd	%f2,%f0,%f0
	fsqrtd	%f0,%f0
	fdtos	%f0,%f0
5:
	.end

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_mult)(c, a, b)
! complex *c, *a, *b;
! {
	.inline	NAME(__Fc_mult),3
!    21		c->real = (a->real *  b->real) - (a->imag *  b->imag)
	ld	[%o1+4],%f0	! f0 = a->imag
	ld	[%o2+4],%f1	! f1 = b->imag
	ld	[%o1],%f2	! f2 = a->real
	fsmuld	 %f0,%f1,%f4	 ! f4 = (a->imag *  b->imag)
	ld	[%o2],%f3	! f3 = b->real
	fsmuld	 %f2,%f1,%f6	! f6 = a->real * b->imag
	fsmuld	 %f2,%f3,%f8	! f8 =	a->real * b->real
	fsmuld	 %f0,%f3,%f10	! f10 = a->imag * b->real
	fsubd	%f8,%f4,%f0	! f0 =	ar*br - ai*bi
	faddd	%f6,%f10,%f2	! f2 = ai*br + ar*bi
	fdtos	%f0,%f4
	fdtos	%f2,%f6
	st	%f4,[%o0]
	st	%f6,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_div)(c, a, b)
! complex *c, *a, *b;
! {
	.inline	NAME(__Fc_div),3
	ld	[%o2+4],%o3
	sethi	%hi(0x7fffffff),%o4
	or	%o4,%lo(0x7fffffff),%o4 ! [internal]
	andcc	%o3,%o4,%g0
	ld	[%o2],%f6		! f6 gets reb
	bne	1f
	nop
	ld	[%o1],%f0
	ld	[%o2],%f1
	fdivs	%f0,%f1,%f0
	st	%f0,[%o0]
	ld	[%o1+4],%f3
	fdivs	%f3,%f1,%f3
	st	%f3,[%o0+4]
	ba	2f
	nop
1:					! [internal]
	sethi	%hi(0x3ff00000),%o4	_C(the cg inliner circa Lionel FCS)
	or	%g0,0,%o5		_C([aka WS6U1 but not before] maps)
	std	%o4,[%sp+0x48]		_C(the idiom to an LDDF of 1.0)
	ldd	[%sp+0x48],%f8		_C(from a constant pool)
	ld	[%o2+4],%f10		! f10 gets imb
	fsmuld	%f6,%f6,%f16		! f16/17 gets reb**2
	ld	[%o1+4],%f4		! f4 gets ima
	fsmuld	%f10,%f10,%f12		! f12/13 gets imb**2
	ld	[%o1],%f19		! f19 gets rea
	fsmuld	%f4,%f10,%f0		! f0/f1 gets ima*imb
	fsmuld	%f19,%f6,%f2		! f2/3 gets rea*reb
	faddd	%f12,%f16,%f12		! f12/13 gets reb**2+imb**2
	fdivd	%f8,%f12,%f12		! f12/13 gets 1/(reb**2+imb**2)
	faddd	%f2,%f0,%f2		! f2/3 gets rea*reb+ima*imb
	fsmuld	%f4,%f6,%f24		! f24/5 gets ima*reb
	fmuld	%f2,%f12,%f2		! f2/3 gets rec
	fsmuld	%f19,%f10,%f10		! f10/11 gets rea*imb
	fsubd	%f24,%f10,%f10		! f10/11 gets ima*reb-rea*imb
	fmuld	%f10,%f12,%f12		! f12 gets imc
	fdtos	%f2,%f7			! f7 gets rec
	fdtos	%f12,%f15		! f15 gets imc
	st	%f7,[%o0]
	st	%f15,[%o0+4]
2:
	.end
! }

')dnl
ifdef(`NO_MULDIV', `', `dnl
dnl!	v8a (and up) implementation specific inline expansion templates
dnl!
	.inline	.mul,2
	.volatile
	smul	%o0,%o1,%o0
	rd	%y,%o1
	sra	%o0,31,%o2
	cmp	%o1,%o2		_C(return with Z set if %y == (%o0 >> 31))
	.nonvolatile
	.end

	.inline	.umul,2
	.volatile
	umul	%o0,%o1,%o0
	rd	%y,%o1
	tst	%o1		_C(return with Z set if high order bits are 0)
	.nonvolatile
	.end

	.inline	.div,2
	sra	%o0,31,%o4	! extend sign
	.volatile
	wr	%o4,%g0,%y
	cmp	%o1,0xffffffff	! is divisor -1?
	be,a	1f		! if yes
	.volatile
	subcc	%g0,%o0,%o0	! simply negate dividend
	nop			! RT620 FABs A.0/A.1
	sdiv	%o0,%o1,%o0	! o0 contains quotient a/b
	.nonvolatile
1:
	.end

	.inline	.udiv,2
	.volatile
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%o0,%o1,%o0	! o0 contains quotient a/b
	.nonvolatile
	.end

	.inline	.rem,2
	sra	%o0,31,%o4	! extend sign
	.volatile
	wr	%o4,%g0,%y
	cmp	%o1,0xffffffff	! is divisor -1?
	be,a	1f		! if yes
	.volatile
	or	%g0,%g0,%o0	! simply return 0
	nop			! RT620 FABs A.0/A.1
	sdiv	%o0,%o1,%o2	! o2 contains quotient a/b
	.nonvolatile
	smul	%o2,%o1,%o4	! o4 contains q*b
	sub	%o0,%o4,%o0	! o0 gets a-q*b
1:
	.end

	.inline	.urem,2
	.volatile
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%o0,%o1,%o2	! o2 contains quotient a/b
	.nonvolatile
	umul	%o2,%o1,%o4	! o4 contains q*b
	sub	%o0,%o4,%o0	! o0 gets a-q*b
	.end

	.inline	.div_o3,2
	sra	%o0,31,%o4	! extend sign
	.volatile
	wr	%o4,%g0,%y
	cmp	%o1,0xffffffff	! is divisor -1?
	be,a	1f		! if yes
	.volatile
	subcc	%g0,%o0,%o0	! simply negate dividend
	mov	%o0,%o3		! o3 gets remainder
	sdiv	%o0,%o1,%o0	! o0 contains quotient a/b
	.nonvolatile
	smul	%o0,%o1,%o4	! o4 contains q*b
	ba	2f
	sub	%o3,%o4,%o3	! o3 gets a-q*b
1:
	mov	%g0,%o3		! remainder is 0
2:
	.end

	.inline	.udiv_o3,2
	.volatile
	wr	%g0,%g0,%y
	mov	%o0,%o3		! o3 gets remainder
	nop
	nop
	udiv	%o0,%o1,%o0	! o0 contains quotient a/b
	.nonvolatile
	umul	%o0,%o1,%o4	! o4 contains q*b
	sub	%o3,%o4,%o3	! o3 gets a-q*b
	.end

')dnl
dnl!	v7 (and up) implementation specific inline expansion templates
dnl!	[efficient implementation of fsqrts/fsqrtd assumed]
dnl!
ifdef(`LOCALLIBM', `dnl
	.inline	NAME(__ieee754_sqrt),2
	std	%o0,[%sp+0x48]		! store to 8-aligned address
	ldd	[%sp+0x48],%f0
	fsqrtd	%f0,%f0
	.end

	.inline	NAME(__inline_sqrtf),1
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	fsqrts	%f0,%f0
	.end

	.inline	NAME(__inline_sqrt),2
	std	%o0,[%sp+0x48]		! store to 8-aligned address
	ldd	[%sp+0x48],%f0
	fsqrtd	%f0,%f0
	.end

')dnl
	.inline	NAME(sqrtf),1
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	fsqrts	%f0,%f0
	.end

	.inline	NAME(sqrt),2
	std	%o0,[%sp+0x48]		! store to 8-aligned address
	ldd	[%sp+0x48],%f0
	fsqrtd	%f0,%f0
	.end

	.inline	NAME(r_sqrt_),1
	ld	[%o0],%f0
	fsqrts	%f0,%f0
	.end

	.inline	NAME(d_sqrt_),1
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	fsqrtd	%f0,%f0
	.end

dnl!
dnl!	generic SPARC inline templates
dnl!
ifdef(`ARCH_v8plusb', `dnl
	.inline	NAME(ceil),2
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	sllx	%o0,32,%o0
	or	%o0,%o1,%o0
	stx	%o0,[%sp+0x48]
	ldd	[%sp+0x48],%f0	_C(x)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x48]
	ldd	[%sp+0x48],%f2	_C(2^52)
	fcmpd	%fcc0,%f6,%f2
	fmovduge %fcc0,%f4,%f2	_C(fiddle := |x| < 2^52 ? 2^52 : 0)
	fand	%f0,%f8,%f8	_C(copysign(0, x))
	for	%f2,%f8,%f2	_C(copysign(fiddle, x))
	siam	6
	faddd	%f0,%f2,%f0	_C(x + copysign(fiddle, x) rnd toward +Inf)
	siam	4
	fsubd	%f0,%f2,%f0	_C(" - copysign(fiddle, x) rnd to nearest)
	siam	0
	for	%f0,%f8,%f0	_C(in case previous fsubd gave +0)
	.end

	.inline	NAME(floor),2
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	sllx	%o0,32,%o0
	or	%o0,%o1,%o0
	stx	%o0,[%sp+0x48]
	ldd	[%sp+0x48],%f0	_C(x)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x48]
	ldd	[%sp+0x48],%f2	_C(2^52)
	fcmpd	%fcc0,%f6,%f2
	fmovduge %fcc0,%f4,%f2	_C(fiddle := |x| < 2^52 ? 2^52 : 0)
	fand	%f0,%f8,%f8	_C(copysign(0, x))
	for	%f2,%f8,%f2	_C(copysign(fiddle, x))
	siam	7
	faddd	%f0,%f2,%f0	_C(x + copysign(fiddle, x) rounded down)
	siam	4
	fsubd	%f0,%f2,%f0	_C(" - copysign(fiddle, x) rnd to nearest)
	siam	0
	for	%f0,%f8,%f0	_C(in case previous fsubd gave +0)
	.end

',`dnl
dnl!
dnl! [%sp+0x48]	x -> scratch
dnl! [%sp+0x50]	two52 -> zero -> one
dnl!
	.inline	NAME(ceil),2
	std	%o0,[%sp+0x48]
	sethi	%hi(0x80000000),%o5	_C(o5 = sign bit mask)
	andn	%o0,%o5,%o2
	sethi	%hi(0x43300000),%o3
	st	%g0,[%sp+0x54]		_C(clear memory for two52, zero and one)
	subcc	%o2,%o3,%g0
	bl	1f
	nop
	sethi	%hi(0x3ff00000),%o2
	st	%o2,[%sp+0x50]		_C([%sp+0x50] = one)
	ldd	[%sp+0x48],%f0
	ldd	[%sp+0x50],%f2
	fmuld	%f0,%f2,%f0		_C(return x * one if |x| >= 2^52)
	ba	4f
	nop
1:
	tst	%o0
	st	%o3,[%sp+0x50]		_C([%sp+0x50] = two52)
	ldd	[%sp+0x50],%f2		_C(L = copysign(two52, x))
	bge	2f
	nop
	fnegs	%f2,%f2			_C()
2:
	ldd	[%sp+0x48],%f4
	faddd	%f4,%f2,%f0		_C((x + L) rounded)
	fsubd	%f0,%f2,%f0		_C(t = (x + L) rounded - L)
	fcmpd	%f0,%f4
	sethi	%hi(0x3ff00000),%o2
	st	%o2,[%sp+0x50]		_C([%sp+0x50] = one)
	and	%o0,%o5,%o4		_C(o4 = sign bit of x)
	fbge	3f
	nop
	ldd	[%sp+0x50],%f4
	faddd	%f0,%f4,%f0		_C(t = t + 1 if t < x)
3:
	st	%f0,[%sp+0x48]
	ld	[%sp+0x48],%o3
	andn	%o3,%o5,%o3
	or	%o4,%o3,%o3
	st	%o3,[%sp+0x48]
	ld	[%sp+0x48],%f0		_C(return copysign(t, x))
4:
	.end

dnl!
dnl! [%sp+0x48]	x -> scratch
dnl! [%sp+0x50]	two52 -> zero -> one
dnl!
	.inline	NAME(floor),2
	std	%o0,[%sp+0x48]
	sethi	%hi(0x80000000),%o5	_C(o5 = sign bit mask)
	andn	%o0,%o5,%o2
	sethi	%hi(0x43300000),%o3
	st	%g0,[%sp+0x54]		_C(clear memory for two52, zero and one)
	subcc	%o2,%o3,%g0
	bl	1f
	nop
	sethi	%hi(0x3ff00000),%o2
	st	%o2,[%sp+0x50]		_C([%sp+0x50] = one)
	ldd	[%sp+0x48],%f0
	ldd	[%sp+0x50],%f2
	fmuld	%f0,%f2,%f0		_C(return x * one if |x| >= 2^52)
	ba	4f
	nop
1:
	tst	%o0
	st	%o3,[%sp+0x50]		_C([%sp+0x50] = two52)
	ldd	[%sp+0x50],%f2		_C(L = copysign(two52, x))
	bge	2f
	nop
	fnegs	%f2,%f2			_C()
2:
	ldd	[%sp+0x48],%f4
	faddd	%f4,%f2,%f0		_C((x + L) rounded)
	fsubd	%f0,%f2,%f0		_C(t = (x + L) rounded - L)
	fcmpd	%f0,%f4
	sethi	%hi(0x3ff00000),%o2
	st	%o2,[%sp+0x50]		_C([%sp+0x50] = one)
	ldd	[%sp+0x50],%f4
	and	%o0,%o5,%o4		_C(o4 = sign bit of x)
	fble	3f
	nop
	fsubd	%f0,%f4,%f0		_C(t = t - 1 if t > x)
3:
	st	%f0,[%sp+0x48]
	ld	[%sp+0x48],%o3
	andn	%o3,%o5,%o3
	or	%o4,%o3,%o3
	st	%o3,[%sp+0x48]
	ld	[%sp+0x48],%f0		_C(return copysign(t, x))
4:
	.end

')dnl
dnl!
dnl! [%sp+0x48]	x -> scaled x
dnl! [%sp+0x50]	two54
dnl!
	.inline	NAME(ilogb),2
	sethi	%hi(0x7ff00000),%o4
	andcc	%o4,%o0,%o2
	bne	1f
	nop
	sethi	%hi(0x43500000),%o3
	std	%o0,[%sp+0x48]
	st	%o3,[%sp+0x50]
	st	%g0,[%sp+0x54]
	ldd	[%sp+0x48],%f0
	ldd	[%sp+0x50],%f2
	fmuld	%f0,%f2,%f0		_C(scale x up by two54)
	sethi	%hi(0x80000001),%o0	_C(return - (2^31 - 1) if iszero(x))
	or	%o0,%lo(0x80000001),%o0	_C()
	st	%f0,[%sp+0x48]
	ld	[%sp+0x48],%o2
	andcc	%o2,%o4,%o2
	srl	%o2,20,%o2
	be	2f
	nop
	sub	%o2,0x435,%o0
	ba	2f
	nop
1:
	subcc	%o4,%o2,%g0
	srl	%o2,20,%o3
	bne	0f
	nop
	sethi	%hi(0x7fffffff),%o0	_C(return 2^31 - 1 if !finite(x))
	or	%o0,%lo(0x7fffffff),%o0	_C()
	ba	2f
	nop
0:
	sub	%o3,0x3ff,%o0
2:
	.end

ifdef(`ARCH_v8plusa', `dnl
	.inline	NAME(rint),2
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	sllx	%o0,32,%o0
	or	%o0,%o1,%o0
	stx	%o0,[%sp+0x48]
	ldd	[%sp+0x48],%f0	_C(x)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x48]
	ldd	[%sp+0x48],%f2	_C(2^52)
	fcmpd	%fcc0,%f6,%f2
	fmovduge %fcc0,%f4,%f2	_C(fiddle := |x| < 2^52 ? 2^52 : 0)
	fand	%f0,%f8,%f8	_C(copysign(0, x))
	for	%f2,%f8,%f2	_C(copysign(fiddle, x))
	faddd	%f0,%f2,%f0	_C(x + copysign(fiddle, x))
	fsubd	%f0,%f2,%f0	_C(" - copysign(fiddle, x))
	fabsd	%f0,%f0
	for	%f0,%f8,%f0	_C(in case previous fsubd gave wrong sign of 0)
	.end

	.inline	NAME(rintf),1
	fzeros	%f4		_C(0)
	fnegs	%f4,%f8		_C(-0)
	st	%o0,[%sp+0x48]
	ld	[%sp+0x48],%f0	_C(x)
	fabss	%f0,%f6		_C(|x|)
	sethi	%hi(0x4b000000),%o2
	st	%o2,[%sp+0x48]
	ld	[%sp+0x48],%f2	_C(2^23)
	fcmps	%fcc0,%f6,%f2
	fmovsuge %fcc0,%f4,%f2	_C(fiddle := |x| < 2^23 ? 2^23 : 0)
	fands	%f0,%f8,%f8	_C(copysignf(0, x))
	fors	%f2,%f8,%f2	_C(copysignf(fiddle, x))
	fadds	%f0,%f2,%f0	_C(x + copysignf(fiddle, x))
	fsubs	%f0,%f2,%f0	_C(" - copysignf(fiddle, x))
	fabss	%f0,%f0
	fors	%f0,%f8,%f0	_C(in case previous fsubs gave wrong sign of 0)
	.end

',`dnl
dnl!
dnl! [%sp+0x48]	x -> two52
dnl! [%sp+0x50]	zero
dnl!
	.inline	NAME(rint),2
	std	%o0,[%sp+0x48]
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o2
	ldd	[%sp+0x48],%f0
	sethi	%hi(0x43300000),%o3
	st	%g0,[%sp+0x50]		_C([%sp+0x50] = zero)
	st	%g0,[%sp+0x54]
	subcc	%o2,%o3,%g0
	bl	1f
	nop
	sethi	%hi(0x3ff00000),%o2
	st	%o2,[%sp+0x50]		_C([%sp+0x50] = one)
	ldd	[%sp+0x50],%f2
	fmuld	%f0,%f2,%f0		_C(return x * one (raise flag if SNaN))
	ba	3f
	nop
1:
	tst	%o0
	st	%o3,[%sp+0x48]		_C([%sp+0x48] = two52)
	st	%g0,[%sp+0x4c]
	ldd	[%sp+0x48],%f2		_C(L = copysign(two52, x))
	bge	2f
	nop
	fnegs	%f2,%f2
2:
	faddd	%f0,%f2,%f0		_C((x + L) rounded)
	fcmpd	%f0,%f2
ifdef(`ARCH_v7', `dnl
	nop
')dnl
	fbne	0f
	nop
	ldd	[%sp+0x50],%f0		_C(return copysign(zero, x))
	bge	3f
	nop
	fnegs	%f0,%f0
	ba	3f
	nop
0:
	fsubd	%f0,%f2,%f0		_C(return (x + L) rounded - L)
3:
	.end

	.inline	NAME(rintf),1
	st	%o0,[%sp+0x48]
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o2
	ld	[%sp+0x48],%f0
	sethi	%hi(0x4b000000),%o3
	st	%g0,[%sp+0x50]		_C([%sp+0x50] = zero)
	subcc	%o2,%o3,%g0
	bl	1f
	nop
	sethi	%hi(0x3f800000),%o2
	st	%o2,[%sp+0x50]		_C([%sp+0x50] = one)
	ld	[%sp+0x50],%f2
	fmuls	%f0,%f2,%f0		_C(return x * one (raise flag if SNaN))
	ba	3f
	nop
1:
	tst	%o0
	st	%o3,[%sp+0x48]		_C([%sp+0x48] = two23)
	ld	[%sp+0x48],%f2		_C(L = copysignf(two23, x))
	bge	2f
	nop
	fnegs	%f2,%f2
2:
	fadds	%f0,%f2,%f0		_C((x + L) rounded)
	fcmps	%f0,%f2
ifdef(`ARCH_v7', `dnl
	nop
')dnl
	fbne	0f
	nop
	ld	[%sp+0x50],%f0		_C(return copysignf(zero, x))
	bge	3f
	nop
	fnegs	%f0,%f0
	ba	3f
	nop
0:
	fsubs	%f0,%f2,%f0		_C(return (x + L) rounded - L)
3:
	.end

')dnl
dnl
dnl! x0 = 0x44	! shadow area of %o0
dnl! x1 = 0x48	! shadow area of %o1
dnl! x2 = 0x4c	! shadow area of %o2
dnl! x3 = 0x50	! shadow area of %o3
dnl! x4 = 0x54	! shadow area of %o4
dnl! x5 = 0x58	! shadow area of %o5
dnl
	.inline	NAME(min_subnormal),0
	set	0x0,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0x1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(d_min_subnormal_),0
	set	0x0,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0x1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(min_subnormalf),0
	set	0x1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_min_subnormal_),0
	set	0x1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(max_subnormal),0
	set	0x000fffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0xffffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(d_max_subnormal_),0
	set	0x000fffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0xffffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(max_subnormalf),0
	set	0x007fffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_max_subnormal_),0
	set	0x007fffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(min_normal),0
        set     0x00100000,%o0
        set     0x0,%o1
        std     %o0,[%sp+0x48]
        ldd     [%sp+0x48],%f0
	.end

	.inline	NAME(d_min_normal_),0
	set	0x00100000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0x0,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(min_normalf),0
	set	0x00800000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_min_normal_),0
	set	0x00800000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(max_normal),0
        set     0x7fefffff,%o0
        set     0xffffffff,%o1
        std     %o0,[%sp+0x48]
        ldd     [%sp+0x48],%f0
	.end

	.inline	NAME(d_max_normal_),0
	set	0x7fefffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0xffffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(max_normalf),0
	set	0x7f7fffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_max_normal_),0
	set	0x7f7fffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(__infinity),0
        set      0x7ff00000,%o0
        set      0x0,%o1
        std      %o0,[%sp+0x48]
        ldd      [%sp+0x48],%f0
        .end

	.inline	NAME(infinity),0
        set      0x7ff00000,%o0
        set      0x0,%o1
        std      %o0,[%sp+0x48]
        ldd      [%sp+0x48],%f0
        .end

	.inline	NAME(d_infinity_),0
	set	0x7ff00000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0x0,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(infinityf),0
	set	0x7f800000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_infinity_),0
	set	0x7f800000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(signaling_nan),0
        set     0x7ff00000,%o0
        set     0x1,%o1
        std     %o0,[%sp+0x48]
        ldd     [%sp+0x48],%f0
	.end

	.inline	NAME(d_signaling_nan_),0
	set	0x7ff00000,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0x1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(signaling_nanf),0
	set	0x7f800001,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_signaling_nan_),0
	set	0x7f800001,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(quiet_nan),0
	set	0x7fffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0xffffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(d_quiet_nan_),0
	set	0x7fffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	set	0xffffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f1
	.end

	.inline	NAME(quiet_nanf),0
	set	0x7fffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_quiet_nan_),0
	set	0x7fffffff,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(__swapEX),1
	and     %o0,0x1f,%o1
	sll     %o1,5,%o1               ! shift input to aexc bit location
	.volatile
	st      %fsr,[%sp+0x44]
	ld      [%sp+0x44],%o0          ! o0 = fsr
	andn    %o0,0x3e0,%o2
	or      %o1,%o2,%o1             ! o1 = new fsr
	st      %o1,[%sp+0x44]
	ld      [%sp+0x44],%fsr
	srl     %o0,5,%o0
	and     %o0,0x1f,%o0
	.nonvolatile
	.end

	.inline	NAME(_QgetRD),0
	st	%fsr,[%sp+0x44]
	ld	[%sp+0x44],%o0		! o0 = fsr
	srl	%o0,30,%o0		! return round control value
	.end

	.inline	NAME(_QgetRP),0
	or	%g0,%g0,%o0
	.end

	.inline	NAME(__swapRD),1
	and	%o0,0x3,%o0
	sll     %o0,30,%o1              ! shift input to RD bit location
	.volatile
	st      %fsr,[%sp+0x44]
	ld      [%sp+0x44],%o0          ! o0 = fsr
	set     0xc0000000,%o4          ! mask of rounding direction bits
	andn    %o0,%o4,%o2
	or      %o1,%o2,%o1             ! o1 = new fsr
	st      %o1,[%sp+0x44]
	ld      [%sp+0x44],%fsr
	srl     %o0,30,%o0
	and     %o0,0x3,%o0
	.nonvolatile
	.end

!
! On the SPARC, __swapRP is a no-op; always return 0 for backward compatibility
!
	.inline	NAME(__swapRP),1
	or	%g0,%g0,%o0
	.end

	.inline	NAME(__swapTE),1
	and	%o0,0x1f,%o0
	sll     %o0,23,%o1              ! shift input to TEM bit location
	.volatile
	st      %fsr,[%sp+0x44]
	ld      [%sp+0x44],%o0            ! o0 = fsr
	set     0x0f800000,%o4          ! mask of TEM (Trap Enable Mode bits)
	andn    %o0,%o4,%o2
	or      %o1,%o2,%o1             ! o1 = new fsr
	st      %o1,[%sp+0x48]
	ld      [%sp+0x48],%fsr
	srl     %o0,23,%o0
	and     %o0,0x1f,%o0
	.nonvolatile
	.end

	.inline	NAME(fp_class),2
	sethi	%hi(0x80000000),%o2	! o2 gets 80000000
	andn	%o0,%o2,%o0		! o0-o1 gets abs(x)
	orcc	%o0,%o1,%g0		! set cc as x is zero/nonzero
	bne	1f			! branch if x is nonzero
	nop
	mov	0,%o0
	ba	2f			! x is 0
	nop
1:
	sethi	%hi(0x7ff00000),%o2	! o2 gets 7ff00000
	andcc	%o0,%o2,%g0		! cc set by exp field of x
	bne	1f			! branch if normal or max exp
	nop
	mov	1,%o0
	ba	2f			! x is subnormal
	nop
1:
	cmp	%o0,%o2
	bge	1f			! branch if x is max exp
	nop
	mov	2,%o0
	ba	2f			! x is normal
	nop
1:
	andn	%o0,%o2,%o0		! o0 gets msw significand field
	orcc	%o0,%o1,%g0		! set cc by OR significand
	bne	1f			! Branch if nan
	nop
	mov	3,%o0
	ba	2f			! x is infinity
	nop
1:
	sethi	%hi(0x00080000),%o2
	andcc	%o0,%o2,%g0		! set cc by quiet/sig bit
	be	1f			! Branch if signaling
	nop
	mov	4,%o0			! x is quiet NaN
	ba	2f
	nop
1:
	mov	5,%o0			! x is signaling NaN
2:
	.end

	.inline	NAME(fp_classf),1
	sethi	%hi(0x80000000),%o2
	andncc	%o0,%o2,%o0
	bne	1f
	nop
	mov	0,%o0
	ba	2f			! x is 0
	nop
1:
	sethi	%hi(0x7f800000),%o2
	andcc	%o0,%o2,%g0
	bne	1f
	nop
	mov	1,%o0
	ba	2f			! x is subnormal
	nop
1:
	cmp	%o0,%o2
	bge	1f
	nop
	mov	2,%o0
	ba	2f			! x is normal
	nop
1:
	bg	1f
	nop
	mov	3,%o0
	ba	2f			! x is infinity
	nop
1:
	sethi	%hi(0x00400000),%o2
	andcc	%o0,%o2,%g0
	mov	4,%o0			! x is quiet NaN
	bne	2f
	nop
	mov	5,%o0			! x is signaling NaN
2:
	.end

	.inline	NAME(ir_fp_class_),1
	ld	[%o0],%o0
	sethi	%hi(0x80000000),%o2
	andncc	%o0,%o2,%o0
	bne	1f
	nop
	mov	0,%o0
	ba	2f			! x is 0
	nop
1:
	sethi	%hi(0x7f800000),%o2
	andcc	%o0,%o2,%g0
	bne	1f
	nop
	mov	1,%o0
	ba	2f			! x is subnormal
	nop
1:
	cmp	%o0,%o2
	bge	1f
	nop
	mov	2,%o0
	ba	2f			! x is normal
	nop
1:
	bg	1f
	nop
	mov	3,%o0
	ba	2f			! x is infinity
	nop
1:
	sethi	%hi(0x00400000),%o2
	andcc	%o0,%o2,%g0
	mov	4,%o0			! x is quiet NaN
	bne	2f
	nop
	mov	5,%o0			! x is signaling NaN
2:
	.end

	.inline	NAME(copysign),4
        set     0x80000000,%o3
        and     %o2,%o3,%o2
        andn    %o0,%o3,%o0
        or      %o0,%o2,%o0
        std      %o0,[%sp+0x48]
        ldd     [%sp+0x48],%f0
        .end

	.inline	NAME(copysignf),2
	set	0x80000000,%o2
	andn	%o0,%o2,%o0
	and	%o1,%o2,%o1
	or	%o0,%o1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(r_copysign_),2
	ld	[%o0],%o0
	ld	[%o1],%o1
	set	0x80000000,%o2
	andn	%o0,%o2,%o0
	and	%o1,%o2,%o1
	or	%o0,%o1,%o0
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	.end

	.inline	NAME(finite),2
	set	0x7ff00000,%o1
	and	%o0,%o1,%o0
	cmp	%o0,%o1
	mov	1,%o0
	bne	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(finitef),2
	set	0x7f800000,%o1
	and	%o0,%o1,%o0
	cmp	%o0,%o1
	mov	1,%o0
	bne	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(ir_finite_),1
	ld	[%o0],%o0
	set	0x7f800000,%o1
	and	%o0,%o1,%o0
	cmp	%o0,%o1
	mov	1,%o0
	bne	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(signbit),1
	srl	%o0,31,%o0
	.end

	.inline	NAME(signbitf),1
	srl	%o0,31,%o0
	.end

	.inline	NAME(ir_signbit_),1
	ld	[%o0],%o0
	srl	%o0,31,%o0
	.end

	.inline	NAME(isinf),2
	tst	%o1
	sethi	%hi(0x80000000),%o2
	bne	1f
	nop
	andn	%o0,%o2,%o0
	sethi	%hi(0x7ff00000),%o2
	cmp	%o0,%o2
	mov	1,%o0
	be	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(isinff),1
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0		! o0 gets abs(x)
	sethi	%hi(0x7f800000),%o2
	cmp	%o0,%o2
	mov	0,%o0
	bne	1f			! Branch if not inf.
	nop
	mov	1,%o0
1:
	.end

	.inline	NAME(ir_isinf_),1
	ld	[%o0],%o0
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0		! o0 gets abs(x)
	sethi	%hi(0x7f800000),%o2
	cmp	%o0,%o2
	mov	0,%o0
	bne	1f			! Branch if not inf.
	nop
	mov	1,%o0
1:
	.end

	.inline	NAME(isnan),2
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0		_C(mask off sign bit)
	sub	%g0,%o1,%o3		_C(sticky <- ((lo|-lo) >> 31))
	or	%o1,%o3,%o1
	srl	%o1,31,%o1
	or	%o0,%o1,%o0		_C(hi <- hi | sticky)
	sethi	%hi(0x7ff00000),%o4
	sub	%o4,%o0,%o0
	srl	%o0,31,%o0
	.end

	.inline	NAME(isnanf),1
	sethi	%hi(0x80000000),%o2	_C(mask off sign bit)
	andn	%o0,%o2,%o0
	sethi	%hi(0x7f800000),%o1
	sub	%o1,%o0,%o0
	srl	%o0,31,%o0
	.end

	.inline	NAME(ir_isnan_),1
	ld	[%o0],%o0
	sethi	%hi(0x80000000),%o2	_C(mask off sign bit)
	andn	%o0,%o2,%o0
	sethi	%hi(0x7f800000),%o1
	sub	%o1,%o0,%o0
	srl	%o0,31,%o0
	.end

	.inline	NAME(isnormal),2
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0
	sethi	%hi(0x7ff00000),%o2
	cmp	%o0,%o2
	sethi	%hi(0x00100000),%o2
	bge	1f
	nop
	cmp	%o0,%o2
	mov	1,%o0
	bge	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(isnormalf),1
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0
	sethi	%hi(0x7f800000),%o2
	cmp	%o0,%o2
	sethi	%hi(0x00800000),%o2
	bge	1f
	nop
	cmp	%o0,%o2
	mov	1,%o0
	bge	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(ir_isnormal_),1
	ld	[%o0],%o0
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0
	sethi	%hi(0x7f800000),%o2
	cmp	%o0,%o2
	sethi	%hi(0x00800000),%o2
	bge	1f
	nop
	cmp	%o0,%o2
	mov	1,%o0
	bge	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(issubnormal),2
	sethi	%hi(0x80000000),%o2	! o2 gets 80000000
	andn	%o0,%o2,%o0		! o0/o1 gets abs(x)
	sethi	%hi(0x00100000),%o2	! o2 gets 00100000
	cmp	%o0,%o2
	bge	1f			! branch if x norm or max exp
	nop
	orcc	%o0,%o1,%g0
	be	1f			! Branch if x zero
	nop
	mov	1,%o0			! x is subnormal
	ba	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(issubnormalf),1
	sethi	%hi(0x80000000),%o2	! o2 gets 80000000
	andn	%o0,%o2,%o0		! o0 gets abs(x)
	sethi	%hi(0x00800000),%o2	! o2 gets 00800000
	cmp	%o0,%o2
	bge	1f			! branch if x norm or max exp
	nop
	orcc	%o0,%g0,%g0
	be	1f			! Branch if x zero
	nop
	mov	1,%o0			! x is subnormal
	ba	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(ir_issubnormal_),1
	ld	[%o0],%o0
	sethi	%hi(0x80000000),%o2	! o2 gets 80000000
	andn	%o0,%o2,%o0		! o0 gets abs(x)
	sethi	%hi(0x00800000),%o2	! o2 gets 00800000
	cmp	%o0,%o2
	bge	1f			! branch if x norm or max exp
	nop
	orcc	%o0,%g0,%g0
	be	1f			! Branch if x zero
	nop
	mov	1,%o0			! x is subnormal
	ba	2f
	nop
1:
	mov	0,%o0
2:
	.end

	.inline	NAME(iszero),2
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o0
	orcc	%o0,%o1,%g0
	mov	1,%o0
	be	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(iszerof),1
	sethi	%hi(0x80000000),%o2
	andncc	%o0,%o2,%o0
	mov	1,%o0
	be	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(ir_iszero_),1
	ld	[%o0],%o0
	sethi	%hi(0x80000000),%o2
	andncc	%o0,%o2,%o0
	mov	1,%o0
	be	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(abs),1
	sra	%o0,31,%o1
	xor	%o0,%o1,%o0
        sub	%o0,%o1,%o0
        .end

	.inline	NAME(fabs),2
	st	%o0,[%sp+0x48]
	st	%o1,[%sp+0x4c]
	ldd	[%sp+0x48],%f0
ifdef(`ARCH_v8plus', `dnl
	fabsd	%f0,%f0
',`dnl
	fabss	%f0,%f0
')dnl
	.end

	.inline	NAME(fabsf),1
	st	%o0,[%sp+0x44]
	ld	[%sp+0x44],%f0
	fabss	%f0,%f0
	.end

	.inline	NAME(r_fabs_),1
	ld	[%o0],%f0
	fabss	%f0,%f0
	.end

!
!	__nintf - f77 NINT(REAL*4)
!
	.inline	NAME(__nintf),1
	srl	%o0,30-7,%g1
	sethi	%hi(0x7fffff),%o2
	st	%o0,[%sp+0x44]		_C(prepare for reload if |x| >= 2^31)
	and	%g1,0xff,%g1		_C(%g1 := biased exponent)
	or	%o2,%lo(0x7fffff),%o2	_C(%o2 := 0x7fffff)
	sethi	%hi(1<<22),%o4		_C(%o4 := 0x400000)
	subcc	%g1,127+31,%g0		_C(< 0 iff |x| < 2^31)
	and	%o0,%o2,%o3		_C(%o3 := mantissa)
	bl	0f
	nop
	sethi	%hi(0xcf000000),%o2	_C(%o2 := -2^31 in floating point)
	sethi	%hi(0x80000000),%g1	_C(%g1 := -2^31 in fixed point)
	subcc	%o0,%o2,%g0		_C(x == -2^31?)
	or	%g1,%g0,%o0		_C(return -2^31 if x == -2^31)
	be	9f
	nop
	ld	[%sp+0x44],%f0
	fstoi	%f0,%f0			_C(return result and trigger fp_invalid)
	st	%f0,[%sp+0x44]
	ld	[%sp+0x44],%o0
	ba	9f
	nop
0:
	add	%o4,%o4,%o5		_C(%o5 := 0x800000)
	or	%o3,%o5,%o3		_C(%o3 := mantissa w/hidden leading bit)
	sra	%o0,31-0,%o2		_C(%o2 := 0/-1 = copysign(0.5, x) - 0.5)
	subcc	%g1,127,%g1		_C(%g1 := e)
	srl	%o4,%g1,%o4		_C(%o4 := 0.5 in fixed point)
	bge	1f			_C(if |x| >= 1.0)
	nop
	subcc	%g1,-1,%g0
	or	%g0,0,%o0		_C(return 0 if |x| < 0.5)
	bne	2f
	nop
	or	%g0,1,%o0		_C(return 1 if 0.5 <= |x| < 1)
	ba	2f
	nop
1:
	add	%o3,%o4,%o3		_C(%o3 := mantissa + 0.5 in fixed point)
	or	%g0,23,%o0		_C(%o0 := 23)
	subcc	%o0,%g1,%o0		_C(%o0 := 23 - e)
	bl	1f			_C(if 0 <= e <= 23)
	nop
	srl	%o3,%o0,%o0		_C(%o0 := int(|x| + 0.5))
	ba	2f
	nop
1:
	sub	%g0,%o0,%o0		_C(%o0 := e - 23)
	sll	%o3,%o0,%o0
2:
	xor	%o0,%o2,%o0
	and	%o2,1,%o2		_C(%o2 := 0/1)
	add	%o0,%o2,%o0
9:
	.end

ifdef(`ARCH_v8plus', `dnl
	.inline	NAME(__il_nint),1
	ld	[%o0],%o0	_C(%o0 := s*1.f*2^e)
	sra	%o0,0,%o0	_C(sign-extend to 64-bit %o0)
	srlx	%o0,31-8,%g1
	or	%g0,1,%o2
	sllx	%o2,23-1,%o4	_C(%o4 := 0x00000000 00400000)
	and	%g1,0xff,%g1	_C(%g1 := biased exponent)
	sllx	%o2,63-0,%o2
	subcc	%g1,127+63,%g0	_C(>= 0 iff |x| >= 2^63)
	bl	0f
	nop
	st	%o0,[%sp+0x48]
	ld	[%sp+0x48],%f0
	fstox	%f0,%f0
	std	%f0,[%sp+0x48]
	ldx	[%sp+0x48],%o1
	ba	9f
	nop
0:
	add	%o4,%o4,%o5	_C(%o5 := 0x00000000 00800000)
	srax	%o2,63-23,%o2
	sub	%g1,127+23,%o1	_C(%o1 >= 0 iff |x| >= 2^23)
	xnor	%o2,%g0,%o2	_C(%o2 := 0x00000000 007fffff)
	and	%o0,%o2,%o3	_C(%o3 := mantissa)
	or	%o3,%o5,%o3	_C(%o3 := mantissa w/hidden leading bit)
	srax	%o0,63-0,%o2	_C(%o2 := 0/-1 = copysign(0.5, x) - 0.5)
	subcc	%g1,127,%g1	_C(%g1 := e)
	bge	1f		_C(if |x| >= 1.0)
	nop
	subcc	%g1,-1,%g0
	or	%g0,0,%o0	_C(return 0 if |x| < 0.5)
	bne	2f
	nop
	or	%g0,1,%o0	_C(return 1 if 0.5 <= |x| < 1)
	ba	2f
	nop
1:
	brlz,pt	%o1,3f
	nop			_C(2^23 <= |x| < 2^63)
	sub	%g1,23,%o0	_C(%o0 := e - 23)
	sllx	%o3,%o0,%o0	_C(%o0 := int(|x|))
	ba	2f
	nop
3:
	srlx	%o4,%g1,%o4	_C(%o4 := 0.5 in fixed point)
	add	%o3,%o4,%o3	_C(%o3 := mantissa w/HLB + 0.5 in fixed point)
	or	%g0,23,%o0	_C(%o0 := 23)
	sub	%o0,%g1,%o0	_C(%o0 := 23 - e)
	srlx	%o3,%o0,%o0	_C(%o0 := int(|x| + 0.5))
2:
	xor	%o0,%o2,%o0
	sub	%o0,%o2,%o1
9:
	srlx	%o1,32,%o0
	.end

')dnl
!
!	__i_dnnt - f77 NINT(REAL*8)
!
ifdef(`ARCH_v8plus', `dnl
	.inline	NAME(__i_dnnt),1
	ld	[%o0],%o1	_C(we may not assume the address is DW-aligned)
	sllx	%o1,32,%o1
	ld	[%o0+4],%o0
	or	%o0,%o1,%o0	_C(%o0 := s*1.f*2^e)
	srlx	%o0,63-11,%g1
	or	%g0,1,%o2
	stx	%o0,[%sp+0x48]	_C(prepare for reload if x is out of range)
	sllx	%o2,52-1,%o4	_C(%o4 := 0x00080000 00000000)
	and	%g1,0x7ff,%g1	_C(%g1 := biased exponent)
	sllx	%o2,63-0,%o2
	subcc	%g1,1023+32,%g0	_C(>= 0 iff |x| >= 2^32)
	bl	0f
	nop
	ldd	[%sp+0x48],%f0
	ba	8f
	nop
0:
	add	%o4,%o4,%o5	_C(%o5 := 0x00100000 00000000)
	srax	%o2,63-52,%o2
	sub	%g1,1023+30,%o1	_C(%o1 >= 0 iff |x| >= 2^30)
	xnor	%o2,%g0,%o2	_C(%o2 := 0x000fffff ffffffff)
	and	%o0,%o2,%o3	_C(%o3 := mantissa)
	or	%o3,%o5,%o3	_C(%o3 := mantissa w/hidden leading bit)
	srax	%o0,63-0,%o2	_C(%o2 := 0/-1 = copysign(0.5, x) - 0.5)
	subcc	%g1,1023,%g1	_C(%g1 := e)
	bge	1f		_C(if |x| >= 1.0)
	nop
	subcc	%g1,-1,%g0
	or	%g0,0,%o0	_C(return 0 if |x| < 0.5)
	bne	2f
	nop
	or	%g0,1,%o0	_C(return 1 if 0.5 <= |x| < 1)
	ba	2f
	nop
1:
	srlx	%o4,%g1,%o4	_C(%o4 := 0.5 in fixed point)
	add	%o3,%o4,%o3	_C(%o3 := mantissa w/HLB + 0.5 in fixed point)
	or	%g0,52,%o0	_C(%o0 := 52)
	sub	%o0,%g1,%o0	_C(%o0 := 52 - e)
	srlx	%o3,%o0,%o0	_C(%o0 := int(|x| + 0.5))
2:
	xor	%o0,%o2,%o0
	sub	%o0,%o2,%o0
	brlz,pt	%o1,9f
	nop
	stx	%o0,[%sp+0x48]	_C(2^30 <= |x| < 2^32)
	ldd	[%sp+0x48],%f0
	fxtod	%f0,%f0
8:
	fdtoi	%f0,%f0
	st	%f0,[%sp+0x44]
	ld	[%sp+0x44],%o0
9:
	.end

	.inline	NAME(__il_dnnt),1
	ld	[%o0],%o1	_C(we may not assume the address is DW-aligned)
	sllx	%o1,32,%o1
	ld	[%o0+4],%o0
	or	%o0,%o1,%o0	_C(%o0 := s*1.f*2^e)
	srlx	%o0,63-11,%g1
	or	%g0,1,%o2
	sllx	%o2,52-1,%o4	_C(%o4 := 0x00080000 00000000)
	and	%g1,0x7ff,%g1	_C(%g1 := biased exponent)
	sllx	%o2,63-0,%o2
	subcc	%g1,1023+63,%g0	_C(>= 0 iff |x| >= 2^63)
	bl	0f
	nop
	stx	%o0,[%sp+0x48]
	ldd	[%sp+0x48],%f0
	fdtox	%f0,%f0
	std	%f0,[%sp+0x48]
	ldx	[%sp+0x48],%o1
	ba	9f
	nop
0:
	add	%o4,%o4,%o5	_C(%o5 := 0x00100000 00000000)
	srax	%o2,63-52,%o2
	sub	%g1,1023+52,%o1	_C(%o1 >= 0 iff |x| >= 2^52)
	xnor	%o2,%g0,%o2	_C(%o2 := 0x000fffff ffffffff)
	and	%o0,%o2,%o3	_C(%o3 := mantissa)
	or	%o3,%o5,%o3	_C(%o3 := mantissa w/hidden leading bit)
	srax	%o0,63-0,%o2	_C(%o2 := 0/-1 = copysign(0.5, x) - 0.5)
	subcc	%g1,1023,%g1	_C(%g1 := e)
	bge	1f		_C(if |x| >= 1.0)
	nop
	subcc	%g1,-1,%g0
	or	%g0,0,%o0	_C(return 0 if |x| < 0.5)
	bne	2f
	nop
	or	%g0,1,%o0	_C(return 1 if 0.5 <= |x| < 1)
	ba	2f
	nop
1:
	brlz,pt	%o1,3f
	nop			_C(2^52 <= |x| < 2^63)
	sub	%g1,52,%o0	_C(%o0 := e - 52)
	sllx	%o3,%o0,%o0	_C(%o0 := int(|x|))
	ba	2f
	nop
3:
	srlx	%o4,%g1,%o4	_C(%o4 := 0.5 in fixed point)
	add	%o3,%o4,%o3	_C(%o3 := mantissa w/HLB + 0.5 in fixed point)
	or	%g0,52,%o0	_C(%o0 := 52)
	sub	%o0,%g1,%o0	_C(%o0 := 52 - e)
	srlx	%o3,%o0,%o0	_C(%o0 := int(|x| + 0.5))
2:
	xor	%o0,%o2,%o0
	sub	%o0,%o2,%o1
9:
	srlx	%o1,32,%o0
	.end

',`dnl
dnl!	int __i_dnnt(const double *xp) {
dnl!		unsigned long long u = *(unsigned long long *) xp;
dnl!		unsigned v = 0x432 - (unsigned) ((u >> 52U) & 0x7ffU);
dnl!		if (v < 53U)			/* i.e. 0 <= v <= 52 */
dnl!			u += 1ULL << v;
dnl!		return (int) *(double *) &u;
dnl!	}
	.inline	NAME(__i_dnnt),1
	ld	[%o0],%o4
	ld	[%o0+4],%o5	_C(o4:5 := u)
	srl	%o4,20,%o3
	and	%o3,0x7ff,%o3
	sub	%o3,0x432,%o3
	sub	%g0,%o3,%o3	_C(o3 := v = 0x432 - ((u >> 52) & 0x7ff))
	subcc	%o3,53,%g0
	bcc	2f
	nop
	or	%g0,1,%g1
	subcc	%o3,32,%o2	_C(o2 = v - 32)
	bl	1f
	nop
	sll	%g1,%o2,%g1	_C(.5 falls in the high word)
	add	%o4,%g1,%o4	_C(u += 1 << v)
	ba	2f
	nop
1:
	sll	%g1,%o3,%g1	_C(.5 falls in the low word)
	addcc	%o5,%g1,%o5
	addx	%o4,0,%o4	_C(u += 1 << v)
2:
	st	%o4,[%sp+0x48]
	st	%o5,[%sp+0x4c]
	ldd	[%sp+0x48],%f2
	fdtoi	%f2,%f2
	st	%f2,[%sp+0x44]
	ld	[%sp+0x44],%o0
	.end

')dnl
ifdef(`ARCH_v8plusa', `dnl
	.inline	NAME(__aintf),1
	fzeros	%f4		_C(0)
	fnegs	%f4,%f8		_C(-0)
	st	%o0,[%sp+0x48]
	ld	[%sp+0x48],%f0	_C(x)
	fabss	%f0,%f6		_C(|x|)
	sethi	%hi(0x4b000000),%o2
	st	%o2,[%sp+0x48]
	ld	[%sp+0x48],%f2	_C(2^23)
	fcmps	%fcc0,%f6,%f2
	fmovsuge %fcc0,%f4,%f6	_C(|x| < 2^23 ? |x| : 0)
	fstoi	%f6,%f6		_C(truncate to integer)
	fitos	%f6,%f6
	fadds	%f0,%f4,%f2	_C(x + 0)
	fmovsuge %fcc0,%f2,%f6	_C(|x| < 2^23 ? truncf(|x|) : x + 0)
	fands	%f0,%f8,%f0	_C(copysignf(0, x))
	fors	%f0,%f6,%f0	_C(restore sign of x)
	.end

	.inline	NAME(__aint),2
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	sllx	%o0,32,%o0
	or	%o0,%o1,%o0
	stx	%o0,[%sp+0x48]
	ldd	[%sp+0x48],%f0	_C(x)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x48]
	ldd	[%sp+0x48],%f2	_C(2^52)
	fcmpd	%fcc0,%f6,%f2
	fmovduge %fcc0,%f4,%f6	_C(|x| < 2^52 ? |x| : 0)
	fdtox	%f6,%f6		_C(truncate to integer)
	fxtod	%f6,%f6
	faddd	%f0,%f4,%f2	_C(x + 0)
	fmovduge %fcc0,%f2,%f6	_C(|x| < 2^52 ? trunc(|x|) : x + 0)
	fand	%f0,%f8,%f0	_C(copysign(0, x))
	for	%f0,%f6,%f0	_C(restore sign of x)
	.end

')dnl
dnl!float
dnl!__anintf(float x) {
dnl!	unsigned u = *(unsigned *) &x;
dnl!	unsigned v = 0x95 - (unsigned) ((u >> 23U) & 0xffU);
dnl!	unsigned t = 1U << v;
dnl!	unsigned s = t - 1;
dnl!	/*
dnl!	 * v := 22 - e
dnl!	 */
dnl!	if (v < 23U) {			/* 0 <= e <= 22 */
dnl!		t &= u;
dnl!		u += t;
dnl!		u &= ~s;
dnl!	}
dnl!	else if (v == 23U) {		/* e == -1 */
dnl!		u += t;
dnl!		u &= ~s;
dnl!	}
dnl!	else if (*(int *) &v > 23)	/* e <= -2 */
dnl!		u &= 0x80000000;
dnl!	return *(float *) &u;
dnl!}
	.inline	NAME(__anintf),1
	or	%g0,1,%o1
	srl	%o0,23,%g1
	and	%g1,0xff,%g1
	sub	%g0,%g1,%g1
	add	%g1,0x95,%g1
	subcc	%g1,23,%g0
	sll	%o1,%g1,%o1
	sub	%o1,1,%o2
	bcs	1f
	nop
	be	2f
	nop
	bl	3f
	nop
	sethi	%hi(0x80000000),%o1
	and	%o0,%o1,%o0
	ba	3f
	nop
1:
	and	%o0,%o1,%o1
2:
	add	%o0,%o1,%o0
	andn	%o0,%o2,%o0
3:
	st	%o0,[%sp+0x48]
	ld	[%sp+0x48],%f0
	.end

ifdef(`ARCH_v8plus', `dnl
dnl!double
dnl!__anint(double x) {
dnl!	unsigned long long u = *(unsigned long long *) &x;
dnl!	unsigned v = 0x432 - (unsigned) ((u >> 52U) & 0x7ffU);
dnl!	unsigned long long t = 1ULL << v;
dnl!	unsigned long long s = t - 1;
dnl!	/*
dnl!	 * v := 51 - e
dnl!	 */
dnl!	if (v < 52U) {			/* 0 <= e <= 51 */
dnl!		t &= u;
dnl!		u += t;
dnl!		u &= ~s;
dnl!	}
dnl!	else if (v == 52U) {		/* e == -1 */
dnl!		u += t;
dnl!		u &= ~s;
dnl!	}
dnl!	else if (*(int *) &v > 52)	/* e <= -2 */
dnl!		u = (u >> 63) << 63;
dnl!	return *(double *) &u;
dnl!}
	.inline	NAME(__anint),2
	sllx	%o0,32,%o0
	or	%o0,%o1,%o0
	or	%g0,1,%o1
	srlx	%o0,52,%g1
	and	%g1,0x7ff,%g1
	sub	%g0,%g1,%g1
	add	%g1,0x432,%g1
	subcc	%g1,52,%g0
	sllx	%o1,%g1,%o1
	sub	%o1,1,%o2
	bcs,pt	%icc,1f
	nop
	be,pt	%icc,2f
	nop
	bl,pt	%icc,3f
	nop
	srlx	%o0,63,%o0
	sllx	%o0,63,%o0
	ba	3f
	nop
1:
	and	%o0,%o1,%o1
2:
	add	%o0,%o1,%o0
	andn	%o0,%o2,%o0
3:
	stx	%o0,[%sp+0x48]
	ldd	[%sp+0x48],%f0
	.end

')dnl
	.inline	NAME(__Fz_minus),3
	ld	[%o1],%f0
	ld	[%o1+0x4],%f1
	ld	[%o2],%f4
	ld	[%o2+0x4],%f5
	fsubd	%f0,%f4,%f0
	ld	[%o1+8],%f2
	ld	[%o1+0xc],%f3
	ld	[%o2+8],%f6
	ld	[%o2+0xc],%f7
	fsubd	%f2,%f6,%f2
	st	%f0,[%o0+0x0]
	st	%f1,[%o0+0x4]
	st	%f2,[%o0+0x8]
	st	%f3,[%o0+0xc]
	.end

	.inline	NAME(__Fz_add),3
	ld	[%o1],%f0
	ld	[%o1+0x4],%f1
	ld	[%o2],%f4
	ld	[%o2+0x4],%f5
	faddd	%f0,%f4,%f0
	ld	[%o1+8],%f2
	ld	[%o1+0xc],%f3
	ld	[%o2+8],%f6
	ld	[%o2+0xc],%f7
	faddd	%f2,%f6,%f2
	st	%f0,[%o0+0x0]
	st	%f1,[%o0+0x4]
	st	%f2,[%o0+0x8]
	st	%f3,[%o0+0xc]
	.end

	.inline	NAME(__Fz_neg),2
	ld	[%o1],%f0
	fnegs	%f0,%f0
	ld	[%o1+0x4],%f1
	st	%f1,[%o0+0x4]
	ld	[%o1+8],%f2
	fnegs	%f2,%f2
	ld	[%o1+0xc],%f3
	st	%f3,[%o0+0xc]
	st	%f0,[%o0]
	st	%f2,[%o0+0x8]
	.end

	.inline	NAME(__Ff_conv_z),2
	st	%o1,[%sp+0x44]
	ld	[%sp+0x44],%f0
	fstod	%f0,%f0
	st	%g0,[%o0+0x8]
	st	%g0,[%o0+0xc]
	st	%f1,[%o0+0x4]
	st	%f0,[%o0]
	.end

	.inline	NAME(__Fz_conv_f),1
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	fdtos	%f0,%f0
	.end

	.inline	NAME(__Fz_conv_i),1
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	fdtoi	%f0,%f0
	st	%f0,[%sp+0x44]
	ld	[%sp+0x44],%o0
	.end

	.inline	NAME(__Fi_conv_z),2
	st	%o1,[%sp+0x44]
	ld	[%sp+0x44],%f0
	fitod	%f0,%f0
	st	%g0,[%o0+0x8]
	st	%g0,[%o0+0xc]
	st	%f1,[%o0+0x4]
	st	%f0,[%o0]
	.end

	.inline	NAME(__Fz_conv_d),1
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	.end

	.inline	NAME(__Fd_conv_z),3
	st	%o1,[%o0]
	st	%o2,[%o0+0x4]
	st	%g0,[%o0+0x8]
	st	%g0,[%o0+0xc]
	.end

	.inline	NAME(__Fz_conv_c),2
	ldd     [%o1],%f0
        fdtos   %f0,%f0
        st      %f0,[%o0]
        ldd     [%o1+0x8],%f2
        fdtos   %f2,%f1
        st      %f1,[%o0+0x4]
	.end

	.inline	NAME(__Fz_eq),2
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%f2
	ld	[%o1+4],%f3
	fcmpd	%f0,%f2
	mov	%o0,%o2
	mov	0,%o0
	fbne	1f
	nop
	ld	[%o2+8],%f0
	ld	[%o2+12],%f1
	ld	[%o1+8],%f2
	ld	[%o1+12],%f3
	fcmpd	%f0,%f2
	nop
	fbne	1f
	nop
	mov	1,%o0
1:
	.end

	.inline	NAME(__Fz_ne),2
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%f2
	ld	[%o1+4],%f3
	fcmpd	%f0,%f2
	mov	%o0,%o2
	mov	1,%o0
	fbne	1f
	nop
	ld	[%o2+8],%f0
	ld	[%o2+12],%f1
	ld	[%o1+8],%f2
	ld	[%o1+12],%f3
	fcmpd	%f0,%f2
	nop
	fbne	1f
	nop
	mov	0,%o0
1:
	.end

	.inline	NAME(__c_cmplx),3
	ld	[%o1],%o1
	st	%o1,[%o0]
	ld	[%o2],%o2
	st	%o2,[%o0+4]
	.end

	.inline	NAME(__d_cmplx),3
	ld	[%o1],%f0
	st	%f0,[%o0]
	ld	[%o1+4],%f1
	st	%f1,[%o0+4]
	ld	[%o2],%f0
	st	%f0,[%o0+0x8]
	ld	[%o2+4],%f1
	st	%f1,[%o0+0xc]
	.end

	.inline	NAME(__r_cnjg),2
	ld	[%o1+0x4],%f1
	fnegs	%f1,%f1
	ld	[%o1],%f0
	st	%f0,[%o0]
	st	%f1,[%o0+4]
	.end

	.inline	NAME(__d_cnjg),2
	ld	[%o1+0x8],%f0
	fnegs	%f0,%f0
	ld	[%o1+0xc],%f1
	st	%f1,[%o0+0xc]
	ld	[%o1+0x0],%f1
	st	%f1,[%o0+0x0]
	ld	[%o1+0x4],%f1
	st	%f1,[%o0+0x4]
	st	%f0,[%o0+0x8]
	.end

	.inline	NAME(__r_dim),2
ifdef(`ARCH_v8plus', `dnl
ifdef(`ARCH_v8plusa', `dnl
	fzeros	%f4
',`dnl
	st	%g0,[%sp+0x48]
	ld	[%sp+0x48],%f4
')dnl
	ld	[%o0],%f0
	ld	[%o1],%f2
	fcmps	%fcc0,%f0,%f2
	fmovsule %fcc0,%f4,%f2
	fsubs	%f0,%f2,%f0
	fmovsule %fcc0,%f4,%f0
',`dnl
	ld	[%o0],%f2
	ld	[%o1],%f4
	fcmps	%f2,%f4
	st	%g0,[%sp+0x48]
	ld	[%sp+0x48],%f0
	fbule	1f
	nop
	fsubs	%f2,%f4,%f0
1:
')dnl
	.end

	.inline	NAME(__d_dim),2
ifdef(`ARCH_v8plus', `dnl
ifdef(`ARCH_v8plusa', `dnl
	fzero	%f4
',`dnl
	stx	%g0,[%sp+0x48]
	ldd	[%sp+0x48],%f4
')dnl
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%f2
	ld	[%o1+4],%f3
	fcmpd	%fcc0,%f0,%f2
	fmovdule %fcc0,%f4,%f2
	fsubd	%f0,%f2,%f0
	fmovdule %fcc0,%f4,%f0
',`dnl
	ld	[%o0],%f2
	ld	[%o0+4],%f3
	ld	[%o1],%f4
	ld	[%o1+4],%f5
	fcmpd	%f2,%f4
	st	%g0,[%sp+0x48]
	ld	[%sp+0x48],%f0
	ld	[%sp+0x48],%f1
	fbule	1f
	nop
	fsubd	%f2,%f4,%f0
1:
')dnl
	.end

	.inline	NAME(__r_imag),1
	ld	[%o0+4],%f0
	.end

	.inline	NAME(__d_imag),1
	ld	[%o0+8],%f0
	ld	[%o0+0xc],%f1
	.end

ifdef(`ARCH_v8plus', `dnl
ifdef(`ARCH_v8plusa', `dnl
	.inline	NAME(__f95_signf),2
	fzeros	%f2
	fnegs	%f2,%f2
	ld	[%o0],%f0
	ld	[%o1],%f1
	fabss	%f0,%f0
	fands	%f1,%f2,%f1
	fors	%f0,%f1,%f0
	.end

	.inline	NAME(__f95_sign),2
	fzero	%f4
	fnegd	%f4,%f4
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%f2
	ld	[%o1+4],%f3
	fabsd	%f0,%f0
	fand	%f2,%f4,%f2
	for	%f0,%f2,%f0
	.end

',`dnl
	.inline	NAME(__f95_signf),2
	ld	[%o0],%f0
	ld	[%o1],%o1
	fabss	%f0,%f0
	fnegs	%f0,%f1
	sra	%o1,0,%o1	_C(sign-extend to 64-bit %o1)
	fmovrslz %o1,%f1,%f0
	.end

	.inline	NAME(__f95_sign),2
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%o1
	fabsd	%f0,%f0
	fnegd	%f0,%f2
	sra	%o1,0,%o1	_C(sign-extend to 64-bit %o1)
	fmovrdlz %o1,%f2,%f0
	.end

')dnl
	.inline	NAME(__r_sign),2
	ld	[%o0],%f0
	ld	[%o1],%o1
	fabss	%f0,%f0
	fnegs	%f0,%f1
	sub	%o1,1,%o0
	and	%o1,%o0,%o1	_C(%o1 < 0 iff A2 is negative and not -0)
	sra	%o1,0,%o1	_C(sign-extend to 64-bit %o1)
	fmovrslz %o1,%f1,%f0
	.end

	.inline	NAME(__d_sign),2
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%o0
	sllx	%o0,32,%o0
	ld	[%o1+4],%o1
	or	%o1,%o0,%o1
	fabsd	%f0,%f0
	fnegd	%f0,%f2
	sub	%o1,1,%o0
	and	%o1,%o0,%o1	_C(%o1 < 0 iff A2 is negative and not -0)
	fmovrdlz %o1,%f2,%f0
	.end

',`dnl
	.inline	NAME(__f95_signf),2
	ld	[%o0],%f0
	fabss	%f0,%f0
	ld	[%o1],%o1
	orcc	%g0,%o1,%g0
	bge	1f
	nop
	fnegs	%f0,%f0
1:
	.end

	.inline	NAME(__f95_sign),2
	ld	[%o0],%f0
	fabss	%f0,%f0
	ld	[%o0+4],%f1
	ld	[%o1],%o1
	orcc	%g0,%o1,%g0
	bge	1f
	nop
	fnegs	%f0,%f0
1:
	.end

	.inline	NAME(__r_sign),2
	ld	[%o0],%f0
	fabss	%f0,%f0
	ld	[%o1],%o2
	sethi	%hi(0x80000000),%o3
	cmp	%o2,%o3
	be	1f
	nop
	tst	%o2
	bge	1f
	nop
	fnegs	%f0,%f0
1:
	.end

	.inline	NAME(__d_sign),2
	ld	[%o0],%f0
	fabss	%f0,%f0
	ld	[%o0+4],%f1
	ld	[%o1],%o2
	ld	[%o1+4],%o3
	sethi	%hi(0x80000000),%o4
	andn	%o2,%o4,%o4
	orcc	%o3,%o4,%g0
	be	1f
	nop
	tst	%o2
	bge	1f
	nop
	fnegs	%f0,%f0
1:
	.end

')dnl
	.inline	NAME(__Fz_mult),3
	ld	[%o1],%f0
	ld	[%o1+0x4],%f1
	ld	[%o2],%f4
	ld	[%o2+0x4],%f5
	fmuld	%f0,%f4,%f8	! f8 = r1*r2
	ld	[%o1+0x8],%f2
	ld	[%o1+0xc],%f3
	ld	[%o2+0x8],%f6
	ld	[%o2+0xc],%f7
	fmuld	%f2,%f6,%f10	! f10= i1*i2
	fsubd	%f8,%f10,%f12	! f12= r1*r2-i1*i2
	st	%f12,[%o0]
	st	%f13,[%o0+4]
	fmuld	%f0,%f6,%f14	! f14= r1*i2
	fmuld	%f2,%f4,%f16	! f16= r2*i1
	faddd	%f14,%f16,%f2	! f2 = r1*i2+r2*i1
	st	%f2,[%o0+8]
	st	%f3,[%o0+12]
	.end

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_minus)(c, a, b)
! complex *c, *a, *b;
! {
	.inline	NAME(__Fc_minus),3
!    30	 	c->real = a->real - b->real

	ld	[%o1],%f0
	ld	[%o2],%f1
	fsubs	%f0,%f1,%f2
!    31	  	c->imag = a->imag - b->imag

	ld	[%o1+4],%f3
	ld	[%o2+4],%f4
	fsubs	%f3,%f4,%f5
	st	%f2,[%o0]
	st	%f5,[%o0+4]
	.end
 }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_add)(c, a, b)
! complex *c, *a, *b;
! {
	.inline	NAME(__Fc_add),3
!    39	 	c->real = a->real + b->real

	ld	[%o1],%f0
	ld	[%o2],%f1
	fadds	%f0,%f1,%f2
!    40	 	c->imag = a->imag + b->imag

	ld	[%o1+4],%f3
	ld	[%o2+4],%f4
	fadds	%f3,%f4,%f5
	st	%f2,[%o0]
	st	%f5,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_neg)(c, a)
! complex *c, *a;
! {
	.inline	NAME(__Fc_neg),2
!    48	  	c->real = - a->real

	ld	[%o1],%f0
	fnegs	%f0,%f1
!    49	  	c->imag = - a->imag

	ld	[%o1+4],%f2
	fnegs	%f2,%f3
	st	%f1,[%o0]
	st	%f3,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Ff_conv_c)(c, x)
! complex *c;
! FLOATPARAMETER x;
! {
	.inline	NAME(__Ff_conv_c),2
!    59		c->real = x

	st	%o1,[%o0]
!    60		c->imag = 0.0

	st	%g0,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! FLOATFUNCTIONTYPE
! NAME(__Fc_conv_f)(c)
! complex *c;
! {
	.inline	NAME(__Fc_conv_f),1
!    69  	RETURNFLOAT(c->real)

	ld	[%o0],%f0
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! int
! NAME(__Fc_conv_i)(c)
! complex *c;
! {
	.inline	NAME(__Fc_conv_i),1
!    78		return (int)c->real

	ld	[%o0],%f0
	fstoi	%f0,%f1
	st	%f1,[%sp+68]
	ld	[%sp+68],%o0
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fi_conv_c)(c, i)
! complex *c;
! int i;
! {
	.inline	NAME(__Fi_conv_c),2
!    88		c->real = (float)i

	st	%o1,[%sp+68]
	ld	[%sp+68],%f0
	fitos	%f0,%f1
	st	%f1,[%o0]
!    89		c->imag = 0.0

	st	%g0,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! double
! NAME(__Fc_conv_d)(c)
! complex *c;
! {
	.inline	NAME(__Fc_conv_d),1
!    98		return (double)c->real

	ld	[%o0],%f2
	fstod	%f2,%f0
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fd_conv_c)(c, x)
! complex *c;
! double x;
! {
	.inline	NAME(__Fd_conv_c),2
	st	%o1,[%sp+72]
	st	%o2,[%sp+76]
!   109		c->real = (float)(x)

	ldd	[%sp+72],%f0
	fdtos	%f0,%f1
	st	%f1,[%o0]
!   110		c->imag = 0.0

	st	%g0,[%o0+4]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! void
! NAME(__Fc_conv_z)(result, c)
! dcomplex *result;
! complex *c;
! {
	.inline	NAME(__Fc_conv_z),2
!   120		result->dreal = (double)c->real

	ld	[%o1],%f0
	fstod	%f0,%f2
	st	%f2,[%o0]
	st	%f3,[%o0+4]
!   121		result->dimag = (double)c->imag

	ld	[%o1+4],%f3
	fstod	%f3,%f4
	st	%f4,[%o0+8]
	st	%f5,[%o0+12]
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! int
! NAME(__Fc_eq)(x, y)
! complex *x, *y;
! {
	.inline	NAME(__Fc_eq),2
!	return  (x->real == y->real) && (x->imag == y->imag);
	ld	[%o0],%f0
	ld	[%o1],%f2
	mov	%o0,%o2
	fcmps	%f0,%f2
	mov	0,%o0
	fbne	1f
	nop
	ld	[%o2+4],%f0
	ld	[%o1+4],%f2
	fcmps	%f0,%f2
	nop
	fbne	1f
	nop
	mov	1,%o0
1:
	.end
! }

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! int
! NAME(__Fc_ne)(x, y)
! complex *x, *y;
! {
	.inline	NAME(__Fc_ne),2
!	return  (x->real != y->real) || (x->imag != y->imag);
	ld	[%o0],%f0
	ld	[%o1],%f2
	mov	%o0,%o2
	fcmps	%f0,%f2
	mov	1,%o0
	fbne	1f
	nop
	ld	[%o2+4],%f0
	ld	[%o1+4],%f2
	fcmps	%f0,%f2
	nop
	fbne	1f
	nop
	mov	0,%o0
1:
	.end
! }

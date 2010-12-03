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
! @(#)libm.m4	1.28	06/01/31 SMI
!
undefine(`_C')dnl
define(`_C',`')dnl
ifdef(`ARCH_v9a', `define(ARCH_v9)')dnl
ifdef(`ARCH_v9b', `define(ARCH_v9)')dnl
ifdef(`ARCH_v9b', `define(ARCH_v9a)')dnl
ifdef(`LOCALLIBM', `dnl
	.inline	__ieee754_sqrt,1
	fsqrtd	%f0,%f0
	.end

	.inline	__inline_sqrtf,1
	fsqrts	%f1,%f0
	.end

	.inline	__inline_sqrt,1
	fsqrtd	%f0,%f0
	.end

')dnl
	.inline	sqrtf,1
	fsqrts	%f1,%f0
	.end

	.inline	sqrt,1
	fsqrtd	%f0,%f0
	.end

ifdef(`ARCH_v9b', `dnl
	.inline	ceil,1
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2	_C(2^52)
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

	.inline	floor,1
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2	_C(2^52)
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
	.inline	ceil,1
	sethi	%hi(0x43300000),%o0
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2		_C(f2:3 = 2^52)
	fabsd	%f0,%f4			_C(f4:5 = |x|)
	fsubd	%f2,%f2,%f6		_C(f6:7 = zero)
	fcmpd	%fcc0,%f4,%f2
	fbl,pt	%fcc0,1f
	nop
	sethi	%hi(0x3ff00000),%o0
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f6		_C(f6:7 = one)
	fmuld	%f0,%f6,%f0		_C(return x * one if |x| >= 2^52, NaN)
	ba	4f
	nop
1:
	fcmpd	%fcc1,%f0,%f6		_C(fcc1 = x : zero)
	fbg,pt	%fcc1,2f
	nop
	fbe,pn	%fcc1,4f		_C(return x if x is +/-zero)
	nop
	fnegd	%f2,%f2			_C(L := f2:3 = copysign(2^52, x))
2:
	faddd	%f0,%f2,%f4		_C(f4:5 = (x + L) rounded)
	fsubd	%f4,%f2,%f4		_C(t := f4:5 = (x + L) rounded - L)
	fcmpd	%fcc0,%f4,%f0
	fbge,pt	%fcc0,3f
	nop
	sethi	%hi(0x3ff00000),%o0
	st	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2		_C(f2:3 = one)
	faddd	%f4,%f2,%f4		_C(t = t + 1 if t < x)
3:
	fabsd	%f4,%f0			_C(f0:1 = |t|)
	fbge,pt	%fcc1,4f		_C(at this point we know x is not +/-0)
	nop
	fnegd	%f0,%f0			_C(return copysign(t, x))
4:
	.end

	.inline	floor,1
	sethi	%hi(0x43300000),%o0
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2		_C(f2:3 = 2^52)
	fabsd	%f0,%f4			_C(f4:5 = |x|)
	fsubd	%f2,%f2,%f6		_C(f6:7 = zero)
	fcmpd	%fcc0,%f4,%f2
	fbl,pt	%fcc0,1f
	nop
	sethi	%hi(0x3ff00000),%o0
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f6		_C(f6:7 = one)
	fmuld	%f0,%f6,%f0		_C(return x * one if |x| >= 2^52)
	ba	4f
	nop
1:
	fcmpd	%fcc1,%f0,%f6		_C(fcc1 = x : zero)
	fbg,pt	%fcc1,2f
	nop
	fbe,pn	%fcc1,4f		_C(return x if x is +/-zero)
	nop
	fnegd	%f2,%f2			_C(L := f2:3 = copysign(2^52, x))
2:
	faddd	%f0,%f2,%f4		_C(f4:5 = (x + L) rounded)
	fsubd	%f4,%f2,%f4		_C(t := f4:5 = (x + L) rounded - L)
	fcmpd	%fcc0,%f4,%f0
	fble,pt	%fcc0,3f
	nop
	sethi	%hi(0x3ff00000),%o0
	st	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2		_C(f2:3 = one)
	fsubd	%f4,%f2,%f4		_C(t = t - 1 if t > x)
3:
	fabsd	%f4,%f0			_C(f0:1 = |t|)
	fbge,pt	%fcc1,4f		_C(at this point we know x is not +/-0)
	nop
	fnegd	%f0,%f0			_C(return copysign(t, x))
4:
	.end

')dnl
	.inline	ilogb,1
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x7ff00000),%o1	_C(o1 = 0x7ff00000)
	andcc	%o0,%o1,%o0
	bne,pt	%icc,2f
	nop
	sethi	%hi(0x43500000),%o0	_C(x subnormal)
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2		_C(f2:3 = 2^54)
	fmuld	%f0,%f2,%f0		_C(scale x up by 2^54)
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	andcc	%o0,%o1,%o0
	bne,pt	%icc,1f
	nop
	sethi	%hi(0x80000001),%o0	_C(return -(2^31 - 1) for x +/-0)
	or	%o0,%lo(0x80000001),%o0
	ba	4f
	nop
1:
	srl	%o0,20,%o0
	sub	%o0,0x435,%o0
	ba	4f
	nop
2:
	subcc	%o1,%o0,%g0
	bne,pt	%icc,3f
	nop
	sethi	%hi(0x7fffffff),%o0	_C(return 2^31 - 1 for x +/-Inf or NaN)
	or	%o0,%lo(0x7fffffff),%o0
	ba	4f
	nop
3:
	srl	%o0,20,%o0
	sub	%o0,0x3ff,%o0
4:
	.end

ifdef(`ARCH_v9a', `dnl
	.inline	rint,1
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2	_C(2^52)
	fcmpd	%fcc0,%f6,%f2
	fmovduge %fcc0,%f4,%f2	_C(fiddle := |x| < 2^52 ? 2^52 : 0)
	fand	%f0,%f8,%f8	_C(copysign(0, x))
	for	%f2,%f8,%f2	_C(copysign(fiddle, x))
	faddd	%f0,%f2,%f0	_C(x + copysign(fiddle, x))
	fsubd	%f0,%f2,%f0	_C(" - copysign(fiddle, x))
	fabsd	%f0,%f0
	for	%f0,%f8,%f0	_C(in case previous fsubd gave wrong sign of 0)
	.end

	.inline	rintf,1
	fzeros	%f4		_C(0)
	fnegs	%f4,%f8		_C(-0)
	fabss	%f1,%f6		_C(|x|)
	sethi	%hi(0x4b000000),%o2
	st	%o2,[%sp+0x87f]
	ld	[%sp+0x87f],%f2	_C(2^23)
	fcmps	%fcc0,%f6,%f2
	fmovsuge %fcc0,%f4,%f2	_C(fiddle := |x| < 2^23 ? 2^23 : 0)
	fands	%f1,%f8,%f8	_C(copysignf(0, x))
	fors	%f2,%f8,%f2	_C(copysignf(fiddle, x))
	fadds	%f1,%f2,%f0	_C(x + copysignf(fiddle, x))
	fsubs	%f0,%f2,%f0	_C(" - copysignf(fiddle, x))
	fabss	%f0,%f0
	fors	%f0,%f8,%f0	_C(in case previous fsubs gave wrong sign of 0)
	.end

',`dnl
	.inline	rint,1
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0		_C(x)
	sethi	%hi(0x80000000),%o2
	sllx	%o2,32,%o2
	andn	%o0,%o2,%o2
	sethi	%hi(0x43300000),%o3
	sllx	%o3,32,%o3
	stx	%g0,[%sp+0x887]
	subcc	%o2,%o3,%g0
	bl,pt	%xcc,1f
	nop
	sethi	%hi(0x3ff00000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x887]
	ldd	[%sp+0x887],%f2
	fmuld	%f0,%f2,%f0		_C(return x * one (raise flag if SNaN))
	ba	3f
	nop
1:
	orcc	%o0,0,%g0
	stx	%o3,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2		_C(L = copysign(two52, x))
	bge,pt	%xcc,2f
	nop
	fnegd	%f2,%f2
2:
	faddd	%f0,%f2,%f0		_C((x + L) rounded)
	fcmpd	%f0,%f2
	fbne,pt	%fcc0,0f
	nop
	ldd	[%sp+0x887],%f0		_C(return copysign(zero, x))
	bge,pt	%xcc,3f
	nop
	fnegd	%f0,%f0
	ba	3f
	nop
0:
	fsubd	%f0,%f2,%f0		_C(return (x + L) rounded - L)
3:
	.end

	.inline	rintf,1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0		_C(x)
	sethi	%hi(0x80000000),%o2
	andn	%o0,%o2,%o2
	sethi	%hi(0x4b000000),%o3
	st	%g0,[%sp+0x887]
	subcc	%o2,%o3,%g0
	bl	1f
	nop
	sethi	%hi(0x3f800000),%o2
	st	%o2,[%sp+0x887]
	ld	[%sp+0x887],%f2
	fmuls	%f1,%f2,%f0		_C(return x * one (raise flag if SNaN))
	ba	3f
	nop
1:
	tst	%o0
	st	%o3,[%sp+0x87f]
	ld	[%sp+0x87f],%f2		_C(L = copysignf(two23, x))
	bge	2f
	nop
	fnegs	%f2,%f2
2:
	fadds	%f1,%f2,%f0		_C((x + L) rounded)
	fcmps	%f0,%f2
	fbne	0f
	nop
	ld	[%sp+0x887],%f0		_C(return copysignf(zero, x))
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
	.inline	min_subnormal,1
	or	%g0,1,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	min_subnormalf,1
	or	%g0,1,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	max_subnormal,1
	xnor	%g0,%g0,%o0
	srlx	%o0,12,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	max_subnormalf,1
	xnor	%g0,%g0,%o0
	srl	%o0,9,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	min_normal,1
	sethi	%hi(0x00100000),%o0
	sllx	%o0,32,%o0
        stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	min_normalf,1
	sethi	%hi(0x00800000),%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	max_normal,1
	sethi	%hi(0x80100000),%o1
	sllx	%o1,32,%o1
	xnor	%g0,%g0,%o0
	andn	%o0,%o1,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	max_normalf,1
	sethi	%hi(0x7f7ffc00),%o0
	or	%o0,0x3ff,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	__infinity,1
	sethi	%hi(0x7ff00000),%o0
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	infinity,1
	sethi	%hi(0x7ff00000),%o0
	sllx	%o0,32,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	infinityf,1
	sethi	%hi(0x7f800000),%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	signaling_nan,1
	sethi	%hi(0x7ff00000),%o0
	sllx	%o0,32,%o0
	or	%o0,0x1,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	signaling_nanf,1
	sethi	%hi(0x7f800000),%o0
	or	%o0,1,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	quiet_nan,1
	xnor	%g0,%g0,%o0
	srlx	%o0,1,%o0
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	quiet_nanf,1
	xnor	%g0,%g0,%o0
	srl	%o0,1,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	__swapEX,1
	and	%o0,0x1f,%o1
	sll	%o1,5,%o1
	.volatile
	st	%fsr,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	andn	%o0,0x3e0,%o2
	or	%o1,%o2,%o1
	st	%o1,[%sp+0x87f]
	ld	[%sp+0x87f],%fsr
	srl	%o0,5,%o0
	and	%o0,0x1f,%o0
	.nonvolatile
	.end

	.inline	_QgetRD,0
	st	%fsr,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	srl	%o0,30,%o0
	.end

	.inline	_QgetRP,0
	or	%g0,%g0,%o0
	.end

	.inline	__swapRD,1
	and	%o0,0x3,%o0
	sll	%o0,30,%o1
	.volatile
	st	%fsr,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0xc0000000),%o4
	andn	%o0,%o4,%o2
	or	%o1,%o2,%o1
	st	%o1,[%sp+0x87f]
	ld	[%sp+0x87f],%fsr
	srl	%o0,30,%o0
	and	%o0,0x3,%o0
	.nonvolatile
	.end

!
! On the SPARC, __swapRP is a no-op; always return 0 for backward compatibility
!
	.inline	__swapRP,1
	or	%g0,%g0,%o0
	.end

	.inline	__swapTE,1
	and	%o0,0x1f,%o0
	sll	%o0,23,%o1
	.volatile
	st	%fsr,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x0f800000),%o4
	andn	%o0,%o4,%o2
	or	%o1,%o2,%o1
	st	%o1,[%sp+0x87f]
	ld	[%sp+0x87f],%fsr
	srl	%o0,23,%o0
	and	%o0,0x1f,%o0
	.nonvolatile
	.end

	.inline	fp_class,1
	fabsd	%f0,%f0
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
	orcc	%g0,%o0,%g0
	be,pn	%xcc,2f			_C(x is +/-zero)
	nop
	sethi	%hi(0x7ff00000),%o1
	sllx	%o1,32,%o1		_C(o1 gets 7ff00000 00000000)
	andcc	%o0,%o1,%g0		_C(cc set by exp field of x)
	bne,pt	%xcc,1f			_C(branch if normal or max exp)
	nop
	or	%g0,1,%o0
	ba	2f			_C(x is subnormal)
	nop
1:
	subcc	%o0,%o1,%g0
	bge,pn	%xcc,1f			_C(branch if x is max exp)
	nop
	or	%g0,2,%o0
	ba	2f			_C(x is normal)
	nop
1:
	andncc	%o0,%o1,%o0		_C(o0 gets significand)
	bne,pn	%xcc,1f			_C(branch if NaN)
	nop
	or	%g0,3,%o0
	ba	2f			_C(x is infinity)
	nop
1:
	sethi	%hi(0x00080000),%o1
	sllx	%o1,32,%o1
	andcc	%o0,%o1,%g0		_C(cc set by quiet/sig bit)
	or	%g0,4,%o0		_C(x is quiet NaN)
	bne,pt	%xcc,2f			_C(Branch if signaling)
	nop
	or	%g0,5,%o0		_C(x is signaling NaN)
2:
	.end

	.inline	fp_classf,1
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	orcc	%g0,%o0,%g0
	be,pn	%icc,2f
	nop
1:
	sethi	%hi(0x7f800000),%o1
	andcc	%o0,%o1,%g0
	bne,pt	%icc,1f
	nop
	or	%g0,1,%o0
	ba	2f			_C(x is subnormal)
	nop
1:
	subcc	%o0,%o1,%g0
	bge,pn	%icc,1f
	nop
	or	%g0,2,%o0
	ba	2f			_C(x is normal)
	nop
1:
	bg,pn	%icc,1f
	nop
	or	%g0,3,%o0
	ba	2f			_C(x is infinity)
	nop
1:
	sethi	%hi(0x00400000),%o1
	andcc	%o0,%o1,%g0
	or	%g0,4,%o0		_C(x is quiet NaN)
	bne,pt	%icc,2f
	nop
	or	%g0,5,%o0		_C(x is signaling NaN)
2:
	.end

	.inline	copysign,2
	fabsd	%f0,%f0
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	st	%f2,[%sp+0x887]
	ld	[%sp+0x887],%o1
	srl	%o1,31,%o1
	sll	%o1,31,%o1
	or	%o0,%o1,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0		_C(f1 stays unchanged)
	.end

	.inline	copysignf,2
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	st	%f3,[%sp+0x887]
	ld	[%sp+0x887],%o1
	srl	%o1,31,%o1
	sll	%o1,31,%o1
	or	%o0,%o1,%o0
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

	.inline	finite,1
	fabsd	%f0,%f0
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x7ff00000),%o1
	sub	%o0,%o1,%o0
	srl	%o0,31,%o0
	.end

	.inline	finitef,1
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x7f800000),%o1
	sub	%o0,%o1,%o0
	srl	%o0,31,%o0
	.end

	.inline	signbit,1
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	srl	%o0,31,%o0
	.end

	.inline	signbitf,1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	srl	%o0,31,%o0
	.end

	.inline	isinf,1
	fabsd	%f0,%f0
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
	sethi	%hi(0x7ff00000),%o1
	sllx	%o1,32,%o1
	sub	%o0,%o1,%o0
	sub	%g0,%o0,%o1
	or	%o0,%o1,%o0
	xnor	%o0,%g0,%o0
	srlx	%o0,63,%o0
	.end

	.inline	isinff,1
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x7f800000),%o1
	sub	%o0,%o1,%o0
	sub	%g0,%o0,%o1
	or	%o0,%o1,%o0
	xnor	%o0,%g0,%o0
	srl	%o0,31,%o0
	.end

	.inline	isnan,1
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
	sllx	%o0,1,%o0		_C(shift off sign bit; see 4837702)
	srlx	%o0,1,%o0
	sethi	%hi(0x7ff00000),%o1
	sllx	%o1,32,%o1
	sub	%o1,%o0,%o0
	srlx	%o0,63,%o0
	.end

	.inline	isnanf,1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x80000000),%o2	_C(mask off sign bit)
	andn	%o0,%o2,%o0
	sethi	%hi(0x7f800000),%o1
	sub	%o1,%o0,%o0
	srl	%o0,31,%o0
	.end

	.inline	isnormal,1
	fabsd	%f0,%f0
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x7ff00000),%o1
	sub	%o0,%o1,%o2			_C(signbit(o2): finite)
	sethi	%hi(0x00100000),%o1
	sub	%o0,%o1,%o1			_C(signbit(o1): subnormal or 0)
	andn	%o2,%o1,%o0
	srl	%o0,31,%o0
	.end

	.inline	isnormalf,1
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x7f800000),%o1
	sub	%o0,%o1,%o2
	sethi	%hi(0x00800000),%o1
	sub	%o0,%o1,%o1
	andn	%o2,%o1,%o0
	srl	%o0,31,%o0
	.end

	.inline	issubnormal,1
	fabsd	%f0,%f0
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
	sethi	%hi(0x00100000),%o1
	sllx	%o1,32,%o1
	sub	%o0,%o1,%o1
	sub	%g0,%o0,%o2
	or	%o0,%o2,%o0
	and	%o0,%o1,%o0
	srlx	%o0,63,%o0
	.end

	.inline	issubnormalf,1
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sethi	%hi(0x00800000),%o1
	sub	%o0,%o1,%o1
	sub	%g0,%o0,%o2
	or	%o0,%o2,%o0
	and	%o0,%o1,%o0
	srl	%o0,31,%o0
	.end

	.inline	iszero,1
	fabsd	%f0,%f0
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
	sub	%g0,%o0,%o1
	or	%o0,%o1,%o0
	xnor	%o0,%g0,%o0
	srlx	%o0,63,%o0
	.end

	.inline	iszerof,1
	fabss	%f1,%f1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sub	%g0,%o0,%o1
	or	%o0,%o1,%o0
	xnor	%o0,%g0,%o0
	srl	%o0,31,%o0
	.end

	.inline	abs,1
	sra	%o0,31,%o1
	xor	%o0,%o1,%o0
	sub	%o0,%o1,%o0
	sra	%o0,0,%o0		_C(sign-extended 64-bit value)
	.end

	.inline	fabs,1
	fabsd	%f0,%f0
	.end

	.inline	fabsf,1
	fabss	%f1,%f0
	.end

!
!	__nintf - f77 NINT(REAL*4)
!
	.inline	__nintf,1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	srl	%o0,30-7,%g1
	sethi	%hi(0x7fffff),%o2
	and	%g1,0xff,%g1		_C(%g1 := biased exponent)
	or	%o2,%lo(0x7fffff),%o2	_C(%o2 := 0x7fffff)
	sethi	%hi(1<<22),%o4		_C(%o4 := 0x400000)
	subcc	%g1,127+31,%g0		_C(< 0 iff |x| < 2^31)
	and	%o0,%o2,%o3		_C(%o3 := mantissa)
	bl	1f
	nop
	sethi	%hi(0xcf000000),%o2	_C(%o2 := -2^31 in floating point)
	sethi	%hi(0x80000000),%g1	_C(%g1 := -2^31 in fixed point)
	subcc	%o0,%o2,%g0		_C(x == -2^31?)
	or	%g1,%g0,%o0		_C(return -2^31 if x == -2^31)
	be	0f
	nop
	fstoi	%f1,%f0			_C(return result and trigger fp_invalid)
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
0:
	sra	%o0,0,%o0		_C(%o0 := sign-extended 64-bit value)
	ba	9f
	nop
1:
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
	sra	%o0,0,%o0		_C(%o0 := sign-extended 64-bit value)
	and	%o2,1,%o2		_C(%o2 := 0/1)
	add	%o0,%o2,%o0
9:
	.end

	.inline	__il_nint,1
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
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	fstox	%f0,%f0
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
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
	sub	%o0,%o2,%o0
9:
	.end

!
!	__i_dnnt - f77 NINT(REAL*8)
!
	.inline	__i_dnnt,1
	ldx	[%o0],%o0	_C(%o0 := s*1.f*2^e)
	srlx	%o0,63-11,%g1
	or	%g0,1,%o2
	stx	%o0,[%sp+0x87f]	_C(prepare for reload if x is out of range)
	sllx	%o2,52-1,%o4	_C(%o4 := 0x00080000 00000000)
	and	%g1,0x7ff,%g1	_C(%g1 := biased exponent)
	sllx	%o2,63-0,%o2
	subcc	%g1,1023+32,%g0	_C(>= 0 iff |x| >= 2^32)
	bl	0f
	nop
	ldd	[%sp+0x87f],%f0
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
	stx	%o0,[%sp+0x87f]	_C(2^30 <= |x| < 2^32)
	ldd	[%sp+0x87f],%f0
	fxtod	%f0,%f0
8:
	fdtoi	%f0,%f0
	st	%f0,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
	sra	%o0,0,%o0	_C(%o0 := sign-extended 64-bit value)
9:
	.end

	.inline	__il_dnnt,1
	ldx	[%o0],%o0	_C(%o0 := s*1.f*2^e)
	srlx	%o0,63-11,%g1
	or	%g0,1,%o2
	sllx	%o2,52-1,%o4	_C(%o4 := 0x00080000 00000000)
	and	%g1,0x7ff,%g1	_C(%g1 := biased exponent)
	sllx	%o2,63-0,%o2
	subcc	%g1,1023+63,%g0	_C(>= 0 iff |x| >= 2^63)
	bl	0f
	nop
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	fdtox	%f0,%f0
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
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
	sub	%o0,%o2,%o0
9:
	.end

ifdef(`ARCH_v9a', `dnl
	.inline	__aintf,1
	fzeros	%f4		_C(0)
	fnegs	%f4,%f8		_C(-0)
	fabss	%f1,%f6		_C(|x|)
	sethi	%hi(0x4b000000),%o2
	st	%o2,[%sp+0x87f]
	ld	[%sp+0x87f],%f2	_C(2^23)
	fcmps	%fcc0,%f6,%f2
	fmovsuge %fcc0,%f4,%f6	_C(|x| < 2^23 ? |x| : 0)
	fstoi	%f6,%f6		_C(truncate to integer)
	fitos	%f6,%f6
	fadds	%f1,%f4,%f2	_C(x + 0)
	fmovsuge %fcc0,%f2,%f6	_C(|x| < 2^23 ? truncf(|x|) : x + 0)
	fands	%f1,%f8,%f0	_C(copysignf(0, x))
	fors	%f0,%f6,%f0	_C(restore sign of x)
	.end

	.inline	__aint,1
	fzero	%f4		_C(0)
	fnegd	%f4,%f8		_C(-0)
	fabsd	%f0,%f6		_C(|x|)
	sethi	%hi(0x43300000),%o2
	sllx	%o2,32,%o2
	stx	%o2,[%sp+0x87f]
	ldd	[%sp+0x87f],%f2	_C(2^52)
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
	.inline	__anintf,1
	st	%f1,[%sp+0x87f]
	ld	[%sp+0x87f],%o0
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
	st	%o0,[%sp+0x87f]
	ld	[%sp+0x87f],%f0
	.end

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
	.inline	__anint,1
	std	%f0,[%sp+0x87f]
	ldx	[%sp+0x87f],%o0
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
	stx	%o0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f0
	.end

	.inline	__r_dim,2
ifdef(`ARCH_v9a', `dnl
	fzeros	%f4
',`dnl
	st	%g0,[%sp+0x87f]
	ld	[%sp+0x87f],%f4
')dnl
	ld	[%o0],%f0
	ld	[%o1],%f2
	fcmps	%fcc0,%f0,%f2
	fmovsule %fcc0,%f4,%f2
	fsubs	%f0,%f2,%f0
	fmovsule %fcc0,%f4,%f0
	.end

	.inline	__d_dim,2
ifdef(`ARCH_v9a', `dnl
	fzero	%f4
',`dnl
	stx	%g0,[%sp+0x87f]
	ldd	[%sp+0x87f],%f4
')dnl
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%f2
	ld	[%o1+4],%f3
	fcmpd	%fcc0,%f0,%f2
	fmovdule %fcc0,%f4,%f2
	fsubd	%f0,%f2,%f0
	fmovdule %fcc0,%f4,%f0
	.end

ifdef(`ARCH_v9a', `dnl
	.inline	__f95_signf,2
	fzeros	%f2
	fnegs	%f2,%f2
	ld	[%o0],%f0
	ld	[%o1],%f1
	fabss	%f0,%f0
	fands	%f1,%f2,%f1
	fors	%f0,%f1,%f0
	.end

	.inline	__f95_sign,2
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
	.inline	__f95_signf,2
	ld	[%o0],%f0
	ld	[%o1],%o1
	fabss	%f0,%f0
	fnegs	%f0,%f1
	sra	%o1,0,%o1	_C(sign-extend to 64-bit %o1)
	fmovrslz %o1,%f1,%f0
	.end

	.inline	__f95_sign,2
	ld	[%o0],%f0
	ld	[%o0+4],%f1
	ld	[%o1],%o1
	fabsd	%f0,%f0
	fnegd	%f0,%f2
	sra	%o1,0,%o1	_C(sign-extend to 64-bit %o1)
	fmovrdlz %o1,%f2,%f0
	.end

')dnl
	.inline	__r_sign,2
	ld	[%o0],%f0
	ld	[%o1],%o1
	fabss	%f0,%f0
	fnegs	%f0,%f1
	sub	%o1,1,%o0
	and	%o1,%o0,%o1	_C(%o1 < 0 iff A2 is negative and not -0)
	sra	%o1,0,%o1	_C(sign-extend to 64-bit %o1)
	fmovrslz %o1,%f1,%f0
	.end

	.inline	__d_sign,2
	ldd	[%o0],%f0
	ldx	[%o1],%o1
	fabsd	%f0,%f0
	fnegd	%f0,%f2
	sub	%o1,1,%o0
	and	%o1,%o0,%o1	_C(%o1 < 0 iff A2 is negative and not -0)
	fmovrdlz %o1,%f2,%f0
	.end

!
! complex __Fc_div_f(complex a, complex b);
!
	.inline	__Fc_div_f,0
ifdef(`ARCH_v9a', `dnl
	fzeros	%f4
',`dnl
	st	%g0,[%sp+0x87f]
	ld	[%sp+0x87f],%f4
')dnl
	fcmps	%fcc0,%f3,%f4		_C(will trigger fp_invalid on SNaN)
	fbne,pn	%fcc0,1f
	nop
	fdivs	%f0,%f2,%f0
	fdivs	%f1,%f2,%f1
	ba	2f
	nop
1:
	sethi	%hi(0x3ff00000),%o0	_C(the cg inliner circa Lionel FCS)
	sllx	%o0,32,%o0		_C([aka WS6U1 but not before] maps)
	stx	%o0,[%sp+0x87f]		_C(the idiom to an LDDF of 1.0)
	ldd	[%sp+0x87f],%f16	_C(from a constant pool)
	fsmuld	%f2,%f2,%f4		_C(f4/5 gets reb**2)
	fsmuld	%f3,%f3,%f6		_C(f6/7 gets imb**2)
	fsmuld	%f1,%f3,%f8		_C(f8/9 gets ima*imb)
	fsmuld	%f0,%f2,%f10		_C(f10/11 gets rea*reb)
	faddd	%f6,%f4,%f6		_C(f6/7 gets reb**2+imb**2)
	fdivd	%f16,%f6,%f6		_C(f6/7 gets 1/(reb**2+imb**2))
	faddd	%f10,%f8,%f10		_C(f10/11 gets rea*reb+ima*imb)
	fsmuld	%f1,%f2,%f12		_C(f12/13 gets ima*reb)
	fmuld	%f10,%f6,%f10		_C(f10/11 gets rec)
	fsmuld	%f0,%f3,%f14		_C(f14/15 gets rea*imb)
	fsubd	%f12,%f14,%f14		_C(f14/15 gets ima*reb-rea*imb)
	fmuld	%f14,%f6,%f6		_C(f6/7 gets imc)
	fdtos	%f10,%f0		_C(f0 gets rec)
	fdtos	%f6,%f1			_C(f1 gets imc)
2:
	.end


/
/ CDDL HEADER START
/
/ The contents of this file are subject to the terms of the
/ Common Development and Distribution License (the "License").
/ You may not use this file except in compliance with the License.
/
/ You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
/ or http://www.opensolaris.org/os/licensing.
/ See the License for the specific language governing permissions
/ and limitations under the License.
/
/ When distributing Covered Code, include this CDDL HEADER in each
/ file and include the License file at usr/src/OPENSOLARIS.LICENSE.
/ If applicable, add the following below this CDDL HEADER, with the
/ fields enclosed by brackets "[]" replaced with your own identifying
/ information: Portions Copyright [yyyy] [name of copyright owner]
/
/ CDDL HEADER END
/
/ Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
/ Use is subject to license terms.
/
/ @(#)libm.m4	1.8	06/01/31 SMI
/
define(NAME,$1)dnl
dnl
ifdef(`LOCALLIBM',`dnl
	.inline	NAME(__ieee754_sqrt),0
	sqrtsd	%xmm0,%xmm0
	.end
/
	.inline	NAME(__inline_sqrtf),0
	sqrtss	%xmm0,%xmm0
	.end
/
	.inline	NAME(__inline_sqrt),0
	sqrtsd	%xmm0,%xmm0
	.end
/
	.inline	NAME(__inline_fstsw),0
	fstsw	%ax
	.end
/
/ 00 - 24 bits
/ 01 - reserved
/ 10 - 53 bits
/ 11 - 64 bits
/
	.inline	NAME(__swapRP),0
	subq	$16,%rsp
	fstcw	(%rsp)
	movw	(%rsp),%ax
	movw	%ax,%cx
	andw	$0xfcff,%cx
	andl	$0x3,%edi
	shlw	$8,%di
	orw	%di,%cx
	movl	%ecx,(%rsp)
	fldcw	(%rsp)
	shrw	$8,%ax
	andq	$0x3,%rax
	addq	$16,%rsp
	.end
/
/ 00 - Round to nearest, with even preferred
/ 01 - Round down
/ 10 - Round up
/ 11 - Chop
/
	.inline	NAME(__swap87RD),0
	subq	$16,%rsp
	fstcw	(%rsp)
	movw	(%rsp),%ax
	movw	%ax,%cx
	andw	$0xf3ff,%cx
	andl	$0x3,%edi
	shlw	$10,%di
	orw	%di,%cx
	movl	%ecx,(%rsp)
	fldcw	(%rsp)
	shrw	$10,%ax
	andq	$0x3,%rax
	addq	$16,%rsp
	.end
/
	.inline	NAME(abs),0
	cmpl	$0,%edi
	jge	1f
	negl	%edi
1:	movl	%edi,%eax
	.end
/
ifdef(`XXX64',`dnl
dnl/	Vulcan Build11.0 chokes on the following template (BugId 5069852)
	.inline	NAME(abs),0
	movl	%edi,%eax
	negl	%edi
	cmovnsl	%edi,%eax
	.end
')dnl
')dnl
ifdef(`XXX64',`dnl
/
/	Convert Top-of-Stack to long
/
	.inline	NAME(__xtol),0
	.end
/
	.inline	NAME(ceil),0
	.end
/
')dnl
	.inline	NAME(copysign),0
	movq	$0x7fffffffffffffff,%rax
	movdq	%rax,%xmm2
	andpd	%xmm2,%xmm0
	andnpd	%xmm1,%xmm2
	orpd	%xmm2,%xmm0
	.end
/
	.inline	NAME(d_sqrt_),0
	movlpd	(%rdi),%xmm0
	sqrtsd	%xmm0,%xmm0
	.end
/
	.inline	NAME(fabs),0
	movq	$0x7fffffffffffffff,%rax
	movdq	%rax,%xmm1
	andpd	%xmm1,%xmm0
	.end
/
	.inline	NAME(fabsf),0
	movl	$0x7fffffff,%eax
	movdl	%eax,%xmm1
	andps	%xmm1,%xmm0
	.end
/
ifdef(`XXX64',`dnl
dnl/	Vulcan Build12.0 corrupts callee-saved registers (BugId 5083361)
	.inline	NAME(fabsl),0
	fldt	(%rsp)
ifdef(`LOCALLIBM',`dnl
#undef	fabs
')dnl
	fabs
	.end
/
')dnl
	.inline	NAME(finite),0
	subq	$16,%rsp
	movlpd	%xmm0,(%rsp)
	movq	(%rsp),%rcx
	movq	$0x7fffffffffffffff,%rax
	andq	%rcx,%rax
	movq	$0x7ff0000000000000,%rcx
	subq	%rcx,%rax
	shrq	$63,%rax
	addq	$16,%rsp
	.end
/
ifdef(`XXX64',`dnl
	.inline	NAME(floor),0
	.end
/
dnl/	branchless isnan
dnl/	((0x7ff00000-[((lx|-lx)>>31)&1]|ahx)>>31)&1 = 1 iff x is NaN
dnl/
	.inline	NAME(isnan),0
	.end
/
	.inline	NAME(isnanf),0
	.end
/
	.inline	NAME(isinf),0
	.end
/
	.inline	NAME(isnormal),0
	.end
/
	.inline	NAME(issubnormal),0
	.end
/
	.inline	NAME(iszero),0
	.end
/
')dnl
	.inline	NAME(r_sqrt_),0
	movss	(%rdi),%xmm0
	sqrtss	%xmm0,%xmm0
	.end
/
ifdef(`XXX64',`dnl
	.inline	NAME(rint),0
	.end
/
	.inline	NAME(scalbn),0
	.end
/
')dnl
	.inline	NAME(signbit),0
	movmskpd %xmm0,%eax
	andq	$1,%rax
	.end
/
	.inline	NAME(signbitf),0
	movmskps %xmm0,%eax
	andq	$1,%rax
	.end
/
	.inline	NAME(sqrt),0
	sqrtsd	%xmm0,%xmm0
	.end
/
	.inline	NAME(sqrtf),0
	sqrtss	%xmm0,%xmm0
	.end
/
ifdef(`XXX64',`dnl
dnl/	Vulcan Build12.0 corrupts callee-saved registers (BugId 5083361)
	.inline	NAME(sqrtl),0
	fldt	(%rsp)
	fsqrt
	.end
/
	.inline	NAME(isnanl),0
	movl	8(%rsp),%eax		/ ax <-- sign bit and exp
	andq	$0x7fff,%rax
	jz	1f			/ jump if exp is all 0
	xorq	$0x7fff,%rax
	jz	2f			/ jump if exp is all 1
	testl	$0x80000000,4(%rsp)
	jz	3f			/ jump if leading bit is 0
	movq	$0,%rax
	jmp	1f
2:					/ note that %eax = 0 from before
	cmpl	$0x80000000,4(%rsp)	/ what is first half of significand?
	jnz	3f			/ jump if not equal to 0x80000000
	testl	$0xffffffff,(%rsp)	/ is second half of significand 0?
	jnz	3f			/ jump if not equal to 0
	jmp	1f
3:
	movq	$1,%rax
1:
	.end
/
	.inline	NAME(__anint),0
	.end
/
')dnl
	.inline	NAME(__f95_signf),0
	movl	(%rdi),%eax
	movl	(%rsi),%ecx
	andl	$0x7fffffff,%eax
	andl	$0x80000000,%ecx
	orl	%ecx,%eax
	movdl	%eax,%xmm0
	.end
/
	.inline	NAME(__f95_sign),0
	movq	(%rsi),%rax
	movq	$0x7fffffffffffffff,%rdx
	shrq	$63,%rax
	shlq	$63,%rax
	andq	(%rdi),%rdx
	orq	%rdx,%rax
	movdq	%rax,%xmm0
	.end
/
	.inline	NAME(__r_sign),0
	movl	$0x7fffffff,%eax
	movl	$0x80000000,%edx
	andl	(%rdi),%eax
	cmpl	(%rsi),%edx
	cmovel	%eax,%edx
	andl	(%rsi),%edx
	orl	%edx,%eax
	movdl	%eax,%xmm0
	.end
/
	.inline	NAME(__d_sign),0
	movq	$0x7fffffffffffffff,%rax
	movq	$0x8000000000000000,%rdx
	andq	(%rdi),%rax
	cmpq	(%rsi),%rdx
	cmoveq	%rax,%rdx
	andq	(%rsi),%rdx
	orq	%rdx,%rax
	movdq	%rax,%xmm0
	.end

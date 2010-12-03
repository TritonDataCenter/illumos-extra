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

/*
 * Parts of Solaris 10 x86 /usr/include/sys/regset.h
 */

#ifndef	_SYS_REGSET_H
#define	_SYS_REGSET_H

#pragma ident	"@(#)regset.h	1.3	06/01/31 SMI"

#include <sys/types.h>

typedef union {
	long double	_q;
	uint32_t	_l[4];
} myupad128_t;

#ifdef __cplusplus
extern "C" {
#endif

/*
 * The names and offsets defined here are specified by i386 ABI suppl.
 */

#define	SS		18	/* only stored on a privilege transition */
#define	UESP		17	/* only stored on a privilege transition */
#define	EFL		16
#define	CS		15
#define	EIP		14
#define	ERR		13
#define	TRAPNO		12
#define	EAX		11
#define	ECX		10
#define	EDX		9
#define	EBX		8
#define	ESP		7
#define	EBP		6
#define	ESI		5
#define	EDI		4
#define	DS		3
#define	ES		2
#define	FS		1
#define	GS		0

/* aliases for portability */

#define	REG_PC	EIP
#define	REG_FP	EBP
#define	REG_SP	UESP
#define	REG_PS	EFL
#define	REG_R0	EAX
#define	REG_R1	EDX

/*
 * A gregset_t is defined as an array type for compatibility with the reference
 * source. This is important due to differences in the way the C language
 * treats arrays and structures as parameters.
 */
#define	_NGREG	19

typedef int	greg_t;
typedef greg_t	gregset_t[_NGREG];

/*
 * This definition of the floating point structure is binary
 * compatible with the Intel386 psABI definition, and source
 * compatible with that specification for x87-style floating point.
 * It also allows SSE/SSE2 state to be accessed on machines that
 * possess such hardware capabilities.
 */
typedef struct fpu {
	union {
		struct fpchip_state {
			uint32_t state[27];	/* 287/387 saved state */
			uint32_t status;	/* saved at exception */
			uint32_t mxcsr;		/* SSE control and status */
			uint32_t xstatus;	/* SSE mxcsr at exception */
			uint32_t __pad[2];	/* align to 128-bits */
			myupad128_t xmm[8];	/* %xmm0-%xmm7 */
		} fpchip_state;
		struct fp_emul_space {		/* for emulator(s) */
			uint8_t	fp_emul[246];
			uint8_t	fp_epad[2];
		} fp_emul_space;
		uint32_t	f_fpregs[95];	/* union of the above */
	} fp_reg_set;
} fpregset_t;

/*
 * Structure mcontext defines the complete hardware machine state.
 * (This structure is specified in the i386 ABI suppl.)
 */
typedef struct {
	gregset_t	gregs;		/* general register set */
	fpregset_t	fpregs;		/* floating point register set */
} mcontext_t;

#ifdef	__cplusplus
}
#endif

#endif	/* _SYS_REGSET_H */

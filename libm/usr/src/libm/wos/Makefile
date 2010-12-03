#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"@(#)Makefile	1.76	06/01/31 SMI"
#

MCPU:sh		= uname -p

DESTDIR		= destdir-$(MCPU)

CG_sparc	= v8plus
CG_i386		= f80387
CG		= $(CG_$(MCPU))
CHIP		= ultra
XARCH		= $(CG)

VnA		= sparcv8plus+vis
VnB		= sparcv9+vis2
IA1		= libmvec
ISA_DIRS_sparc	= $(VnA) $(VnB)
ISA_DIRS_i386	= $(IA1)
ISA_DIRS	= $(ISA_DIRS_$(MCPU))
FLTRTYPE_sparc	= -f
FLTRTYPE_i386	= -f
FLTRTYPE	= $(FLTRTYPE_$(MCPU))
FLTRPATH_sparc	= $$ORIGIN/cpu/$$ISALIST/libmvec_isa.so.1
FLTRPATH_i386	= $$ORIGIN/libmvec/$$HWCAP
FLTRPATH	= $(FLTRPATH_$(MCPU))

#
# system commands
#

CPP_CMD		= $(CC) -E -Xs
INSTALL		= /usr/sbin/install
INST_CMD	= $(INSTALL) $(OWNED_BY) -m 644 -f $(@D) $<
INST_EXEC_CMD	= $(INSTALL) $(OWNED_BY) -m 755 -f $(@D) $<
LD		= /usr/ccs/bin/ld
M4		= /usr/ccs/bin/m4
MCS		= /usr/ccs/bin/mcs
STRIP		= /usr/ccs/bin/strip
TR		= /usr/bin/tr

#
# compiler-related symbols and flags
#

OSREL:sh	= /usr/bin/uname -r
POUND_SIGN:sh	= /usr/bin/printf "\\043"
BUILDDATE:sh	= /usr/bin/date +%m/%d/%Y
BUILDNAME	= Generic
PATCHID		=
BUILDINFO	= SunOS $(OSREL) $(BUILDNAME) $(PATCHID)
LIBM_VERSION	= "@($(POUND_SIGN))RELEASE VERSION $(BUILDINFO) $(BUILDDATE)"

FPDEF_sparc	= -DCG89 -DARCH_v8plus
FPDEF_i386	= -D__i386
FPDEF		= $(FPDEF_$(MCPU))

#
# above and beyond what CDEF defines; so -DELFOBJ -DPIC is removed
#
ASDEF		= -D_ASM $(FPDEF)

ASOPT_sparc	= -xarch=$(XARCH) -Kpic
ASOPT_i386	=
ASOPT		= $(ASOPT_$(MCPU))

ASSUFFIX_sparc	= S
ASSUFFIX_i386	= s
ASSUFFIX	= $(ASSUFFIX_$(MCPU))

CDEF_sparc	=
CDEF_i386	=
CDEF		= -DELFOBJ -DPIC -D_STDC_C99= -D_REENTRANT \
		  -DLIBM_MT_FEX_SYNC $(CDEF_$(MCPU))

CINC		= -I../inc -I$(SRC)/C

#
# __INLINE turns on the use of __inline_sqrt in sqrt.c
#
COPT_sparc	= -D__INLINE -xO4 -xregs=no%appl -xarch=$(XARCH) -xchip=ultra3
COPT_i386	= -D__INLINE -O
COPT		= -Xa -Kpic -xstrconst $(COPT_$(MCPU)) $(LM_IL)

#
# $(LDEND) must come *last* when link editing with versioning; otherwise
# _lib_version, isnan, logb, nextafter, scalb will disappear from version
# information due to the fact that they are also part of libc
#
MAPFMV1		= mapfiles/libmv1-common
MAPFMV2		= mapfiles/libmv2-$(MCPU)
MAPFMVEC	= mapfiles/libmvec-common
MAPFMVECA	= mapfiles/libmvec-v8plusa
MAPFMVECB	= mapfiles/libmvec-v8plusb
MAPFMVEC1	= mapfiles/libmvec-ia1
MAPFILES_sparc	= $(MAPFMV1) $(MAPFMV2) $(MAPFMVEC) $(MAPFMVECA) $(MAPFMVECB)
MAPFILES_i386	= $(MAPFMV1) $(MAPFMV2) $(MAPFMVEC) $(MAPFMVEC1)
MAPFILES	= $(MAPFILES_$(MCPU))
LDOPT0		= -z redlocsym 
LDOPT		= -dy -G $(LDOPT0) -z combreloc -z text -z defs -h $(@F)
LDEND		= -lc

APPFLAGS	= $(ASDEF) -Wp,-P
ASFLAGS		= $(ASOPT)
CFLAGS		= $(COPT)
CPPFLAGS	= $(CDEF) $(CINC)
LINTFLAGS	= -Xa -u

OWNED_BY	= -u root

M4FLAGS		= -D__STDC__ -DELFOBJ -DPIC

#
# SVR4 hack
#
CMD.S		= $(CPP_CMD) $(APPFLAGS) $(CPPFLAGS) $< > $(CG)/$(@F:%.o=%.s); \
		$(COMPILE.S) -o $@ $(CG)/$(@F:%.o=%.s); \
		$(RM) $(CG)/$(@F:%.o=%.s)

#
# Directories
#

MDIR		= $(MCPU)
USR		= $(DESTDIR)/usr
USRLIB		= $(USR)/lib
ROOTLIB		= $(DESTDIR)/lib
SRC		= ../src

LDBLDIR_sparc	= Q
LDBLDIR_i386	= LD
LDBLDIR		= $(LDBLDIR_$(MCPU))

#
# Symbols and flags
#

LLIB_LM		= llib-lm.ln
M_LN		= $(LLIB_LM:%=$(CG)/misc/%)

LIBM_IL_SRC	= $(SRC)/$(MDIR)/common/libm.m4

LOCALLIBM_IL	= locallibm.il
LM_IL		= $(LOCALLIBM_IL:%=$(CG)/misc/%)

M9X_IL		= __fenv_$(MCPU).il
m9x_IL		= $(M9X_IL:%=$(SRC)/m9x/%)

COBJS_i386	= \
		#end

COBJS_sparc	= \
		_TBL_atan.o \
		_TBL_exp2.o \
		_TBL_log.o \
		_TBL_log2.o \
		_TBL_tan.o \
		__tan.o \
		__tanf.o \
		#end
#
# atan2pi.o and sincospi.o is for internal use only
#
COBJS		= \
		$(COBJS_$(MCPU)) \
		__cos.o \
		__lgamma.o \
		__libx_errno.o \
		__rem_pio2.o \
		__rem_pio2m.o \
		__sin.o \
		__sincos.o \
		__xpg6.o \
		_lib_version.o \
		_SVID_error.o \
		_TBL_ipio2.o \
		_TBL_sin.o \
		acos.o \
		acosh.o \
		asin.o \
		asinh.o \
		atan.o \
		atan2.o \
		atan2pi.o \
		atanh.o \
		cbrt.o \
		ceil.o \
		cos.o \
		cosh.o \
		erf.o \
		exp10.o \
		exp2.o \
		expm1.o \
		floor.o \
		gamma.o \
		gamma_r.o \
		hypot.o \
		j0.o \
		j1.o \
		jn.o \
		lgamma.o \
		lgamma_r.o \
		log.o \
		log10.o \
		log1p.o \
		log2.o \
		logb.o \
		matherr.o \
		pow.o \
		scalb.o \
		signgam.o \
		significand.o \
		sin.o \
		sincos.o \
		sincospi.o \
		sinh.o \
		sqrt.o \
		tan.o \
		tanh.o \
		#end

QOBJS_i386	= \
		#end

#
# LSARC/2003/658 adds isnanl
#
QOBJS_sparc	= \
		_TBL_atanl.o \
		_TBL_expl.o \
		_TBL_expm1l.o \
		_TBL_logl.o \
		finitel.o \
		isnanl.o \
		#end

#
# atan2pil.o, ieee_funcl.o, rndintl.o, sinpil.o, sincospil.o
# are for internal use only
#
# LSARC/2003/279 adds the following:
#		gammal.o	1
#		gammal_r.o	1
#		j0l.o		2
#		j1l.o		2
#		jnl.o		2
#		lgammal_r.o	1
#		scalbl.o	1
#		significandl.o	1
#
QOBJS		= \
		$(QOBJS_$(MCPU)) \
		__cosl.o \
		__lgammal.o \
		__poly_libmq.o \
		__rem_pio2l.o \
		__sincosl.o \
		__sinl.o \
		__tanl.o \
		_TBL_cosl.o \
		_TBL_ipio2l.o \
		_TBL_sinl.o \
		_TBL_tanl.o \
		acoshl.o \
		acosl.o \
		asinhl.o \
		asinl.o \
		atan2l.o \
		atan2pil.o \
		atanhl.o \
		atanl.o \
		cbrtl.o \
		copysignl.o \
		coshl.o \
		cosl.o \
		erfl.o \
		exp10l.o \
		exp2l.o \
		expl.o \
		expm1l.o \
		fabsl.o \
		floorl.o \
		fmodl.o \
		gammal.o \
		gammal_r.o \
		hypotl.o \
		ieee_funcl.o \
		ilogbl.o \
		j0l.o \
		j1l.o \
		jnl.o \
		lgammal.o \
		lgammal_r.o \
		log10l.o \
		log1pl.o \
		log2l.o \
		logbl.o \
		logl.o \
		nextafterl.o \
		powl.o \
		remainderl.o \
		rintl.o \
		rndintl.o \
		scalbl.o \
		scalbnl.o \
		signgaml.o \
		significandl.o \
		sincosl.o \
		sincospil.o \
		sinhl.o \
		sinl.o \
		sinpil.o \
		sqrtl.o \
		tanhl.o \
		tanl.o \
		#end

ROBJS_i386	= \
		#end

#
# LSARC/2003/658 adds isnanf
#
ROBJS_sparc	= \
		__cosf.o \
		__sincosf.o \
		__sinf.o \
		isnanf.o \
		#end

#
# atan2pif.o, sincosf.o, sincospif.o are for internal use only
#
# LSARC/2003/279 adds the following:
#		besself.o	6
#		scalbf.o	1
#		gammaf.o	1
#		gammaf_r.o	1
#		lgammaf_r.o	1
#		significandf.o	1
#
ROBJS		= \
		$(ROBJS_$(MCPU)) \
		_TBL_r_atan_.o \
		acosf.o \
		acoshf.o \
		asinf.o \
		asinhf.o \
		atan2f.o \
		atan2pif.o \
		atanf.o \
		atanhf.o \
		besself.o \
		cbrtf.o \
		copysignf.o \
		cosf.o \
		coshf.o \
		erff.o \
		exp10f.o \
		exp2f.o \
		expf.o \
		expm1f.o \
		fabsf.o \
		floorf.o \
		fmodf.o \
		gammaf.o \
		gammaf_r.o \
		hypotf.o \
		ilogbf.o \
		lgammaf.o \
		lgammaf_r.o \
		log10f.o \
		log1pf.o \
		log2f.o \
		logbf.o \
		logf.o \
		nextafterf.o \
		powf.o \
		remainderf.o \
		rintf.o \
		scalbf.o \
		scalbnf.o \
		signgamf.o \
		significandf.o \
		sinf.o \
		sinhf.o \
		sincosf.o \
		sincospif.o \
		sqrtf.o \
		tanf.o \
		tanhf.o \
		#end

#
# LSARC/2003/658 adds isnanf/isnanl
#
SOBJS_i386	= \
		__reduction.o \
		finitef.o \
		finitel.o \
		isnanf.o \
		isnanl.o \
		#end

SOBJS_sparc	= \
		#end

SOBJS		= \
		$(SOBJS_$(MCPU)) \
		copysign.o \
		exp.o \
		fabs.o \
		fmod.o \
		ilogb.o \
		isnan.o \
		nextafter.o \
		remainder.o \
		rint.o \
		scalbn.o \
		#end

m9xsseOBJS_i386	= \
		__fex_hdlr.o \
		__fex_i386.o \
		__fex_sse.o \
		__fex_sym.o \
		fex_log.o \
		#end

m9xsseOBJS_sparc	= \
		#end

m9xsseOBJS	= $(m9xsseOBJS_$(MCPU))

m9xOBJS_i386	= \
		__fex_sse.o \
		feprec.o \
		#end

m9xOBJS_sparc	= \
		#end

m9xOBJS		= \
		$(m9xOBJS_$(MCPU)) \
		__fex_$(MCPU).o \
		__fex_hdlr.o \
		__fex_sym.o \
		fdim.o \
		fdimf.o \
		fdiml.o \
		feexcept.o \
		fenv.o \
		feround.o \
		fex_handler.o \
		fex_log.o \
		fma.o \
		fmaf.o \
		fmal.o \
		fmax.o \
		fmaxf.o \
		fmaxl.o \
		fmin.o \
		fminf.o \
		fminl.o \
		frexp.o \
		frexpf.o \
		frexpl.o \
		ldexp.o \
		ldexpf.o \
		ldexpl.o \
		llrint.o \
		llrintf.o \
		llrintl.o \
		llround.o \
		llroundf.o \
		llroundl.o \
		lrint.o \
		lrintf.o \
		lrintl.o \
		lround.o \
		lroundf.o \
		lroundl.o \
		modf.o \
		modff.o \
		modfl.o \
		nan.o \
		nanf.o \
		nanl.o \
		nearbyint.o \
		nearbyintf.o \
		nearbyintl.o \
		nexttoward.o \
		nexttowardf.o \
		nexttowardl.o \
		remquo.o \
		remquof.o \
		remquol.o \
		round.o \
		roundf.o \
		roundl.o \
		scalbln.o \
		scalblnf.o \
		scalblnl.o \
		tgamma.o \
		tgammaf.o \
		tgammal.o \
		trunc.o \
		truncf.o \
		truncl.o \
		#end

complexOBJS	= \
		cabs.o \
		cabsf.o \
		cabsl.o \
		cacos.o \
		cacosf.o \
		cacosh.o \
		cacoshf.o \
		cacoshl.o \
		cacosl.o \
		carg.o \
		cargf.o \
		cargl.o \
		casin.o \
		casinf.o \
		casinh.o \
		casinhf.o \
		casinhl.o \
		casinl.o \
		catan.o \
		catanf.o \
		catanh.o \
		catanhf.o \
		catanhl.o \
		catanl.o \
		ccos.o \
		ccosf.o \
		ccosh.o \
		ccoshf.o \
		ccoshl.o \
		ccosl.o \
		cexp.o \
		cexpf.o \
		cexpl.o \
		cimag.o \
		cimagf.o \
		cimagl.o \
		clog.o \
		clogf.o \
		clogl.o \
		conj.o \
		conjf.o \
		conjl.o \
		cpow.o \
		cpowf.o \
		cpowl.o \
		cproj.o \
		cprojf.o \
		cprojl.o \
		creal.o \
		crealf.o \
		creall.o \
		csin.o \
		csinf.o \
		csinh.o \
		csinhf.o \
		csinhl.o \
		csinl.o \
		csqrt.o \
		csqrtf.o \
		csqrtl.o \
		ctan.o \
		ctanf.o \
		ctanh.o \
		ctanhf.o \
		ctanhl.o \
		ctanl.o \
		k_atan2.o \
		k_atan2l.o \
		k_cexp.o \
		k_cexpl.o \
		k_clog_r.o \
		k_clog_rl.o \
		#end

LIBMV1_SO_OBJS	= \
		libmv1.o \
		#end

LIBM_SO_OBJS	= $(COBJS) $(ROBJS) $(QOBJS) $(SOBJS) $(m9xOBJS) $(complexOBJS)

mvecOBJS	= \
		__vTBL_atan1.o \
		__vTBL_atan2.o \
		__vTBL_rsqrt.o \
		__vTBL_sincos.o \
		__vTBL_sincos2.o \
		__vTBL_sqrtf.o \
		__vatan.o \
		__vatan2.o \
		__vatan2f.o \
		__vatanf.o \
		__vc_abs.o \
		__vc_exp.o \
		__vc_log.o \
		__vc_pow.o \
		__vcos.o \
		__vcosbig.o \
		__vcosbigf.o \
		__vcosf.o \
		__vexp.o \
		__vexpf.o \
		__vhypot.o \
		__vhypotf.o \
		__vlog.o \
		__vlogf.o \
		__vpow.o \
		__vpowf.o \
		__vrem_pio2m.o \
		__vrhypot.o \
		__vrhypotf.o \
		__vrsqrt.o \
		__vrsqrtf.o \
		__vsin.o \
		__vsinbig.o \
		__vsinbigf.o \
		__vsincos.o \
		__vsincosbig.o \
		__vsincosbigf.o \
		__vsincosf.o \
		__vsinf.o \
		__vsqrt.o \
		__vsqrtf.o \
		__vz_abs.o \
		__vz_exp.o \
		__vz_log.o \
		__vz_pow.o \
		vatan2_.o \
		vatan2f_.o \
		vatan_.o \
		vatanf_.o \
		vc_abs_.o \
		vc_exp_.o \
		vc_log_.o \
		vc_pow_.o \
		vcos_.o \
		vcosf_.o \
		vexp_.o \
		vexpf_.o \
		vhypot_.o \
		vhypotf_.o \
		vlog_.o \
		vlogf_.o \
		vpow_.o \
		vpowf_.o \
		vrhypot_.o \
		vrhypotf_.o \
		vrsqrt_.o \
		vrsqrtf_.o \
		vsin_.o \
		vsincos_.o \
		vsincosf_.o \
		vsinf_.o \
		vsqrt_.o \
		vsqrtf_.o \
		vz_abs_.o \
		vz_exp_.o \
		vz_log_.o \
		vz_pow_.o \
		#end

mvecaCOBJS	= \
		__vTBL_atan1.o \
		__vTBL_atan2.o \
		__vTBL_rsqrt.o \
		__vTBL_sincos.o \
		__vTBL_sincos2.o \
		__vTBL_sqrtf.o \
		__vcosbig.o \
		__vcosbigf.o \
		__vrem_pio2m.o \
		__vsinbig.o \
		__vsinbigf.o \
		__vsincosbig.o \
		__vsincosbigf.o \
		#end

mvecaSOBJS	= \
		__vatan.o \
		__vatan2.o \
		__vatan2f.o \
		__vatanf.o \
		__vcos.o \
		__vcosf.o \
		__vexp.o \
		__vexpf.o \
		__vhypot.o \
		__vhypotf.o \
		__vlog.o \
		__vlogf.o \
		__vpow.o \
		__vpowf.o \
		__vrhypot.o \
		__vrhypotf.o \
		__vrsqrt.o \
		__vrsqrtf.o \
		__vsin.o \
		__vsincos.o \
		__vsincosf.o \
		__vsinf.o \
		__vsqrt.o \
		__vsqrtf.o \
		#end

mvecbCOBJS	= \
		__vTBL_sincos.o \
		__vTBL_sincos2.o \
		__vTBL_sqrtf.o \
		__vcosbig.o \
		__vcosbig_ultra3.o \
		__vrem_pio2m.o \
		__vsinbig.o \
		__vsinbig_ultra3.o \
		#end

mvecbSOBJS	= \
		__vcos_ultra3.o \
		__vlog_ultra3.o \
		__vsin_ultra3.o \
		__vsqrtf_ultra3.o \
		#end

LIBMVEC_SO_OBJS		= $(mvecOBJS)
LIBMVEC_VnA_OBJS	= $(mvecaCOBJS) $(mvecaSOBJS)
LIBMVEC_VnB_OBJS	= $(mvecbCOBJS) $(mvecbSOBJS)
LIBMVEC_IA1_OBJS	= $(mvecOBJS)

#
# Header files under $(SRC)
#

CHDR		= \
		libm.h \
		libm_macros.h \
		libm_protos.h \
		libm_synonyms.h \
		libm_thread.h \
		xpg6.h \
		#end

QHDR		= longdouble.h

complexHDR	= complex_wrapper.h

m9xHDR		= \
		fenv_synonyms.h \
		fex_handler.h \
		fma.h \
		regset.h \
		#end

C_HDR		= $(CHDR:%=$(SRC)/C/%)
Q_HDR		= $(QHDR:%=$(SRC)/$(LDBLDIR)/%)
complex_HDR	= $(complexHDR:%=$(SRC)/complex/%)
m9x_HDR		= $(m9xHDR:%=$(SRC)/m9x/%)
HDRS		= $(C_HDR) $(Q_HDR) $(complex_HDR) $(m9x_HDR)

#
# Header files above and beyond
#

_HEADERS	= \
		complex.h \
		fenv.h \
		floatingpoint.h \
		iso/math_c99.h \
		iso/math_iso.h \
		math.h \
		sys/ieeefp.h \
		tgmath.h \
		#end

HEADERS		= $(_HEADERS:%=../inc/%)

INCS		= $(HEADERS)

#
# Objects
#
LIBMV1_S	= $(CG)/libm.so.1
LIBM_P		=
LIBM_S		= $(CG)/libm.so.2
LIBMS		= $(LIBMV1_S) $(LIBM_S)

LIBMVEC_S	= $(CG)/libmvec.so.1
LIBMVEC_VnA	= $(VnA)/libmvec_isa.so.1
LIBMVEC_VnB	= $(VnB)/libmvec_isa.so.1
LIBMVEC_IA1	= $(IA1)/libmvec_hwcap1.so.1
LIBMVECS_sparc	= $(LIBMVEC_S) $(LIBMVEC_VnA) $(LIBMVEC_VnB)
LIBMVECS_i386	= $(LIBMVEC_S) $(LIBMVEC_IA1)
LIBMVECS	= $(LIBMVECS_$(MCPU))

LIBS		= $(LIBMS) $(LIBMVECS)

$(LIBM_P)	:= VARIANT	= $(CG)/mobj_p
$(LIBMV1_S)	:= VARIANT	= $(CG)/mobj_s
$(LIBM_S)	:= VARIANT	= $(CG)/mobj_s

$(LIBMVEC_S)	:= VARIANT	= $(CG)/mvobj_s
$(LIBMVEC_VnA)	:= VARIANT	= $(VnA)/mvobj_s
$(LIBMVEC_VnB)	:= VARIANT	= $(VnB)/mvobj_s
$(LIBMVEC_IA1)	:= VARIANT	= $(IA1)/mvobj_s

OBJS_LIBMV1_SO	= $(LIBMV1_SO_OBJS:%=$(VARIANT)/%)
OBJS_LIBM_SO	= $(LIBM_SO_OBJS:%=$(VARIANT)/%)

OBJS_LIBMVEC_SO		= $(LIBMVEC_SO_OBJS:%=$(VARIANT)/%)
OBJS_LIBMVEC_VnA	= $(LIBMVEC_VnA_OBJS:%=$(VARIANT)/%)
OBJS_LIBMVEC_VnB	= $(LIBMVEC_VnB_OBJS:%=$(VARIANT)/%)
OBJS_LIBMVEC_IA1	= $(LIBMVEC_IA1_OBJS:%=$(VARIANT)/%)

OBJS_M9XSSE	= $(m9xsseOBJS:%=$(CG)/mobj_s/%)

OBJS_LIB	= \
		$(LIBM_SO_OBJS:%=$(CG)/mobj_p/%) \
		$(LIBM_SO_OBJS:%=$(CG)/mobj_s/%) \
		$(LIBMVEC_SO_OBJS:%=$(CG)/mvobj_s/%) \
		$(LIBMVEC_VnA_OBJS:%=$(VnA)/mvobj_s/%) \
		$(LIBMVEC_VnB_OBJS:%=$(VnB)/mvobj_s/%) \
		$(LIBMVEC_IA1_OBJS:%=$(IA1)/mvobj_s/%) \
		#end

%.o			:= FPDEF_sparc	+= -DFPADD_TRAPS_INCOMPLETE_ON_NAN
%.o			:= CDEF_sparc	+= -DFPADD_TRAPS_INCOMPLETE_ON_NAN
%.o			:= CDEF_sparc	+= -DFDTOS_TRAPS_INCOMPLETE_IN_FNS_MODE

%.o			:= CDEF_i386	+= -DCOMPARISON_MACRO_BUG

$(CG)/mobj%.o		:= ASDEF	+= -DLIBM_BUILD
$(CG)/mobj%.o		:= CDEF		+= -DLIBM_BUILD
$(CG)/mobj%.o		:= COPT_sparc	+= -dalign

$(CG)/mobj_p/%.o	:= ASDEF	+= -DPROF
$(CG)/mobj_p/%.o	:= CDEF		+= -DPROF
$(CG)/mobj_p/%.o	:= COPT		+= -p

#
# __vatan.c, __vatan2.c, __vpow.c ,__vexp.c reference fabs;
# we need acomp to treat fabs as an intrinsic.
#
$(CG)/mv%.o		:= CDEF		+= -DLIBMVEC_SO_BUILD
$(CG)/mv%.o		:= COPT		+= -W0,-xintrinsic
$(CG)/mv%.o		:= CDEF_i386	+= -Dfabs=__fabs

$(VnA)/mv%.o	:= CHIP		= vis
$(VnA)/mv%.o	:= XARCH	= v8plusa
$(VnA)/mv%.o	:= CDEF		+= -DLIBMVEC_SO_BUILD

$(VnB)/mv%.o	:= CHIP		= vis
$(VnB)/mv%.o	:= XARCH	= v8plusb
$(VnB)/mv%.o	:= CDEF		+= -DLIBMVEC_SO_BUILD

$(IA1)/mv%.o	:= CDEF		+= -DLIBMVEC_SO_BUILD
$(IA1)/mv%.o	:= CDEF_i386	+= -Dfabs=__fabs
$(IA1)/mv%.o	:= COPT_i386	+= -xarch=sse2

$(OBJS_M9XSSE)	:= COPT_i386	= -xarch=sse2

dryrun		:= DR_BGN = -@echo '
dryrun		:= DR_END = '
dryrun		:= DR_NBGN = true || echo '
dryrun		:= DR_NEND = '

CG_DIRS_i386	= mobj_p mobj_s mvobj_s misc
CG_DIRS_sparc	= mobj_p mobj_s mvobj_s misc
CG_DIRS		= $(CG_DIRS_$(MCPU))

DIRS_CG		= \
		$(CG_DIRS:%=$(CG)/%) \
		$(ISA_DIRS:%=%/mvobj_s) \
		#end

INST_HDIR	= iso sys
INST_DIRS_sparc	= $(ISA_DIRS:%=cpu/%)
INST_DIRS_i386	= $(ISA_DIRS)
INST_DIRS	= . $(INST_DIRS_$(MCPU))
DIRS_INST	= $(INST_HDIR:%=$(USR)/include/%) $(INST_DIRS:%=$(ROOTLIB)/%)

LIBS_INST_i386	= \
		$(LIBMS:$(CG)/%=$(ROOTLIB)/%) \
		$(LIBMVEC_S:$(CG)/%=$(ROOTLIB)/%) \
		$(LIBMVEC_IA1:%=$(ROOTLIB)/%) \
		#end
LIBS_INST_sparc	= \
		$(LIBMS:$(CG)/%=$(ROOTLIB)/%) \
		$(LIBMVEC_S:$(CG)/%=$(ROOTLIB)/%) \
		$(LIBMVEC_VnA:$(VnA)/%=$(ROOTLIB)/cpu/$(VnA)/%) \
		$(LIBMVEC_VnB:$(VnB)/%=$(ROOTLIB)/cpu/$(VnB)/%) \
		#end
LIBS_INST	= $(LIBS_INST_$(MCPU))

INST_FILES	= $(LLIB_LM:%.ln=%) $(LLIB_LM)
FILES_INST	= $(_HEADERS:%=$(USR)/include/%) $(INST_FILES:%=$(ROOTLIB)/%)

#
# libm build rules
#

.INIT: $(DIRS_CG) $(MAPFILES)

.NO_PARALLEL: $(DIRS_CG) $(DIRS_INST) $(LIBS_INST)

.PARALLEL: $(OBJS_LIB)

.DONE:
	-@echo $(CG) DONE

all: $(DIRS_CG) .WAIT $(INCS) $(HDRS) $(M_LN) $(LIBS)

dryrun: all

install: all .WAIT $(DIRS_INST) .WAIT $(FILES_INST) $(LIBS_INST)

clean: FRC
	-$(RM) -r $(CG)/mobj_p $(CG)/mobj_s $(CG)/mvobj_s \
	 $(ISA_DIRS:%=%/mvobj_s) $(LM_IL)
	 

clobber: clean
	-$(RM) -r $(CG) $(ISA_DIRS)

$(CG)/misc/%.ln: %
	$(LINT) -nvx $(LINTFLAGS) $(CPPFLAGS) -om$(<D)$(CG) $<
	mv $(<F)$(<D)$(CG).ln $@

#
# -DLOCALLIBM turns on more inline templates intended for use
# only by the build process
#
$(LM_IL): $(LIBM_IL_SRC) $(SRC)/C/libm_synonyms.h
	@$(M4) $(FPDEF) $(M4FLAGS) -DLOCALLIBM $(LIBM_IL_SRC) | \
	 cat $(SRC)/C/libm_synonyms.h - > $(CG)/$(@F).$(ASSUFFIX); \
	 $(CPP_CMD) $(CPPFLAGS) $(CG)/$(@F).$(ASSUFFIX) | \
	 sed -e 's/[ 	]*$$//' -e '/^#/d' -e '/^$$/d' > $@; \
	 $(RM) $(CG)/$(@F).$(ASSUFFIX)
	-@echo $@ created with `wc -w < $@` words

$(LIBM_P) $(LIBM_S): $(MAPFMV2) $$(OBJS_LIBM_SO)
	-@_d=`pwd`; echo 'cd $(VARIANT); $(LD) $(LDOPT) \'; \
	 echo -M $${_d}/'$(MAPFMV2) \'; \
	 echo -o '$(@:$(CG)/%=../%) \'; \
	 echo $(OBJS_LIBM_SO:$(VARIANT)/%=%) | $(TR) -s ' 	' '\012' | \
	 fmt -64 | sed -e 's,^,	,' -e 's,$$, \\,' \
	 -e '$$s, \\$$, $(LDEND),'; \
	 echo '$(MCS) -a $(LIBM_VERSION) $(@:$(CG)/%=../%)'
	@$(DR_NBGN)_d=`pwd`; cd $(VARIANT); $(LD) $(LDOPT) \
	 -M $${_d}/$(MAPFMV2) \
	 -o $(@:$(CG)/%=../%) \
	 $(OBJS_LIBM_SO:$(VARIANT)/%=%) $(LDEND); \
	 $(MCS) -d $(@:$(CG)/%=../%); $(STRIP) -x $(@:$(CG)/%=../%); \
	 $(MCS) -a $(LIBM_VERSION) $(@:$(CG)/%=../%)$(DR_NEND)
	-@echo BUILT $@

$(LIBMV1_S): $(MAPFMV1) $$(OBJS_LIBMV1_SO)
	$(DR_NBGN)_d=`pwd`; cd $(VARIANT); $(LD) $(LDOPT) -M $${_d}/$(MAPFMV1) \
	 -o $(@:$(CG)/%=../%) -F libm.so.2 $(OBJS_LIBMV1_SO:$(VARIANT)/%=%); \
	 $(MCS) -d $(@:$(CG)/%=../%); $(STRIP) -x $(@:$(CG)/%=../%); \
	 $(MCS) -a $(LIBM_VERSION) $(@:$(CG)/%=../%)$(DR_NEND)
	-@echo BUILT $@

$(LIBMVEC_S): $(MAPFMVEC) $$(OBJS_LIBMVEC_SO)
	-@_d=`pwd`; echo 'cd $(VARIANT); $(LD) $(LDOPT) \'; \
	 echo -M $${_d}/'$(MAPFMVEC) \'; \
	 echo $(FLTRTYPE) '$(FLTRPATH) \'; \
	 echo -o '$(@:$(CG)/%=../%) \'; \
	 echo $(OBJS_LIBMVEC_SO:$(VARIANT)/%=%) | $(TR) -s ' 	' '\012' | \
	 fmt -64 | sed -e 's,^,	,' -e 's,$$, \\,' \
	 -e '$$s, \\$$,,'; \
	 echo '$(MCS) -a $(LIBM_VERSION) $(@:$(CG)/%=../%)'
	@$(DR_NBGN)_d=`pwd`; cd $(VARIANT); $(LD) $(LDOPT) \
	 -M $${_d}/$(MAPFMVEC) \
	 $(FLTRTYPE) '$(FLTRPATH)' \
	 -o $(@:$(CG)/%=../%) \
	 $(OBJS_LIBMVEC_SO:$(VARIANT)/%=%); \
	 $(MCS) -d $(@:$(CG)/%=../%); $(STRIP) -x $(@:$(CG)/%=../%); \
	 $(MCS) -a $(LIBM_VERSION) $(@:$(CG)/%=../%)$(DR_NEND)
	-@echo BUILT $@

$(LIBMVEC_VnA): $(MAPFMVECA) $$(OBJS_LIBMVEC_VnA)
	-@_d=`pwd`; echo 'cd $(VARIANT); $(LD) $(LDOPT) \'; \
	 echo '-z endfiltee \'; \
	 echo -M $${_d}/'$(MAPFMVECA) \'; \
	 echo -o '$(@:$(VnA)/%=../%) \'; \
	 echo $(OBJS_LIBMVEC_VnA:$(VARIANT)/%=%) | \
	 $(TR) -s ' 	' '\012' | \
	 fmt -64 | sed -e 's,^,	,' -e 's,$$, \\,' \
	 -e '$$s, \\$$,,'; \
	 echo '$(MCS) -a $(LIBM_VERSION) $(@:$(VnA)/%=../%)'
	@$(DR_NBGN)_d=`pwd`; cd $(VARIANT); $(LD) $(LDOPT) \
	 -z endfiltee \
	 -M $${_d}/$(MAPFMVECA) \
	 -o $(@:$(VnA)/%=../%) \
	 $(OBJS_LIBMVEC_VnA:$(VARIANT)/%=%); \
	 $(MCS) -d $(@:$(VnA)/%=../%); $(STRIP) -x $(@:$(VnA)/%=../%); \
	 $(MCS) -a $(LIBM_VERSION) $(@:$(VnA)/%=../%)$(DR_NEND)
	-@echo BUILT $@

$(LIBMVEC_VnB): $(MAPFMVECB) $$(OBJS_LIBMVEC_VnB)
	-@_d=`pwd`; echo 'cd $(VARIANT); $(LD) $(LDOPT) \'; \
	 echo -M $${_d}/'$(MAPFMVECB) \'; \
	 echo -o '$(@:$(VnB)/%=../%) \'; \
	 echo $(OBJS_LIBMVEC_VnB:$(VARIANT)/%=%) | \
	 $(TR) -s ' 	' '\012' | \
	 fmt -64 | sed -e 's,^,	,' -e 's,$$, \\,' \
	 -e '$$s, \\$$,,'; \
	 echo '$(MCS) -a $(LIBM_VERSION) $(@:$(VnB)/%=../%)'
	@$(DR_NBGN)_d=`pwd`; cd $(VARIANT); $(LD) $(LDOPT) \
	 -M $${_d}/$(MAPFMVECB) \
	 -o $(@:$(VnB)/%=../%) \
	 $(OBJS_LIBMVEC_VnB:$(VARIANT)/%=%); \
	 $(MCS) -d $(@:$(VnB)/%=../%); $(STRIP) -x $(@:$(VnB)/%=../%); \
	 $(MCS) -a $(LIBM_VERSION) $(@:$(VnB)/%=../%)$(DR_NEND)
	-@echo BUILT $@

$(LIBMVEC_IA1): $(MAPFMVEC) $(MAPFMVEC1) $$(OBJS_LIBMVEC_IA1)
	-@_d=`pwd`; echo 'cd $(VARIANT); $(LD) $(LDOPT) \'; \
	 echo -M $${_d}/'$(MAPFMVEC1) \'; \
	 echo -M $${_d}/'$(MAPFMVEC) \'; \
	 echo -o '$(@:$(IA1)/%=../%) \'; \
	 echo $(OBJS_LIBMVEC_IA1:$(VARIANT)/%=%) | \
	 $(TR) -s ' 	' '\012' | \
	 fmt -64 | sed -e 's,^,	,' -e 's,$$, \\,' \
	 -e '$$s, \\$$,,'; \
	 echo '$(MCS) -a $(LIBM_VERSION) $(@:$(IA1)/%=../%)'
	@$(DR_NBGN)_d=`pwd`; cd $(VARIANT); $(LD) $(LDOPT) \
	 -M $${_d}/$(MAPFMVEC1) \
	 -M $${_d}/$(MAPFMVEC) \
	 -o $(@:$(IA1)/%=../%) \
	 $(OBJS_LIBMVEC_IA1:$(VARIANT)/%=%); \
	 $(MCS) -d $(@:$(IA1)/%=../%); $(STRIP) -x $(@:$(IA1)/%=../%); \
	 $(MCS) -a $(LIBM_VERSION) $(@:$(IA1)/%=../%)$(DR_NEND)
	-@echo BUILT $@

$$(VARIANT)/%.o: $(SRC)/mvec/$$(CHIP)/%.S
	$(DR_BGN)$(CMD.S)$(DR_END)

$$(VARIANT)/%.o: $(SRC)/$(MDIR)/common/%.$(ASSUFFIX) $(C_HDR)
	$(DR_BGN)$(CMD.S)$(DR_END)

$$(VARIANT)/%.o: $(SRC)/mvec/%.c $(HEADERS) $(LM_IL)
	$(DR_BGN)$(COMPILE.c) -o $@ $<$(DR_END)

$$(VARIANT)/%.o: $(SRC)/C/%.c $(C_HDR) $(HEADERS) $(LM_IL)
	$(DR_BGN)$(COMPILE.c) -o $@ $<$(DR_END)

$$(VARIANT)/%.o: $(SRC)/$(LDBLDIR)/%.c $(C_HDR) $(Q_HDR) $(HEADERS) $(LM_IL)
	$(DR_BGN)$(COMPILE.c) -o $@ $<$(DR_END)

$$(VARIANT)/%.o: $(SRC)/R/%.c $(C_HDR) $(HEADERS) $(LM_IL)
	$(DR_BGN)$(COMPILE.c) -o $@ $<$(DR_END)

$$(VARIANT)/%.o: $(SRC)/complex/%.c $(C_HDR) $(complex_HDR) $(HEADERS) $(LM_IL)
	$(DR_BGN)$(COMPILE.c) -o $@ $<$(DR_END)

$$(VARIANT)/%.o: $(SRC)/m9x/%.c $(C_HDR) $(m9x_HDR) $(HEADERS) $(m9x_IL) $(LM_IL)
	$(DR_BGN)$(COMPILE.c) $(m9x_IL) -o $@ $<$(DR_END)

$(DIRS_CG):
	$(INSTALL) -d -m 0775 $@

$(DIRS_INST):
	$(INSTALL) -d $(OWNED_BY) $@

$(USR)/include/%.h: ../inc/%.h
	$(INST_CMD)

$(ROOTLIB)/libm.so.%: $(CG)/libm.so.%
	$(INST_EXEC_CMD)
	@if [ $< = $(LIBM_S) ]; then \
	 (cd $(@D); $(RM) libm.so; ln -s $(@F) libm.so) \
	 fi

$(ROOTLIB)/libmvec.so.%: $(CG)/libmvec.so.%
	$(INST_EXEC_CMD)
	@cd $(@D); $(RM) libmvec.so; ln -s $(@F) libmvec.so

$(ROOTLIB)/cpu/%.so.1: %.so.1
	$(INST_EXEC_CMD)

$(ROOTLIB)/$(IA1)/%.so.1: $(IA1)/%.so.1
	$(INST_EXEC_CMD)

$(ROOTLIB)/%-lm: %-lm
	$(INST_CMD)

$(ROOTLIB)/%:: $(CG)/misc/%
	$(INST_CMD)

FRC:

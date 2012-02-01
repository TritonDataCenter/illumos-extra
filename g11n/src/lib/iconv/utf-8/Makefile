#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

include $(SRC)/Makefile.master

#
# Prototype directory:
ROOT_DIR		= $(FILEROOT)/usr/lib/iconv
BTS_DIR			= $(FILEROOT)/usr/lib/iconv/geniconvtbl/binarytables 

# geniconvtbl loadmodule
GENICONVTBL= /usr/bin/geniconvtbl
#
# Common sources come from following directory:
CMN			= .
GENI_SRCS		= binarytables/srcs



include Makefile.iconv


.NO_PARALLEL:

.PARALLEL: $(ALL_SOS) $(BINARYTABLES)


all: $(MACH64) $(ALL_SOS) $(BINARYTABLES)

install: all $(ROOT_DIR) $(BTS_DIR) $(ALLOTHERFILES)
	for f in  $(BINARYTABLES) ; do \
		TMP=`echo $$f | $(TR) "+" "%"` ; \
		echo installing $$TMP to $(BTS_DIR) ; \
		$(RM) $(BTS_DIR)/$$TMP ; \
		$(CP) $$f $(BTS_DIR)/$$TMP ; \
	done
	for f in $(ALL_SOS) ; do \
		TMP=`echo $$f | $(TR) "+" "%"` ; \
		echo installing $$TMP to $(ROOT_DIR) ; \
		$(RM) $(ROOT_DIR)/$$TMP ; \
		$(CP) $$f $(ROOT_DIR)/$$TMP ; \
		echo installing $(MACH64)/$$TMP to $(ROOT_DIR)/$(MACH64) ; \
		$(CP) $(MACH64)/$$f $(ROOT_DIR)/$(MACH64)/$$TMP ; \
	done
	for f in $(ALLOTHERFILES) ; do \
		echo installing $$f to $(ROOT_DIR) ; \
		$(RM) $(ROOT_DIR)/$$f ; \
		$(INS) $(ROOT_DIR) $$f ; \
	done
	-@echo "done."


$(ROOT_DIR) :
	/usr/bin/test -d $@ || $(INSDIR) $@
	/usr/bin/test -d $@/$(MACH64) || $(INSDIR) $@/$(MACH64)

$(BTS_DIR) $(MACH64):
	/usr/bin/test -d $@ || $(INSDIR) $@

clean:
	$(RM) *.o core *.s
	$(RM) $(ALL_SOS) $(BINARYTABLES) 
	$(RM) -r $(MACH64) 
	for f in  $(BINARYTABLES) ; do \
		$(RM) $(BTS_DIR)/`echo $$f | $(TR) "+" "%"` ; \
	done


LDFLAGS			= -G -z defs
LDLIBS			= -lc

$(ALL_SOS)		:= CFLAGS += $(XREGSFLAG) -KPIC -D_REENTRANT \
					-I$(CMN) -I$(CMN)/tbls 
$(ALL_SOS)		:= CFLAGS64 += $(XREGSFLAG64) -KPIC -D_REENTRANT \
					-I$(CMN) -I$(CMN)/tbls 

$(UCS_2_SOS)		:= CFLAGS += -DUCS_2
$(UCS_2_SOS)		:= CFLAGS64 += -DUCS_2
$(UCS_2BE_SOS)		:= CFLAGS += -DUCS_2BE
$(UCS_2BE_SOS)		:= CFLAGS64 += -DUCS_2BE
$(UCS_2LE_SOS)		:= CFLAGS += -DUCS_2LE
$(UCS_2LE_SOS)		:= CFLAGS64 += -DUCS_2LE

$(UTF_16_SOS)		:= CFLAGS += -DUTF_16
$(UTF_16_SOS)		:= CFLAGS64 += -DUTF_16
$(UTF_16BE_SOS)		:= CFLAGS += -DUTF_16BE
$(UTF_16BE_SOS)		:= CFLAGS64 += -DUTF_16BE
$(UTF_16LE_SOS)		:= CFLAGS += -DUTF_16LE
$(UTF_16LE_SOS)		:= CFLAGS64 += -DUTF_16LE

$(UTF_32_SOS)		:= CFLAGS += -DUTF_32
$(UTF_32_SOS)		:= CFLAGS64 += -DUTF_32
$(UTF_32BE_SOS)		:= CFLAGS += -DUTF_32BE
$(UTF_32BE_SOS)		:= CFLAGS64 += -DUTF_32BE
$(UTF_32LE_SOS)		:= CFLAGS += -DUTF_32LE
$(UTF_32LE_SOS)		:= CFLAGS64 += -DUTF_32LE

$(UCS_4_SOS)		:= CFLAGS += -DUCS_4
$(UCS_4_SOS)		:= CFLAGS64 += -DUCS_4
$(UCS_4BE_SOS)		:= CFLAGS += -DUCS_4BE
$(UCS_4BE_SOS)		:= CFLAGS64 += -DUCS_4BE
$(UCS_4LE_SOS)		:= CFLAGS += -DUCS_4LE
$(UCS_4LE_SOS)		:= CFLAGS64 += -DUCS_4LE

$(UTF_8_SOS)		:= CFLAGS += -DUTF_8
$(UTF_8_SOS)		:= CFLAGS64 += -DUTF_8

$(US_ASCII_SOS)		:= CFLAGS += -DUS_ASCII
$(US_ASCII_SOS)		:= CFLAGS64 += -DUS_ASCII
$(ISO_8859_1_SOS)	:= CFLAGS += -DISO_8859_1
$(ISO_8859_1_SOS)	:= CFLAGS64 += -DISO_8859_1
$(ISO_8859_2_SOS)	:= CFLAGS += -DISO_8859_2
$(ISO_8859_2_SOS)	:= CFLAGS64 += -DISO_8859_2
$(ISO_8859_3_SOS)	:= CFLAGS += -DISO_8859_3
$(ISO_8859_3_SOS)	:= CFLAGS64 += -DISO_8859_3
$(ISO_8859_4_SOS)	:= CFLAGS += -DISO_8859_4
$(ISO_8859_4_SOS)	:= CFLAGS64 += -DISO_8859_4
$(ISO_8859_5_SOS)	:= CFLAGS += -DISO_8859_5
$(ISO_8859_5_SOS)	:= CFLAGS64 += -DISO_8859_5
$(ISO_8859_6_SOS)	:= CFLAGS += -DISO_8859_6
$(ISO_8859_6_SOS)	:= CFLAGS64 += -DISO_8859_6
$(ISO_8859_7_SOS)	:= CFLAGS += -DISO_8859_7
$(ISO_8859_7_SOS)	:= CFLAGS64 += -DISO_8859_7
$(ISO_8859_8_SOS)	:= CFLAGS += -DISO_8859_8
$(ISO_8859_8_SOS)	:= CFLAGS64 += -DISO_8859_8
$(ISO_8859_9_SOS)	:= CFLAGS += -DISO_8859_9
$(ISO_8859_9_SOS)	:= CFLAGS64 += -DISO_8859_9
$(ISO_8859_10_SOS)	:= CFLAGS += -DISO_8859_10
$(ISO_8859_10_SOS)	:= CFLAGS64 += -DISO_8859_10
$(ISO_8859_13_SOS)	:= CFLAGS += -DISO_8859_13
$(ISO_8859_13_SOS)	:= CFLAGS64 += -DISO_8859_13
$(ISO_8859_14_SOS)	:= CFLAGS += -DISO_8859_14
$(ISO_8859_14_SOS)	:= CFLAGS64 += -DISO_8859_14
$(ISO_8859_15_SOS)	:= CFLAGS += -DISO_8859_15
$(ISO_8859_15_SOS)	:= CFLAGS64 += -DISO_8859_15
$(ISO_8859_16_SOS)	:= CFLAGS += -DISO_8859_16
$(ISO_8859_16_SOS)	:= CFLAGS64 += -DISO_8859_16
$(KOI8_R)		:= CFLAGS += -DKOI8_R
$(KOI8_R)		:= CFLAGS64 += -DKOI8_R
$(KOI8_U)		:= CFLAGS += -DKOI8_U
$(KOI8_U)		:= CFLAGS64 += -DKOI8_U
$(PTCP154)		:= CFLAGS += -DPTCP154
$(PTCP154)		:= CFLAGS64 += -DPTCP154
$(CP437_SOS)		:= CFLAGS += -DCP437
$(CP437_SOS)		:= CFLAGS64 += -DCP437
$(CP720_SOS)		:= CFLAGS += -DCP720
$(CP720_SOS)		:= CFLAGS64 += -DCP720
$(CP737_SOS)		:= CFLAGS += -DCP737
$(CP737_SOS)		:= CFLAGS64 += -DCP737
$(CP775_SOS)		:= CFLAGS += -DCP775
$(CP775_SOS)		:= CFLAGS64 += -DCP775
$(CP850_SOS)		:= CFLAGS += -DCP850
$(CP850_SOS)		:= CFLAGS64 += -DCP850
$(CP852_SOS)		:= CFLAGS += -DCP852
$(CP852_SOS)		:= CFLAGS64 += -DCP852
$(CP855_SOS)		:= CFLAGS += -DCP855
$(CP855_SOS)		:= CFLAGS64 += -DCP855
$(CP857_SOS)		:= CFLAGS += -DCP857
$(CP857_SOS)		:= CFLAGS64 += -DCP857
$(CP860_SOS)		:= CFLAGS += -DCP860
$(CP860_SOS)		:= CFLAGS64 += -DCP860
$(CP861_SOS)		:= CFLAGS += -DCP861
$(CP861_SOS)		:= CFLAGS64 += -DCP861
$(CP862_SOS)		:= CFLAGS += -DCP862
$(CP862_SOS)		:= CFLAGS64 += -DCP862
$(CP863_SOS)		:= CFLAGS += -DCP863
$(CP863_SOS)		:= CFLAGS64 += -DCP863
$(CP864_SOS)		:= CFLAGS += -DCP864
$(CP864_SOS)		:= CFLAGS64 += -DCP864
$(CP865_SOS)		:= CFLAGS += -DCP865
$(CP865_SOS)		:= CFLAGS64 += -DCP865
$(CP866_SOS)		:= CFLAGS += -DCP866
$(CP866_SOS)		:= CFLAGS64 += -DCP866
$(CP869_SOS)		:= CFLAGS += -DCP869
$(CP869_SOS)		:= CFLAGS64 += -DCP869
$(CP874_SOS)		:= CFLAGS += -DCP874
$(CP874_SOS)		:= CFLAGS64 += -DCP874
$(CP1250_SOS)		:= CFLAGS += -DCP1250
$(CP1250_SOS)		:= CFLAGS64 += -DCP1250
$(CP1251_SOS)		:= CFLAGS += -DCP1251
$(CP1251_SOS)		:= CFLAGS64 += -DCP1251
$(CP1252_SOS)		:= CFLAGS += -DCP1252
$(CP1252_SOS)		:= CFLAGS64 += -DCP1252
$(CP1253_SOS)		:= CFLAGS += -DCP1253
$(CP1253_SOS)		:= CFLAGS64 += -DCP1253
$(CP1254_SOS)		:= CFLAGS += -DCP1254
$(CP1254_SOS)		:= CFLAGS64 += -DCP1254
$(CP1255_SOS)		:= CFLAGS += -DCP1255
$(CP1255_SOS)		:= CFLAGS64 += -DCP1255
$(CP1256_SOS)		:= CFLAGS += -DCP1256
$(CP1256_SOS)		:= CFLAGS64 += -DCP1256
$(CP1257_SOS)		:= CFLAGS += -DCP1257
$(CP1257_SOS)		:= CFLAGS64 += -DCP1257
$(CP1258_SOS)		:= CFLAGS += -DCP1258
$(CP1258_SOS)		:= CFLAGS64 += -DCP1258

$(ACE_TO_UTF_8_SO)	:= CFLAGS += -DICV_ACE_TO_UTF8
$(ACE_TO_UTF_8_SO)	:= CFLAGS64 += -DICV_ACE_TO_UTF8
$(ACE_ALLOW_UNAS_TO_UTF_8_SO)	:= CFLAGS += -DICV_ACE_TO_UTF8 \
						-DICV_IDN_ALLOW_UNASSIGNED
$(ACE_ALLOW_UNAS_TO_UTF_8_SO)	:= CFLAGS64 += -DICV_ACE_TO_UTF8 \
						-DICV_IDN_ALLOW_UNASSIGNED
$(UTF_8_TO_ACE_SO)	:= CFLAGS += -DICV_UTF8_TO_ACE
$(UTF_8_TO_ACE_SO)	:= CFLAGS64 += -DICV_UTF8_TO_ACE
$(UTF_8_TO_ACE_ALLOW_UNAS_SO)	:= CFLAGS += -DICV_UTF8_TO_ACE \
						-DICV_IDN_ALLOW_UNASSIGNED
$(UTF_8_TO_ACE_ALLOW_UNAS_SO)	:= CFLAGS64 += -DICV_UTF8_TO_ACE \
						-DICV_IDN_ALLOW_UNASSIGNED

#
# Dependencies and actual compilations are defined at below.
$(SB_TO_UCS_SOS): $(CMN)/common_defs.h $(CMN)/sb_to_ucs.h $(CMN)/sb_to_ucs.c
	$(CC) $(CFLAGS) $(CMN)/sb_to_ucs.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/sb_to_ucs.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UCS_TO_SB_SOS): $(CMN)/common_defs.h $(CMN)/ucs_to_sb.h $(CMN)/ucs_to_sb.c
	$(CC) $(CFLAGS) $(CMN)/ucs_to_sb.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/ucs_to_sb.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(SB_TO_UTF_8_SOS): $(CMN)/common_defs.h $(CMN)/sb_to_utf8.h $(CMN)/sb_to_utf8.c
	$(CC) $(CFLAGS) $(CMN)/sb_to_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/sb_to_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_8_TO_SB_SOS): $(CMN)/common_defs.h $(CMN)/utf8_to_sb.h $(CMN)/utf8_to_sb.c
	$(CC) $(CFLAGS) $(CMN)/utf8_to_sb.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf8_to_sb.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UCS_4_TO_UCS_SOS): $(CMN)/common_defs.h $(CMN)/ucs4_to_ucs.h $(CMN)/ucs4_to_ucs.c
	$(CC) $(CFLAGS) $(CMN)/ucs4_to_ucs.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/ucs4_to_ucs.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UCS_TO_UCS_4_SOS): $(CMN)/common_defs.h $(CMN)/ucs_to_ucs4.h $(CMN)/ucs_to_ucs4.c
	$(CC) $(CFLAGS) $(CMN)/ucs_to_ucs4.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/ucs_to_ucs4.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UCS_4_TO_UTF_32_SOS): $(CMN)/common_defs.h $(CMN)/ucs4_to_ucs.h $(CMN)/ucs4_to_ucs.c
	$(CC) $(CFLAGS) $(CMN)/ucs4_to_utf32.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/ucs4_to_utf32.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_32_TO_UCS_4_SOS): $(CMN)/common_defs.h $(CMN)/ucs_to_ucs4.h $(CMN)/ucs_to_ucs4.c
	$(CC) $(CFLAGS) $(CMN)/utf32_to_ucs4.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf32_to_ucs4.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UCS_TO_UTF_8_SOS): $(CMN)/common_defs.h $(CMN)/ucs_to_utf8.h $(CMN)/ucs_to_utf8.c
	$(CC) $(CFLAGS) $(CMN)/ucs_to_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/ucs_to_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_8_TO_UCS_SOS): $(CMN)/common_defs.h $(CMN)/utf8_to_ucs.h $(CMN)/utf8_to_ucs.c
	$(CC) $(CFLAGS) $(CMN)/utf8_to_ucs.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf8_to_ucs.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UCS_TO_UTF_7_SOS): $(CMN)/common_defs.h $(CMN)/ucs_to_utf7.h $(CMN)/ucs_to_utf7.c
	$(CC) $(CFLAGS) $(CMN)/ucs_to_utf7.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/ucs_to_utf7.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_7_TO_UCS_SOS): $(CMN)/common_defs.h $(CMN)/utf7_to_ucs.h $(CMN)/utf7_to_ucs.c
	$(CC) $(CFLAGS) $(CMN)/utf7_to_ucs.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf7_to_ucs.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_8_TO_UTF_EBCDIC_SO): $(CMN)/common_defs.h $(CMN)/utf8_to_utf_ebcdic.h $(CMN)/utf8_to_utf_ebcdic.c
	$(CC) $(CFLAGS) $(CMN)/utf8_to_utf_ebcdic.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf8_to_utf_ebcdic.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_EBCDIC_TO_UTF_8_SO): $(CMN)/common_defs.h $(CMN)/utf_ebcdic_to_utf8.h $(CMN)/utf_ebcdic_to_utf8.c
	$(CC) $(CFLAGS) $(CMN)/utf_ebcdic_to_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf_ebcdic_to_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(ACE_TO_UTF_8_SO): $(CMN)/ace.h $(CMN)/ace_utf8.c
	$(CC) $(CFLAGS) $(CMN)/ace_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS) -ldl
	$(CC) $(CFLAGS64) $(CMN)/ace_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(ACE_ALLOW_UNAS_TO_UTF_8_SO): $(CMN)/ace.h $(CMN)/ace_utf8.c
	$(CC) $(CFLAGS) $(CMN)/ace_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS) -ldl
	$(CC) $(CFLAGS64) $(CMN)/ace_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_8_TO_ACE_SO): $(CMN)/ace.h $(CMN)/ace_utf8.c
	$(CC) $(CFLAGS) $(CMN)/ace_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS) -ldl
	$(CC) $(CFLAGS64) $(CMN)/ace_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_8_TO_ACE_ALLOW_UNAS_SO): $(CMN)/ace.h $(CMN)/ace_utf8.c
	$(CC) $(CFLAGS) $(CMN)/ace_utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS) -ldl
	$(CC) $(CFLAGS64) $(CMN)/ace_utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)

$(UTF_8_TO_UTF_8_SO): $(CMN)/common_defs.h $(CMN)/utf8.c
	$(CC) $(CFLAGS) $(CMN)/utf8.c -c -o $@.o
	$(LD) $(LDFLAGS) -o $@ $@.o $(LDLIBS)
	$(CC) $(CFLAGS64) $(CMN)/utf8.c -c -o $(MACH64)/$@.o
	$(LD) $(LDFLAGS) -o $(MACH64)/$@ $(MACH64)/$@.o $(LDLIBS)


#
# Rules for binary tables:
.SUFFIXES: $(SUFFIXES) .src
.SUFFIXES: $(SUFFIXES) .bt

%.bt: $(GENI_SRCS)/%.src
	$(GENICONVTBL) -o $@ -f $< 

#
# Rules for all other files:
#$(ALLOTHERFILES):
#	$(RM) $@
#	if [ -d $(CMN)/SCCS ] ; then \
#		/usr/ccs/bin/sccs -d$(CMN) get $@; \
#	else \
#		$(CP) $(CMN)/$@ .; \
#	fi

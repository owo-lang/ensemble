#*************************************************************#
#
#   Ensemble, (Version 1.00)
#   Copyright 2000 Cornell University
#   All rights reserved.
#
#   See ensemble/doc/license.txt for further information.
#
#*************************************************************#
# -*- Mode: makefile -*- 
#*************************************************************#
#
# OCAMLOPT: definitions for the native code compiler
#
# Author: Mark Hayden, 2/96
#
#*************************************************************#
MLCOMP		= ocamlopt
MLLINK		= $(MLCOMP)
MLLIBR		= $(MLCOMP) -a
CMI		= .cmi
CMOS		= .cmx
CMAS		= .cmxa
CMO		= $(CMOS)
CMA		= $(CMAS)
#*************************************************************#
COMPTYPE	= opt
MLWARN		=
#MLFAST		= -unsafe -noassert -inline 5
MLFAST		= -unsafe -noassert -compact
PROFILE		=# -p
DEBUGGER	=
MLFLAGS		= $(DEBUGGER) $(MLFAST) $(PROFILE)
MLLINKFLAGS	= $(MLFAST) $(PROFILE) -ccopt -g
DEPFLAGS	= -opt
ENSCOMPFLAGS	= -opt $(MLFLAGS)
ENSCOMP		= $(ECAMLCC) -Io $(OBJD) $(ENSCOMPFLAGS)
MLRUNTIME	= $(OCAML_LIB)/libasmrun$(ARCS)
LIBDYNLINK	= -cclib -ldynlink dynlink$(CMAS)
#*************************************************************#
CUSTOM		=# no -custom option for ocamlopt
#*************************************************************#

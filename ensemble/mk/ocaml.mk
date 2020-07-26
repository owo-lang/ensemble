# -*- Mode: makefile -*- 
#*************************************************************#
#
# OCAML: definitions for the bytecode compiler
#
# Author: Mark Hayden, 2/96
#
#*************************************************************#
MLCOMP		= ocamlc
MLLINK		= $(MLCOMP)
MLLIBR		= $(MLCOMP) -a $(DEBUGGER)
CMI		= .cmi
CMOS		= .cmo
CMAS		= .cma
CMO		= $(CMOS)
CMA		= $(CMAS)
#*************************************************************#
COMPTYPE	= byte
MLWARN		=
MLFAST		=# -unsafe
PROFILE         =# -profile
DEBUGGER        =# -g
MLFLAGS		= $(DEBUGGER) $(MLFAST) $(COMP_THR) $(PROFILE)
MLLINKFLAGS	= $(DEBUGGER) $(MLWARN) $(MLFAST) $(MLTHREAD)
DEPFLAGS	= -noopt
ENSCOMPFLAGS	= $(MLFLAGS)
ENSCOMP		= $(ECAMLCC) -Io $(OBJD) $(ENSCOMPFLAGS)
MLRUNTIME	= $(OCAML_LIB)/libcamlrun$(ARCS)
LIBDYNLINK	= dynlink$(CMAS)
#*************************************************************#
CUSTOM		= -custom
#*************************************************************#

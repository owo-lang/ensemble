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
MLWARN		=
MLFAST		=# -unsafe
PROFILE         =# -profile
DEBUGGER        =#-ccopt -lefence
MLFLAGS		= $(DEBUGGER) $(MLFAST) $(COMP_THR) $(PROFILE)
MLLINKFLAGS	= $(DEBUGGER) $(MLWARN) $(MLFAST) $(MLTHREAD)
DEPFLAGS	= -noopt
ENSCOMP		= $(MLCOMP) $(MLFLAGS)
MLRUNTIME	= $(OCAML_LIB)/libcamlrun$(ARCS)
#*************************************************************#
CUSTOM		= -custom
#*************************************************************#

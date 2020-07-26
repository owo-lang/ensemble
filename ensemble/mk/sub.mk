# -*- Mode: makefile -*- 
#*************************************************************#
#
# MAKEFILE.SUB: this makefile is included in source code
# subdirectories.  It allows compilations to be run from those
# directories.
#
# Author: Mark Hayden, 2/96
#
#*************************************************************#


all:
	cd $(ENSROOT); $(MAKE) all 

just:
	cd $(ENSROOT); $(MAKE) just

opt:
	cd $(ENSROOT); $(MAKE) opt

tk:
	cd $(ENSROOT); $(MAKE) tk

tk_opt:
	cd $(ENSROOT); $(MAKE) tk_opt

crypto:
	cd $(ENSROOT); $(MAKE) crypto

crypto_opt:
	cd $(ENSROOT); $(MAKE) crypto_opt

clean:
	$(CLEANDIR)

realclean:
	cd $(ENSROOT); $(MAKE) realclean

#*************************************************************#

ENSROOT = ../..
include $(ENSROOT)/mk/config.mk
include $(ENSROOT)/mk/rules.mk

SRC = Mtalk.java Perf.java Rand.java
OBJS = Mtalk.class Perf.class Rand.class

TESTS = $(ENSBIN)/Rand.class $(ENSBIN)/Perf.class 
DEMOS = $(ENSBIN)/Mtalk.class

all : $(OBJS) $(ENSLIB)/ensemble.jar $(DEMOS)

$(OBJS): $(SRC)
	javac *.java

tests : all $(TESTS)

$(ENSLIB)/ensemble.jar : 
	jar cf $(ENSLIB)/ensemble.jar ensemble

$(ENSBIN)/Mtalk.class : Mtalk.class
	$(CP) Mtalk.class $(ENSBIN)/Mtalk.class

$(ENSBIN)/Rand.class : Rand.class
	$(CP) Rand.class $(ENSBIN)/Rand.class

$(ENSBIN)/Perf.class : Perf.class
	$(CP) Perf.class $(ENSBIN)/Perf.class

clean: 
	$(RM) *.class
	$(RM) $(ENSLIB)/ensemble.jar
	cd ensemble; $(MAKE) clean

#doc : 
#	mkdir -p docs
#	javadoc ensemble/hot/*.java -d docs

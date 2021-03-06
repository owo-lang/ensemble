# -*- Mode: makefile -*-
#*************************************************************#
#
# FILES: macros listing files of different parts of Ensemble
#
# Author: Mark Hayden, 3/96
#
#*************************************************************#
# ENSEMBLEMLI and ENSEMBLECMI list the modules of the core
# library that are exported from the Ensemble module.  The
# MLI macro is used for dependency calculation.  The CMI is
# used for generating the ensemble.ml and ensemble.mli
# files.

ENSEMBLEMLI = \
	socket/socket.mli \
	util/trans.mli	\
	util/util.mli	\
	util/queuee.mli	\
	util/fqueue.mli	\
	util/trace.mli	\
	util/arraye.mli	\
	util/arrayf.mli	\
	mm/buf.mli		\
	mm/iovec.mli		\
	mm/iovecl.mli	\
\
	util/marsh.mli	\
\
	type/security.mli	\
	type/shared.mli	\
	util/tree.mli	\
	util/mrekey_dt.mli	\
\
	util/hsys.mli	\
	util/lset.mli	\
	util/resource.mli	\
	util/sched.mli	\
	type/time.mli	\
	type/addr.mli	\
	type/proto.mli	\
	type/stack_id.mli	\
	type/unique.mli	\
	type/endpt.mli	\
	type/group.mli	\
	type/param.mli	\
	type/version.mli	\
	type/view.mli	\
	type/conn.mli	\
	route/route.mli	\
	infr/async.mli	\
	trans/real.mli	\
	type/alarm.mli	\
	type/auth.mli	\
	type/domain.mli	\
	type/event.mli	\
	type/property.mli\
	type/appl_intf.mli\
	type/appl_handle.mli\
	type/layer.mli \
	infr/transport.mli	\
	infr/glue.mli	\
	infr/stacke.mli	\
	appl/arge.mli	\
	groupd/mutil.mli	\
	groupd/manage.mli	\
	appl/appl.mli	\
	appl/reflect.mli	\
	appl/protos.mli	\
	infr/hsyssupp.mli    \
	appl/timestamp.mli

#*************************************************************#
# Core Ensemble stuff

ENSCOREOBJ = \
	util/printe$(CMO)	\
	util/trans$(CMO)	\
	util/util$(CMO)	\
	util/queuee$(CMO)	\
	util/trace$(CMO)	\
	util/arraye$(CMO)	\
	util/arrayf$(CMO)	\
	mm/buf$(CMO)	\
	mm/iovec$(CMO)	\
	mm/iovecl$(CMO)	\
	util/hsys$(CMO)	\
	util/fqueue$(CMO)	\
	util/queuea$(CMO)	\
	util/lset$(CMO)	\
	util/once$(CMO)	\
	util/priq$(CMO)	\
	util/resource$(CMO)	\
	util/sched$(CMO)	\
\
	mm/iq$(CMO)		\
	util/marsh$(CMO)	\
	type/time$(CMO)	\
	type/addr$(CMO)	\
	type/version$(CMO)	\
\
	type/security$(CMO)	\
	type/shared$(CMO)	\
	util/tree$(CMO)		\
	util/mrekey_dt$(CMO)	\
\
	type/proto$(CMO)	\
	type/stack_id$(CMO)	\
	type/unique$(CMO)	\
	type/endpt$(CMO)	\
	type/group$(CMO)	\
	type/param$(CMO)	\
	type/view$(CMO)		\
	type/conn$(CMO)		\
	route/handler$(CMO)	\
	route/route$(CMO)	\
	infr/async$(CMO)	\
	type/alarm$(CMO)	\
	type/auth$(CMO)	\
	type/domain$(CMO)	\
	type/event$(CMO)	\
	type/property$(CMO)	\
	type/appl_intf$(CMO)	\
	type/appl_handle$(CMO) \
	type/layer$(CMO)	\
\
	infr/transport$(CMO)	\
\
	route/unsigned$(CMO)	\
	route/signed$(CMO)	\
\
	infr/config_trans$(CMO) \
	infr/glue$(CMO)	\
	appl/arge$(CMO)	\
	infr/stacke$(CMO)	\
	appl/timestamp$(CMO)	\
\
	trans/ipmc$(CMO)	\
	trans/udp$(CMO)	\
	trans/real$(CMO)	\
\
	route/bypassr$(CMO)	\
	infr/hsyssupp$(CMO)	\
	trans/netsim$(CMO)	\
\
	appl/pgp$(CMO)	\
	util/arrayop$(CMO)	\
	appl/appl_debug$(CMO) \
	appl/appl_aggr$(CMO) \
	appl/appl_power$(CMO) \
	appl/appl_lwe$(CMO)	\
	appl/appl_multi$(CMO) \
	appl/handle$(CMO) \
	appl/partition$(CMO) \
\
	appl/protos$(CMO)	\
\
	groupd/mutil$(CMO)	\
	groupd/proxy$(CMO)	\
	groupd/member$(CMO)	\
	groupd/coord$(CMO)	\
	groupd/actual$(CMO)	\
	groupd/manage$(CMO)	\
	appl/appl$(CMO)	\
\
	appl/reflect$(CMO)	\
\
	$(ENSLIB)/ensemble$(CMO)

#*************************************************************#
# These are an almost minimal set of additional modules to link with
# the core library.  They do not include many of the optional
# features of ensemble such as the various servers and debugging
# capabilities.  Only layers needed for vsync and vsync+total
# protocol stacks are included here.

ENSMINOBJ = \
	layers/other/top_appl$(CMO)	\
	layers/other/top$(CMO)	\
	layers/other/partial_appl$(CMO) \
	layers/trans/stable$(CMO)	\
	layers/trans/bottom$(CMO)	\
	layers/trans/mnak$(CMO)	\
	layers/trans/pt2pt$(CMO)	\
	layers/vsync/suspect$(CMO)	\
	layers/vsync/fz_suspect$(CMO) \
	layers/vsync/fz_detect$(CMO) \
	layers/vsync/fz_decide$(CMO) \
	layers/vsync/merge$(CMO)	\
	layers/vsync/inter$(CMO)	\
	layers/vsync/intra$(CMO)	\
	layers/vsync/elect$(CMO)	\
	layers/trans/frag$(CMO)	\
	layers/trans/frag_abv$(CMO)	\
	layers/vsync/leave$(CMO)	\
	layers/vsync/sync$(CMO)	\
	layers/vsync/vsync$(CMO)	\
	layers/vsync/slander$(CMO)	\
	layers/gossip/heal$(CMO)	\
	layers/flow/pt2ptw$(CMO)	\
	layers/flow/pt2ptwp$(CMO)	\
	util/mcredit$(CMO)	\
	layers/flow/mflow$(CMO)	\
	layers/total/sequencer$(CMO) \
\
	layers/bypass/fpmb$(CMO)	\

#*************************************************************#
# All other modules are listed here.

ENSRESTOBJ = \
	layers/gossip/switch$(CMO)	\
	util/mexchange$(CMO)	\
	layers/security/exchange$(CMO)	\
	layers/security/rekey$(CMO)	\
	layers/security/rekey_dt$(CMO)	\
	layers/security/secchan$(CMO)	\
\
	layers/other/local$(CMO)	\
	layers/other/cltsvr$(CMO)	\
	layers/other/xfer$(CMO)	\
	layers/other/subcast$(CMO)	\
	layers/other/migrate$(CMO)	\
	layers/security/perfrekey$(CMO)	\
	layers/other/primary$(CMO)	\
	layers/vsync/present$(CMO)	\
\
	layers/flow/window$(CMO)	\
\
	layers/other/collect$(CMO)	\
	util/request$(CMO)	\
	layers/total/total$(CMO)	\
	layers/total/totem$(CMO)	\
	layers/total/seqbb$(CMO)	\
	layers/total/tops$(CMO)	\
	layers/scale/asym$(CMO)	\
\
	layers/debug/assert$(CMO)	\
	layers/debug/delay$(CMO)	\
	layers/debug/drop$(CMO)	\
	layers/debug/chk_secchan$(CMO) \
	layers/debug/chk_rekey$(CMO) \
	layers/debug/chk_fifo$(CMO)	\
	layers/debug/chk_total$(CMO)	\
	layers/debug/chk_sync$(CMO)	\
	layers/scale/pr_stable$(CMO)	\
	layers/scale/pr_suspect$(CMO) \
	layers/scale/gcast$(CMO)	\
	layers/scale/pbcast$(CMO)	\
	layers/scale/zbcast$(CMO)	\
	layers/debug/chk_causal$(CMO) \
	util/mcausal$(CMO)	\
	layers/trans/causal$(CMO)	\
\
	util/dtbl$(CMO)	\
	util/dtblbatch$(CMO)	\
	infr/disp$(CMO)	\
	layers/debug/dbg$(CMO)	\
	layers/debug/dbgbatch$(CMO)

# Yet more stuff that is no longer used/supported.
#	$(OBJD)/credit$(CMO)	\
#	$(OBJD)/rate$(CMO)	\
#	$(OBJD)/smq$(CMO)	\
#	$(OBJD)/dag$(CMO)	\
#	$(OBJD)/bypass$(CMO)	\
#	$(OBJD)/safe$(CMO)
#	$(OBJD)/bypfifo$(CMO)	\
#	$(OBJD)/side$(CMO)	\
#	$(OBJD)/mngchan$(CMO)	\
#*************************************************************#

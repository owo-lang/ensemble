(**************************************************************)
(*
 *  Ensemble, 1.10
 *  Copyright 2001 Cornell University, Hebrew University
 *  All rights reserved.
 *
 *  See ensemble/doc/license.txt for further information.
 *)
(**************************************************************)
(**************************************************************)
(* EVENT.MLI *)
(* Author: Mark Hayden, 4/95 *)
(* Based on Horus events by Robbert vanRenesse *)
(**************************************************************)
open Trans
open Tdefs
(**************************************************************)

  (* Up and down events *)
type t
type up = t
type dn = t

(**************************************************************)

  (* Event types *)
type typ =
    (* These events should have messages associated with them. *)
  | ECast				(* Multicast message *)
  | ESend				(* Pt2pt message *)
  | ESubCast				(* Multi-destination message *)
  | ECastUnrel				(* Unreliable multicast message *)
  | ESendUnrel				(* Unreliable pt2pt message *)
  | EMergeRequest			(* Request a merge *)
  | EMergeGranted			(* Grant a merge request *)
  | EOrphan				(* Message was orphaned *)

    (* These types do not have messages. *)
  | EAccount				(* Output accounting information *)
(*| EAck			      *)(* Acknowledge message *)
  | EAsync				(* Asynchronous application event *)
  | EBlock				(* Block the group *)
  | EBlockOk				(* Acknowledge blocking of group *)
  | EDump				(* Dump your state (debugging) *)
  | EElect				(* I am now the coordinator *)
  | EExit				(* Disable this stack *)
  | EFail				(* Fail some members *)
  | EGossipExt				(* Gossip message *)
  | EGossipExtDir			(* Gossip message directed at particular address *)
  | EInit				(* First event delivered *)
  | ELeave				(* A member wants to leave *)
  | ELostMessage			(* Member doesn't have a message *)
  | EMergeDenied			(* Deny a merge request *)
  | EMergeFailed			(* Merge request failed *)
  | EMigrate				(* Change my location *)
  | EPresent                            (* Members present in this view *)
  | EPrompt				(* Prompt a new view *)
  | EProtocol				(* Request a protocol switch *)
  | ERekey				(* Request a rekeying of the group *)
  | ERekeyPrcl				(* The rekey protocol events *)
  | ERekeyPrcl2				(*                           *)
  | EStable				(* Deliver stability down *)
  | EStableReq				(* Request for stability information *)
  | ESuspect				(* Member is suspected to be faulty *)
  | ESystemError			(* Something serious has happened *)
  | ETimer				(* Request a timer *)
  | EView				(* Notify that a new view is ready *)
  | EXferDone				(* Notify that a state transfer is complete *)
  | ESyncInfo
      (* Ohad, additions *)
  | ESecureMsg				(* Private Secure messaging *)
  | EChannelList			(* passing a list of secure-channels *)
  | EFlowBlock				(* Blocking/unblocking the application for flow control*)
(* Signature/Verification with PGP *)
  | EAuth

  | ESecChannelList                     (* The channel list held by the SECCHAN layer *)
  | ERekeyCleanup
  | ERekeyCommit 

(**************************************************************)

type field =
      (* Common fields *)
  | Type	of typ			(* type of the message*)
  | Peer	of rank			(* rank of sender/destination *)
  | Iov	        of Iovecl.t		(* payload of message *)
  | ApplMsg				(* was this message generated by an appl? *)

      (* Uncommon fields *)
  | Address     of Addr.set		(* new address for a member *)
  | Failures	of bool Arrayf.t	(* failed members *)
  | Presence    of bool Arrayf.t        (* members present in the current view *)
  | Suspects	of bool Arrayf.t        (* suspected members *)
  | SuspectReason of string		(* reasons for suspicion *)
  | Stability	of seqno Arrayf.t	(* stability vector *)
  | NumCasts	of seqno Arrayf.t	(* number of casts seen *)
  | Contact	of Endpt.full * View.id option (* contact for a merge *)
  | HealGos	of Proto.id * View.id * Endpt.full * View.t * Hsys.inet list (* HEAL gossip *)  
  | SwitchGos	of Proto.id * View.id * Time.t  (* SWITCH gossip *)
  | ExchangeGos	of string		(* EXCHANGE gossip *)
  | MergeGos	of (Endpt.full * View.id option) * seqno * typ * View.state (* INTER gossip *)
  | ViewState	of View.state		(* state of next view *)
  | ProtoId	of Proto.id		(* protocol id (only for down events) *)
  | Time        of Time.t		(* current time *)
  | Alarm       of Time.t		(* for alarm requests *)(* BUG: this is not needed *)
  | ApplCasts   of seqno Arrayf.t
  | ApplSends   of seqno Arrayf.t
  | DbgName     of string

      (* Flags *)
  | NoTotal				(* message is not totally ordered*)
  | ServerOnly				(* deliver only at servers *)
  | ClientOnly				(* deliver only at clients *)
  | NoVsync
  | ForceVsync
  | Fragment				(* Iovec has been fragmented *)

      (* Debugging *)
  | History	of string		(* debugging history *)

      (* Ohad -- Private Secure Messaging *)
  | SecureMsg of Buf.t
  | ChannelList of (rank * Security.key) list
	
      (* Ohad -- interaction between Mflow, Pt2ptw, Pt2ptwp and the application*)
  | FlowBlock of rank option * bool

  (* Signature/Verification with Auth *)
  | AuthData of Addr.set * Auth.data

  (* Information passing between optimized rekey layers
   *)
  | Tree    of bool * Tree.z
  | TreeAct of Tree.sent
  | AgreedKey of Security.key

  | SecChannelList of Trans.rank list  (* The channel list held by the SECCHAN layer *)
  | SecStat of int                      (* PERF figures for SECCHAN layer *)
  | RekeyFlag of bool                   (* Do a cleanup or not *)

(**************************************************************)

  (* Directed events. *)
type dir = Up of t | Dn of t

type ('a,'b) dirm = UpM of up * 'a | DnM of dn * 'b

(**************************************************************)

  (* Constructor *)
val create	: debug -> typ -> field list -> t

(**************************************************************)

  (* Modifier *)
val set		: debug -> t -> field list -> t

(**************************************************************)

  (* Copier *) 
val copy	: debug -> t -> t

(**************************************************************)

  (* Destructor *)
val free	: debug -> t -> unit

(* Same as above, but don't modify iovec refcounts.
 *)
val free_noIov	: debug -> t -> unit

(**************************************************************)

  (* Sanity checkers *)
val upCheck	: debug -> t -> unit
val dnCheck	: debug -> t -> unit

(**************************************************************)

  (* Pretty printer *)
val to_string	: t -> string
val string_of_type : typ -> string

(**************************************************************)

  (* Special constructors *)

val bodyCore		: debug -> typ -> origin -> Iovecl.t -> t
val castEv		: debug	-> t
val castUnrel		: debug	-> t
val castIov		: debug -> Iovecl.t -> t
val castIovAppl		: debug -> Iovecl.t -> t
val castPeerIov 	: debug -> rank -> Iovecl.t -> t
val sendPeer		: debug -> rank	-> t
val sendPeerIov         : debug -> rank -> Iovecl.t -> t
val sendPeerIovAppl	: debug -> rank -> Iovecl.t -> t
val sendUnrelPeer       : debug -> rank -> t
val suspectReason       : debug -> bool Arrayf.t -> debug -> t
val timerAlarm		: debug -> Time.t -> t
val timerTime		: debug -> Time.t -> t
val dumpEv              : debug -> t

(**************************************************************)

  (* Accessors *)

val getAddress     	: t -> Addr.set
val getAlarm		: t -> Time.t
val getApplMsg	        : t -> bool
val getApplCasts	: t -> seqno Arrayf.t
val getApplSends  	: t -> seqno Arrayf.t
val getClientOnly	: t -> bool
val getContact		: t -> Endpt.full * View.id option
val getExtend     	: t -> field list
val getExtendFail     	: (field -> 'a option) -> debug -> t -> 'a
val getExtender     	: (field -> 'a option) -> 'a -> t -> 'a
val getExtendOpt	: t -> (field -> bool) -> unit
val getFailures		: t -> bool Arrayf.t
val getFragment		: t -> bool
val getIov		: t -> Iovecl.t
val getNoTotal		: t -> bool
val getNoVsync          : t -> bool
val getForceVsync       : t -> bool 
val getNumCasts		: t -> seqno Arrayf.t
val getPeer		: t -> origin
val getDbgName          : t -> string
val getPresence         : t -> bool Arrayf.t
val getProtoId		: t -> Proto.id
val getServerOnly	: t -> bool
val getStability	: t -> seqno Arrayf.t
val getSuspectReason	: t -> string
val getSuspects		: t -> bool Arrayf.t
val getTime		: t -> Time.t
val getType		: t -> typ
val getViewState	: t -> View.state
val getSecureMsg        : t -> Buf.t
val getChannelList      : t -> (Trans.rank * Security.key) list
val getFlowBlock        : t -> rank option * bool	
val getAuthData         : t -> Addr.set * Auth.data
val getSecChannelList   : t -> Trans.rank list
val getSecStat          : t -> int 
val getRekeyFlag        : t -> bool 

val setIovFragment	: debug -> t -> Iovecl.t -> t
val setNoTotal  	: debug -> t -> t
val getTree             : t -> bool * Tree.z 
val getTreeAct          : t -> Tree.sent
val getAgreedKey        : t -> Security.key 
val setPeer        	: debug -> t -> rank -> t
val setSendUnrelPeer   	: debug -> t -> rank -> t

(**************************************************************)

val getIovLen           : t -> Buf.len

(**************************************************************)

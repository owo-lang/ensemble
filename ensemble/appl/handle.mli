(**************************************************************)
(* HANDLE.MLI *)
(* Author: Mark Hayden, 10/97 *)
(**************************************************************)

val new_f : 'msg Appl_handle.New.full -> Appl_handle.handle_gen * 'msg Appl_intf.New.full

val old_f : ('a,'b,'c,'d) Appl_handle.Old.full -> Appl_handle.handle_gen * ('a,'b,'c,'d) Appl_intf.Old.full
